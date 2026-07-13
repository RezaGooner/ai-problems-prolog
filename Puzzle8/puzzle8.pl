:- use_module(library(lists)).
:- use_module(library(readutil)).

go :-
    solve_puzzle.

solve_puzzle :-
    nl,
    writeln('>>> A* 8-Puzzle Solver <<<'),
    writeln('Enter initial board as a list of 9 integers (0..8), where 0 is blank.'),
    writeln('Example: [1,2,3,4,0,6,7,5,8].'),
    nl,
    read_initial_state(Start),
    ( valid_state(Start) ->
        true
    ; writeln('Invalid input: must be a permutation of 0..8.'),
      fail
    ),
    nl,
    writeln('Initial state:'),
    print_board(Start),
    nl,
    ( solvable(Start) ->
        true
    ; writeln('This puzzle configuration is NOT solvable.'),
      fail
    ),
    goal_state(Goal),
    writeln('Finding solution first ...'),
    statistics(walltime, [_]),
    ( a_star(Start, Goal, PathStates, PathActions) ->
        statistics(walltime, [_, TimeMs]),
        length(PathActions, MoveCount),
        nl,
        writeln('Solution found successfully.'),
        format('Number of moves: ~d~n', [MoveCount]),
        format('Time taken: ~3f seconds~n~n', [TimeMs / 1000]),
        writeln('Now the correct path will be shown step by step.'),
        writeln('Press Enter for next step.'),
        nl,
        wait_enter,
        show_full_path(PathStates, PathActions, 1)
    ; writeln('No solution found.'),
      fail
    ).

% -----------------------------------
% Goal state
% -----------------------------------

goal_state([1,2,3,4,5,6,7,8,0]).

% -----------------------------------
% Input and validation
% -----------------------------------

read_initial_state(State) :-
    repeat,
    write('Initial state = '),
    read(Term),
    ( is_list(Term),
      length(Term, 9),
      maplist(integer, Term)
    ->
      State = Term,
      !
    ;
      writeln('Please enter a valid list like [1,2,3,4,0,6,7,5,8].'),
      fail
    ).

valid_state(State) :-
    msort(State, Sorted),
    Sorted = [0,1,2,3,4,5,6,7,8].

solvable(State) :-
    exclude(=(0), State, Tiles),
    inversions(Tiles, Inv),
    0 is Inv mod 2.

inversions(List, Count) :-
    findall(
        1,
        ( nth0(I, List, A),
          nth0(J, List, B),
          J > I,
          A > B
        ),
        Ones
    ),
    length(Ones, Count).

% -----------------------------------
% Board display
% -----------------------------------

print_board([A,B,C,D,E,F,G,H,I]) :-
    print_row([A,B,C]),
    print_row([D,E,F]),
    print_row([G,H,I]).

print_row([X,Y,Z]) :-
    cell_str(X, SX),
    cell_str(Y, SY),
    cell_str(Z, SZ),
    format('| ~w ~w ~w |~n', [SX, SY, SZ]).

cell_str(0, '  ') :- !.
cell_str(N, S) :-
    format(atom(S), '~d ', [N]).

% -----------------------------------
% Helpers
% -----------------------------------

row(Pos, R) :- R is Pos // 3.
col(Pos, C) :- C is Pos mod 3.

set_nth0([_|T], 0, X, [X|T]) :- !.
set_nth0([H|T], I, X, [H|R]) :-
    I > 0,
    I1 is I - 1,
    set_nth0(T, I1, X, R).

swap_positions(State, I, J, Next) :-
    nth0(I, State, Ei),
    nth0(J, State, Ej),
    set_nth0(State, I, Ej, Tmp),
    set_nth0(Tmp, J, Ei, Next).

% -----------------------------------
% Moves
% action(Direction, TileMoved)
% -----------------------------------

move(State, Next, action(left, Tile)) :-
    nth0(B, State, 0),
    col(B, C),
    C < 2,
    T is B + 1,
    nth0(T, State, Tile),
    swap_positions(State, B, T, Next).

move(State, Next, action(right, Tile)) :-
    nth0(B, State, 0),
    col(B, C),
    C > 0,
    T is B - 1,
    nth0(T, State, Tile),
    swap_positions(State, B, T, Next).

move(State, Next, action(up, Tile)) :-
    nth0(B, State, 0),
    row(B, R),
    R < 2,
    T is B + 3,
    nth0(T, State, Tile),
    swap_positions(State, B, T, Next).

