% ============================================================
% Ejercicio Evaluado - Ejercicio 2
% Dado un numero N, sumar N con todos los numeros anteriores
% hasta llegar a 1.   suma(N, S)  ->  S = N + (N-1) + ... + 1
% ============================================================

% Caso base: la suma desde 1 hasta 1 es 1.
% (Siempre va primero, antes de la clausula recursiva)
suma(1, 1).

% Caso recursivo: para N > 1, se resta 1 a N, se resuelve el
% subproblema mas pequeño suma(N1, S1) y al resultado se le
% suma N.
suma(N, S) :-
    N > 1,
    N1 is N - 1,
    suma(N1, S1),
    S is N + S1.

% ------------------------------------------------------------
% Consulta de ejemplo usada para construir el arbol SLD:
%
%   ?- trace.
%   ?- suma(3, S).
%   S = 6.
%
% Tambien se puede probar:  suma(5, S).  ->  S = 15.
% ------------------------------------------------------------
