-module(pollution_supervisor).
-behaviour(supervisor).

-export([start_link/0,init/1]).

start_link() -> 
    supervisor:start_link({local, pollution_supervisor}, pollution_supervisor, []).

init(_) ->  Child = {pollution_gen_server, 
                     {pollution_gen_server, start_link, []},
                     permanent, brutal_kill, worker, [pollution_gen_server, pollution]},
            {ok, {{one_for_one, 2, 3},[Child]}}.
