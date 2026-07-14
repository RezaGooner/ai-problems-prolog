# Sudoku Solver using Constraint Logic Programming (CLP(FD))

<img width="554" height="554" alt="images" src="https://github.com/user-attachments/assets/000d9fb9-9c90-4531-8d4f-df6edc4e0341" />

This directory contains a Prolog implementation of the classic **Sudoku Puzzle Solver** using **Constraint Logic Programming over Finite Domains (CLP(FD))**.

The solver allows users to enter the known values of a Sudoku puzzle and automatically finds a valid solution that satisfies all Sudoku constraints.

---

## 🧩 Problem Description

Sudoku is a logic-based puzzle played on a 9×9 grid.

The objective is to fill the empty cells with digits from **1 to 9** such that:

- Each row contains every digit exactly once.
- Each column contains every digit exactly once.
- Each 3×3 subgrid contains every digit exactly once.

---

## 🚀 Features

- Interactive user input
- Automatic Sudoku solving
- Constraint-based reasoning using `CLP(FD)`
- Validation of Sudoku rules
- Readable grid display
- Detects unsolvable puzzles

---

## 🛠 How to Run

1. Open SWI-Prolog.
2. Load the program:

```bash
swipl sudoku.pl
```

3. Start the solver:

```prolog
?- start.
```

4. Enter the known cells of the puzzle.
5. Enter `0` as the row number when finished.

---

## Example Problem

Given the following Sudoku puzzle:

> Ex 1
```text
5 3 _ | _ 7 _ | _ _ _
6 _ _ | 1 9 5 | _ _ _
_ 9 8 | _ _ _ | _ 6 _
```
> Ex 2
```
8 _ _ | _ 6 _ | _ _ 3
4 _ _ | 8 _ 3 | _ _ 1
7 _ _ | _ 2 _ | _ _ 6
```
> Ex 3
```
_ 6 _ | _ _ _ | 2 8 _
_ _ _ | 4 1 9 | _ _ 5
_ _ _ | _ 8 _ | _ 7 9
```

---

## Example Input

> Ex 1
```text
Row number (1-9) or 0 to finish: 1
Col num (1-9): 1
Value (1-9): 5

Row number (1-9) or 0 to finish: 1
Col num (1-9): 2
Value (1-9): 3

Row number (1-9) or 0 to finish: 1
Col num (1-9): 5
Value (1-9): 7

...

Row number (1-9) or 0 to finish: 0
```

---

## Example Output

### Result:

> Ex 1 (Solution)
```text
5 3 4 6 7 8 9 1 2
6 7 2 1 9 5 3 4 8
1 9 8 3 4 2 5 6 7
```
> Ex 2 (Solution)
```
8 5 9 7 6 1 4 2 3
4 2 6 8 5 3 7 9 1
7 1 3 9 2 4 8 5 6
```
> Ex 3 (Solution)
```
9 6 1 5 3 7 2 8 4
2 8 7 4 1 9 6 3 5
3 4 5 2 8 6 1 7 9
```

---

## How It Works

The solver models Sudoku as a Constraint Satisfaction Problem (CSP):

1. Every cell is a variable with domain `1..9`.
2. All values in each row must be distinct.
3. All values in each column must be distinct.
4. All values in each 3×3 block must be distinct.
5. Constraint propagation reduces the search space.
6. Labeling assigns values that satisfy all constraints.

---

## Main Predicates

- `sudoku/1`
  - Defines all Sudoku constraints.

- `blocks/3`
  - Validates 3×3 subgrids.

- `create_empty_grid/1`
  - Creates an empty 9×9 board.

- `set_cell/4`
  - Inserts a value into a specific cell.

- `get_user_inputs/1`
  - Reads puzzle values from the user.

- `print_grid/1`
  - Displays the Sudoku board.

- `start/0`
  - Main entry point of the program.

---

## Algorithm

This implementation uses:

- Constraint Satisfaction Problem (CSP)
- Constraint Logic Programming over Finite Domains (CLP(FD))
- Backtracking Search
- Constraint Propagation

Unlike brute-force approaches, CLP(FD) significantly reduces the search space by enforcing constraints before exploring assignments.

---

## Requirements

- SWI-Prolog
- `library(clpfd)`

---
