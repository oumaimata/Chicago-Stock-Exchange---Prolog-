
% plateau arbitraire pour tester l'affichage : les 9 piles de 4 jetons, la position du trader, la bourse, J1R, J2R
plateauTest([
	[[ble,sucre,sucre,sucre],[ble, riz, riz, riz],[ble,ble,riz,sucre],[sucre,riz,cafe,mais],[cafe,cafe,mais,cafe],[ble,cacao,cacao,cacao],[riz,mais,mais,cacao],[riz,ble,sucre,cafe],[mais,cafe,cacao,mais]], 	
	8,
	[[ble,7],[riz,6],[cacao,6],[cafe,6],[sucre,6],[mais,6]],							
	[],					
	[]
	]).





%----------------------------Variables définies----------------------------

%jetons au total, on va piocher dedans pour générer nos piles
jetons([
	ble, ble, ble, ble, ble, ble,
	riz, riz, riz, riz, riz, riz,
	cacao, cacao, cacao, cacao, cacao, cacao,
	cafe, cafe, cafe, cafe, cafe, cafe,
	sucre, sucre, sucre, sucre, sucre, sucre,
	mais, mais, mais, mais, mais, mais
	]).


%les piles sont des listes
generer_piles(P1, P2, P3, P4, P5, P6, P7, P8, P9, P):- 
	jetons(S),
	une_pile(A1, B1, C1, D1, P1, S, S1), 
	une_pile(A2, B2, C2, D2, P2, S1,S2),
	une_pile(A3, B3, C3, D3, P3, S2, S3),
	une_pile(A4, B4, C4, D4, P4, S3, S4),
	une_pile(A5, B5, C5, D5, P5, S4, S5),
	une_pile(A6, B6, C6, D6, P6, S5, S6),
	une_pile(A7, B7, C7, D7, P7, S6, S7),
	une_pile(A8, B8, C8, D8, P8, S7, S8),
	une_pile(A9, B9, C9, D9, P9, S8, S9),
	P = ([P1, P2, P3, P4, P5, P6, P7, P8, P9]),
	write(P), nl.


une_pile(A, B, C, D, Pi, Sac, Sac_res):-
	choose(Sac,A),
	del(A, Sac, J1),
	choose(J1,B),
	del(B, J1, J2),
	choose(J2,C),
	del(C, J2, J3),
	choose(J3,D),
	del(D, J3, Sac_res),
	Pi = ([A, B, C, D]).


	/*
	write('Sac entré '), nl,
	write(Sac), nl,
	write('Sac resultat'), nl,write(Sac_res).
*/

%Nouveau modulo pour ne pas avoir de résultat égal à 0
modulo(X, X, X):- !.				%Pour éviter le 9 mod 9 = 0 par exemple
modulo(X, Nbpiles, Res):- Res is X mod Nbpiles.





% met dans Elt un élément aléatoire de List : calcule la longueur de la liste, prends un élément d'indice aléatoire et le renvoie
choose([], []).
choose(List, Elt) :-
        length(List, Length),
        random(0, Length, Index),
        nth0(Index, List, Elt).

nth0(0,[X|_], X):-!.
nth0(Index,[_|List], X):- Index>0, Index1 is Index-1, nth0(Index1,List, X).


nth1(1,[X|_], X):-!.
nth1(Index,[_|List], X):- Index>1, Index1 is Index-1, nth1(Index1,List, X).

%Supprime la 1ère occurence A dans la liste L, et retourne la nouvelle liste R
%delete(X, L, R). 
del(A, [A|B], B):- !.		%si premier élément de la liste, on renvoie la queue
del(A, [B|C], [B|D]):- del(A, C, D).	%sinon on continue à chercher


%LANCER delete_element([], [[], [1,2,3], [], [], [1,2]], X).
%retire toutes les occurences de X dans la liste (même les listes vides).
delete_element(_, [], []).
delete_element(X, [X|R], R1):- delete_element(X, R, R1).
delete_element(X, [Y|R], [Y|R1]):- X\=Y, delete_element(X, R, R1).



%Supprime le premier élément d'une sous liste d'indice I d'une liste  et renvoie la nouvelle Liste
del_first(_, [], []).
del_first(I, P, P2):-
	nieme(I, P, [T|Q]),

	substitue([T|Q], Q, P, P2)
%	write(P), nl,
%	write(P2), nl
	.


