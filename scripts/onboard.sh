#!/bin/bash
set -e

MOD_ID="${1:?Usage: onboard.sh <mod_id>}"
WORKSPACE_DIR="${2:-$(pwd)}"

echo "=== Minecraft Modding with Kids: Environment Setup ==="
echo "Mod ID: $MOD_ID"
echo "Workspace: $WORKSPACE_DIR"
echo ""

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Darwin) PLATFORM="macos" ;;
    Linux)  PLATFORM="linux" ;;
    *)      echo "ERROR: Unsupported OS: $OS"; exit 1 ;;
esac
echo "Platform: $PLATFORM"

# Step 1: Install JDK 21
echo ""
echo "--- Step 1: Java Development Kit 21 ---"
if java --version 2>/dev/null | grep -q "21\."; then
    echo "JDK 21 already installed."
else
    echo "Installing JDK 21..."
    if [ "$PLATFORM" = "macos" ]; then
        if ! command -v brew &>/dev/null; then
            echo "ERROR: Homebrew not found. Install from https://brew.sh"
            exit 1
        fi
        brew install openjdk@21
        echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
        echo 'export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"' >> ~/.zshrc
        export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
        export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
    else
        sudo apt update && sudo apt install -y openjdk-21-jdk
        export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
    fi
    echo "JDK 21 installed: $(java --version 2>&1 | head -1)"
fi

# Step 2: Install deno (for Fabric CLI)
echo ""
echo "--- Step 2: Deno (for Fabric CLI) ---"
if command -v deno &>/dev/null; then
    echo "Deno already installed."
else
    echo "Installing deno..."
    if [ "$PLATFORM" = "macos" ]; then
        brew install deno
    else
        curl -fsSL https://deno.land/install.sh | sh
    fi
    echo "Deno installed."
fi

# Step 3: Generate Fabric mod project
echo ""
echo "--- Step 3: Fabric Mod Project ---"
cd "$WORKSPACE_DIR"
if [ -d "$MOD_ID" ]; then
    echo "Project directory $MOD_ID already exists. Skipping generation."
else
    echo "Generating Fabric mod project: $MOD_ID"
    deno run -A https://fabricmc.net/cli init "$MOD_ID" -y
    echo "Project generated."
fi

# Step 4: Build the project
echo ""
echo "--- Step 4: First Build ---"
cd "$WORKSPACE_DIR/$MOD_ID"
chmod +x gradlew
export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home}"
export PATH="${JAVA_HOME}/bin:$PATH"
./gradlew build
echo "Build successful!"

# Step 5: Initialize git
echo ""
echo "--- Step 5: Git Setup ---"
cd "$WORKSPACE_DIR"
if [ -d ".git" ]; then
    echo "Git repo already initialized."
else
    git init
    echo "Git initialized."
fi

# Step 6: Create directories
mkdir -p "$WORKSPACE_DIR/audio"
echo ""
echo "=== Setup Complete! ==="
echo "Mod project: $WORKSPACE_DIR/$MOD_ID"
echo "Next: run extract-mappings.sh and generate-workspace.sh"
