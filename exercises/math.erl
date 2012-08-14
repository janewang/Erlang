-module(math).
-export([add/2]).

add(X,Y) -> 
    test_int(X), 
    test_int(Y), 
    X + Y.

test_int(Int) when is_integer(Int) -> true; test_int(Int) -> throw({error, {non_integer, Int}})