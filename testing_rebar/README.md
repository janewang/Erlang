## Setup Rebar 
`mkdir testing_rebar`
`cd testing_rebar`

`rebar create-app`
console output:
==> testing_rebar (create-app)
Writing src/myapp.app.src
Writing src/myapp_app.erl
Writing src/myapp_sup.erl
note: src directory is created

`mkdir -p apps/myapp`
`mv src apps/myapp`
note: moves src directory into apps/myapp directory

`mate rebar.config`
create config files with 
`{sub_dirs, ["apps/myapp", "rel"]}.`

`rebar compile`
console output:
==> myapp (compile)
Compiled src/myapp_app.erl
Compiled src/myapp_sup.erl
==> testing_rebar (compile)

`mkdir rel`
`cd rel`
`rebar create-node`
Note: or use: `rebar create-node nodeid=myapp`
console output:
==> rel (create-node)
Writing reltool.config
Writing files/erl
Writing files/nodetool
Writing files/mynode
Writing files/sys.config
Writing files/vm.args
Writing files/mynode.cmd
Writing files/start_erl.cmd
Writing files/install_upgrade.escript

`mate reltool.config`
add `{lib_dir, "../apps/myapp"}`
to `{app, myapp, [{mod_cond, app}, {incl_cond, include}]}`
to become `{app, myapp, [{mod_cond, app}, {incl_cond, include}, {lib_dir, "../apps/myapp"}]}`

Note: Inside rel directory
`rebar -v generate`
console output:
==> rel (generate)

`rel/mynode/bin/mynode console`
starts in the shell

Eshell > `registered().`

See this gist for the same instructions above: https://gist.github.com/3317595
Slight update to this setup: http://skeptomai.com/?p=56 due to version difference.