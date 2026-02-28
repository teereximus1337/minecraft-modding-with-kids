# Session Flow

How to structure modding sessions with parent and child.

## Two Phases

### Prep Phase (Parent Solo)
- Scaffold boilerplate: Java classes, registration, model JSONs, lang entries
- Get things compiling with `./gradlew build`
- Leave the FUN decisions for the child: naming, behaviors, colors, textures
- Summarize what's ready and what's left to decide

### Build Phase (Parent + Child)
- Child is the creative director: they decide WHAT to make
- AI is the engineer: decides HOW to implement it
- Parent is the bridge: relays between child and AI
- Keep the feedback loop tight: build, run, see it, react, iterate
- Each change should be testable in under 5 minutes

## Build Phase Timeline (~30 min)

| Time | Activity |
|---|---|
| 0-5 min | Child picks what to build, names it |
| 5-15 min | Voice explanation, code generation, test in Minecraft |
| 15-25 min | Iterate: "What else should it do?" Add features, test again |
| 25-30 min | Final test, celebrate, git commit, teaser for next time |

## Workflow: Every Code Change

1. **Voice explanation** (ElevenLabs TTS → play audio)
2. **Code changes** (edit files)
3. **Build** (`./gradlew build`)
4. **Launch** (kill old Minecraft, `./gradlew runClient`) — ALWAYS LAST

## First Session Checklist

- [ ] Minecraft Java Edition installed and launched once
- [ ] Mod environment set up and compiling
- [ ] A pre-built starter item ready to show the child
- [ ] Child picks the REAL first item to build together
- [ ] Build it, test it, celebrate
- [ ] Git commit with a fun message

## Between Sessions

End every session with:
1. A git commit (fun message: "Add [Child]'s Exploding Chicken Cannon!")
2. A summary of what was built
3. A teaser: "Next time, we could make it [exciting possibility]..."
4. Push to GitHub: `git push`

## Git Workflow

- Commit after every working milestone
- Fun, descriptive messages (not "update code")
- Never force-push or rebase
- Linear history only
- Push to remote after each session

## In-Game First

When introducing a new concept (Redstone, command blocks, etc.), explore it in Minecraft first before opening any code. Let the child see and play with the concept, THEN explain how code controls it.
