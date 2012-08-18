-file("check.erl", 1).

double(X) ->
    X + X.

module_info() ->
    erlang:get_module_info(check).

module_info(X) ->
    erlang:get_module_info(check, X).

