:- use_module(library(lists)).

read_jobs(0, []).
read_jobs(N, [job(ID, D, P) | Rest]) :-
    N > 0,
    write('Enter job ID: '), read(ID),
    write('Enter deadline day: '), read(D),
    write('Enter penalty: '), read(P),
    N1 is N - 1,
    read_jobs(N1, Rest).

compare_by_penalty(Order, job(_, D1, P1), job(_, D2, P2)) :-
    ( P1 > P2 -> Order = '<'
    ; P1 < P2 -> Order = '>'
    ; D1 > D2 -> Order = '<'
    ; D1 < D2 -> Order = '>'
    ; Order = '='
    ).

sort_jobs(Jobs, Sorted) :-
    predsort(compare_by_penalty, Jobs, Sorted).

max_deadline([], 0).
max_deadline([job(_, D, _) | Rest], Max) :-
    max_deadline(Rest, RMax),
    Max is max(D, RMax).

create_slots(0, []).
create_slots(N, [empty | Rest]) :-
    N > 0,
    N1 is N - 1,
    create_slots(N1, Rest).

get_at([X|_], 1, X).
get_at([_|R], I, X) :-
    I > 1,
    I1 is I - 1,
    get_at(R, I1, X).

replace_at([_|R], 1, V, [V|R]).
replace_at([H|R], I, V, [H|NR]) :-
    I > 1,
    I1 is I - 1,
    replace_at(R, I1, V, NR).

place_job_policy(job(ID,D,P), Days, NewDays, PlacedDay) :-
    get_at(Days, D, empty),
    replace_at(Days, D, job(ID,D,P), NewDays),
    PlacedDay = D,
    !.
place_job_policy(Job, Days, NewDays, PlacedDay) :-
    Job = job(_, D, _),
    place_earliest_free_before_deadline(Job, 1, D, Days, NewDays, PlacedDay).

place_earliest_free_before_deadline(Job, Day, Deadline, Days, NewDays, Day) :-
    Day =< Deadline,
    get_at(Days, Day, empty),
    replace_at(Days, Day, Job, NewDays),
    !.
place_earliest_free_before_deadline(Job, Day, Deadline, Days, NewDays, PlacedDay) :-
    Day < Deadline,
    Next is Day + 1,
    place_earliest_free_before_deadline(Job, Next, Deadline, Days, NewDays, PlacedDay).

schedule_jobs([], Days, Days, [], []).
schedule_jobs([Job|Rest], Days, FinalDays,
              [scheduled(PlacedDay, Job)|ScheduledRest],
              Missed) :-
    place_job_policy(Job, Days, NewDays, PlacedDay),
    schedule_jobs(Rest, NewDays, FinalDays, ScheduledRest, Missed),
    !.
schedule_jobs([Job|Rest], Days, FinalDays,
              Scheduled, [Job|MissedRest]) :-
    schedule_jobs(Rest, Days, FinalDays, Scheduled, MissedRest).

place_latest_free(job(ID,D,P), Day, Days, NewDays) :-
    Day >= 1,
    get_at(Days, Day, empty),
    replace_at(Days, Day, job(ID,D,P), NewDays),
    !.
place_latest_free(Job, Day, Days, NewDays) :-
    Day > 1,
    D1 is Day - 1,
    place_latest_free(Job, D1, Days, NewDays).

compact_schedule(DaysIn, DaysOut) :-
    findall(Job, member(Job, DaysIn), Items),
    include(is_job, Items, JobsOnly),
    max_deadline(JobsOnly, MaxD),
    create_slots(MaxD, EmptyDays),
    sort_jobs(JobsOnly, Sorted),
    foldl(place_compact, Sorted, EmptyDays, DaysOut).

is_job(job(_,_,_)).

place_compact(Job, Days, NewDays) :-
    Job = job(_, D, _),
    place_latest_free(Job, D, Days, NewDays).

print_final_schedule([], _).
print_final_schedule([empty|R], Day) :-
    Day1 is Day + 1,
    print_final_schedule(R, Day1).
print_final_schedule([job(ID,D,P)|R], Day) :-
    format('Day ~w: job ~w (D=~w, P=~w)~n', [Day, ID, D, P]),
    Day1 is Day + 1,
    print_final_schedule(R, Day1).

print_missed([]).
print_missed([job(ID,D,P)|R]) :-
    format('job ~w (D=~w, P=~w)~n', [ID, D, P]),
    print_missed(R).

total_penalty([], 0).
total_penalty([job(_,_,P)|R], T) :-
    total_penalty(R, RT),
    T is P + RT.

run :-
    write('Enter number of jobs: '), read(N),
    read_jobs(N, Jobs),
    sort_jobs(Jobs, SortedJobs),
    max_deadline(SortedJobs, MaxDay),
    create_slots(MaxDay, Days0),
    schedule_jobs(SortedJobs, Days0, DaysBeforeCompact, _, Missed),
    compact_schedule(DaysBeforeCompact, DaysFinal),

    nl,
    write('Final schedule:'), nl,
    print_final_schedule(DaysFinal, 1),

    nl,
    write('Missed jobs:'), nl,
    print_missed(Missed),

    total_penalty(Missed, TP),
    nl,
    format('Total penalty = ~w~n', [TP]).