%Ajout d'un élément X à la liste L et renvoie le résultat dans R (UTILE pour les réserves des joueurs)
%add(X, L, R).
add(X, [], [X]):- !.	%si liste vide
add(X, [T|Q], [X,T|Q]).	%si liste non vide, on l'ajoute en début de liste.


%va chercher l'élément X dans la liste
element(X, [X|_]).
element(X, [T|Q]):- T\= X, element(X, Q).

%va chercher l'élément X dans la liste et RENVOIE L'INDICE : on peut retirer le T\= X
elementindice(X, [X|_], 1).
elementindice(X, [T|Q], I):- T\= X, element(X, Q, I2), I is I2 + 1.

%va chercher le Nième élément de L et renvoie l'élément X
%nieme(2, [[ble,7], [riz,7], [cacao,7]], [X|_]). Si on veut juste la tête d'une sous liste
nieme(1, [X|_], X):-!.
nieme(N, [_|Q], X):- M is N -1, nieme(M, Q, X).




% Valeur des marchandises : les valeurs seront modifiées à chaque tour de jeu
bourse([
[ble,7],
[riz,6],
[cacao,6],
[cafe,6],
[sucre,6],
[mais,6]
]).



j1Reserve([]).			 % on va compléter leur réserve respective au fur et à mesure du jeu 
j2Reserve([]).





% ----------------------------prédicats----------------------------


ecrire(ble):- write('Blé'), !.
ecrire(riz):- write('Riz'), !.
ecrire(cacao):- write('Cacao'), !.
ecrire(cafe):- write('Café'), !.
ecrire(sucre):- write('Sucre'), !.
ecrire(mais):- write('Maïs'), !.
ecrire(X):-write(X).	% pour afficher un entier

%ecrire([T|Q]):- write(T), affiche_elements_liste(Q).


% affiche le premier élément de chaque pile précédé de son indice
affichageElement1Ind(_, []).
affichageElement1Ind(X, [A|T]):- write(X), tab(2), afficher(A), Y is X+1, affichageElement1Ind(Y, T) .
afficher([H|Q]):- write(H). %tab(3).

%LANCER positionTrader(Trader), write('trader position'), write(Trader), nl, affichageElement1Trad([[1, 2, 3], [1,3,2], [4,6,3], [4, 2, 1]], 1, Trader).
%affiche le premier élément de chaque pile précédé de son indice avec le Trader bien placé
affichageElement1Trad([], _, _).
affichageElement1Trad([A|T], Trader, Trader):- write(Trader), tab(2), afficher(A), tab(10), write(' <-- Trader'), nl, Y is Trader+1, affichageElement1Trad(T, Y, Trader).
affichageElement1Trad([A|T], X, Trader):- X\=Trader, write(X), tab(2), afficher(A), nl, Y is X+1, affichageElement1Trad(T, Y, Trader).


% affiche le premier élément de chaque pile
affichageElement1([]).
affichageElement1([A|T]):- tab(2), afficher(A), affichageElement1(T).


positionInitiale(X):- random(1,10,X).	% genere un nombre entre 1 et 9

% position du trader aléatoire au début, puis est modfiée de 1 à 3 unités, allant de la position 1 à 9
positionTrader(X):- random(1,4,X).

%Afficher les piles du plateau et le trader à la bonne position EN DEBUT DE PARTIE
affiche_piles_ini_trad(P, Trader):- write('-------Piles-------'), nl, generer_piles(P1, P2, P3, P4, P5, P6, P7, P8, P9, P),
 nl, positionInitiale(Trader), write('-------Position du Trader : '), write(Trader),write(' -------'), nl, affichageElement1Trad(P, 1, Trader).


%Afficher les piles du plateau et le trader à la bonne position EN COURS DE PARTIE
affiche_piles(P, Trader):- write('-------Piles-------'), nl, nl, affichageElement1Trad(P, 1, Trader).


affiche_elements_liste([]).									% Pour afficher tous les élements d'une liste séparément
affiche_elements_liste([X|R]):- write(X), tab(3), affiche_elements_liste(R).		% utile ?


afficheValeur([Produit, Valeur]):- ecrire(Produit), write(' = '), write(Valeur), !.


