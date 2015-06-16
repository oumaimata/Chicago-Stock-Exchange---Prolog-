% Les 9 piles de 4 jetons parmi : ble, riz, caco, cafe, sucre, mais
piles([
	[mais, riz, ble, ble], 
	[ble, mais, sucre, riz], 
	[cafe, sucre, cacao, riz], 
	[cafe, mais, sucre, mais], 
	[cacao, mais, ble, sucre], 
	[riz, cafe, sucre, ble], 
	[cafe, ble, sucre, cacao], 
	[mais, cacao, cacao],
	[riz,riz,cafe,cacao]
	]).


affiche_piles2:- write('-------Piles-------'), nl, piles(X),affichageElement1(X).




%ne prends pas en compte les 6 jetons maximum par céréale
une_pile2(A, B, C, D, Pi):- 
	choose([ble, riz, cacao, cafe, sucre, mais],A),
	choose([ble, riz, cacao, cafe, sucre, mais],B),
	choose([ble, riz, cacao, cafe, sucre, mais],C),
	choose([ble, riz, cacao, cafe, sucre, mais],D),
	Pi = ([A, B, C, D]),
	write(Pi).



	affiche_elements_liste([[ble,7],[riz,6],[cacao,6],[cafe,6],[sucre,6],[mais,6]]).


	affiche_bourse2([[ble,7],[riz,6],[cacao,6],[cafe,6],[sucre,6],[mais,6]]).



% affiche le plateau après chaque coup joué : PROB : 
affiche_plateau(M,B,P,R1,R2):- 
	affiche_piles,
	nl,
	write('-------Bourse-------'), nl,
	affiche_bourse,
	nl,
	affiche_position(P), 
	nl,
	affiche_J1Reserve(R1), 
	nl,
	affiche_J2Reserve(R2).




%Pour les réserves des joueurs
	add(Garde, J1R, J1R2),
	write(J1R2), nl,
	add(Garde, J2R, J2R2),
	write(J2R2), nl,
	affiche_position_ini(X):-
	random(1,10,X),
	Y is 3*X,
	Z is Y+3*X,
	tab(Z),
	write('X'),
	nl,
	write('X = '),
	write(X),
	nl, nl, nl.
	/*
	write('Y ='),
	write(Y),
	nl,
	write('Z ='),
	write(Z).
*/

% LANCER plateauTest([P, Pos, B, J1R, J2R]), affiche_piles(P, Pos), coup_possible([P, Pos, B, J1R, J2R],[Joueur, Deplacement, Garde, Vend]).
%coup_possible(Plateau, Coup)

coup_possible([P, Pos, B, J1R, J2R], [Joueur, Deplacement, Garde, Vend]):-
	repeat,
	write('Entrez un déplacement (1, 2 ou 3) : '),
	read(Deplacement), Deplacement>=1, Deplacement =< 3, 
	Y is Pos + Deplacement,				
%	module(Y, 9, Pos2),
	Pos2 is Y mod 9,				%PROBLEME nbre de piles
	Prec is Pos2-1,
	Suiv is Pos2+1,					%déterminer le numéro des piles afin d'y accéder
	write('position précédente '), write(Prec), nl,
	write('position suivante '), write(Suiv), nl,
	nieme(Prec, P, [Choix1|_]),
	nieme(Suiv, P, [Choix2|_]),
	write('Quelle céréale voulez-vous Garder ?'),
	repeat,
	write(' Tapez 1 pour '), write(Choix1), write(' ou Tapez 2 pour '), write(Choix2), write(' : '),
	read(Choix), Choix>=1, Choix=<2,
	cerealegardee(Choix, Choix1, Choix2, Garde, Vend),
	write('Céréale gardée : '), write(Garde), nl,
	write('Céréale vendue : '), write(Vend), nl
	.


%LANCER plateauTest([P, Pos, B, J1R, J2R]), delete_element([], P, NP), affiche_piles(P, Pos), coup_possible_ordi([NP, Pos, B, J1R, J2R],[Joueur, 1, Garde, Vend]).
%L'ordi (peu importe j1 ou j2) GARDE la céréale précédente, et VEND la suivante
coup_possible_ordi([P, Pos, B, J1R, J2R], [_, Deplacement, Garde, Vend]):-
	Y is Pos + Deplacement,	
	length(P, NbPiles),
	modulo(Y, NbPiles, Pos2),	
%	affiche_piles(P, Pos2),		% à virer
%	write('Nouvelle position du Trader : '), write(Pos2), nl,
	positionPrec(Pos2, Prec, P),
	positionSuiv(Pos2, Suiv, P),
%	write('Position précédente '), write(Prec), nl,
%	write('Position suivante '), write(Suiv), nl,
	nieme(Prec, P, [Garde|_]),
	nieme(Suiv, P, [Vend|_])
%	write('Céréale gardée : '), write(Garde), nl,
%	write('Céréale vendue : '), write(Vend), nl
	.


/*		Ce qu'on voulait faire initialement pour coups_possibles
		coups_possibles([P, Pos, B, J1R, J2R], [C1, C2, C3, C4, C5, C6]):-

		Coup = [Joueur, Deplacement, Garde, Vend],
		findall(Coup, coup_possible_ordi([P, Pos, B, J1R, J2R],Coup),L),
		afficher(L)
*/

