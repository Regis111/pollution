-module(pollution_server_tests).

-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

start_test() ->
    pollution_server:start(), 
    ?assert(lists:member(server, registered())), 
    ?assertEqual(#{},pollution_server:getMonitor()).

addStation_test() ->
    pollution_server:addStation("AGH",{1,1}),
    ?assertEqual(#{"AGH" => {station,"AGH",{1,1},[]}},pollution_server:getMonitor()),
    ?assertEqual({error, jest_juz_taka_stacja},pollution_server:addStation("AGH",{2,2})),
    ?assertEqual({error, jest_juz_taka_stacja},pollution_server:addStation("UJ",{1,1})).

get_add_remove_Value_test() ->
    Date = calendar:local_time(),
    ?assertEqual(ok,pollution_server:addValue("AGH",Date,"T1",20)),
    ?assertEqual(#{"AGH" => {station,"AGH",{1,1},[{measurement, Date,"T1",20}]}},pollution_server:getMonitor()),
    ?assertEqual(20,pollution_server:getOneValue("AGH",Date,"T1")),
    ?assertEqual(ok,pollution_server:removeValue("AGH",Date,"T1")),
    ?assertEqual(#{"AGH" => {station,"AGH",{1,1},[]}},pollution_server:getMonitor()).

end_test() ->
    pollution_server:stop().
