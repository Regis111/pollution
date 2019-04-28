-module(pollution_server_test).

-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

start_test() ->
    pollution_server:start(),
    ?assert(lists:member(pollution_server, registered())),
    ?assertEqual(#{},pollution_server:getMonitor()).

addStation_test() ->
    pollution_server:addStation("AGH",{1,1}),
    ?assertEqual(#{"AGH" => #station{"AGH",{1,1},[]}},pollution_server:getMonitor()).
    %?assertThrow(jest_juz_taka_stacja,pollution_server:addStation("AGH",{2,2})).
    %?assertThrow(jest_juz_taka_stacja,pollution_server:addStation("UJ",{1,1})).
