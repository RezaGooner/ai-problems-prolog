# Job Scheduling with Deadlines and Penalties

This section contains a Prolog implementation of a **job scheduling** problem where each job has:

- an **ID**
- a **deadline**
- a **penalty**

The goal is to schedule jobs within available days so that the **total penalty of missed jobs is minimized**.

---

## Problem Description

Suppose we have a set of jobs.  
Each job:

- takes **exactly one day**
- must be completed **on or before its deadline**
- causes a **penalty** if it is not scheduled

We want to choose and schedule jobs in a way that minimizes the total penalty of missed jobs.

This implementation uses a **greedy strategy**:

1. Sort jobs by **penalty in descending order**
2. Try to place more important jobs first
3. Assign each selected job to an available day before or on its deadline
4. Jobs that cannot be scheduled are considered **missed**
5. The penalties of missed jobs are added to compute the final total penalty

---

## Input Format

Each job is entered as:

- `Job ID`
- `Deadline day`
- `Penalty`

Example:

```prolog
job(a, 2, 100)
```

which means:

- Job ID = `a`
- Deadline = `2`
- Penalty = `100`

This job should be completed by day 2, otherwise a penalty of 100 is incurred.

---

## How to Run

1. Open SWI-Prolog
2. Load the file:

```bash
swipl job_scheduling.pl
```

3. Run the program:

```prolog
?- run.
```

4. Enter the number of jobs and then the data for each one.

---

## Example Problem

Assume we have 5 jobs:

| Job | Deadline | Penalty |
|-----|----------|---------|
| A   | 2        | 100     |
| B   | 1        | 19      |
| C   | 2        | 27      |
| D   | 1        | 25      |
| E   | 3        | 15      |

Each job takes one day, and at most one job can be done per day.

The maximum deadline is `3`, so we have 3 available days for scheduling.

---

## Example Input

```text
Enter number of jobs: 5
Enter job ID: a
Enter deadline day: 2
Enter penalty: 100

Enter job ID: b
Enter deadline day: 1
Enter penalty: 19

Enter job ID: c
Enter deadline day: 2
Enter penalty: 27

Enter job ID: d
Enter deadline day: 1
Enter penalty: 25

Enter job ID: e
Enter deadline day: 3
Enter penalty: 15
```

---

## Sorted Jobs by Priority

The jobs are sorted by penalty in descending order:

1. `a (D=2, P=100)`
2. `c (D=2, P=27)`
3. `d (D=1, P=25)`
4. `b (D=1, P=19)`
5. `e (D=3, P=15)`

This means the algorithm tries to schedule the jobs with the highest penalty first.

---

## Example Output

```text
Final schedule:
Day 1: job a (D=2, P=100)
Day 2: job c (D=2, P=27)
Day 3: job e (D=3, P=15)

Missed jobs:
job d (D=1, P=25)
job b (D=1, P=19)

Total penalty = 44
```

---

## Explanation of the Result

There are only 3 available days, so not all 5 jobs can be scheduled.

The algorithm gives priority to jobs with higher penalties:

- `a` is very important because missing it causes penalty `100`
- `c` is also important with penalty `27`
- `e` can still fit on day `3`

Jobs `d` and `b` both have deadline `1`, but there is only one available slot before or on day 1, and higher-priority jobs occupy the schedule. Therefore, these two jobs are missed.

### Final schedule:
- Day 1 → `a`
- Day 2 → `c`
- Day 3 → `e`

### Missed jobs:
- `d`
- `b`

### Total missed penalty:
- `25 + 19 = 44`

So the final total penalty is:

```text
44
```

---

## Main Predicates

- `read_jobs/2`  
  Reads jobs from user input

- `sort_jobs/2`  
  Sorts jobs by penalty in descending order

- `max_deadline/2`  
  Finds the maximum deadline to determine the number of available days

- `create_slots/2`  
  Creates empty schedule slots

- `schedule_jobs/5`  
  Tries to place jobs into valid days

- `compact_schedule/2`  
  Rearranges scheduled jobs compactly into valid positions

- `print_final_schedule/2`  
  Prints the final day-by-day schedule

- `print_missed/1`  
  Prints jobs that could not be scheduled

- `total_penalty/2`  
  Computes the total penalty of missed jobs

- `run/0`  
  Main predicate to execute the whole program

---

## Algorithm Idea

This implementation follows a **greedy approach**.

### Greedy rule:
Schedule the jobs with the **largest penalties first**, because missing them is more costly.

This helps reduce the total penalty of unscheduled jobs.

---

## Notes

- Each job takes exactly **one day**
- Only **one job per day** can be scheduled
- Jobs must be completed **on or before** their deadline
- The program minimizes the total penalty of missed jobs using a greedy strategy
- This is a classic scheduling problem in Artificial Intelligence and Algorithms

---

