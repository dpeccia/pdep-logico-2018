%Base de conocimiento
mira(juan,himym).
mira(juan,futurama).
mira(juan,got).
mira(maiu,onePiece).
mira(maiu,got).
mira(maiu,starWars).
mira(nico,got).
mira(nico,starWars).
mira(gaston,hoc).
mira(pedro,got).

amigo(nico, maiu).
amigo(maiu, gaston).
amigo(maiu, juan).
amigo(juan, aye).

quiereVer(juan,hoc).
quiereVer(aye,got).
quiereVer(gaston,himym).

temporadas(3,got,12).
temporadas(2,got,10).
temporadas(1,himym,23).
temporadas(8,drHouse,16).

paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).
paso(got, 3, 2, plotTwist([suenio,sinPiernas])).
paso(got, 3, 12, plotTwist([fuego,boda])).
paso(supercampeones, 9, 9, plotTwist([suenio,coma,sinPiernas])).
paso(drHouse, 8, 7, plotTwist([coma,pastillas])).

leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(nico, juan, futurama, muerte(seymourDiera)). 
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).
leDijo(pedro, nico, got, relacion(parentesco, tyrion, dragon)).
leDijo(pedro, aye, got, relacion(amistad, tyrion, dragon)).

% Entrega 1 - Punto B - Es spoiler
esSpoiler(Serie,PosibleSpoiler) :- paso(Serie,_,_,PosibleSpoiler).

% Entrega 1 - Punto C - Le spoileo
leSpoileo(Persona1,Persona2,Serie) :- leDijo(Persona1,Persona2,Serie,Spoiler), miraOQuiereVer(Persona2,Serie), esSpoiler(Serie,Spoiler).

% Entrega 1 - Punto D - Televidente responsable
televidenteResponsable(Persona) :- persona(Persona), not(leSpoileo(Persona,_,_)).
persona(Persona) :- miraOQuiereVer(Persona,_).

miraOQuiereVer(Persona,Serie) :- mira(Persona,Serie).
miraOQuiereVer(Persona,Serie) :- quiereVer(Persona,Serie).

% Entrega 1 - Punto E - Viene zafando
vieneZafando(Persona,Serie) :- miraOQuiereVer(Persona,Serie), noSeLaSpoilearon(Persona,Serie), esPopularOPasaronCosasFuertes(Serie).

esPopularOPasaronCosasFuertes(Serie) :- popular(Serie).
esPopularOPasaronCosasFuertes(Serie) :- pasaronCosasFuertesEnTodasLasTemporadas(Serie).    

noSeLaSpoilearon(Persona,Serie) :- not(leSpoileo(_,Persona,Serie)).

pasaronCosasFuertesEnTodasLasTemporadas(Serie) :- 
    hayInformacionSuficiente(Serie), 
    forall(temporadas(Temporada,Serie,_), (paso(Serie,Temporada,_,Paso),fuerte(Serie,Paso))).

hayInformacionSuficiente(Serie) :- temporadas(_,Serie,_).

fuerte(_,muerte(_)).
fuerte(_,relacion(amorosa,_,_)).
fuerte(_,relacion(parentesco,_,_)).

% Entrega 2 - Punto A - malaGente
malaGente(Persona) :- lesSpoileoAlgoATodos(Persona).
malaGente(Persona) :- spoileoYNoLaVeia(Persona).

lesSpoileoAlgoATodos(Persona1) :- hablo(Persona1,_,_), 
                                  forall(hablo(Persona1,Persona2,_), 
                                  leSpoileo(Persona1,Persona2,_)).

hablo(Persona1,Persona2,_) :- leDijo(Persona1,Persona2,_,_).

spoileoYNoLaVeia(Persona) :- leSpoileo(Persona,_,Serie), not(mira(Persona,Serie)).

% Entrega 2 - Punto B - esFuerte
fuerte(Serie,plotTwist(PalabrasClave)) :- not(cliche(PalabrasClave)), 
           pasoEnUnFinalDeTemporada(Serie, plotTwist(PalabrasClave)).

cliche(PalabrasClave) :- paso(_,_,_,plotTwist(Giros)),
                         member(PalabrasClave, Giros).

pasoEnUnFinalDeTemporada(Serie, PlotTwist) :- 
    paso(Serie,Temporada,Episodio,PlotTwist), temporadas(Temporada,Serie,Episodio).

% Entrega 2 - Punto C - popularidad

popular(hoc).
popular(Serie) :- serie(Serie), popularidad(Serie, Popularidad), 
                  popularidad(starWars,PopularidadStarWars),
                  Popularidad >= PopularidadStarWars.

serie(Serie) :- miraOQuiereVer(_,Serie).
serie(Serie) :- paso(Serie,_,_,_).

