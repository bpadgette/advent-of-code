https://adventofcode.com/2025/day/5

- Part 1: simple to solve
- Part 2: simple to solve (with a hash map and infinite memory)
  - Try setting up a sorted tree with ID range bounds as leaves, overlapping ranges could be easy to collapse when traversing the tree
  - Give up on the tree, come up with a recursive solution to condense ranges instead
