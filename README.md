# AI Problem Solving with Prolog 

## 🚀 Overview
Prolog (Programming in Logic) is a declarative language particularly well-suited for symbolic AI, constraint satisfaction, and search-based problems. This repository contains various classic AI challenges, ranging from pathfinding to optimized scheduling.

---

## 📂 Project Structure

Each directory contains a specific problem, its Prolog implementation, and a dedicated README with detailed explanations.

### 🧩 1. [8-Puzzle Solver](https://github.com/RezaGooner/ai-problems-prolog/tree/main/8-Puzzle)
*   **Technique**: A* Search Algorithm.
*   **Heuristic**: Manhattan Distance.
*   **Concepts**: State-space search, Admissible heuristics, Solvability (Inversion Count).

### 🗓️ 2. [Job Scheduling](https://github.com/RezaGooner/ai-problems-prolog/tree/main/Job%20Scheduling)
This section covers optimization problems using Greedy approaches:
*   **[Activity Selection](https://github.com/RezaGooner/ai-problems-prolog/tree/main/Job%20Scheduling/Activity%20Selection%20Problem)**: Maximizing the number of non-overlapping tasks.
*   **[Job Selection with Penalties](https://github.com/RezaGooner/ai-problems-prolog/tree/main/Job%20Scheduling/Job%20Sequencing%20with%20Deadlines%20and%20Penalties)**: Minimizing total penalty for jobs with deadlines.

### 🔢 3. [Sudoku Solver](https://github.com/RezaGooner/ai-problems-prolog/tree/main/Sudoko)
*   **Technique**: Constraint Logic Programming over Finite Domains (CLP(FD)).
*   **Concepts**: Constraint Satisfaction Problems (CSP), Backtracking, Constraint Propagation.

---

## 🧠 AI Concepts Explored
- **State-Space Search**: Navigating through possible configurations to find a goal.
- **Informed Search (A*)**: Using heuristics to find the shortest path efficiently.
- **Greedy Algorithms**: Making locally optimal choices with the hope of finding a global optimum.
- **Constraint Satisfaction**: Modeling problems with variables, domains, and rules.

---

## 🛠️ Requirements
To run these programs, you need **SWI-Prolog** installed on your system.
1. Download it from [swi-prolog.org](https://www.swi-prolog.org/).
2. Clone this repository:
   ```bash
   git clone https://github.com/RezaGooner/ai-problems-prolog.git
   ```
3. Consult the README within each folder for specific execution commands.

---
