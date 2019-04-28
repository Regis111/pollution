-module(onp).
-export([onp/1,calc/2,read/1]).


onp(String) when is_list(String)-> calc(string:tokens(String," "),[]).

read(N) ->
  case string:to_float(N) of
    {error,_} -> list_to_integer(N);
    {F,_} -> F
  end.

calc([] , X ) when is_list(X)-> case length(X) of 1 -> hd(X); _ -> zabraklo_operatora end; % koniec wejścia
calc([ "sin"  | T ] , [ A | L ]) -> calc(T , [math:cos(A)| L]);
calc([ "cos"  | T ] , [ A | L ]) -> calc(T , [math:cos(A)| L]);
calc([ "sqrt" | T ] , [ A | L ]) -> calc(T , [math:sqrt(A)| L]);
calc([ "^" | T ],[ A,B | L ]) -> calc( T , [math:pow(B,A) | L]);
calc([ "*" | T ],[ A,B | L ]) -> calc( T , [ B * A | L]); % '*' jest na wejściu
calc([ "/" | T ],[ A,B | L ]) when A /= 0 -> calc( T , [ B / A | L]); % '/' jest na wejściu
calc([ "+" | T ],[ A,B | L ]) -> calc( T , [ B + A | L]); % '+' jest na wejściu
calc([ "-" | T ],[ A,B | L ]) -> calc( T , [ B - A | L]); % '-' jest na wejściu
calc([  H  | T ], L ) -> calc(T , [read(H) | L]).