popularidad(Serie, Popularidad) :-    
    cantidadDePersonasQueLaMiran(Serie,CantidadQueMiran),
    cantidadDeConversaciones(Serie,CantidadQueHablan),
    Popularidad is CantidadQueMiran * CantidadQueHablan.

cantidadDePersonasQueLaMiran(Serie, Cantidad) :-
        findall(Persona, mira(Persona, Serie), Personas),
        length(Personas, Cantidad).

cantidadDeConversaciones(Serie, Cantidad) :-
        findall(Persona, hablo(Persona,_,Serie), Personas),
        length(Personas, Cantidad).

% Entrega 2 - Punto D - fullSpoil
fullSpoil(Persona1,Persona2) :- leSpoileo(Persona1,Persona2,_).
fullSpoil(Persona1,Persona2) :- amigo(Persona3, Persona2),
                                Persona1 \= Persona2, 
                                fullSpoil(Persona1,Persona3).

% Casos de prueba unitarios
:- begin_tests(spoiler_alert).

    % Test Entrega 1 - Punto B - Es spoiler
    test(esSpoilerMuerteEmperorEnStarWars, nondet) :-
        esSpoiler(starWars, muerte(emperor)).
            
    test(esSpoilerMuertePedroEnStarWars, nondet) :-
        not(esSpoiler(starWars, muerte(pedro))).
            
    test(esSpoilerParentescoAnakinReyEnStarWars, nondet) :-
        esSpoiler(starWars, relacion(parentesco, anakin, rey)).
            
    test(esSpoilerParentescoAnakinLavezziEnStarWars, nondet) :-
        not(esSpoiler(starWars, relacion(parentesco, anakin, lavezzi))).
            
    % Test Entrega 1 - Punto C - Le spoileo
    test(leSpoileoGastonAMaiuGoT, nondet) :-
        leSpoileo(gaston, maiu, got).
            
    test(leSpoileoNicoAMaiuStarWars, nondet) :-
        leSpoileo(nico, maiu, starWars).
            
    % Test Entrega 1 - Punto D - Televidente responsable
    test(nicoNoEsResponsable, nondet):-
        not(televidenteResponsable(nico)).
            
    test(gastonNoEsResponsable, nondet):-
        not(televidenteResponsable(gaston)).
            
    test(ayeSoloEsUnaTroll, nondet):-
        televidenteResponsable(aye).
            
    test(televidenteResponsableEsInversible, set(Televidente == [juan, maiu, aye])):-
        televidenteResponsable(Televidente).
            
    % Test Entrega 1 - Punto E - Viene zafando
    test(maiuNoVieneZafando, nondet):-
        not(vieneZafando(maiu, _)).
    test(juanVieneZafando, set(Serie == [himym, got, hoc])):-
        vieneZafando(juan, Serie).
    test(soloNicoVieneZafandoConStarWars, set(Persona == [nico])):-
        vieneZafando(Persona, starWars).
             
    % Test Entrega 2 
            
    % Punto A - malaGente
    test(malaGente, set(Malos = [nico, gaston])):-
        malaGente(Malos).
            
    test(buenaGente, set(Buenos = [aye, maiu, pedro, juan])):-
        miraOQuiereVer(Buenos, _), not(malaGente(Buenos)).
                
    % Punto B - esFuerte
    test(fuerte1, nondet):-
        fuerte(futurama, muerte(seymourDiera)).
            
    test(fuerte2, nondet):-
        fuerte(starWars, muerte(emperor)).
            
    test(fuerte3, nondet):-
        fuerte(starWars, relacion(parentesco, anakin, rey)).
            
    test(fuerte4, nondet):-
        fuerte(starWars, relacion(parentesco, vader, luke)).
            
    test(fuerte5, nondet):-
        fuerte(himym, relacion(amorosa, ted, robin)).
                        
    test(fuerte6, nondet):-
        fuerte(himym, relacion(amorosa, swarley, robin)).
            
    test(fuerte7, nondet):-
        fuerte(got, plotTwist([fuego, boda])).
                            
    test(fuerte8, nondet):-
        not(fuerte(got, plotTwist([suenio]))).
            
    test(fuerte9, nondet):-
        not(fuerte(drHouse, plotTwist([coma, pastillas]))).
                
    % Punto C - popularidad
    test(popularidad, set(Populares = [got, starWars, hoc])):-
        popular(Populares).
            
    % Punto D - fullSpoil
    test(fullSpoil, set(Quienes = [gaston, aye, juan, maiu])):-
        fullSpoil(nico, Quienes).
            
    test(fullSpoil2, set(Quienes = [aye, juan, maiu])):-
        fullSpoil(gaston, Quienes).
            
    test(fullSpoil3, set(Quienes = [])):-
        fullSpoil(maiu, Quienes).
                    
:- end_tests(spoiler_alert).