move(State, Next, action(down, Tile)) :-
    nth0(B, State, 0),
    row(B, R),
    R > 0,
    T is B - 3,
    nth0(T, State, Tile),
    swap_positions(State, B, T, Next).

% -----------------------------------
% Manhattan heuristic
% -----------------------------------

heuristic(State, H) :-
    goal_state(Goal),
    findall(
        D,
        ( nth0(Pos, State, Tile),
          Tile \= 0,
          nth0(GoalPos, Goal, Tile),
          row(Pos, R1), col(Pos, C1),
          row(GoalPos, R2), col(GoalPos, C2),
          D is abs(R1 - R2) + abs(C1 - C2)
        ),
        Distances
    ),
    sum_list(Distances, H).

% -----------------------------------
% A* Search
% Node structure:
% node(F, G, State, RevStates, RevActions)
% RevStates  = visited states on path in reverse order
% RevActions = actions on path in reverse order
% -----------------------------------

a_star(Start, Goal, PathStates, PathActions) :-
    heuristic(Start, H0),
    astar(
        [node(H0, 0, Start, [Start], [])],
        [best(Start, 0)],
        Goal,
        RevStates,
        RevActions
    ),
    reverse(RevStates, PathStates),
    reverse(RevActions, PathActions).

astar([node(_, _, Goal, RevStates, RevActions)|_], _, Goal, RevStates, RevActions) :- !.

astar([node(_, G, State, RevStates, RevActions)|RestOpen], BestG, Goal, FinalStates, FinalActions) :-
    expand_children(State, G, RevStates, RevActions, BestG, Children, NewBestG),
    append(RestOpen, Children, Open1),
    predsort(compare_nodes, Open1, OpenSorted),
    astar(OpenSorted, NewBestG, Goal, FinalStates, FinalActions).

expand_children(State, G, RevStates, RevActions, BestG0, Children, BestGOut) :-
    findall(pair(Next, Act), move(State, Next, Act), Pairs),
    expand_pairs(Pairs, G, RevStates, RevActions, BestG0, Children, BestGOut).

expand_pairs([], _, _, _, BestG, [], BestG).

expand_pairs([pair(Next, Act)|Rest], G, RevStates, RevActions, BestG0, Children, BestGOut) :-
    G1 is G + 1,
    ( better_g_update(Next, G1, BestG0, BestG1) ->
        heuristic(Next, H1),
        F1 is G1 + H1,
        Child = node(F1, G1, Next, [Next|RevStates], [Act|RevActions]),
        Children = [Child|MoreChildren],
        expand_pairs(Rest, G, RevStates, RevActions, BestG1, MoreChildren, BestGOut)
    ;
        expand_pairs(Rest, G, RevStates, RevActions, BestG0, Children, BestGOut)
    ).

better_g_update(State, G, BestG0, BestGOut) :-
    ( select(best(State, OldG), BestG0, Tail) ->
        G < OldG,
        BestGOut = [best(State, G)|Tail]
    ;
        BestGOut = [best(State, G)|BestG0]
    ).

compare_nodes(Order, node(F1, G1, _, _, _), node(F2, G2, _, _, _)) :-
    ( F1 < F2 -> Order = <
    ; F1 > F2 -> Order = >
    ; G1 < G2 -> Order = <
    ; G1 > G2 -> Order = >
    ; Order = =
    ).

% -----------------------------------
% Step-by-step display after solution
% -----------------------------------

show_full_path([State], [], _) :-
    format('Step ~d (Goal state):~n', [0]),
    print_board(State),
    nl,
    writeln('Goal reached.').

show_full_path([Start|RestStates], Actions, StepNum) :-
    writeln('Start state:'),
    print_board(Start),
    nl,
    show_steps(RestStates, Actions, StepNum).

show_steps([], [], _) :-
    writeln('Goal reached.').

show_steps([State|RestStates], [Action|RestActions], StepNum) :-
    format('Step ~d: ', [StepNum]),
    print_action(Action),
    print_board(State),
    nl,
    ( RestStates \= [] ->
        wait_enter
    ; true
    ),
    NextStep is StepNum + 1,
    show_steps(RestStates, RestActions, NextStep).

print_action(action(Direction, Tile)) :-
    format('move tile ~d to ~w~n', [Tile, Direction]).

wait_enter :-
    writeln('>>> press Enter <<<'),
    read_line_to_string(user_input, _).
