% =============================================================
% Ejercicio 3 - Programacion Declarativa (Prolog)
%
% Dado un valor entero, almacenar cada uno de los digitos que lo
% componen en una lista, un digito por casilla.
%
% Ejemplo:
%   ?- almacenar(82671, L).
%   L = [1, 7, 6, 2, 8].
% =============================================================

% almacenar(+N, -L)
% L es la lista de digitos de N, empezando por las unidades

% Numeros negativos: se trabaja con su valor absoluto.
almacenar(N, L) :-
    N < 0, !,
    N1 is abs(N),
    almacenar(N1, L).

% Caso base: numero de una sola cifra (0 a 9).
almacenar(N, [N]) :-
    N >= 0, N < 10, !.

% Caso recursivo: se extrae el ultimo digito y se procesa el resto
almacenar(N, [D|R]) :-
    N >= 10,
    D  is N mod 10,     % ultimo digito (unidades)
    N1 is N // 10,      % numero sin el ultimo digito
    almacenar(N1, R).

% -------------------------------------------------------------
% Consultas de prueba:
%   ?- almacenar(82671, L).   % L = [1, 7, 6, 2, 8].
%   ?- almacenar(5, L).       % L = [5].
%   ?- almacenar(0, L).       % L = [0].
%   ?- almacenar(-305, L).    % L = [5, 0, 3].
% -------------------------------------------------------------
