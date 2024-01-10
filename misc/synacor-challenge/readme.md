Source: https://github.com/Aneurysm9/vm_challenge


## Timelog

### 24JAN06 1.75 10:20-12:05 Initial attempt, implementing opcodes until first missing ADD, implementing debugging

### 24JAN06 1.5 14:25-15:55 Implement more opcodes, start adding debug tooling

### 24JAN06 0.75 23:25-00:10 Add more debugging, realized \n \r issue, moving in the game

VM expected ord=10 as enter, but on linux that was ord=13. Adding in `value-=3 if value==13` solved it

### 24JAN07 0.5 10:10-10:40 Implementing memdump

### 24JAN08 1.25 9:40-10:55 Printing out, analyzing text

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

There are 69 locations in the game:
- 0x1814 Foothills: doorway south
- 0x18e4 Foothills: north
- 0x193f Dark cave: north south
- 0x19db Dark cave: north south
- 0x1a4d Dark cave: bridge south
- 0x1b20 Rope bridge: continue back
- 0x1bb4 Falling through the air!: down
- 0x1c7c Moss cavern: west east
- 0x1d64 Moss cavern: west
- 0x1dd6 Moss cavern: east passage
- 0x1e8d Passage: cavern ladder darkness
- 0x1f5d Passage: continue back
- 0x1ff9 Twisty passages: ladder north south east west
- 0x20a2 Twisty passages: north south west
- 0x20fb Twisty passages: north south east
- 0x2154 Twisty passages: north south west east
- 0x21f7 Twisty passages: north south east
- 0x2250 Twisty passages: north south west east
- 0x22fa Twisty passages: north east south
- 0x2353 Twisty passages: west
- 0x23a0 Twisty passages: west
- 0x23ed Twisty passages: north south
- 0x2441 Dark passage: west east
- 0x24cb Dark passage: east west
- 0x2505 Dark passage: east west
- 0x253f Dark passage: east west
- 0x25bb Ruins: east north
- 0x26c5 Ruins: north south
- 0x278d Ruins: north south east west
- 0x28cf Ruins: south
- 0x2983 Ruins: down west
- 0x2a1e Ruins: up
- 0x2aa2 Ruins: up east
- 0x2b64 Ruins: down
- 0x2c19 Synacor Headquarters: outside
- 0x2d36 Synacor Headquarters: inside
- 0x2de4 Beach: west east north
- 0x2ea5 Beach: east north
- 0x2fbd Beach: west north
- 0x30c1 Tropical Island: north south east
- 0x31a9 Tropical Island: north south west
- 0x3245 Tropical Island: north south
- 0x3348 Tropical Island: north south
- 0x3482 Tropical Island: north south
- 0x3594 Tropical Cave: north south
- 0x368b Tropical Cave: north south
- 0x3720 Tropical Cave: north south east
- 0x3882 Tropical Cave Alcove: west
- 0x3940 Tropical Cave: north south
- 0x39c3 Vault Lock: east south
- 0x3a5a Vault Lock: east south west
- 0x3af8 Vault Lock: east south west
- 0x3b94 Vault Door: south west vault
- 0x3ca7 Vault Lock: north east south
- 0x3d46 Vault Lock: north east south west
- 0x3de8 Vault Lock: north east south west
- 0x3e8d Vault Lock: north south west
- 0x3f2a Vault Lock: north east south
- 0x3fc7 Vault Lock: north east south west
- 0x406b Vault Lock: north east south west
- 0x410d Vault Lock: north south west
- 0x41ad Vault Antechamber: north east south
- 0x4261 Vault Lock: north east west
- 0x42fd Vault Lock: north east west
- 0x439b Vault Lock: north west
- 0x4432 Vault: leave
- 0x4513 Fumbling around in the darkness: forward back
- 0x45a4 Fumbling around in the darkness: run investigate
- 0x4633 Panicked and lost: run wait hide eaten

Next tasks:
- Should capture code area running during the game
  - Init code coverage tracing
  - Dump code coverage tracing
  - NOTE: Could collect addresses we jumped to, add labels to them
- Goal is probably to USE teleporter
- Could identify:
  - Where the code is located for item uses
  - Where are the edges between locations stored
  - Where is the list of items for each location stored
  - Where is game state stored?

### 24JAN08 4.5 17:20-21:50 trace code/data use, decode some functions, get xor'ed texts, initial understanding on logic

`use tablet`: You find yourself writing "pWDWTEfURAdS" on the tablet.  Perhaps it's some kind of code?

@19:15
idea: trace memory

0x0a84: 0x0923 => 0x0000 when `take tablet`


Variables
  0x6584: input prompt is read here

0x05c8 is a function `array_apply_fn(r0:string*, r1:apply_fn*, r2:accumulator)`
  apply_fn alters accumulator, r1 will be 0 (if apply_fn terminated) or length of array
