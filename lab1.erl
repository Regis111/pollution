-module(first).
-author("regis").

-export([print_helloworld/0,power/2,contains/2,duplicateElements/1,sumFloats/1]).

print_helloworld()->
  io:format("Hello World").

power(X,Y) when X =/= 0 ->
  case Y of
    0 -> 1;
    _ -> X * power(X,Y-1)
  end.

contains([],_) -> false;
contains([H|_],H) -> true;
contains([_|T],X) -> contains(T,X).

duplicateElements([]) -> [];
duplicateElements([H]) -> [H,H];
duplicateElements([H | T]) ->  [H,H] ++ duplicateElements(T).
