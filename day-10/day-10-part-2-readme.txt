Possible paths to (joltage : path count)
0:1
1:1
4:1
5:1 (from 4:1)
6:2 (from 4:1 + 5:1)
7:4 (from 4:1 + 5:1 + 6:2)
10:4 (from 7:4)
11:4 (from 7:4)
12:8 (from 10:4 + 11:4)

So, algorithm:
- The number of paths to joltage 0 is 1
- For each joltage, in ascending order starting from the smallest adapter:
  - The number of paths to that joltage is the sum of the (up to 3) number of paths to each of the joltages that can come before the current joltage.
  - Store that value (in a key:value store of joltage:path_count)

Then, the total number of paths is simply the number of paths to the final joltage.

No recursion needed!