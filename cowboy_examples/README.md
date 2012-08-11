##Cowboy

####What is it? (Notes)
- Not only an HTTP server
- A transport and protocol-agnostic acceptor pool, a pool of processes accepting connections
- Can have listeners running side by side (listeners doesn't have to be http)
- TCP, SSL, possibly UDP
- Having many acceptor processes make things faster, Erlang process are lightweight in the Erlang VM, which does not create an OS thread per Erlang process. Avoid process creation time?
- All processes started by a listener are supervised.

###What are connection pools?


Source: http://www.erlang-factory.com/upload/presentations/456/cowboy.pdf