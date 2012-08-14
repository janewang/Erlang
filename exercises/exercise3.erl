-module(exercise3).
-export([sum/1, sum/2, create/1, reverse_create/1, printlist/1]).


sum(N) when N > 0 ->
    N + sum(N-1);
sum(0) -> 0.


sum(X,Y) ->
    if 
        X > Y ->
            sum(X) - sum(Y) + Y;
        X < Y ->
            sum(Y) - sum(X) + X;
        X =:= Y ->
            X
    end.

create(N) when N > 0 ->
    [N] ++ create(N-1);
create(0) -> [].

reverse_create(N) ->
    lists:reverse(create(N)).

printlist(N) ->
    io:format("Number:~p~n",[create(N)]).