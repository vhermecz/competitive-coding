Source: https://github.com/Aneurysm9/vm_challenge


## Timelog

### 24JAN06 1.75 10:20-12:05 Initial attempt, implementing opcodes until first missing ADD, implementing debugging

### 24JAN06 1.5 14:25-15:55 Implement more opcodes, start adding debug tooling

### 24JAN06 0.75 23:25-00:10 Add more debugging, realized \n \r issue, moving in the game

VM expected ord=10 as enter, but on linux that was ord=13. Adding in `value-=3 if value==13` solved it

### 24JAN07 0.5 10:10-10:40 Implementing memdump

### 24JAN08 1 9:40-10:40 Printing out, analyzing text

#### Game data structure

Starting at 0x1814 a repeating structure:
- The first two strings start with upper-case letter 
- First is the title of the room
- Second is the description
- Remaining strings until next one with upper-case start is are the available actions

Strange string at 0x654d "dbqpwuiolxv8WTYUIOAHXVM"

From 0x6565, the actions avail:
- go
- look
- help
- inv
- take
- drop
- use

Memory between 0x6584 .. 0x65a4 is 0s, 33 0 value.

There are two longer texts:
- strange book: "A Brief Introduction to Interdimensional Physics"
  - TLDR: Talks about teleportation via placing a value into r7 (8th register). "you will need to extract the confirmation algorithm, reimplement it on more powerful hardware, and optimize it"
- journal: Talks about the Orb and Reverse Polish Notation (RPN)
  - Weight of Orb altered by mosaic 'runes' with RPN
  - Weight of Orb should be match text when entering Vault door?
  - Orb's pedestal '22'
  - Vauld door '30'
  - Rune values: '1', '4', '4', '8', '9', '11', '18', '*', '*', '*', '*', '+', '-', '-', '-'
  - Days on journal follow Fib 1,1,2,3,5,...,144

All the items in the game:
- 0x46a4 tablet: The tablet seems appropriate for use as a writing surface but is unfortunately blank.  Perhaps you should USE it as a writing surface...
- 0x4734 empty lantern: The lantern seems to have quite a bit of wear but appears otherwise functional.  It is, however, sad that it is out of oil.
- 0x47be lantern: The lantern seems to have quite a bit of wear but appears otherwise functional.  It is off but happily full of oil.
- 0x483a lit lantern: The lantern seems to have quite a bit of wear.  It is lit and producing a bright light.
- 0x489e can: This can is full of high-quality lantern oil.
- 0x48d0 red coin: This coin is made of a red metal.  It has two dots on one side.
- 0x4919 corroded coin: This coin is somewhat corroded.  It has a triangle on one side.
- 0x4967 shiny coin: This coin is somehow still quite shiny.  It has a pentagon on one side.
- 0x49ba concave coin: This coin is slightly rounded, almost like a tiny bowl.  It has seven dots on one side.
- 0x4a1f blue coin: This coin is made of a blue metal.  It has nine dots on one side.
- 0x4a6b teleporter: This small device has a button on it and reads "teleporter" on the side.
- 0x4abf business card: This business card has "synacor.com" printed in red on one side.
- 0x4b0e orb: This is a clear glass sphere about the size of a tennis ball.
- 0x4b50 mirror: This is a rather mundane hand-held mirror from the otherwise magnificent vault room.  What USE could it possibly have?
- 0x4bce strange book
- 0x565b journal

There are 70 locations in the game:
- 0x1814: Foothills
- 0x18e4: Foothills
- 0x193f: Dark cave
- 0x19db: Dark cave
- 0x1a4d: Dark cave
- 0x1b20: Rope bridge
- 0x1bb4: Falling through the air!
- 0x1c7c: Moss cavern
- 0x1d64: Moss cavern
- 0x1dd6: Moss cavern
- 0x1e8d: Passage
- 0x1f5d: Passage
- 0x1ff9: Twisty passages
- 0x20a2: Twisty passages
- 0x20fb: Twisty passages
- 0x2154: Twisty passages
- 0x21f7: Twisty passages
- 0x2250: Twisty passages
- 0x22fa: Twisty passages
- 0x2353: Twisty passages
- 0x23a0: Twisty passages
- 0x23ed: Twisty passages
- 0x2441: Dark passage
- 0x24cb: Dark passage
- 0x2505: Dark passage
- 0x253f: Dark passage
- 0x25bb: Ruins
- 0x26c5: Ruins
- 0x278d: Ruins
- 0x28cf: Ruins
- 0x2983: Ruins
- 0x2a1e: Ruins
- 0x2aa2: Ruins
- 0x2b64: Ruins
- 0x2c19: Synacor Headquarters
- 0x2d36: Synacor Headquarters
- 0x2de4: Beach
- 0x2ea5: Beach
- 0x2fbd: Beach
- 0x30c1: Tropical Island
- 0x31a9: Tropical Island
- 0x3245: Tropical Island
- 0x3348: Tropical Island
- 0x3482: Tropical Island
- 0x3594: Tropical Cave
- 0x368b: Tropical Cave
- 0x3720: Tropical Cave
- 0x3882: Tropical Cave Alcove
- 0x3940: Tropical Cave
- 0x394e: This tunnel slopes deeper underground to the north, but the fireflies are all around to light your path.
- 0x39c3: Vault Lock
- 0x3a5a: Vault Lock
- 0x3af8: Vault Lock
- 0x3b94: Vault Door
- 0x3ca7: Vault Lock
- 0x3d46: Vault Lock
- 0x3de8: Vault Lock
- 0x3e8d: Vault Lock
- 0x3f2a: Vault Lock
- 0x3fc7: Vault Lock
- 0x406b: Vault Lock
- 0x410d: Vault Lock
- 0x41ad: Vault Antechamber
- 0x4261: Vault Lock
- 0x42fd: Vault Lock
- 0x439b: Vault Lock
- 0x4432: Vault
- 0x4513: Fumbling around in the darkness
- 0x45a4: Fumbling around in the darkness
- 0x4633: Panicked and lost
