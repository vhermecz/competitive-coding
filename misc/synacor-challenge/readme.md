Source: https://github.com/Aneurysm9/vm_challenge


## Timelog

### 24JAN06 1.75 10:20-12:05 Initial attempt, implementing opcodes until first missing ADD, implementing debugging

### 24JAN06 1.5 14:25-15:55 Implement more opcodes, start adding debug tooling

### 24JAN06 0.75 23:25-00:10 Add more debugging, realized \n \r issue, moving in the game

VM expected ord=10 as enter, but on linux that was ord=13. Adding in `value-=3 if value==13` solved it
