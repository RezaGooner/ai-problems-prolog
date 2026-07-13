:- use_module(library(clpfd)).

% Rule of Sudoku
sudoku(Rows) :-
    % check length of rows and columns (must be 9*9)
    length(Rows, 9),
    maplist(same_length(Rows), Rows),

    % variables to the range of 1 to 9
    append(Rows, Vs),
    Vs ins 1..9,

    % Rule of non-repeating rows
    maplist(all_distinct, Rows),

    % Rule of non-repeating columns
    transpose(Rows, Columns),
    maplist(all_distinct, Columns),

    % rule of non-repetition for 3*3 blocks
    Rows = [R1, R2, R3, R4, R5, R6, R7, R8, R9],
    blocks(R1, R2, R3),
    blocks(R4, R5, R6),
    blocks(R7, R8, R9).

% Define 3*3 blocks
blocks([], [], []).
blocks([A,B,C|Bs1], [D,E,F|Bs2], [G,H,I|Bs3]) :-
    all_distinct([A,B,C,D,E,F,G,H,I]),
    blocks(Bs1, Bs2, Bs3).

% Creating an empty 9*9 grid consisting of free variables
create_empty_grid(Grid) :-
    length(Grid, 9),
    maplist(create_row, Grid).
create_row(Row) :- length(Row, 9).

% Filling a specific cell in the grid 
% based on the row (1 to 9) and column (1 to 9)
set_cell(Grid, RowIdx, ColIdx, Val) :-
    nth1(RowIdx, Grid, Row),
    nth1(ColIdx, Row, Val).

% Collecting information from the user
get_user_inputs(Grid) :-
    writeln('>>> Sudoku <<<'),
    writeln('Please enter the specified values.'),
    writeln('To finish data entry, enter 0 as the row number.'),
    get_input_loop(Grid).

get_input_loop(Grid) :-
    write('Row number (1-9) or 0 to finish: '), read(Row),
    (   Row = 0
    ->  true
    ;   write('Col num (1-9): '), read(Col),
        write('Value (1-9): '), read(Val),
        (   between(1, 9, Row), between(1, 9, Col), between(1, 9, Val)
        ->  set_cell(Grid, Row, Col, Val),
            writeln('OK!')
        ;   writeln('Error: The entered values ​​must be between 1 and 9!')
        ),
        get_input_loop(Grid)
    ).

% Displaying the Sudoku grid in a readable format
print_grid([]).
print_grid([Row|Rows]) :-
    print_row(Row),
    print_grid(Rows).

print_row([]) :- nl.
print_row([H|T]) :-
    (   var(H) -> write('_ ') ; write(H), write(' ')   ),
    print_row(T).

% Program execution start point
start :-
    create_empty_grid(Grid),
    get_user_inputs(Grid),
    writeln('\nYour initial table looks like this::'),
    print_grid(Grid),
    writeln('\nSolving Sudoku...'),
    (   sudoku(Grid),
        % Labeling to find variable values
        flatten(Grid, FlatGrid),
        label(FlatGrid)
    ->  writeln('\nResult:'),
        print_grid(Grid)
    ;   writeln('\nUnfortunately, this grid has no solution, or the initial values ​​conflict with the rules of Sudoku.')
    ).
