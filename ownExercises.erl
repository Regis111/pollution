-module(ownExercises).
-author("regis").

%% API
-export([sum/1,sum/2,create/1,reverse_create/1,filter/2,concatenate1/2,concatenate/1,flatten1/2,flatten/1,quickSort/1,merge/3,mergeSort/1]).

%3.0
sum(1) -> 1;
sum(N) when is_integer(N) -> N + sum(N-1).

%3.1
sum(N,N) when is_integer(N) -> N;
sum(N,M) when is_integer(N) and is_integer(M) -> M + sum(N,M-1).


%3.2
create(1) -> [1];
create(N) -> create(N-1) ++ [N].

%3.3
reverse_create(1) -> [1];
reverse_create(N) -> [N | reverse_create(N-1)].

%3.5
filter(L,N) when is_list(L) and is_integer(N) -> [X || X <- L , X =< N].

concatenate1([],Acc) -> Acc;
concatenate1([H|T],Acc) when is_list(H) -> concatenate1(T,Acc ++ H).

concatenate(L) when is_list(L) -> concatenate1(L,[]).

flatten(L) when is_list(L) -> flatten1(L,[]).

flatten1([],Acc) -> Acc;
flatten1([H|T],Acc) when is_integer(H) -> flatten1(T,Acc++[H]);
flatten1([H|T],Acc) when is_list(H) -> flatten1(T,flatten1(H,Acc)).

%3.6
quickSort([]) -> [];
quickSort([H|T]) -> concatenate([quickSort([X || X <- T , X < H]),[H],quickSort([X || X <- T , X > H])]).


merge([],L,Acc) -> Acc ++ L;
merge(L,[],Acc) -> Acc ++ L;
merge([H1|T1],[H2|T2],Acc) when H1 >= H2 -> merge([H1|T1],T2,Acc ++ [H2]);
merge([H1|T1],[H2|T2],Acc) -> merge(T1,[H2|T2],Acc ++ [H1]).	

mergeSort([X]) when is_number(X) -> [X];
mergeSort(L) when is_list(L) ->{L1,L2}=lists:split(length(L) div 2,L),merge(mergeSort(L1),mergeSort(L2),[]).
