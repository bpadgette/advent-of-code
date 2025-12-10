https://adventofcode.com/2025/day/9

> I needed some help on this one.

- Part 1: Simple challenge, somewhat concerned with the opportunities to make this complicated
- Part 2: Suspicions confirmed!
  - Around 10 hours spent
  - First idea was to implement raycasting and check polygon wrapping for each rectangle: https://www.eecs.umich.edu/courses/eecs380/HANDOUTS/PROJ2/InsidePoly.html
  - This approach was too slow given the size of the polygon
  - Several optimizations/memoizations were applied, I had a solution in 30 seconds, but the solution was wrong
  - Finally, I decided to cave and seek out other approaches to the problem
  - I was using https://aoc-puzzle-solver.streamlit.app/ to confirm my solution, and then I saw how the author of the tool approached this problem: https://github.com/mgtezak/Advent_of_Code/blob/master/2025/09/p2.py
  - It seems checking if the *entire rectangle* fits within the polygon rather than checking if each point of the rectangle fits as in the U Mich raycasting article is a faster and more accurate approach to this problem