% l'IA simule un coup et calcule le score du Joueur concerné
simuler_coup_ordi([P, Pos, B, J1R, J2R], [Joueur, D, Garde, Vend], Score):-
	delete_element([], P, Ptemp),		%on supprimer les éventuelles piles vides
	Y is Pos + D,
	length(Ptemp, NbPiles),	
	modulo(Y, NbPiles, Pos2),				
	write(Pos2), nl,
	add_reserve(Garde,Joueur,J1R,J2R,J1R2,J2R2),
	write('Réserve du Joueur 1 :'), write(J1R2), nl,
	write('Réserve du Joueur 2 :'), write(J2R2), nl,
	bourse_sortie([Vend, Valeur], B, B2),
	affiche_bourse(B), nl,
	affiche_bourse(B2), nl, 
	positionPrec(Pos2, Prec, Ptemp),
	positionSuiv(Pos2, Suiv, Ptemp),

	del_first(Prec, Ptemp, P1), 
	del_first(Suiv, P1, P2),
	delete_element([], P2, NP)							
%	write(P2),
%	affiche_piles(Ptemp, Pos), nl,
%	affiche_piles(NP, Pos2)
	.


	%LANCER bourse(B), score_joueur([ble, riz, cacao, ble, ble], B, S).
%Calcule le score d'un joueur à partir de sa réserve et de l'état de la Bourse actuelle
%score_joueur(ReserveJoueur, BourseActuelle, Score)
score_joueur([], BourseActuelle, 0).
score_joueur([T|Q], BourseActuelle, Score):-
	score_Elt(T, BourseActuelle, S),
	score_joueur(Q, BourseActuelle, SM),
	Score is S + SM
	.
%maximum de deux nombres
maximum(X, Y, X):- Y=<X, !.
maximum(X, Y, Y).


%LANCER supprimeElement([[mais],[cafe,riz],[cacao],[riz,cafe,sucre],[cacao],[cacao,cafe,cafe],[ble],[mais,ble],[riz,sucre]], 5, P2).
% Prédicat permettant de supprimer la tête de la ième sous-liste et de renvoyer la liste modifiée
supprimeElement([[_|R]|Queue],1,[R|Queue]):-!.
    supprimeElement([Tete|Queue],PositionRelativeSousListe,[Tete|R]):-
    NewPositionRelativeSousListe is PositionRelativeSousListe-1,
    supprimeElement(Queue,NewPositionRelativeSousListe,R).


%LANCER plateauTest([P, Pos, B, J1R, J2R]), jouer_coup([P, Pos, B, J1R, J2R],[j1, 2, sucre, riz],[P2, Pos2, B2, J1R2, J2R2]).

%jouer_coup additionne le déplacement du Trader à la position initiale, modifie la réserve du joueur qui joue,
%décrémente la céréale vendue, et retourne le nouveau plateau avec les 2 jetons de moins (et supprime les éventuelles listes vides)
% jouer_coup(+PlateauInitial, ?Coup, ?NouveauPlateau)

jouer_coup([P, Pos, B, J1R, J2R], [Joueur, D, Garde, Vend], [NP, Pos2, B2, J1R2, J2R2]):-
%	write('********************JOUER COUP*******************'), nl,
	delete_element([], P, Ptemp),		%on supprimer les éventuelles piles vides
	Y is Pos + D,
	length(Ptemp, NbPiles),	
	modulo(Y, NbPiles, Pos2),				
%	write(Pos2), nl,
	add_reserve(Garde,Joueur,J1R,J2R,J1R2,J2R2),
	write('Nouvelle réserve du Joueur 1 :'), write(J1R2), nl,nl,
	write('Nouvelle réserve du Joueur 2 :'), write(J2R2), nl,nl,
	bourse_sortie([Vend, Valeur], B, B2),
	write('Ancienne Bourse : '), tab(5), affiche_bourse(B), nl,					%affiche l'ancienne bourse
	write('Nouvelle Bourse : '), tab(5), affiche_bourse(B2), nl, 				%affiche la nouvelle bourse
	positionPrec(Pos2, Prec, Ptemp),
	positionSuiv(Pos2, Suiv, Ptemp),

%	nl, write('Avant de suppr le prec'), nl,
%	nl, write(Ptemp), nl,

	delete_first_sous_liste(Ptemp,Prec,Ptemp2),
%	nl, write('Après avoir suppr le prec'), nl,
%	nl, write(Ptemp2), nl,
%	nl, write('Avant de suppr le suiv'), nl,
	delete_first_sous_liste(Ptemp2,Suiv,Ptemp3),
%	nl, write('Après avoir suppr le suiv'), nl,
%	nl, write(Ptemp3), nl,
	delete_element([], Ptemp3, NP),				%le nombre de piles vides supprimées change la position du trader
%	nl, write('SOUS ICI3'), nl,
%	write('Apres avoir retiré les listes vides'),
	nl, write('Etat des piles du plateau après le coup :'), nl, write(NP)
%	affiche_piles(NP, Pos2)					%montre les 9 tetes de piles ave la position du trader
	.

	
%LANCER compte([[1,2,3], []], X).
% compte(L,N) est vrai si N est le nombre d'éléments dans la liste L.
compte([],0).
compte([_|R],N) :- compte(R,N1), N is N1+1, N>0 .					%TO COMMENT


%NON UTILISE FINALEMENT
%coup_enrichir(Coup1, Score1, Coup2, Score2, MeilleurCoup, MeilleurScore).	%On compare les coups deux à deux
coup_enrichir(Coup1, Score1, Coup2, Score2, Coup1, Score1):-	% si le coup1 est le meilleur coup
		Score1 > Score2, !.
coup_enrichir(Coup1, Score1, Coup2, Score2, Coup2, Score2).		% si le Coup2 est le meilleur coup




affiche_position(X):-
	write('-------Position du Trader-------'), nl,
	Y is 3*X,
	Z is Y+3*X,
	tab(Z),
	write('X'),
	nl,
	write('X = '),
	write(X),
	nl, nl,nl.									% position recalculée à partir de la précédente + 1, 2 ou 3

	