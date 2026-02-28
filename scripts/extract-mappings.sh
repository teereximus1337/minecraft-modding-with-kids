#!/bin/bash
set -e

MOD_DIR="${1:?Usage: extract-mappings.sh <mod_project_dir>}"
OUTPUT_FILE="${2:-references/class-mappings-1.21.11.md}"

echo "=== Extracting Minecraft 1.21.11 Class Mappings ==="
cd "$MOD_DIR"

export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home}"
export PATH="${JAVA_HOME}/bin:$PATH"

# Generate decompiled sources
echo "Decompiling Minecraft sources (this takes ~30 seconds)..."
./gradlew genSources 2>&1 | tail -3

# Find the sources JAR
SOURCES_JAR=$(find .gradle/loom-cache/minecraftMaven -name "*-sources.jar" -path "*minecraft-common*" | head -1)
if [ -z "$SOURCES_JAR" ]; then
    echo "ERROR: Could not find decompiled sources JAR."
    echo "Falling back to bundled class-mappings-1.21.11.md"
    exit 1
fi
echo "Found sources: $SOURCES_JAR"

# Extract class paths
echo "Extracting class names..."
TMPFILE=$(mktemp)
jar tf "$SOURCES_JAR" | grep "\.java$" | grep -E "^net/minecraft/(world/item/|world/entity/|world/effect/|world/level/block/|core/|resources/|sounds/|server/level/|world/Interaction)" | sort > "$TMPFILE"

# Build the reference file
OUTPUT_PATH="$(cd "$(dirname "$0")/.." && pwd)/$OUTPUT_FILE"
cat > "$OUTPUT_PATH" << 'HEADER'
# Minecraft 1.21.11 Mojang Official Mappings — Definitive Class Reference

Extracted from decompiled 1.21.11 sources. These are the ONLY correct class names.
AI training data contains outdated names — ALWAYS verify against this file.

## CRITICAL: Classes that were REMOVED or RENAMED in 1.21.11

| Old Name (WRONG) | Replacement | Notes |
|---|---|---|
| `SwordItem` | `Item` with `.sword()` on Properties | No more SwordItem class |
| `TieredItem` | `Item` with tool Properties methods | No more TieredItem class |
| `DiggerItem` | `Item` with tool Properties methods | No more DiggerItem class |
| `ResourceLocation` | `net.minecraft.resources.Identifier` | Renamed in 1.21.x |
| `Item.Settings` | `Item.Properties` | Mojang mapping name |
| `World` / `ServerWorld` | `Level` / `ServerLevel` | Mojang mapping names |
| `StatusEffect` / `StatusEffects` | `MobEffect` / `MobEffects` | Mojang mapping names |
| `StatusEffectInstance` | `MobEffectInstance` | Mojang mapping name |
| `SoundCategory` | `SoundSource` | Mojang mapping name |

HEADER

echo "## Item Classes" >> "$OUTPUT_PATH"
grep "world/item/" "$TMPFILE" | grep "^net/minecraft/world/item/[A-Z]" | sed 's|/|.|g' | sed 's/\.java$//' >> "$OUTPUT_PATH"

echo "" >> "$OUTPUT_PATH"
echo "## Entity Classes" >> "$OUTPUT_PATH"
grep "world/entity/" "$TMPFILE" | grep "^net/minecraft/world/entity/[A-Z]" | sed 's|/|.|g' | sed 's/\.java$//' >> "$OUTPUT_PATH"

echo "" >> "$OUTPUT_PATH"
echo "## Effect Classes" >> "$OUTPUT_PATH"
grep "world/effect/" "$TMPFILE" | sed 's|/|.|g' | sed 's/\.java$//' >> "$OUTPUT_PATH"

echo "" >> "$OUTPUT_PATH"
echo "## Registry Classes" >> "$OUTPUT_PATH"
grep -E "(core/Registry|core/registries/|resources/)" "$TMPFILE" | sed 's|/|.|g' | sed 's/\.java$//' >> "$OUTPUT_PATH"

echo "" >> "$OUTPUT_PATH"
echo "## Sound & Particle Classes" >> "$OUTPUT_PATH"
grep -E "(SoundEvents|SoundSource|ParticleTypes)" "$TMPFILE" | sed 's|/|.|g' | sed 's/\.java$//' >> "$OUTPUT_PATH"

echo "" >> "$OUTPUT_PATH"
echo "## Level/World Classes" >> "$OUTPUT_PATH"
grep -E "(ServerLevel|Level|BlockPos|InteractionResult|InteractionHand|CreativeModeTabs|BuiltInRegistries)\.java$" "$TMPFILE" | sed 's|/|.|g' | sed 's/\.java$//' >> "$OUTPUT_PATH"

rm "$TMPFILE"
echo "Class mappings written to: $OUTPUT_PATH"
echo "$(wc -l < "$OUTPUT_PATH") lines extracted."
