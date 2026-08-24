% --- PROFESIONES ---
profesion(leon, agente).
profesion(ashley, estudiante).
profesion(ada, espia).
profesion(luis, investigador).

% --- EDADES ---
edad(leon, 27).
edad(ashley, 20).
edad(ada, 26).
edad(luis, 32).

% --- ARMAMENTO ---
armado_con(leon, pistola).
armado_con(leon, cuchillo).
armado_con(ada, pistola).
armado_con(luis, cuchillo).

% --- ENEMIGOS Y ORIGEN ---
enemigo(ganados).
enemigo(regeneradores).
infectado_por(ganados, las_plagas).
infectado_por(regeneradores, las_plagas).

% --- APARICIONES DE ENEMIGOS ---
aparece_en(ganados, pueblo).
aparece_en(ganados, castillo).
aparece_en(regeneradores, isla).

% --- DIFICULTAD DE ZONAS ---
dificultad(pueblo, alta).
dificultad(castillo, alta).
dificultad(isla, muy_alta).

% --- UBICACION DE PERSONAJES ---
ubicacion(leon, pueblo).
ubicacion(luis, pueblo).
ubicacion(ada, pueblo).
ubicacion(ada, castillo).