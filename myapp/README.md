##Rebar with eunit

```sh
$ mkdir myapp; cd myapp
```

```sh
$ rebar create-app appid=myapp
```

```sh
$ rebar compile
```

```sh
$ rebar clean
```

=== Testing ===

In {{{src/myapp_app.erl}}}, after the {{{-export()}}}, add:

```erlang
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.
```

In addition, at the end of the same file, add this code:

```erlang
-ifdef(TEST).

simple_test() ->
    ok = application:start(myapp),
    ?assertNot(undefined == whereis(myapp_sup)).

-endif.
```

```sh
$ rebar compile eunit
```

You should see output something like:

```sh
==> myapp (compile)
Compiled src/myapp_app.erl
==> myapp (eunit)
Compiled src/myapp_app.erl
  Test passed
```

Source: https://github.com/basho/rebar/wiki/Getting-started