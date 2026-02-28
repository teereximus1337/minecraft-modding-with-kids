# Minecraft Modding with Kids

Teach your kid to code through Minecraft modding -- with an AI coding assistant that talks to them.

## What Is This?

An [Agent Skill](https://skills.sh) that turns any AI coding agent into a Minecraft modding partner for you and your kid. It handles everything:

- **Full environment setup**: Java, Fabric mod loader, project scaffolding
- **Voice explanations**: Your kid hears what's happening via ElevenLabs TTS -- no reading code required
- **Correct, modern API**: Bundled Minecraft 1.21.11 class mappings extracted from decompiled sources (avoids the stale training data problem)
- **Personalized onboarding**: Interviews you about your kid's name, age, reading level, and interests
- **Session management**: Prep phase (parent solo) and build phase (kid + parent together)
- **Age-adaptive teaching**: Explanations scale from "pure analogies" (age 4-5) to "simplified code concepts" (age 9-12)

Works with **Cursor, Claude Code, Antigravity, Codex, Windsurf**, and 25+ other agents.

## Install

```bash
npx skills add https://github.com/teereximus1337/minecraft-modding-with-kids -y
```

## Requirements

- **macOS or Linux** (Apple Silicon or Intel)
- **Minecraft Java Edition** (~$30 from [minecraft.net](https://minecraft.net))
- **ElevenLabs account** (for voice explanations -- [elevenlabs.io](https://elevenlabs.io), free tier available)
- **An AI coding agent** (Cursor, Claude Code, etc.)

## How It Works

### First Run

Open a new project folder and tell your agent: *"Set up Minecraft modding with my kid."*

The skill will:
1. Interview you (kid's name, age, interests, your coding experience)
2. Install JDK 21 and the Fabric mod framework
3. Generate a personalized mod project
4. Configure ElevenLabs voice explanations
5. Create a starter mod so your kid sees something immediately

### Each Session

Your kid talks (via voice-to-text like Wispr Flow or macOS Dictation), the AI:
1. **Explains the plan out loud** via ElevenLabs (kid listens)
2. **Writes the code** (while the explanation plays)
3. **Builds the mod** 
4. **Launches Minecraft** with the changes

Your kid is the creative director. They decide what to build. The AI handles the Java.

### What Kids Learn

Through play, not lectures:
- **Numbers control things**: "Change the explosion number from 3 to 10 and see what happens"
- **Order matters**: "The computer does step 1, then step 2, in order"
- **Conditions are questions**: "IF the player is crouching, THEN shoot the beam"
- **Loops repeat**: "Do this for every block from here to bedrock"
- **Debugging is detective work**: "The computer went to the wrong address -- let's fix it"

## What's Inside

```
minecraft-modding-with-kids/
├── SKILL.md                          # Main skill: onboarding, sessions, development
├── references/
│   ├── class-mappings-1.21.11.md     # Correct Minecraft class names (from decompiled sources)
│   ├── fabric-patterns.md            # Tested code patterns for items, blocks, sounds
│   ├── voice-explanation-guide.md    # Age-adaptive voice explanation rules
│   └── session-flow.md              # Session structure and workflow
├── scripts/
│   ├── onboard.sh                   # Environment setup (JDK, Fabric, project)
│   ├── extract-mappings.sh          # Extract class mappings from Minecraft sources
│   └── generate-workspace.sh        # Generate personalized workspace files
└── assets/
    ├── agents-md-template.md        # AGENTS.md template with placeholders
    ├── rules/                       # Agent rule templates
    └── sample-textures/             # Starter pixel art
```

## Why This Exists

AI coding assistants are incredibly powerful, but their training data contains outdated Minecraft modding patterns. Classes like `SwordItem` and `ResourceLocation` don't exist anymore in Minecraft 1.21.11. This skill bundles the correct, verified API extracted from actual decompiled sources -- so the AI writes code that compiles on the first try.

It also solves the "kid can't read code" problem. Voice explanations let children as young as 4-5 participate meaningfully in the coding process without needing to read scrolling Java.

## Built By

Rex and Gus (age 6), during a weekend of Minecraft modding in February 2026. Started with a lightning sword, ended with a drum kit and a portable skill package.

## License

MIT
