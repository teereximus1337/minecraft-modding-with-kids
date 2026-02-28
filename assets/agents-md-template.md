# Minecraft Modding with {{CHILD_NAME}} -- Agent Guidelines

## Project Context

Parent and {{CHILD_NAME}} ({{CHILD_AGE}}-year-old) are building Minecraft mods together using an AI coding agent. This is {{CHILD_NAME}}'s introduction to coding. The goal is **fun first, learning second** -- but every session should plant seeds of computational thinking.

- **Mod project name**: `{{MOD_ID}}`
- **Mod ID / namespace**: `{{MOD_ID}}`
- **Framework**: Fabric + Fabric API
- **Minecraft version**: 1.21.11 (pinned)
- **JDK**: 21

## Who's Talking

The parent is the primary operator. {{CHILD_NAME}} (reading level: {{READING_LEVEL}}) participates during build sessions.

**Default mode (parent)**: {{PARENT_STYLE}}

**When asked for a "{{CHILD_NAME}} explanation"**: Generate a {{SENTENCE_RANGE}} sentence explanation and speak it aloud via ElevenLabs TTS (voice_id: `{{ELEVENLABS_VOICE_ID}}`). See the voice explanation guide for age-appropriate rules.

## Session Flow

Sessions have two phases:

1. **Prep phase** (parent solo): Scaffold boilerplate, get things compiling. Leave fun decisions for {{CHILD_NAME}}.
2. **Build phase** (parent + {{CHILD_NAME}}): {{CHILD_NAME}} is the creative director. They decide what to make, name it, pick behaviors. AI generates code, parent runs it, they test in-game.

### Build Phase: Audio FIRST, Then Code

Every code change during build phase follows this order:
1. **Voice explanation** via ElevenLabs TTS -- play BEFORE editing any code
2. **Code changes** -- consult class-mappings-1.21.11.md before writing imports
3. **Build** -- `./gradlew build`
4. **Launch Minecraft** -- kill old instances, `./gradlew runClient` -- ALWAYS LAST

## Coding Approach

- {{CHILD_NAME}} is the creative director, parent is the typist, AI is the engineer
- Use descriptive, fun names {{CHILD_NAME}} would recognize
- Generate ALL required files for every new item/block (never partial implementations)
- Always include full file paths in code blocks

## Content Guidelines

{{CONTENT_GUIDELINES}}

## Technical

- Fabric mod loader (not Forge, not NeoForge)
- Mojang Official Mappings (check class-mappings reference before writing imports)
- `./gradlew build` to compile, `./gradlew runClient` to test
- 16x16 pixel PNG textures
- Git commit after every milestone with fun messages

## ElevenLabs Voice

- Voice ID: `{{ELEVENLABS_VOICE_ID}}`
- Model: `eleven_flash_v2_5`
- Output: `{{WORKSPACE}}/audio/`
- Play with: `open <file>.mp3` (macOS) or `xdg-open <file>.mp3` (Linux)
