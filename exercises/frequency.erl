-module(frequency).
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).

%%  SERVER - These are the start functions used to create and initialize the server.

start() ->  %% this start the server and spawn a process and calls init()
    register(frequency, spawn(frequency, init, [])).

init() ->  %% create frequencies and loop frencies which just keeps on spawning more process
    Frequencies = {get_frequencies(), []},
    loop(Frequencies).

%Hard Coded
get_frequencies() -> [10,11,12,13,14,15].   %% returns an array of frequencies

call(Message) ->                         %% calls message 
    frequency ! {request, self(), Message},   % send request, pid, and message
    receive
        {reply, Reply} -> Reply            %% if receive reply, print out the reply 
    end.

loop(Frequencies) ->                    %% define function frequencies
    receive
        {request, Pid, allocate} ->
            {NewFrequencies, Reply} = allocate(Frequencies, Pid),  %%allocate frequncies and pid
            reply(Pid, Reply),
            loop(NewFrequencies);  %% loops itself
        {request, Pid, {deallocate, Freq}} ->
            NewFrequencies = deallocate(Frequencies, Freq),  %% deallocate frequencies and pid
            reply(Pid, ok),
            loop(NewFrequencies);   %% loops itself
        {request, Pid, stop} ->      %% stops
            reply(Pid, ok)
    end.

reply(Pid, Reply) ->             % reply just send the pid the repy
    Pid ! {reply, Reply}.
    
%% The internal help function used to allocate and deallocate frequencies

allocate({[], Allocated}, _Pid) ->
    {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
    {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.
deallocate({Free, Allocated}, Freq) ->
    NewAllocated=lists:keydelete(Freq, 1, Allocated),
    {[Freq|Free], NewAllocated}.


% CLIENT - The client functions

stop() ->         %% calls stop makes the client stop
    call(stop).

allocate() ->   %% calls allocate make the client allocate
    call(allocate).

deallocate(Freq) ->     %% calls deallocate
    call({deallocate, Freq}).

%% We hide all message passing and the mssage
%% protocal in a functional interface