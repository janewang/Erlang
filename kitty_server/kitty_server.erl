%%%% Naive version
-module(kitty_server).  

-export([start_link/0, order_cat/4, return_cat/2, close_shop/1]).  

-record(cat, {name, color=green, description}).  

%%% Client API
start_link() -> spawn(fun init/0).  

%% Synchronous call
order_cat(Pid, Name, Color, Description) ->           
    Ref = erlang:monitor(process, Pid),               % monitor is a built in function for erlang that create a monitor by passing a process Id. Another process is created to monitor this process. If the process exits, a DOWN message is sent
                                                      % to the monitor which can then be handled or throw an error. Each process has BIFs to use with, such as put(key, value), get(key), get(), get_keys(value), erase(key), erase().
    Pid ! {self(), Ref, {order, Name, Color, Description}},  
    receive
        {Ref, Cat} ->                                            
            erlang:demonitor(Ref, [flush]),
            Cat;
        {'DOWN', Ref, process, Pid, Reason} ->              
            erlang:error(Reason)
    after 5000 ->                                              
        erlang:error(timeout)
    end.

%% Ths call is asynchronous
return_cat(Pid, Cat = #cat{}) ->                              
    Pid ! {return, Cat},
    ok.

%% synchronous call
close_shop(Pid) ->                                        
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, terminate},                      
    receive
        {Ref, ok} ->                                     
            erlang:demonitor(Ref, [flush]),
            ok;
        {'DOWN', Ref, process, Pid, Reason} ->          
            erlang:error(Reason)
    after 5000 ->
        erlang:error(timeout)                       
    end.

%% Sever function
init() -> loop([]).                              

loop(Cats) ->                                                                   
    receive                   
        {Pid, Ref, {order, Name, Color, Description}} ->                        
            if Cats =:= [] ->
                Pid ! {Ref, make_cat(Name, Color, Description)},                
                loop(Cats);                                                     
                Cats =/= [] -> % got to empty the stock                         
                Pid ! {Ref, hd(Cats)},                                          
                loop(tl(Cats))                                              
            end;
        {return, Cat = #cat{}} ->                                          
            loop([Cat|Cats]);                                              
        {Pid, Ref, terminate} ->                                           
            Pid ! {Ref, ok},
            terminate(Cats);
        Unknown ->                                                         
            %% do some logging here too
            io:format("Unknown message: ~p~n", [Unknown]),                  
            loop(Cats)
    end.

%% Private functions of the main loop                                         
make_cat(Name, Col, Desc) ->                                                
    #cat{name=Name, color=Col, description=Desc}.

terminate(Cats) ->                                                  
    [io:format("~p was set free.~n", [C#cat.name]) || C <- Cats],
    ok.