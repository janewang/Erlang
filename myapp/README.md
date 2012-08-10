Getting Started
First Steps
The best way to get going with Rebar is to use it to construct and build a simple Erlang application. First, let's create the directory for our application:

$ mkdir myapp; cd myapp
Now, download the rebar binary into our application. Note: if you have rebar available on your shell PATH, that will work equally well.

$ wget http://bitbucket.org/basho/rebar/downloads/rebar; chmod u+x rebar
Now, we'll use Rebar's templating system to create the skeleton of our application:

$ ./rebar create-app appid=myapp
The result of this command will be a single sub-directory, "src" which contains three files:

myapp.app.src - The OTP application specification
myapp_app.erl - An implementation of the OTP Application behaviour
myapp_sup.erl - An implementation of an OTP Supervisor behaviour
We can now compile this application with rebar:

$ ./rebar compile
A new directory, "ebin/" will now exist and in it you will find the .beam files corresponding to the Erlang source files in the source directory. In addition, note the presence of ebin/myapp.app -- Rebar has dynamically generated a proper OTP application specification using the template in src/myapp.app.src.

To cleanup the directory after compiling simple do:

$ ./rebar clean
Testing
Rebar provides support for both eunit and common_test testing frameworks. In this example, we'll use eunit and write a simple unit test for our application.

In src/myapp_app.erl, after the -export() directive, add the following code:

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.
In addition, at the end of the same file, add this code:

-ifdef(TEST).

simple_test() ->
    ok = application:start(myapp),
    ?assertNot(undefined == whereis(myapp_sup)).

-endif.
By wrapping the test code with that ifdef directive, we can be sure our test code won't be shipped as part of the compiled code in ebin. Let's run the unit test now:

$ ./rebar compile eunit
You should see output something like:

==> myapp (compile)
Compiled src/myapp_app.erl
==> myapp (eunit)
Compiled src/myapp_app.erl
  Test passed
Notice that Rebar compiled myapp_app.erl twice; the second compilation output to a special directory (.eunit) and includes debug information and other helpful testing flags.

If we want to check the coverage of our unit tests, we can easily do that by adding the following line to a rebar.config file:

{cover_enabled, true}.
Now re-run our tests:

$ ./rebar compile eunit
==> myapp (compile)
==> myapp (eunit)
  Test passed.
Cover analysis: /Users/dizzyd/tmp/myapp/.eunit/index.html
$
You can look in the .eunit/index.html file for details of the coverage analysis.

