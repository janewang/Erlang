-module(pingpong17).  %this model separate ping and pong in separate modules

-export([start_ping/1, start_pong/0, ping/2, pong/0]).

ping(0, Pong_Node) ->                     %base case, sent to Pong_Node to another Erlang system
    {pong, Pong_Node} ! finished,         %sent pong to Pong_node
    io:format("ping finished~n", []);     %print in current node ping finished

ping(N, Pong_Node) ->                      % tail recursion
    {pong, Pong_Node} ! {ping, self()},    % send pong to another Erlang system
    receive                                % when receives pong, print ping received pong
        pong ->
            io:format("Ping received pong~n", [])
    end,
    ping(N-1, Pong_Node).

pong() ->
    receive
        finished ->                                 % when receives finishes it calls this            
            io:format("Pong finished~n", []); 
        {ping, Ping_PID} ->                        % when pong is received it print Pong receives ping
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,                        % pass ping id to Pong
            pong()                                  % finally calls pong to return the process  
    end.

start_pong() ->
    register(pong, spawn(pingpong17, pong, [])).

start_ping(Pong_Node) ->
    spawn(pingpong17, ping, [3, Pong_Node]).