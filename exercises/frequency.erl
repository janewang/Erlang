-module(frequency).
-export([start/0, init/0]).
-export([allocate/0, deallocate/1, stop/0]).

%% server functions
start() ->
    register(frequency, spawn(frequency, init, [])).

init() ->
    Frequencies = {get_frequencies(), []},
    loop(Frequencies).

get_frequencies() -> [10,11,12,13,14,15].

% this function handles every type of receives
loop(Frequencies) ->
    receive
        {request, Pid, allocate} -> 
            {NewFrequencies, Reply} = allocate(Frequencies, Pid),
            reply(Pid, Reply),
            loop(NewFrequencies);
        {request, Pid, {deallocate, Freq}} -> 
            NewFrequencies = deallocate(Frequencies, Freq),
            reply(Pid, ok),
            loop(NewFrequencies);
        {request, Pid, stop} ->
            reply(Pid, ok)
    end.
    
allocate({[], Allocated}, Pid) ->
    {{[], Allocated}, {error, no_frequency_available}};
allocate({[Freq|Free], Allocated}, Pid) ->
    {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}. 

deallocate({Free, Allocated}, Freq) ->
    NewAllocated = lists:keydelete(Freq, 1, Allocated),
    {[Freq|Free], NewAllocated}.




reply(Pid, Reply) ->
    Pid ! {reply, Reply}.

%% client functions
call(Message) ->
    frequency ! {request, self(), Message},
    receive
        {reply, Reply} -> Reply
    end.

allocate() ->
    call(allocate).

deallocate(Freq) ->
    call({deallocate, Freq}).

stop() ->
    call(stop).
    