It is called with these apply functions:
- SET r1 0x060e: simply print character
- SET r1 0x0611: xor + print character
- SET r1 0x0669: compare_arrays (r2-in: other array, r2-out: idx of difference if r1==0)
- SET r1 0x14f3: 
- SET r1 0x16cc: 
- SET r1 0x16ec: 
- SET r1 0x171b: 

There are 35 callsites using xord printing.

Callsites look like:

```
0x0b06: 0x0001 0x8000 0x6b24          SET r0 0x6b24
0x0b09: 0x0001 0x8001 0x0611          SET r1 0x0611
0x0b0c: 0x0009 0x8002 0x0f76 0x507a   ADD r2 0x0f76 0x507a
0x0b10: 0x0011 0x05c8                 CALL 0x05c8
```

Could be extracted via finding the `0x0001 0x8000 {r0} 0x0001 0x8001 0x0611 0x0009 0x8002 {r2_1} {r2_2} 0x0011 0x05c8` patterns.

```
cases = [[0x6b24, 0x0f76, 0x507a], [0x6b36, 0x2865, 0x4813]]  # manually collected [r0, r2_1, r2_2]
def hex(value)
  "0x" + value.to_s(16).rjust(4, "0")
end
cases = [[0x68f1, 0x4133, 0x2e42]]
mem = File.read(".dump.short").unpack("S<*")
cases.each do |start, xr1, xr2|
  xor = (xr1+xr2) % 32768
  len = mem[start]
  text = mem[start+1..start+len].map{|v|(v ^ xor).chr}.join
  p [hex(start), hex(xor), text]
end
```

These are:
- addr:0x6b24, xor:0x5ff0, text:"\nWhat do you do?\n"
- addr:0x6b36, xor:0x7078, text:"You see no such item.\n"
- addr:0x6b4d, xor:0x29e7, text:"\nThings of interest here:\n"
- addr:0x6b68, xor:0x4179, text:"I don't understand; try 'help' for instructions.\n"
- addr:0x6b9a, xor:0x0365, text:"look\n  You may merely 'look' to examine the room, or you may 'look <subject>' (such as 'look chair') to examine something specific.\ngo\n  You may 'go <exit>' to travel in that direction (such as 'go west'), or you may merely '<exit>' (such as 'west').\ninv\n  To see the contents of your inventory, merely 'inv'.\ntake\n  You may 'take <item>' (such as 'take large rock').\ndrop\n  To drop something in your inventory, you may 'drop <item>'.\nuse\n  You may activate or otherwise apply an item with 'use <item>'.\n"
- addr:0x6d93, xor:0x04e7, text:"Your inventory:\n"
- addr:0x6da4, xor:0x0560, text:"Taken.\n"
- addr:0x6dac, xor:0x62f1, text:"You see no such item here.\n"
- addr:0x6dc8, xor:0x146d, text:"Dropped.\n"
- addr:0x6dd2, xor:0x1de9, text:"You can't find that in your pack.\n"
- addr:0x6df5, xor:0x0261, text:"You can't find that in your pack.\n"
- addr:0x6e18, xor:0x2472, text:"You aren't sure how to use that.\n"
- addr:0x6e3a, xor:0x777a, text:"You have been eaten by a grue.\n"
- addr:0x6e5a, xor:0x6860, text:"Chiseled on the wall of one of the passageways, you see:\n\n    "
- addr:0x6e9d, xor:0x3265, text:"\n\nYou take note of this and keep walking.\n\n"
- addr:0x6ec9, xor:0x6366, text:"That door is locked.\n"
- addr:0x6edf, xor:0x71f7, text:"You find yourself writing \""
- addr:0x6eff, xor:0x4ce7, text:"\" on the tablet.  Perhaps it's some kind of code?\n\n"
- addr:0x6f33, xor:0x7afa, text:"You fill your lantern with oil.  It seems to cheer up!\n\n"
- addr:0x6f6c, xor:0x78f8, text:"You'll have to find something to put the oil into first.\n\n"
- addr:0x6fa7, xor:0x6575, text:"You light your lantern.\n\n"
- addr:0x6fc1, xor:0x4977, text:"You douse your lantern.\n\n"
- addr:0x6fdb, xor:0x4be0, text:"You're not sure what to do with the coin.\n"
- addr:0x7006, xor:0x50e7, text:"You place the "
- addr:0x7015, xor:0x01f6, text:" into the leftmost open slot.\n"
- addr:0x7034, xor:0x78e9, text:"As you place the last coin, they are all released onto the floor.\n"
- addr:0x7077, xor:0x00ea, text:"As you place the last coin, you hear a click from the north door.\n"
- addr:0x70ba, xor:0x3fe8, text:"A strange, electronic voice is projected into your mind:\n\n  \"Unusual setting detected!  Starting calibration process!  Estimated time to completion: 1 billion years.\"\n\n"
- addr:0x7163, xor:0x59eb, text:"You wake up on a sandy beach with a slight headache.  The last thing you remember is activating that teleporter... but now you can't find it anywhere in your pack.  Someone seems to have drawn a message in the sand here:\n\n    "
- addr:0x724a, xor:0x74f1, text:"\n\nIt begins to rain.  The message washes away.\n\n"
- addr:0x727b, xor:0x30f1, text:"A strange, electronic voice is projected into your mind:\n\n  \"Miscalibration detected!  Aborting teleportation!\"\n\nNothing else seems to happen.\n\n"
- addr:0x730c, xor:0x18f8, text:"You activate the teleporter!  As you spiral through time and space, you think you see a pattern in the stars...\n\n    "
- addr:0x7386, xor:0x0b6e, text:"\n\nAfter a few moments, you find yourself back on solid ground and a little disoriented.\n\n"
- addr:0x73e0, xor:0x2d71, text:"You gaze into the mirror, and you see yourself gazing back.  But wait!  It looks like someone wrote on your face while you were unconscious on the beach!  Through the mirror, you see \""
- addr:0x749d, xor:0x0a77, text:"\" scrawled in charcoal on your forehead.\n\nCongratulations; you have reached the end of the challenge!\n\n"

