:- use_module(library(lists)).

% Read N tasks from the user
read_tasks(0, []).
read_tasks(N, [task(ID, Start, End) | Rest]) :-
    N > 0,
    write('Enter task ID: '),
    read(ID),
    write('Enter start time: '),
    read(Start),
    write('Enter end time: '),
    read(End),
    N1 is N - 1,
    read_tasks(N1, Rest).

% Compare tasks by end time for sorting
compare_by_end(Order, task(_, S1, E1), task(_, S2, E2)) :-
    ( E1 < E2 -> Order = '<'
    ; E1 > E2 -> Order = '>'
    ; S1 =< S2 -> Order = '<'
    ; Order = '>'
    ).

% Sort tasks in ascending order of end time
sort_tasks(Tasks, SortedTasks) :-
    predsort(compare_by_end, Tasks, SortedTasks).

% Greedy selection of non-overlapping tasks
select_tasks([], _, []).
select_tasks([task(ID, Start, End) | Rest], LastEnd, [task(ID, Start, End) | Selected]) :-
    Start >= LastEnd,
    select_tasks(Rest, End, Selected).
select_tasks([task(_, Start, _) | Rest], LastEnd, Selected) :-
    Start < LastEnd,
    select_tasks(Rest, LastEnd, Selected).

% Print the selected schedule
print_schedule([]).
print_schedule([task(ID, Start, End) | Rest]) :-
    format('Task ~w: Start = ~w, End = ~w~n', [ID, Start, End]),
    print_schedule(Rest).

% Main predicate
run :-
    write('Enter number of tasks: '),
    read(N),
    read_tasks(N, Tasks),
    sort_tasks(Tasks, SortedTasks),
    select_tasks(SortedTasks, 0, SelectedTasks),
    nl,
    write('Scheduled tasks:'), nl,
    print_schedule(SelectedTasks).
