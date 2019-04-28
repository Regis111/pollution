-module(pollution_server).

-export([
         start/0,init/0,loop/1,try_fun/3,call/1,getMonitor/0,
         addStation/2,addValue/4,removeValue/3,getOneValue/3,
        getStationMean/2,getDailyMean/2,variation/1,stop/0
        ]).

start() ->
    register(server,spawn(pollution_server, init, [])).

init() ->
    M = pollution:createMonitor(),
    loop(M).

loop(M) ->
    receive 
        {request, Pid, {getMonitor}} ->
            Pid ! {reply, M},
            loop(M);
        {request, Pid, {getDailyMean, Type, Date}} ->
            Reply = pollution:getDailyMean(Type,Date,M),
            Pid ! {reply, Reply},
            loop(M);
        {request, Pid, {variation, Type}} ->
            Reply = pollution:getMaximumVariationStation(Type,M),
            Pid ! {reply, Reply},
            loop(M);

        {request, Pid, {stop}} ->
            Pid ! {reply, ok},
            ok;
        {request, Pid, Args} ->
            try_fun(Pid,Args,M)
    after
            80000 -> 
              stop()
    end.

try_fun(Pid,{addStation,Name,Coords},M) -> 
    try pollution:addStation(Name,Coords,M) of
        NewM -> Pid ! {reply,ok}, loop(NewM)
    catch
        throw:jest_juz_taka_stacja -> 
            Pid ! {reply,{error, jest_juz_taka_stacja}},
            loop(M)
    end;
try_fun(Pid,{addValue,Name,Date,Type,Value},M) ->
    try pollution:addValue(Name,Date,Type,Value,M) of
        NewM -> Pid ! {reply,ok}, loop(NewM)
    catch
        throw:nie_istnieje_stacja -> 
            Pid ! {reply,{error, nie_istnieje_stacja}},
            loop(M);
        throw:nie_mozna_dodac_pomiaru ->
            Pid ! {reply,{error, istnieje_juz_taki_pomiar}},
            loop(M)
    end;
try_fun(Pid,{removeValue,Name,Date,Type},M) ->
    try pollution:removeValue(Name,Date,Type,M) of
        NewM -> Pid ! {reply,ok}, loop(NewM)
    catch
        throw:nie_istnieje_stacja -> 
            Pid ! {reply,{error, nie_istnieje_stacja}},
            loop(M);
        throw:nie_istnieje_pomiar ->
            Pid ! {reply,{error,nie_istnieje_pomiar}},
            loop(M)
    end;
try_fun(Pid,{getOneValue,Name,Date,Type},M) ->
    try pollution:getOneValue(Name,Date,Type,M) of
        Value -> Pid ! {reply,Value}, loop(M)
    catch
        throw:nie_istnieje_stacja -> 
            Pid ! {reply,{error, nie_istnieje_stacja}},
            loop(M);
        throw:nie_istnieje_pomiar ->
            Pid ! {reply,{error,nie_istnieje_pomiar}},
            loop(M)
    end;
try_fun(Pid,{getStationMean,Name,Type},M) ->
    try pollution:getStationMean(Name,Type,M) of
        Value -> Pid ! {reply,Value}, loop(M)
    catch
        throw:nie_istnieje_stacja ->
            Pid ! {reply,{error, nie_istnieje_stacja}},
            loop(M)
    end.

call(Message) ->
    server ! {request, self(), Message},
    receive
        {reply, Reply} -> Reply
    end.

getMonitor() -> call({getMonitor}).

addStation(Name,Coords) -> call({addStation,Name,Coords}).

addValue(Name,Date,Type,Value) -> call({addValue,Name,Date,Type,Value}).

removeValue(Name,Date,Type) -> call({removeValue,Name,Date,Type}).

getOneValue(Name,Date,Type) -> call({getOneValue,Name,Date,Type}).

getStationMean(Name,Type) -> call({getStationMean,Name,Type}).

getDailyMean(Type,Date) -> call({getDailyMean,Type,Date}).  

variation(Type) -> call({variation,Type}).

stop() -> call({stop}).
