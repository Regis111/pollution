-module(pollution_gen_server).
-behaviour(gen_server).

%API
-export([start_link/0, addStation/2, addValue/4, removeValue/3, getOneValue/3, 
         getStationMean/2, getDailyMean/2, variation/1, stop/0, getMonitor/0]).
%gen_server functions
-export([handle_call/3, handle_cast/2, terminate/2, init/1]).

start_link() ->
    gen_server:start_link({local, ?MODULE},
                          ?MODULE,[],[]).
init(_) ->
    {ok, pollution:createMonitor()}.

getMonitor() ->
    gen_server:call(?MODULE, getMonitor).

addStation(Name,Coords) ->
    gen_server:call(?MODULE, {addStation, Name, Coords}).

addValue(Name, Date, Type, Value) ->
    gen_server:call(?MODULE, {addValue, Name, Date, Type, Value}).

removeValue(Name, Date, Type) ->
    gen_server:call(?MODULE, {removeValue, Name, Date, Type}).

getOneValue(Name, Date, Type) ->
    gen_server:call(?MODULE, {getOneValue, Name, Date, Type}).

getStationMean(Name, Type) ->
    gen_server:call(?MODULE, {getStationMean, Name, Type}).

getDailyMean(Type, Date) -> 
    gen_server:call(?MODULE, {getDailyMean, Type, Date}).

variation(Type) ->
    gen_server:call(?MODULE, {variation, Type}).

stop() -> 
    gen_server:cast(?MODULE, stop).

handle_call(getMonitor, _From, M) ->
    {reply, {ok, M}, M};

handle_call({addStation, Name, Coords}, _From, M) ->
    try pollution:addStation(Name,Coords,M) of
        NewM -> {reply, {ok, NewM}, NewM}
    catch
        throw:jest_juz_taka_stacja -> {reply, {error, jest_juz_taka_stacja}, M}
    end;

handle_call({addValue, Name, Date, Type, Value}, _From, M) ->
    try pollution:addValue(Name,Date,Type,Value,M) of
        NewM -> {reply,{ok, NewM}, NewM}
    catch
        throw:nie_istnieje_stacja -> {reply, {error, jest_juz_taka_stacja}, M};
        throw:nie_mozna_dodac_pomiaru -> {reply, {error, istnieje_juz_taki_pomiar}, M}
    end;

handle_call({removeValue, Name, Date, Type}, _From, M) ->
    try pollution:removeValue(Name,Date,Type,M) of
        NewM -> {reply,{ok, NewM}, NewM}
    catch
        throw:nie_istnieje_stacja -> {reply,{error, nie_istnieje_stacja},M};
        throw:nie_istnieje_pomiar -> {reply,{error,nie_istnieje_pomiar},M}
    end;

handle_call({getOneValue, Name, Date, Type}, _From, M) ->
    try pollution:getOneValue(Name,Date,Type,M) of
        Value -> {reply,{ok, Value}, M}
    catch
        throw:nie_istnieje_stacja -> {reply,{error, nie_istnieje_stacja},M};
        throw:nie_istnieje_pomiar -> {reply,{error,nie_istnieje_pomiar},M}
    end;

handle_call({getStationMean, Name, Type}, _From, M) ->
    try pollution:getStationMean(Name,Type,M) of
        Value -> {reply,{ok, Value}, M} 
    catch
        throw:nie_istnieje_stacja -> {reply,{error, nie_istnieje_stacja}, M}
    end;

handle_call({getDailyMean, Type, Date}, _From, M) -> 
    Reply = pollution:getDailyMean(Type,Date,M), 
    {reply, {ok, Reply}, M};

handle_call({variation, Type}, _From, M) ->
    Reply = pollution:getMaximumVariationStation(Type, M),
    {reply, {ok, Reply}, M}.

handle_cast(stop, M) -> {stop, normal, M}.

terminate(_Reason, _) -> {ok, _Reason}.
