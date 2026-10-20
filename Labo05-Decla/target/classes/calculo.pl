% ============================================================
%  calculo.pl
%  Derivadas e integrales simbolicas resueltas con reglas.
%
%  d(Variable, Funcion, Resultado)  -> derivada ya simplificada
%  s(Variable, Funcion, Resultado)  -> integral ya simplificada
%
%  Soporta sumas y restas de terminos aplicando la linealidad:
%     (f + g)' = f' + g'        integral(f + g) = integral(f) + integral(g)
%     (f - g)' = f' - g'        integral(f - g) = integral(f) - integral(g)
% ============================================================


% ------------------------------------------------------------
%  Puntos de entrada que consume la interfaz.
%  Primero se resuelve la derivada/integral en bruto y luego se
%  simplifica, para no mostrar cosas como 2*x^1 - 0.
% ------------------------------------------------------------

d(Var, Func, Resultado) :-
    deriv(Var, Func, Bruto),
    simp(Bruto, Resultado).

s(Var, Func, Resultado) :-
    integ(Var, Func, Bruto),
    simp(Bruto, Resultado).


% ============================================================
%  DERIVADAS
% ============================================================

% ------------------------------------------------------------
%  Casos recursivos (linealidad)
%  Van de primero para que una expresion compuesta se descomponga
%  antes de intentar las reglas de termino simple. El corte evita
%  que al regresar por backtracking se generen soluciones duplicadas.
% ------------------------------------------------------------

% Derivada de una suma
deriv(Var, A + B, DA + DB) :-
    !,
    deriv(Var, A, DA),
    deriv(Var, B, DB).

% Derivada de una resta
deriv(Var, A - B, DA - DB) :-
    !,
    deriv(Var, A, DA),
    deriv(Var, B, DB).


% ------------------------------------------------------------
%  Casos base (un solo termino)
% ------------------------------------------------------------

% Derivada de una constante
deriv(Var, Func, 0) :-
    atomic(Var),
    number(Func),
    !.

% Derivada de una variable con respecto a si misma
deriv(Var, Func, 1) :-
    atomic(Var),
    Var == Func,
    !.

% Derivada de una variable por una constante
deriv(Var, K*Var, K) :-
    atomic(Var),
    number(K),
    !.

% Derivada de una variable elevada a la N
deriv(Var, Var^N, N*Var^Nm1) :-
    atomic(Var),
    number(N),
    Nm1 is N - 1,
    !.

% Derivada de una variable elevada a la N por una constante
deriv(Var, K*Var^N, C*Var^Nm1) :-
    atomic(Var),
    number(K),
    number(N),
    C is K * N,
    Nm1 is N - 1,
    !.

% Derivada de un logaritmo natural
deriv(Var, log(Var), 1/Var) :-
    atomic(Var),
    !.

% Derivada de una constante elevada a la variable
deriv(Var, K^Var, K^Var*log(K)) :-
    atomic(Var),
    number(K),
    !.


% ============================================================
%  INTEGRALES
% ============================================================

% ------------------------------------------------------------
%  Casos recursivos (linealidad)
% ------------------------------------------------------------

% Integral de una suma
integ(Var, A + B, SA + SB) :-
    !,
    integ(Var, A, SA),
    integ(Var, B, SB).

% Integral de una resta
integ(Var, A - B, SA - SB) :-
    !,
    integ(Var, A, SA),
    integ(Var, B, SB).


% ------------------------------------------------------------
%  Casos base (un solo termino)
% ------------------------------------------------------------

% Integral de una constante
integ(Var, K, K*Var) :-
    atomic(Var),
    number(K),
    !.

% Integral de una variable con respecto a si misma
integ(Var, Var, 1/2*Var^2) :-
    atomic(Var),
    !.

% Integral de una variable por una constante
integ(Var, K*Var, K/2*Var^2) :-
    atomic(Var),
    number(K),
    !.

% Integral de una variable elevada a la N
integ(Var, Var^N, 1/M*Var^M) :-
    atomic(Var),
    number(N),
    M is N + 1,
    !.

% Integral de una constante por una variable elevada a la N
integ(Var, K*Var^N, K/M*Var^M) :-
    atomic(Var),
    number(K),
    number(N),
    M is N + 1,
    !.

% Integral de un logaritmo natural
integ(Var, log(Var), Var*log(Var) - Var) :-
    atomic(Var),
    !.

% Integral de una constante elevada a la variable
integ(Var, K^Var, K^Var/log(K)) :-
    atomic(Var),
    number(K),
    !.


% ============================================================
%  SIMPLIFICACION DEL RESULTADO
%  Recorre la expresion de abajo hacia arriba y aplica las
%  identidades basicas: X+0, X-0, X*1, X*0, X^1, X^0 y las
%  operaciones entre numeros.
% ============================================================

simp(T, T) :-
    atomic(T),
    !.

simp(A + B, R) :-
    !,
    simp(A, SA),
    simp(B, SB),
    suma(SA, SB, R).

simp(A - B, R) :-
    !,
    simp(A, SA),
    simp(B, SB),
    resta(SA, SB, R).

simp(A * B, R) :-
    !,
    simp(A, SA),
    simp(B, SB),
    producto(SA, SB, R).

simp(A / B, R) :-
    !,
    simp(A, SA),
    simp(B, SB),
    division(SA, SB, R).

simp(A ^ B, R) :-
    !,
    simp(A, SA),
    simp(B, SB),
    potencia(SA, SB, R).

% Cualquier otra cosa (por ejemplo log(x)) se deja igual
simp(T, T).


% --- Identidades de la suma ---
suma(0, B, B) :- !.
suma(A, 0, A) :- !.
suma(A, B, C) :- number(A), number(B), !, C is A + B.
suma(A, B, A + B).

% --- Identidades de la resta ---
resta(A, 0, A) :- !.
resta(A, B, C) :- number(A), number(B), !, C is A - B.
resta(A, B, A - B).

% --- Identidades del producto ---
producto(0, _, 0) :- !.
producto(_, 0, 0) :- !.
producto(1, B, B) :- !.
producto(A, 1, A) :- !.
producto(A, B, C) :- number(A), number(B), !, C is A * B.
producto(A, B, A * B).

% --- Identidades de la division ---
% Solo se resuelve cuando la division es exacta, para conservar
% fracciones como 1/3 en vez de convertirlas a decimal.
division(A, 1, A) :- !.
division(A, B, C) :-
    integer(A),
    integer(B),
    B =\= 0,
    0 is A mod B,
    !,
    C is A // B.
division(A, B, A / B).

% --- Identidades de la potencia ---
potencia(A, 1, A) :- !.
potencia(_, 0, 1) :- !.
potencia(A, B, A ^ B).
