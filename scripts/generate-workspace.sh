#!/bin/bash
set -e

CONFIG_FILE="${1:?Usage: generate-workspace.sh <config.json>}"
WORKSPACE="${2:-$(pwd)}"
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Read config values
CHILD_NAME=$(jq -r '.child_name' "$CONFIG_FILE")
CHILD_AGE=$(jq -r '.child_age' "$CONFIG_FILE")
READING_LEVEL=$(jq -r '.reading_level' "$CONFIG_FILE")
MOD_ID=$(jq -r '.mod_id' "$CONFIG_FILE")
MOD_DISPLAY_NAME=$(jq -r '.mod_display_name' "$CONFIG_FILE")
PARENT_EXPERIENCE=$(jq -r '.parent_experience' "$CONFIG_FILE")
CONTENT_GUIDELINES=$(jq -r '.content_guidelines' "$CONFIG_FILE")
ELEVENLABS_API_KEY=$(jq -r '.elevenlabs_api_key' "$CONFIG_FILE")
ELEVENLABS_VOICE_ID=$(jq -r '.elevenlabs_voice_id' "$CONFIG_FILE")

echo "=== Generating Workspace Files ==="
echo "Child: $CHILD_NAME (age $CHILD_AGE)"
echo "Mod: $MOD_ID"

# Determine explanation depth
if [ "$CHILD_AGE" -le 5 ] || [ "$READING_LEVEL" = "none" ]; then
    EXPLANATION_DEPTH="simple"
    SENTENCE_RANGE="3-5"
elif [ "$CHILD_AGE" -le 8 ] || [ "$READING_LEVEL" = "basic" ]; then
    EXPLANATION_DEPTH="moderate"
    SENTENCE_RANGE="5-8"
else
    EXPLANATION_DEPTH="detailed"
    SENTENCE_RANGE="8-12"
fi

# Determine parent communication style
if [ "$PARENT_EXPERIENCE" = "experienced" ]; then
    PARENT_STYLE="Talk technically. Skip basic programming concepts. Explain Minecraft/Fabric-specific patterns only."
elif [ "$PARENT_EXPERIENCE" = "basic" ]; then
    PARENT_STYLE="Explain Java/Minecraft-specific concepts. Skip basic programming concepts like variables and loops."
else
    PARENT_STYLE="Explain everything, but keep it practical. Focus on what each piece of code does, not theory."
fi

# Generate AGENTS.md from template
echo "Generating AGENTS.md..."
sed -e "s/{{CHILD_NAME}}/$CHILD_NAME/g" \
    -e "s/{{CHILD_AGE}}/$CHILD_AGE/g" \
    -e "s/{{READING_LEVEL}}/$READING_LEVEL/g" \
    -e "s/{{MOD_ID}}/$MOD_ID/g" \
    -e "s/{{MOD_DISPLAY_NAME}}/$MOD_DISPLAY_NAME/g" \
    -e "s/{{PARENT_STYLE}}/$PARENT_STYLE/g" \
    -e "s/{{CONTENT_GUIDELINES}}/$CONTENT_GUIDELINES/g" \
    -e "s/{{SENTENCE_RANGE}}/$SENTENCE_RANGE/g" \
    -e "s/{{ELEVENLABS_VOICE_ID}}/$ELEVENLABS_VOICE_ID/g" \
    -e "s|{{WORKSPACE}}|$WORKSPACE|g" \
    "$SKILL_DIR/assets/agents-md-template.md" > "$WORKSPACE/AGENTS.md"

# Generate Cursor rules
echo "Generating agent rules..."
RULES_DIR="$WORKSPACE/.cursor/rules"
mkdir -p "$RULES_DIR"

for template in "$SKILL_DIR/assets/rules/"*.template; do
    filename=$(basename "$template" .template)
    sed -e "s/{{MOD_ID}}/$MOD_ID/g" \
        -e "s/{{CHILD_NAME}}/$CHILD_NAME/g" \
        "$template" > "$RULES_DIR/$filename"
done

# Create .gitignore
echo "Generating .gitignore..."
cat > "$WORKSPACE/.gitignore" << 'GITIGNORE'
# Gradle
.gradle/
build/
out/

# IDE
.idea/
*.iml
*.ipr
*.iws
.vscode/

# Minecraft runtime
run/
logs/
*.log

# OS
.DS_Store
Thumbs.db

# Fabric
remappedSrc/

# Java
*.class
*.jar
!gradle/wrapper/gradle-wrapper.jar

# Secrets
.env

# Audio output
audio/
GITIGNORE

# Create audio directory
mkdir -p "$WORKSPACE/audio"

# Create .env for secrets
cat > "$WORKSPACE/.env" << ENV
ELEVENLABS_API_KEY=$ELEVENLABS_API_KEY
ELEVENLABS_VOICE_ID=$ELEVENLABS_VOICE_ID
ENV

echo ""
echo "=== Workspace files generated! ==="
echo "  AGENTS.md"
echo "  .cursor/rules/ ($(ls "$RULES_DIR" | wc -l | tr -d ' ') rules)"
echo "  .gitignore"
echo "  .env"
echo "  audio/"
