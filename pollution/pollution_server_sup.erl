-module(pollution_server_sup).

-export([start/0,init/0,loop/0, stop/0]).

start() ->
    Pid = spawn(pollution_server_sup, init, []),
    register(sup_server, Pid),
    Pid.

init() ->
    process_flag(trap_exit, true), 
    Server = pollution_server:start(),
    link(Server),
    loop().

loop() ->
    receive
        {'EXIT', _, _} -> 
            init();
        stop -> 
            ok
    end.

stop() ->
    sup_server ! stop.
