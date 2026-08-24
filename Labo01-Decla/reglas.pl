% Importamos la base de conocimientos
:- consult('hechos.pl').

% REGLA 1: Uso de OR (;) y AND (,)
% Un personaje esta bien equipado si lleva pistola O si lleva un cuchillo Y ademas es un agente entrenado
bien_equipado(Personaje) :-
    armado_con(Personaje, pistola) ;
    (armado_con(Personaje, cuchillo), profesion(Personaje, agente)).

% REGLA 2: Uso de AND (,) y Comparadores (<)
% Un personaje es considerado "joven en peligro" si esta en un lugar de dificultad alta Y tiene menos de 30 años
joven_en_peligro(Personaje) :-
    ubicacion(Personaje, Lugar),
    dificultad(Lugar, alta),
    edad(Personaje, Edad),
    Edad < 30.

% REGLA 3: Uso de AND (,) y Desigualdad (\=)
% Identifica si dos personajes distintos se cruzan en la misma ubicacion
se_encuentran(Personaje1, Personaje2, Lugar) :-
    ubicacion(Personaje1, Lugar),
    ubicacion(Personaje2, Lugar),
    Personaje1 \= Personaje2.