# Voice Explanation Guide

How to generate spoken explanations for kids during Minecraft modding sessions.

## Core Principle

The child cannot read scrolling code. Voice is their window into what's happening. Every code change gets a spoken explanation BEFORE the code is written.

## Timing: Audio FIRST, Then Code

1. Write the explanation text
2. Call ElevenLabs `text_to_speech` (voice_id from config, model: `eleven_flash_v2_5`)
3. Play the audio with `open <file>.mp3` (macOS) or `xdg-open <file>.mp3` (Linux)
4. ONLY THEN proceed to edit code files

Never batch audio generation with code edits. The child needs context before seeing changes.

## Age-Adaptive Complexity

### Ages 4-5 / Reading Level: None
- 3-5 sentences max
- Zero code terminology
- Pure analogies: "We told the computer to put lightning on the cow, like a magic spell!"
- Focus on what they'll SEE, not how it works
- Heavy excitement, simple cause and effect

### Ages 6-8 / Reading Level: Basic
- 5-8 sentences
- Introduce "rules," "numbers," and "order" concepts
- "There's a number that controls how big the explosion is. We changed it from 3 to 6!"
- "The computer reads rules from top to bottom, like a checklist"
- Connect code changes to visible in-game results

### Ages 9-12 / Reading Level: Intermediate
- 8-12 sentences
- Use simplified code terminology: "We added an IF statement"
- "The IF asks a question: is the player crouching? If yes, shoot the beam"
- Can reference file names and line numbers
- Encourage them to predict what will happen before testing

## Translation Guide

| Code Concept | Kid-Friendly Version |
|---|---|
| Class / Object | "A set of instructions for making a thing" |
| Method / Function | "A special move" or "a trick it knows" |
| Variable | "A label" or "a name tag for a number" |
| If/else | "A rule: IF this happens, THEN do that" |
| Loop | "Do this over and over until you're done" |
| Bug / Error | "The computer got confused! Let's figure out why" |
| Compile / Build | "Putting all the pieces together" |
| Registry | "Adding it to Minecraft's big list of stuff" |
| Import | "Borrowing a tool from Minecraft's toolbox" |
| Parameter / Number | "A number that controls something" |

## Explanation Structure

Every explanation should follow this pattern:

1. **Start with the plan**: What are we building? What will it do in-game?
2. **Reference what the child said**: "You said you wanted bigger explosions, right?"
3. **Explain the code logic**: How does the code make it happen?
4. **Connect to the result**: What will they see when they test it?
5. **End with excitement**: "Go try it right now!"

## Teaching Code Logic (Progressive)

Build these concepts over multiple sessions:

**Sessions 1-3: Things exist because of instructions**
"We tell the computer what to make, and it makes it"

**Sessions 4-6: Order matters**
"The computer reads rules top to bottom, like a checklist"

**Sessions 7-10: Conditions (IF/THEN)**
"We added a question the computer asks every time"

**Sessions 10+: Numbers change everything**
"Let's change this number and see what happens"

## Conversational Tone

- Never use the same greeting twice in a row
- Vary naturally: "So check this out..." / "Guess what!" / "OK here's the plan..." / dive straight in
- Reference what the child actually said (their voice input is the prompt)
- Sound excited, not instructional
- Frame bugs as puzzles, not failures
- End with a teaser or call to action

## ElevenLabs Settings

```
tool: text_to_speech
voice_id: {{ELEVENLABS_VOICE_ID}}
model_id: eleven_flash_v2_5
output_format: mp3_44100_128
output_directory: {{WORKSPACE}}/audio
speed: 1.0
stability: 0.45
similarity_boost: 0.75
```

Play with `open` (macOS) or `xdg-open` (Linux). Never use `afplay` (format issues).
Call `open` exactly ONCE per explanation.
