# Task Scheduling using Greedy Algorithm in Prolog

This section contains a Prolog implementation of the **Task Scheduling Problem** (also known as **Activity Selection Problem**) using a **Greedy Algorithm**.

The goal is to select the maximum number of **non-overlapping tasks** based on their **start** and **end** times.

---

## Problem Description

Suppose we have several tasks.  
Each task has:

- an **ID**
- a **start time**
- an **end time**

We want to schedule as many tasks as possible such that **no two selected tasks overlap**.

The greedy strategy used here is:

1. Sort all tasks by their **end time** in ascending order
2. Always select the next task whose **start time** is greater than or equal to the **end time of the last selected task**

This strategy guarantees an optimal solution for the activity selection problem.

---

## Prolog Code Features

- Reads tasks interactively from the user
- Sorts tasks by finishing time
- Selects compatible tasks greedily
- Prints the final selected schedule

---

## Input Format

Each task is entered as:

- `Task ID`
- `Start Time`
- `End Time`

Example task:

```prolog
task(t1, 1, 4)
```

which means:

- Task ID = `t1`
- Start Time = `1`
- End Time = `4`

---

## How to Run

1. Open SWI-Prolog
2. Load the file:

```bash
swipl task_scheduling.pl
```

3. Run the main predicate:

```prolog
?- run.
```

4. Enter the number of tasks and then the data for each task.

---

## Example Problem

Assume we have the following tasks:

| Task | Start | End |
|------|-------|-----|
| A    | 1     | 4   |
| B    | 3     | 5   |
| C    | 0     | 6   |
| D    | 5     | 7   |
| E    | 8     | 9   |
| F    | 5     | 9   |

We want to choose the maximum number of non-overlapping tasks.

---

## Example Input

```text
Enter number of tasks: 6
Enter task ID: a
Enter start time: 1
Enter end time: 4

Enter task ID: b
Enter start time: 3
Enter end time: 5

Enter task ID: c
Enter start time: 0
Enter end time: 6

Enter task ID: d
Enter start time: 5
Enter end time: 7

Enter task ID: e
Enter start time: 8
Enter end time: 9

Enter task ID: f
Enter start time: 5
Enter end time: 9
```

---

## Example Output

```text
Scheduled tasks:
Task a: Start = 1, End = 4
Task d: Start = 5, End = 7
Task e: Start = 8, End = 9
```

---

## Explanation of the Final Schedule

After sorting by end time, the tasks are considered in this order:

1. `a (1,4)`
2. `b (3,5)`
3. `c (0,6)`
4. `d (5,7)`
5. `e (8,9)`
6. `f (5,9)`

### Step-by-step selection:
- Select **A (1,4)** because it finishes earliest
- Skip **B (3,5)** because it overlaps with A
- Skip **C (0,6)** because it overlaps with A
- Select **D (5,7)** because it starts after A ends
- Select **E (8,9)** because it starts after D ends
- Skip **F (5,9)** because it overlaps with D

### Final selected schedule:
- **A** → `(1,4)`
- **D** → `(5,7)`
- **E** → `(8,9)`

This is the maximum set of non-overlapping tasks.

---

## Algorithm Used

This implementation uses the **Greedy Method**.

### Why Greedy works here?
For the activity selection problem, choosing the activity with the **earliest finishing time** always leaves the most room for the remaining activities. Therefore, this strategy leads to an optimal solution.

---

## Main Predicates

- `read_tasks/2`  
  Reads task data from the user

- `sort_tasks/2`  
  Sorts tasks by end time

- `select_tasks/3`  
  Selects non-overlapping tasks greedily

- `print_schedule/1`  
  Prints the final selected tasks

- `run/0`  
  Main entry point of the program

---

## Notes

- This implementation assumes task times are valid numeric values.
- Tasks are selected based only on **time compatibility**, not on profit, priority, or weight.

---
