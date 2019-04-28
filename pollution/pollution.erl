%monitor jest mapą stacji gdzie kluczami są nazwy stacji, stacje są rekordami posiadającymi nazwę, współrzędne oraz listę pomiarów
-module(pollution).

-export([createMonitor/0,addStation/3,isThereStation/3,isThereMeasurement/4,addValue/5,removeValue/4,getOneValue/4,getStationMean/3,flatten1/2,getDailyMean/3,sumOfDifferences1/2,sumOfDifferences/2,getMaximumVariationStation/2]).

-record(station,{name,coords,measurements}).
-record(measurement,{date,type,value}).

createMonitor() -> maps:new(). 

%sprawdza czy już istnieje stacja z podaną nazwą lub współrzędnymi
isThereStation(Name,Coords,Monitor) -> F1 = fun(Y) -> Name == Y#station.name end, F2 = fun(Y) -> Coords == Y#station.coords end,
 lists:any(F1,maps:values(Monitor)) orelse lists:any(F2,maps:values(Monitor)).

%jeśli nie istnieje stacja z podanymi współrzędnymi lub nazwą dodaje do monitora
addStation(Name,Coords,Monitor) -> 
	case isThereStation(Name,Coords,Monitor) of
		true  -> throw(jest_juz_taka_stacja);
		false -> maps:put(Name,#station{name=Name,coords=Coords,measurements=[]},Monitor)
	end.

%sprawdza czy nie istnieje pomiar z podanej stacji (jeśli istnieje stacja) zwracając go gdy istnieje
isThereMeasurement(Name,Date,Type,Monitor) -> F1 = fun(Y) -> Y#measurement.date == Date andalso Type == Y#measurement.type end,
	case maps:find(Name,Monitor) of
		{ok,S} -> lists:search(F1,S#station.measurements);
		error  -> throw(nie_istnieje_stacja)
	end.

%F1 modyfikuje rekord station dodając do listy measurements nowy rekord measurement
addValue(Name,Date,Type,Value,Monitor) -> F1 = fun(Y) -> Y#station{measurements=[#measurement{date=Date,type=Type,value=Value}|Y#station.measurements]} end,
	case isThereMeasurement(Name,Date,Type,Monitor) of
		{value,_}  -> throw(nie_mozna_dodac_pomiaru);
		false -> maps:update_with(Name,F1,Monitor)
	end.

removeValue(Name,Date,Type,Monitor) -> F1 = fun(S) -> S#station{measurements=[M || M <- S#station.measurements, M#measurement.date =/= Date orelse M#measurement.type =/= Type ]} end, 
	case isThereMeasurement(Name,Date,Type,Monitor) of
		{value,_} -> maps:update_with(Name,F1,Monitor); 
		false  -> throw(nie_istnieje_pomiar)
	end.

getOneValue(Name,Date,Type,Monitor) -> 
	case isThereMeasurement(Name,Date,Type,Monitor) of
		false  -> throw(nie_istnieje_pomiar);
		{value,V} -> V#measurement.value
	end.

getStationMean(Name,Type,Monitor) ->
	case maps:find(Name,Monitor) of
		error  -> throw(nie_istnieje_stacja);
		{ok,S} -> Values = [M#measurement.value || M <- S#station.measurements, M#measurement.type == Type ],lists:sum(Values)/length(Values)
	end.

flatten1([],Acc) -> Acc;
flatten1([H | Monitor],Acc) -> flatten1(Monitor,H#station.measurements++Acc).

%Liczy średnią po pomiarach o z danego dnia i danego typu
getDailyMean(Type,Date,Monitor) -> {Day,_}=Date,  F1=fun(X) -> {Day1,_}=X#measurement.date, X#measurement.type == Type andalso Day==Day1 end,
 List=[M#measurement.value || M <- flatten1(maps:values(Monitor) , []), F1(M) ], lists:sum(List)/length(List).

%zwraca sumę różnic między kolejnymi elementami listy
sumOfDifferences1([],_) -> 0;
sumOfDifferences1([X],Acc) -> Acc;
sumOfDifferences1([A,B | T],Acc) -> sumOfDifferences1([B|T],Acc + abs(B - A)).

%zwraca wynik powyższej funkcji + nazwę stacji
sumOfDifferences(Station,Type) -> F1 = fun(M) -> M#measurement.type == Type end, F2 = fun(M) -> M#measurement.value end,
 List = [F2(M) || M <- Station#station.measurements, F1(M)], {Station#station.name,sumOfDifferences1(List,0)}.

%tworzy listę złożoną z stacji oraz sumy różnic jej pomiarów konkretnego typu, sortuje ją oraz zwraca stację o największej sumie
getMaximumVariationStation(Type,Monitor) -> List = [sumOfDifferences(S,Type) || S <- maps:values(Monitor)], lists:last(lists:keysort(2,List)).
