-module(event_manager).
-export([start/2, stop/1]).
-export([add_handler/3, delete_handler/2, get_data/2, send_event/2]).
-export([init/1]).

start(Name, HandlerList) ->   % spawn an event manager process and register with alias Name
    register(Name, spawn(event_manager, init, [HandlerList])), ok.

init(HandlerList) ->  % starts executing at init with a HandlerList tuple {Handler, Date}
    loop(initialize(HandlerList)).

initialize([]) -> [];
initialize([{Handler, InitDate}|Rest]) -> % We get here from initialize with the HandlerList, and for every entry
    [{Handler, Handler:init(InitDate)}|initialize(Rest)].  % the result is stored in {Handler, State} where state is returned
    % to the init init function
    
stop(Name) ->
    Name ! {stop, self()},
    receive {reply, Reply} -> Reply end.

terminate([]) -> [];
terminate([{Handler, Data}|Rest]) ->
    [{Handler, Handler:terminate(Data)}|terminate(Rest)].
    
    
%% client functions
add_handler(Name, Handler, InitData) ->
    call(Name, {add_handler, Handler, InitData}).
    
delete_handler(Name, Handler) ->
    call(Name, {delete_handler, Handler}).

get_data(Name, Event) ->
    call(Name, {send_event, Event}).

send_event(Name, Event) ->
    call(Name, {send_event, Event}).

handle_msg({add_handler, Handler, InitData}, LoopData) ->
    {ok, [{Handler, Handler:init(InitData)}|LoopData]};
    
handle_msg({delete_handler, Handler}, LoopData) ->
    case lists:keysearch(Handler, 1, LoopData) of 
        false ->
            {{error, instance}, LoopData};
        {value, {Handler, Data}} ->
            Reply = {data, Handler:terminate(Data)},
            NewLoopData = lists:keydelete(Handler, 1, LoopData),
            {Reply, NewLoopData}
    end;

handle_msg({get_data, Handler}, LoopData) ->
    case lists:keysearch(Handler, 1, LoopData) of
        false                       -> {{error, instance}, LoopData};
        {value, {Handler, Data}}    -> {{data, Data}, LoopData}
    end;

handle_msg({send_event, Event}, LoopData) ->
    {ok, event(Event, LoopData)}.
    
event(_Event, []) -> [];
event(Event, [{Handler, Data}|Rest]) ->
    [{Handler, Handler:handle_event(Event, Data)}|event(Event, Rest)].
    
call(Name, Msg) ->
    Name ! {request, self(), Msg},
    receive {reply, Reply} -> Reply end.

reply(To, Msg) ->
    To ! {reply, Msg}.

loop(State) ->
    receive
        {request, From, Msg} ->
            {Reply, NewState} = handle_msg(Msg, State),
            reply(From, Reply),
            loop(NewState);
        {stop, From} ->
            reply(From, terminate(State))
    end.