Okay, so these are strings related to the use of objects.

0x73e0 ... 0x749d => flag?
0x7163 ... => message in the sand?
0x70ba 0x7163 0x724a 0x727b 0x730c 0x7386 => teleporter use

@21:05 - Yey, got the use function of the teleporter

@21:23 CALL 0x0747 prints the flags

@21:45 taking a break

Findings:
- Looks like the game setups up the required state to get the flags
- Need to further understand the structure of the source

Next tasks:
- Further decode `usetablet.trace.txt`, understand how the use-fn is called for an object, find datastructure for objects


### 24JAN09 1 20:00-20:20, 21:00-21:45 Found game::use, descriptor array of objects, decoded some functions

Yey, trace format I invented is super useful, can search for register values during execution. Tablet use function is 0x1286:

```
0x0e0c: 0x0008 0x8000 0x0e27          JF reg::0 0x0e27              r0=0x0a82 r1=0x0e06 r2=0x0003 r3=0x0006 r4=0x0065 r5=0x0000 r6=0x0000 r7=0x0000 st:0x0007|0x0010 0x1802 0x0001 0x0b9e 0x6588 0x0e06
0x0e0f: 0x0009 0x8001 0x8000 0x0002   ADD reg::1 reg::0 0x0002      r0=0x0a82 r1=0x0e06 r2=0x0003 r3=0x0006 r4=0x0065 r5=0x0000 r6=0x0000 r7=0x0000 st:0x0007|0x0010 0x1802 0x0001 0x0b9e 0x6588 0x0e06
0x0e13: 0x000f 0x8001 0x8001          RMEM reg::1 reg::1            r0=0x0a82 r1=0x0a84 r2=0x0003 r3=0x0006 r4=0x0065 r5=0x0000 r6=0x0000 r7=0x0000 st:0x0007|0x0010 0x1802 0x0001 0x0b9e 0x6588 0x0e06
0x0e16: 0x0007 0x8001 0x0e27          JT reg::1 0x0e27              r0=0x0a82 r1=0x0000 r2=0x0003 r3=0x0006 r4=0x0065 r5=0x0000 r6=0x0000 r7=0x0000 st:0x0007|0x0010 0x1802 0x0001 0x0b9e 0x6588 0x0e06
0x0e19: 0x0009 0x8001 0x8000 0x0003   ADD reg::1 reg::0 0x0003      r0=0x0a82 r1=0x0000 r2=0x0003 r3=0x0006 r4=0x0065 r5=0x0000 r6=0x0000 r7=0x0000 st:0x0007|0x0010 0x1802 0x0001 0x0b9e 0x6588 0x0e06
0x0e1d: 0x000f 0x8001 0x8001          RMEM reg::1 reg::1            r0=0x0a82 r1=0x0a85 r2=0x0003 r3=0x0006 r4=0x0065 r5=0x0000 r6=0x0000 r7=0x0000 st:0x0007|0x0010 0x1802 0x0001 0x0b9e 0x6588 0x0e06
0x0e20: 0x0008 0x8001 0x0e41          JF reg::1 0x0e41              r0=0x0a82 r1=0x1286 r2=0x0003 r3=0x0006 r4=0x0065 r5=0x0000 r6=0x0000 r7=0x0000 st:0x0007|0x0010 0x1802 0x0001 0x0b9e 0x6588 0x0e06
0x0e23: 0x0011 0x8001                 CALL reg::1                   r0=0x0a82 r1=0x1286 r2=0x0003 r3=0x0006 r4=0x0065 r5=0x0000 r6=0x0000 r7=0x0000 st:0x0007|0x0010 0x1802 0x0001 0x0b9e 0x6588 0x0e06
0x1286: 0x0002 0x8000                 PUSH reg::0                   r0=0x0a82 r1=0x1286 r2=0x0003 r3=0x0006 r4=0x0065 r5=0x0000 r6=0x0000 r7=0x0000 st:0x0008|0x1802 0x0001 0x0b9e 0x6588 0x0e06 0x0e25
```

