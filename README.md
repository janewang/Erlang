Erlang
======

## Why Erlang?
- Shorter Code and Possibly Clearer Code
- Stability Under Heavy Load
- Understand message queues and selective receives vs. callbacks and context switching
- Understand concurrency models

"Concurrency in Erlang is fundamental to its success. Rather than providing threads that share memory, each Erlang process executes in its own memory space and owns its own heap and stack. Processes can’t interfere with each other inadvertently, as is all too easy in threading models, leading to deadlocks and other horrors."


![OTP png](https://github.com/janewang/erlang/raw/master/erlang.png)


####Applications

- Kitty Server - Erlang Processes
- PingPong - Erlang systems passing messages in the form of ping pong
- Messenger - Multiple Erlang Nodes passing messages
- MyApp - OTP with Eunit Setup
- Cowboy Examples - How to Use Cowboy