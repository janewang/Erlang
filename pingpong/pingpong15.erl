-module(pingpong15).

-export([start/0, ping/2, pong/0]).  % spawn a process most export this, ping takes a number and process ID, pong response

ping(0, Pong_PID) ->                                  % finishes last ping and passes finished to pong
    Pong_PID ! finished,
    io:format("ping finished~n", []);

ping(N, Pong_PID) ->                 
    Pong_PID ! {ping, self()},                        % call pong with (ping, process ID)
    receive
        pong ->                                       % on receiving pong , prints ping
            io:format("Ping received pong~n", [])   
    end,
    ping(N - 1, Pong_PID).                            % recursive call to self

pong() ->
    receive
        finished ->                                   % when pong receives finishes, it finshes te pong
            io:format("Pong finished~n", []);
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),    % receive msg from ping with (ping, process ID) and prints pong
            Ping_PID ! pong,                          % send pong to Ping ID
            pong()
    end.

start() ->
    Pong_PID = spawn(pingpong15, pong, []),
    spawn(pingpong15, ping, [3, Pong_PID]).