Can see &use_fn is loaded from 0x0a85, and offsetted from struct 0x0a82. Use is called from 0x0e23, probably the main use function.

NOTE: Logging call depth in the trace could be useful also.

Did decode some more functions

Next tasks:
- 0x0a82 is object descriptor land
- 0x0e06 is game::use function?
- Further decode `usetablet.trace.txt`, understand how the use-fn is called for an object, find datastructure for objects

### 24JAN10 1.5 8:15-8:50, 12:00-13:00 Cleanup source.txt, found game graph

Adding data into source dump

@8:50 break

Done:
- Add .dump hex option to dump data in disasm format
- .decode to print character on `OUT literat`
- .text to print more strings, wrap in apos
- .decode to use rN instead of reg::N
- add self-test and data sections into source.txt

### 24JAN10 2.75 14:00..17:15 Draw graph, find twisty flag

@14:00-14:27 write code for graph

lunchbreak 

@15:00-

0x68f1 has some kind of text, pieced together from the xor'd text
Must be text as it has 28 uniq values and length of 48.

```
when ".text2"
  addr = 0x68f1
  len = @memory[addr]
  def decoder(memory, addr)
    return memory[addr] ^ 0x4ce7 if addr < 0x6f33
    return memory[addr] ^ 0x7afa if addr < 0x6f6c
    memory[addr] ^ 0x78f8
  end
  # 0x6eff: xor:0x4ce7, text:"\" on the tablet.  Perhaps it's some kind of code?\n\n"
  # 0x6f33: xor:0x7afa, text:"You fill your lantern with oil.  It seems to cheer up!\n\n"
  # 0x6f6c: xor:0x78f8, text:"You'll have to find something to put the oil into first.\n\n"
  value = len.times.map{|i|decoder(@memory, @memory[addr + 1 + i]).chr}.join ""
  puts value
```

"ms Ih  es  h Iaist   'itIai  I'hoI lull\niek   dd" is not it :( :)

Nope, it is just xor'd text for the post self-test "The self-test completion code is: BNCyODLfQkIl\n\n"

In Twisty passage the flag is "rdMkyZhveeIv" by reverse engineering, r0=88=0x58

Got this from brute forcing all 64 possible values, and matching with the expected md5.

This means that s0973 and s0978 needs to be visited before s0982.

Movement is: west, south, north

Could have figured it out as this being the shortest path to trigger the reset

Input to reproduce:
- doorway
- north
- north
- bridge
- continue
- down
- west
- passage
- ladder
- west
- south
- north

@16:53
annotating strings and functions manually is boring
lets implement an annotation tool for the source.txt file

Progress:
- Code:
- Add @calldepth
- Print chars read by IN
- Add some logic_* methods to read basic data structures
- Add .graph to dump game graph
- Fix asm repl, add CALL support
- Fix prim_debug_ref_parse
- Crack:
- Find twisty flag
- Draw game graph


Next steps:
- Crearte source annotator tool
- Add actions and objects into scene-graph/game-graph

@17:15

### 24JAN10 2 17:15..19:45 Create annotations.txt and annotator.rb

At s278d (Ruins) probably need to use the 5 coins to activate the statue

@18:29 compiling the annotations.txt

Discovered the dict structure:

```
0x6b14: 0x0007                        DATA
0x6b15: 0x6565                        DATA  string "go"
0x6b16: 0x6568                        DATA  string "look"
0x6b17: 0x656d                        DATA  string "help"
0x6b18: 0x6572                        DATA  string "inv"
0x6b19: 0x6576                        DATA  string "take"
0x6b1a: 0x657b                        DATA  string "drop"
0x6b1b: 0x6580                        DATA  string "use"
0x6b1c: 0x0007                        DATA
0x6b1d: 0x0cc3                        DATA
0x6b1e: 0x0baa                        DATA
0x6b1f: 0x0d1b                        DATA
0x6b20: 0x0d38                        DATA
0x6b21: 0x0d5e                        DATA
0x6b22: 0x0db6                        DATA
0x6b23: 0x0e06                        DATA
```

Two arrays after one another. Index of key is looked up in first array, value is located by index in second.

@18:57 annotator is nearing launch

@19:10
break
@19:34

finishing annotator.
