-module(messenger).
-export([start_server/0, server/1, logon/1, logoff/0, message/2, client/2]).

% Change the function below to return the name of the node where message server runs
server_node() -> 
    super@Jane-Wangs-MacBook-Pro.

% This is the server process for the "message"
server(User_List) ->                                                  
    receive
        {From, logon, Name} ->
            New_User_List = server_logon(From, Name, User_List),
            server(New_User_List);
        {From, logoff} ->
            New_User_List = server_logoff(From, User_List),
            server(New_User_List);
        {From, message_to, To, Message} ->
            server_transfer(From, To, Message, User_List),
            io:format("list is now: ~p~n", [User_List]),
            server(User_List)
    end.

start_server() ->                                               
    register(messenger, spawn(messenger, server, [[]])).

server_logon(From, Name, User_List) ->                          
    %% check if loggon on anywhere else
    case lists:keymember(Name, 2, User_List) of                       
        true ->
            From ! {messenger, stop, user_exists_at_other_node}, 
            User_List;
        false ->                                                
            From ! {messenger, logged_on},
            [{From, Name} | User_List]
    end.

server_logoff(From, User_List) ->                               
    lists:keydelete(From, 1, User_List).
    
server_transfer(From, To, Message, User_List) ->                
    case lists:keysearch(From, 1, User_List) of
        false ->
            From ! {messenger, stop, you_are_not_logged_on};
        {value, {From, Name}} ->
            server_transfer(From, Name, To, Message, User_List)
    end.

server_transfer(From, Name, To, Message, User_List) ->
    % Find the receiver and sent the message
    case lists:keysearch(To, 2, User_List) of
        false ->
            From ! {messenger, receiver_not_found};
        {value, {ToPid, To}} ->
            ToPid ! {message_from, Name, Message},
            From ! {messenger, sent}
    end.

logon(Name) ->
    case whereis(mess_client) of                                        
        undefined ->
            register(mess_client,
                spawn(messenger, client, [server_node(), Name]));
        _ -> already_logged_on                                              
    end.

logoff() ->
    mess_client ! logoff.

message(ToName, Message) ->                                          
    case whereis(mess_client) of
        undefined ->
            not_logged_on;
        _ -> mess_client ! {message_to, ToName, Message},              
            ok
    end.

client(Server_Node, Name) ->                                        
    {messager, Server_Node} ! {self(), logon, Name},
    await_result(),
    client(Server_Node).

client(Server_Node) ->                                                  
    receive
        logoff ->
            {messager, Server_Node} ! {self(), logoff},
            exit(normal);
        {message_to, ToName, Message} ->                            
            {messager, Server_Node} ! {self(), message_to, ToName, Message},
            await_result();                                             
        {message_from, FromName, Message} ->
            io:format("Message from ~p: ~p~n", [FromName, Message])      
    end,
    client(Server_Node).

await_result() ->                                                           
    receive
        {messenger, stop, Why} -> % stop the client
            io:format("~p~n", [Why]),
            exit(normal);
        {message, What} ->
            io:format("~p~n", [What])
    end.