% Autre version de l'affichage de la bourse
affiche_bourse_ini(A,B,C,D,E,F):- 
	A = 7, B = 6, C = 6, D = 6, E = 6, F = 6,
	write('-------Piles-------'), nl,
	write('Blé = '), write(A), tab(3),
	write('Riz = '), write(B), tab(3),
	write('Cacao = '), write(C), tab(3),
	write('Café = '), write(D), tab(3),
	write('Sucre = '), write(E), tab(3),
	write('Maïs = '), write(F).


%POUR afficher la bourse : lancer "bourse(B), afficher_bourse(B)."

affiche_bourse([]).

affiche_bourse([T|Q]):- afficheValeur(T), tab(3), affiche_bourse(Q), !.	



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



affiche_J1Reserve(R1):- write('-------Réserve du Joueur 1-------'), nl, j1Reserve(R1),affiche_elements_liste(R1).

affiche_J2Reserve(R2):- write('-------Réserve du Joueur 2-------'), nl, j2Reserve(R2),affiche_elements_liste(R2).






% Les reserves doivent être vides d'après les règles du jeu
plateau_depart(M, Pos, B, R1,R2):- 
	affiche_piles_ini_trad(M, Pos), nl,
	write('-------Bourse-------'), nl,
	bourse(B),
	affiche_bourse(B), nl,
	affiche_J1Reserve(R1), nl,
	affiche_J2Reserve(R2), nl
	.

plateau(M,P, B, R1,R2):- 
	affiche_piles(M, P), nl,
	write('-------Bourse-------'), nl,
	bourse(B),
	affiche_bourse(B), nl,
	affiche_J1Reserve(R1), nl,
	affiche_J2Reserve(R2), nl
	.

positionPrec(1, X, List):- length(List, X).
positionPrec(Pos, NPos, List):- NPos is Pos-1.

positionSuiv(X, 1, List):- length(List, X).
positionSuiv(Pos, NPos, List):- NPos is Pos+1.



% LANCER plateauTest([P, Pos, B, J1R, J2R]), delete_element([], P, NP), affiche_piles(P, Pos), coup_possible([NP, Pos, B, J1R, J2R],[Joueur, Deplacement, Garde, Vend]).
%coup_possible(Plateau, Coup)
coup_possible([P, Pos, B, J1R, J2R], [Joueur, Deplacement, Garde, Vend]):-
	repeat,
	write('Entrez un déplacement (1, 2 ou 3) : '),
	read(Deplacement), Deplacement>=1, Deplacement =< 3, 
	Y is Pos + Deplacement,	
	length(P, NbPiles), 	
	modulo(Y, NbPiles, Pos2),	
	affiche_piles(P, Pos2),			
	write('Nouvelle position du Trader : '), write(Pos2), nl,
	positionPrec(Pos2, Prec, P),
	positionSuiv(Pos2, Suiv, P),
	write('Position précédente '), write(Prec), nl,
	write('Position suivante '), write(Suiv), nl,
	nieme(Prec, P, [Choix1|_]),
	nieme(Suiv, P, [Choix2|_]),
	write('Quelle céréale voulez-vous Garder ?'),
	repeat,
	write(' Tapez 1 pour prendre de la pile Précédente '), write(Choix1), nl, write(' ou Tapez 2 pour prendre de la pile Suivante '), write(Choix2), write(' : '),
	read(Choix), Choix>=1, Choix=<2,
	cerealegardee(Choix, Choix1, Choix2, Garde, Vend),
	write('Céréale gardée : '), write(Garde), nl,
	write('Céréale vendue : '), write(Vend), nl
	.

%cerealegardee(Choix, Choix1, Choix2, Garde, Vend).
cerealegardee(1, Choix1, Choix2, Choix1, Choix2).	%Choix1
cerealegardee(2, Choix1, Choix2, Choix2, Choix1).	%choix2



%LANCER plateauTest([P, Pos, B, J1R, J2R]), jouer_coup([P, Pos, B, J1R, J2R],[j1, 2, sucre, riz],[P2, Pos2, B2, J1R2, J2R2]).

%jouer_coup additionne le déplacement du Trader à la position initiale, modifie la réserve du joueur qui joue,
%décrémente la céréale vendue, et retourne le nouveau plateau avec les 2 jetons de moins (et supprime les éventuelles listes vides)
% jouer_coup(+PlateauInitial, ?Coup, ?NouveauPlateau)

jouerCoup:- jouer_coup([P, Pos, B, J1R, J2R], [Joueur, D, Garde, Vend], [NP, Pos2, B2, J1R2, J2R2]).

