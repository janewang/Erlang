-module(rockpaper).

-export([first/2, second/0, start_First_Node/1, start_Second_Node/0]).

first(0, Second_Node) ->
    {second, Second_Node} ! finished,
    io:format("Game over~n",[]);

first(N, Second_Node) ->
    {ok, [First_hand]} = io:fread("Enter rock, paper or scissors: ", "~s"),
    {second, Second_Node} ! {first, [First_hand], self()},
    receive
        {second, [Second_hand]} ->
            case [Second_hand] of
                rock ->
                    io:format("The other player played rock~n",[]);
                paper ->
                    io:format("The other player played paper~n", []);
                scissors ->
                    io:format("The other player played scissors~n", [])
            end
    end,
    first(N-1, Second_Node).


second() ->
    {ok, [Second_hand]} = io:fread("Enter rock, paper or scissors: ", "~s"),
	receive
	    finished ->
	        io:format("Game over~n", []);
	    {first, [First_hand], first_PID} ->
	        case [First_hand] of 
	            rock ->
	                io:format("The other player played rock~n", []);
	            paper ->
	                io:format("The other player played paper~n", []);
                scissors ->
                    io:format("The other player played scissors~n", [])
            end,
        first_PID ! {second, [Second_hand]},
        second()
    end.

start_Second_Node() ->
    register(second, spawn(rockpaper, second, [])).

start_First_Node(Second_Node) ->
    spawn(rockpaper, first, [3, Second_Node]).