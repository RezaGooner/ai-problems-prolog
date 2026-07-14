# 8-Puzzle Solver (A* Algorithm)

This directory contains a robust implementation of the classic **8-Puzzle** problem using **Prolog**. The solver utilizes the **A* Search Algorithm** with the **Manhattan Distance** heuristic to find the most efficient path from an initial state to the goal state.

## 🧩 Problem Overview
The 8-puzzle is a sliding puzzle that consists of a frame of numbered square tiles in random order with one tile missing. The objective is to place the tiles in order by making sliding moves that use the empty space.

<img width="600" height="300" alt="unnamed" src="https://github.com/user-attachments/assets/3f86478c-4636-4eb4-8561-0a5346e6e2b4" />

**Goal State:**
```
| 1 2 3 |
| 4 5 6 |
| 7 8   |
```

## 🚀 Features
- **A* Search Algorithm:** Guarantees an optimal solution (shortest path) provided the heuristic is admissible.
- **Manhattan Distance Heuristic:** Calculates the sum of the absolute differences of coordinates between the current and goal positions of each tile.
- **Solvability Check:** Uses the "Inversion Count" method to determine if a given puzzle configuration can actually be solved before starting the search.
- **Interactive CLI:** Allows the user to input the initial state and view the step-by-step solution.
- **Performance Tracking:** Displays the number of moves and the time taken (in seconds) to find the solution.

## 🛠️ How to Run
1. Ensure you have **SWI-Prolog** installed.
2. Load the file in the terminal:
   ```bash
   swipl 8_puzzle.pl
   ```
3. Start the solver by calling:
   ```prolog
   ?- go.
   ```
4. Enter the initial state as a list of 9 integers (where `0` represents the blank space).
   - Example: `[2, 8, 3, 1, 6, 4, 7, 0, 5].`
  <img width="211" height="211" alt="images (1)" src="https://github.com/user-attachments/assets/2c51aabb-9e57-4b41-a4f7-7788b2477cb5" />


## 🧠 Logic Breakdown
- `solvable/1`: Checks if the number of inversions is even (a requirement for 3x3 puzzles to be solvable).
- `heuristic/2`: Computes the Manhattan Distance.
- `a_star/4`: The main search logic maintaining an open list of `node(F, G, State, PathStates, PathActions)`.
- `move/3`: Defines the legal moves (Up, Down, Left, Right) based on the blank space's position.

## Sample Output
```text
>>> A* 8-Puzzle Solver <<<
Enter initial board as a list of 9 integers (0..8), where 0 is blank.
Example: [1,2,3,4,0,6,7,5,8].

Initial state = [1,2,3,4,8,0,7,6,5].

Solution found successfully.
Number of moves: 5
Time taken: 0.002 seconds

Step 1: move tile 6 to left
| 1 2 3 |
| 4 8 6 |
| 7 0 5 |
...
```
---