jouer_coup([P, Pos, B, J1R, J2R], [Joueur, D, Garde, Vend], [NP, Pos2, B2, J1R2, J2R2]):-
	coup_possible([P, Pos, B, J1R, J2R], [Joueur, D, Garde, Vend]),
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

%On fournit la céréale et sa valeur avec la bourse actuelle, et on renvoie la bourse modifiée avec cette valeur
bourse_sortie([Vend, Valeur],B, B2):-
	element([Vend, Valeur], B),
	V2 is Valeur-1,
	substitue([Vend, Valeur],[Vend, V2], B, B2).



% On remplace l'élément X (qui peut être une SOUS LISTE) de la bourse B (une liste de sous listes) par l'élément 2 dans la nouvelle bourse B2 
%substitute_bourse(X, Y, B, B2).
	
substitue(X,Y,[],[]).
substitue(X,Y,[X|R],[Y|R1]):- substitue(X,Y,R,R1), !.
substitue(X,Y,[Z|R],[Z|R1]):- X\==Y, substitue(X,Y,R,R1).







%bourse([[ble,A],[riz,B2],[cacao,C],[cafe,D],[sucre,E],[mais,F]])
/*
bourse([
[ble,7],
[riz,6],
[cacao,6],
[cafe,6],
[sucre,6],
[mais,6]
]).

[[ble,A],[riz,B],[cacao,C],[cafe,D],[sucre,E],[mais,F]])
*/




add_reserve(Garde,Joueur,J1R,J2R,J1R2,J2R2) :-
	Joueur == 'j1',
	add(Garde, J1R, J1R2),
	J2R2 = J2R,
	!.

add_reserve(Garde,Joueur,J1R,J2R,J1R2,J2R2) :-
	Joueur == 'j2',
	add(Garde, J2R, J2R2),
	J1R2 = J1R.


% LANCER bourse(B), score_Elt(riz, Bourse, S).
% On retrouve le score à partir d'un élément dans la bourse
score_Elt(Elt, Bourse, S):-
	element([Elt, Valeur], Bourse),
	S is Valeur.

%LANCER bourse(B), score_joueur([ble, riz, cacao], B, S).
%Calcule le score d'un joueur à partir de sa réserve et de l'état de la Bourse actuelle
%score_joueur(ReserveJoueur, BourseActuelle, Score)
score_joueur([], BourseActuelle, 0).
score_joueur([T|Q], BourseActuelle, Score):-
	score_Elt(T, BourseActuelle, S),
	score_joueur(Q, BourseActuelle, SM),
	Score is S + SM
	.



% LANCER generer_piles(P1, P2, P3, P4, P5, P6, P7, P8, P9, P), nbPiles(P, X).
% calcule le nombre de piles de marchandises non vides (équivalent à length)
nb_Piles([], 0).
nb_Piles([T|Q], X):-
	nbPiles(Q,Y),
	X is Y+1
	.

%LANCER compte([[1,2,3], []], X).
% compte(L,N) est vrai si N est le nombre d'éléments dans la liste L.
compte([],0).
compte([_|R],N) :- compte(R,N1), N is N1+1, N>0 .


qui(X):-
%	repeat,			%faire répéter si le joueur entre autre chose que j1 ou j2
	write('Qui joue : j1 ou j2 ?'),
%	qui\= 'j1', qui\= 'j2',
	read(X).


%alterner(JoueurActuel, Joueur Suivant).
alterner('j1', 'j2').
alterner('j2', 'j1').

jVSj:-  plateau_depart(Piles,Pos,Bourse,Res1,Res2), qui(Joueur),
	repeat, 
	boucle_JvsJ, !
	.

boucle_JvsJ:-
%	plateau_depart(Piles,Pos,Bourse,Res1,Res2),


	delete_element([], Piles, P),		%on supprime les éventuelles piles vides



	jouer_coup([P, Pos, Bourse, Res1, Res2], [Joueur, Deplacement, Garde, Vend], [PlateauN, PosN, BN, Res1N, Res2N]), !,

	plateau(PlateauN, PosN, BN, Res1N, Res2N)

%	write(PlateauN)

%	nb_Piles(PlateauN, NBPILES), !,

%	alterner(JoueurPrec, Joueur),

%	NBPILES=2,				% condition d'arrêt : 2 piles 

%	write('Partie Terminée')
%	compte()


	.














