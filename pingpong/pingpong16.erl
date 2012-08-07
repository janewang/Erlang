-module(pingpong16).

-export([start/0, ping/1, pong/0]).   % export functions with params

ping(0) ->                            % last case with no more recursion
    pong ! finished,
    io:format("ping finished~n", []);

ping(N) ->                            % with some pings N
    pong ! {ping, self()},
    receive
        pong ->
            io:format("Ping received pong~n", [])
    end,
    ping(N-1).

pong() ->
    receive
        finished ->
            io:format("Pong finished~n", []);
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,
            pong()
    end.

start() ->
    register(pong, spawn(pingpong16, pong, [])),
    spawn(pingpong16, ping, [5]).