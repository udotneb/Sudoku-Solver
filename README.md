# Sudoku-Solver
Swift app that solves inputted sudoku puzzles using backtracking. Animates the backtracking process. Created programmatically using only swift code.

Contains two backtracking algorithms. One is the generic brute force one. The other uses a heuristic to determine which square to pursue next. This other algorithm is much faster for harder sudoku puzzles. 

Utilizes core data to save sudoku board before app closure. Cleans core data with each use, keeping only one board in memory at a time.

## Example
![Alt Text](https://github.com/udotneb/Sudoku-Solver/blob/master/example.gif)
