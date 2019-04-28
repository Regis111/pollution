-module(lab2).

-export([lessThan/2,grtEqThan/2,qs/1,randomElems/3,compareSpeeds/3,filter/2,map/2]).

lessThan(List, Arg) -> [X || X<-List, X < Arg].

grtEqThan(List,Arg) -> [X || X<-List, X >= Arg].


qs([]) -> [];
qs([Pivot|Tail]) -> qs(lessThan(Tail,Pivot)) ++ [Pivot] ++ qs(grtEqThan(Tail,Pivot)).

randomElems(N,Min,Max) -> Max1=Max-Min+1,[rand:uniform(Max1)+Min-1 || A<-lists:seq(1,N) ].

compareSpeeds(List,Fun1,Fun2) -> io:format("lab2:qs - ~w ~n lists:qs -~w",[timer:tc(Fun1,[List]),timer:tc(Fun2,[List])]).

map(F,L) -> [F(X) || X <- L].

filter(F,L) -> [X || X <- L, F(X)].

