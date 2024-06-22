/* Combinatoria con repetición 
Determinar, dado un presupuesto, las "salidas posibles" en base a los costos de cada una.
*/
salida(recital, 100).
salida(cine, 10).
salida(restaurante, 30).
salida(parqueDeDiversiones, 50).
salida(teatro, 35).
salida(museo, 5).

salidasPosibles(_, []).
salidasPosibles(Presupuesto, [UnaSalida|Salidas]):-
    salida(UnaSalida, Costo),
    Costo =< Presupuesto,
    Resto is Presupuesto - Costo,
    salidasPosibles(Resto, Salidas).

/* Combinatoria sin repetición 
Un pirata quiere armar la tripulación para su barco, él solo quiere llevar:
- cocineros
- piratas bravos
- piratas de más de 40 años (no pagan impuestos)
*/
cocinero(donato).
cocinero(pietro).
pirata(felipe, 27).
pirata(marcos, 39).
pirata(facundo, 45).
pirata(tomas, 20).
pirata(betina, 26).
pirata(gonzalo, 22).

bravo(tomas).
bravo(felipe).
bravo(marcos).
bravo(betina).

tripulacionBarco(Tripulantes):-
    candidatos(Candidatos),
    tripulantes(Candidatos, Tripulantes),
    /*tripulantes2(Candidatos, Tripulantes),*/ % cambiar la línea anterior por esta da MUCHOS más resultados por las distintas permutaciones
    Tripulantes \= [].

candidato(UnTripulante):- cocinero(UnTripulante).
candidato(UnTripulante):- bravo(UnTripulante), pirata(UnTripulante, _).
candidato(UnTripulante):- pirata(UnTripulante, Edad), Edad > 40.

candidatos(Candidatos):-
    findall(UnCandidato, candidato(UnCandidato), CandidatosConRepetidos),
    list_to_set(CandidatosConRepetidos, Candidatos).

% En esta primera versión es preferible cortar cuando ya no hay candidatos,
% ya que cada uno de ellos también es omitido en la tercera cláusula y este 
% corte evita repeticiones de respuestas.
tripulantes([], []). 
tripulantes([UnCandidato|Candidatos], [UnCandidato|Tripulantes]):-
    tripulantes(Candidatos, Tripulantes).
tripulantes([_|Candidatos], Tripulantes):-
    tripulantes(Candidatos, Tripulantes).

% En esta versión, no hay cláusula en la cual se omita a un candidato específico,
% así que el corte se hace en cualquier momento.
tripulantes2(_, []).
tripulantes2(Candidatos, [UnCandidato|Tripulantes]):-
    select(UnCandidato, Candidatos, OtrosCandidatos),
    tripulantes2(OtrosCandidatos, Tripulantes).

% Si quieren comprobar la diferencia entre ambas versiones, prueben comentar 
% algunos piratas/cocineros de la base inicial para tener menos respuestas.
    