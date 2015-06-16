
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Chicago Stock Exchange    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         Projet IA02          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------- Benquet Florent & Talouka Oumaima --------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%    Générer Le Plateau De Départ    %%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%

%Tous les jetons présent au début du jeu. 
%Nous allons piocher dedans aléatoirement pour générer nos piles
jetons([
	ble, ble, ble, ble, ble, ble,
	riz, riz, riz, riz, riz, riz,
	cacao, cacao, cacao, cacao, cacao, cacao,
	cafe, cafe, cafe, cafe, cafe, cafe,
	sucre, sucre, sucre, sucre, sucre, sucre,
	mais, mais, mais, mais, mais, mais
	]).


%Générer l'ensemble des 9 piles initiales sous forme d'une liste de sous-listes
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

/*Générer une pile en choisissant successivement 4 jetons aléatoirement.
On supprime à chaque itération (choose) le jeton prélévé 
et on renvoie en sortie la nouvelle liste de jetons.*/
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

%Valeur des marchandises : les valeurs seront modifiées à chaque tour de jeu
bourse([[ble,7],[riz,6],[cacao,6],[cafe,6],[sucre,6],[mais,6]]).

/*Les reserves des joueurs sont initialement vides ,
nous les complétons au fur et à mesure du jeu */
j1Reserve([]).			
j2Reserve([]).




%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%    Prédicats de service    %%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%

%Nouveau modulo pour ne pas avoir de résultat égal à 0
modulo(X, X, X):- !.				%Pour éviter le 9 mod 9 = 0 par exemple
modulo(6, 3, 3):- !.                %Cas particulier relevé lors des tests
modulo(4, 2, 2):- !.                %Cas particulier relevé lors des tests
modulo(X, Nbpiles, Res):- Res is X mod Nbpiles.

%Ce prédicat met dans Elt un élément aléatoire de List: calcule la longueur de la liste, prend un élément d'indice aléatoire et le renvoie.
choose([], []).
choose(List, Elt) :-
        length(List, Length),
        random(0, Length, Index),
        nth0(Index, List, Elt).

%Récupérer l'élément d'indice Index ,Vérifier si l'élément d'indice Ind est Elem.
%Il éussit si l'élément d'indice Ind de la liste List s'unifie avec Elem. Les indices commencent à 0.
nth0(0,[X|_], X):-!.
nth0(Index,[_|List], X):- Index>0, Index1 is Index-1, nth0(Index1,List, X).

%Pareil que nth0 avec des indices commençant à 1.
nth1(1,[X|_], X):-!.
nth1(Index,[_|List], X):- Index>1, Index1 is Index-1, nth1(Index1,List, X).

%Supprime la 1ère occurence A dans la liste L, et retourne la nouvelle liste R
%del(X, L, R). 
del(A, [A|B], B):- !.		            %si premier élément de la liste, on renvoie la queue
del(A, [B|C], [B|D]):- del(A, C, D).	%sinon on continue à chercher

%Retire toutes les occurences de X dans la liste (même les listes vides pour lesquelles on va spécialement l'utiliser).
delete_element(_, [], []).
delete_element(X, [X|R], R1):- delete_element(X, R, R1).
delete_element(X, [Y|R], [Y|R1]):- X\=Y, delete_element(X, R, R1).

%Supprime le premier élément de la sous liste d'indice I de Liste et renvoie le résultat dans NewListe
%delete_first_sous_liste(Liste, I, NewListe). 
delete_first_sous_liste([[_|R]|Q],1,[R|Q]):-!.
delete_first_sous_liste([T|Q],PositionRelativeSousListe,[T|R]):-
	NewPositionRelativeSousListe is PositionRelativeSousListe-1,
 	delete_first_sous_liste(Q,NewPositionRelativeSousListe,R).

%Ajout d'un élément X à la liste L et renvoie le résultat dans R (UTILE pour les réserves des joueurs)
%add(X, L, R).
add(X, [], [X]):- !.	%si liste vide
add(X, [T|Q], [X,T|Q]).	%si liste non vide, on l'ajoute en début de liste.

%Chercher l'élément X dans la liste
element(X, [X|_]).
element(X, [T|Q]):- T\= X, element(X, Q).

%Cherche l'élément X dans la liste et RENVOIE L'INDICE (on peut retirer le T\= X)
elementindice(X, [X|_], 1).
elementindice(X, [T|Q], I):- T\= X, element(X, Q, I2), I is I2 + 1.

%Cherche le Nième élément de L et renvoie l'élément X
%nieme(2, [[ble,7], [riz,7], [cacao,7]], [X|_]). Si on veut juste la tête d'une sous liste
nieme(1, [X|_], X):-!.
nieme(N, [_|Q], X):- M is N -1, nieme(M, Q, X).

%Substitue tous les éléments X de AncienneListe par Y et renvoie NouvelleListe
%substitue(X, Y, AncienneListe, NouvelleListe).
substitue(X,Y,[],[]).
substitue(X,Y,[X|R],[Y|R1]):- substitue(X,Y,R,R1), !.
substitue(X,Y,[Z|R],[Z|R1]):- X\==Z, substitue(X,Y,R,R1).

%Demande qui commence la partie et vérifie bien que seule les valeurs 'j1' et 'j2' peuvent être saisies, sinon il renvoie la question
qui(X):-
	write('Quel joueur commence : j1 ou j2 ?'),
	read(X), quiT(X), !.
qui(X):-qui(X).
quiT('j1').    
quiT('j2').


%alterner(JoueurActuel, Joueur Suivant).
alterner('j1', 'j2').
alterner('j2', 'j1').


%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%    Gestion des affichages    %%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%

%Gère les affichages pour la bourse dans le plateau
ecrire(ble):- write('Blé'), !.
ecrire(riz):- write('Riz'), !.
ecrire(cacao):- write('Cacao'), !.
ecrire(cafe):- write('Café'), !.
ecrire(sucre):- write('Sucre'), !.
ecrire(mais):- write('Maïs'), !.
ecrire(X):-write(X).	% pour afficher un entier


% Affiche le premier élément de chaque pile précédée de son indice
affichageElement1Ind(_, []).
affichageElement1Ind(X, [A|T]):- write(X), tab(2), afficher(A), Y is X+1, affichageElement1Ind(Y, T) .
afficher([H|Q]):- write(H). %tab(3).

% Affiche le premier élément de chaque pile précédée de son indice avec le Trader bien placé (unifie la position du Trader avec le numéro de pile correspondant)
affichageElement1Trad([], _, _).
affichageElement1Trad([A|T], Trader, Trader):- write(Trader), tab(2), afficher(A), tab(10), write(' <-- Trader'), nl, Y is Trader+1, affichageElement1Trad(T, Y, Trader).
affichageElement1Trad([A|T], X, Trader):- X\=Trader, write(X), tab(2), afficher(A), nl, Y is X+1, affichageElement1Trad(T, Y, Trader).

% Génère un nombre aléatoire entre 1 et 9
positionInitiale(X):- random(1,10,X).	

% Affiche les piles du plateau et le trader à la bonne position EN DEBUT DE PARTIE
affiche_piles_ini_trad(P, Trader):- write('-------Piles-------'), nl, generer_piles(P1, P2, P3, P4, P5, P6, P7, P8, P9, P),
 nl, positionInitiale(Trader), write('-------Position du Trader : '), write(Trader),write(' -------'), nl, affichageElement1Trad(P, 1, Trader).

% Affiche les piles du plateau et le trader à la bonne position EN COURS DE PARTIE
affiche_piles(P, Trader):- write('-------Piles-------'), nl, nl, affichageElement1Trad(P, 1, Trader).

% Parcours tous les éléments d'une liste et les affiche un par un séparément
affiche_elements_liste([]).
affiche_elements_liste([X|R]):- write(X), tab(3), affiche_elements_liste(R).		

% Gère l'affichage de chaque élement=> utilisé pour la bourse
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

% Affichage de la bourse 
affiche_bourse([]).
affiche_bourse([T|Q]):- afficheValeur(T), tab(3), affiche_bourse(Q), !.	

% Affichage des reserves
affiche_J1Reserve(R1):- write('-------Réserve du Joueur 1-------'), nl, affiche_elements_liste(R1).
affiche_J2Reserve(R2):- write('-------Réserve du Joueur 2-------'), nl, affiche_elements_liste(R2).

% Initialise le plateau de départ et l'affiche
%Les reserves doivent être vides d'après les règles du jeu
plateau_depart(M, Pos, B, R1,R2):- 
	affiche_piles_ini_trad(M, Pos), nl,
	write('-------Bourse-------'), nl,
	bourse(B),
	affiche_bourse(B), nl, nl,
	affiche_J1Reserve(R1), nl,
	affiche_J2Reserve(R2), nl.

%affiche le plateau AU COURS D'UNE PARTIE
plateauEncours(M,P, B, J1R,J2R):- 
	affiche_piles(M, P), nl,
	write('-------Bourse-------'), nl,
	affiche_bourse(B), nl,nl,
	affiche_J1Reserve(J1R), nl,nl,
	affiche_J2Reserve(J2R), nl,nl.
	



%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Coup Humain    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%

%Determiner la position Precedente par rapport à une position fixé (utile pour déterminer la pile précédente par rapport au Trader)
positionPrec(1, X, List):- length(List, X), !.
positionPrec(Pos, NPos, List):-  NPos is Pos-1.

%Determiner la position suivante par rapport à une position fixé (utile pour déterminer la pile suivante par rapport au Trader)
positionSuiv(X, 1, List):- length(List, X), !.
positionSuiv(Pos, NPos, List):- NPos is Pos+1.


%coup_possible(Plateau, Coup)
coup_possible([P, Pos, B, J1R, J2R], [Joueur, Deplacement, Garde, Vend]):-
%	write('********************COUP POSSIBLE*******************'), nl,
	repeat,
	write('Entrez un déplacement (1, 2 ou 3) : '),
	read(Deplacement), Deplacement>=1, Deplacement =<3, 
	Y is Pos + Deplacement,	
	length(P, NbPiles), 	
	modulo(Y, NbPiles, Pos2),	
	affiche_piles(P, Pos2),			
	positionPrec(Pos2, Prec, P),
	positionSuiv(Pos2, Suiv, P),
	nieme(Prec, P, [Choix1|_]),
	nieme(Suiv, P, [Choix2|_]),
	nl, write('Quelle céréale voulez-vous Garder ?'), nl,
	repeat,
	write(' Tapez 1 pour prendre de le " '), write(Choix1), write(' " de la pile Precedente'),nl,
	write(' Tapez 2 pour prendre de le " '), write(Choix2), write(' " de la pile Suivante'), write(' : '), nl,
	read(Choix), Choix>=1, Choix=<2,
	cerealegardee(Choix, Choix1, Choix2, Garde, Vend),
	write('Céréale gardée : '), write(Garde), nl,
	write('Céréale vendue : '), write(Vend), nl.

%cerealegardee(Choix, Choix2, Garde, Vend).
cerealegardee(1, Choix1, Choix2, Choix1, Choix2).	%Choix1
cerealegardee(2, Choix1, Choix2, Choix2, Choix1).	%choix2





%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%    Jouer_Coup quelque soit la boucle    %%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%


% jouer_coup additionne le déplacement du Trader à la position initiale, modifie la réserve du joueur qui joue,
% décrémente la céréale vendue, et retourne le nouveau plateau avec les 2 jetons de moins (et supprime les éventuelles listes vides)
% jouer_coup(+PlateauInitial, ?Coup, ?NouveauPlateau)

jouer_coup([P, Pos, B, J1R, J2R], [Joueur, D, Garde, Vend], [NP, Pos3, B2, J1R2, J2R2]):-
	delete_element([], P, Ptemp),		%on supprimer les éventuelles piles vides
	Y is Pos + D,
	length(Ptemp, NbPiles),	
	modulo(Y, NbPiles, Pos2),				
	add_reserve(Garde,Joueur,J1R,J2R,J1R2,J2R2),
	write('Nouvelle réserve du Joueur 1 :'), write(J1R2), nl,nl,
	write('Nouvelle réserve du Joueur 2 :'), write(J2R2), nl,nl,
	bourse_sortie([Vend, Valeur], B, B2),
	write('Ancienne Bourse : '), tab(5), affiche_bourse(B), nl,					%affiche l'ancienne bourse
	write('Nouvelle Bourse : '), tab(5), affiche_bourse(B2), nl, 				%affiche la nouvelle bourse
	positionPrec(Pos2, Prec, Ptemp),
	positionSuiv(Pos2, Suiv, Ptemp),
	delete_first_sous_liste(Ptemp,Prec,Ptemp2),
	delete_first_sous_liste(Ptemp2,Suiv,Ptemp3),
	delete_element([], Ptemp3, NP),				%le nombre de piles vides supprimées change la position du trader
	repositionne_trader(Pos2, Pos3, NP),
	nl,write('Position du Trader '), write(Pos3),
	nl, write('Etat des piles du plateau après le coup :'), nl, write(NP).

% Si la position du Trader est supérieure au nombre de Piles (après suppression des piles vides par exemple), on repositionne le Trader à la dernière pile
%repositionne_trader(AnciennePosition, NouvellePosition, Piles)
repositionne_trader(Pos, NPos, Piles):- 
	length(Piles, L), 
	Pos > L, 
	NPos is L, !.
repositionne_trader(Pos, Pos, Piles).	% si ce n'est pas le cas, il garde la même position

%Ajoute la céréale gardée à la reserve du joueur j1
add_reserve(Garde,Joueur,J1R,J2R,J1R2,J2R2) :-
	Joueur == 'j1',
	add(Garde, J1R, J1R2),
	J2R2 = J2R,!.

%Ajoute la céréale gardée à la reserve du joueur j2
add_reserve(Garde,Joueur,J1R,J2R,J1R2,J2R2) :-
	Joueur == 'j2',
	add(Garde, J2R, J2R2),
	J1R2 = J1R.

%On fournit la céréale vendue et sa valeur avec la bourse actuelle, et on renvoie la bourse modifiée avec la nouvelle valeur de la céréale
bourse_sortie([Vend, Valeur],B, B2):-
	element([Vend, Valeur], B),
	V2 is Valeur-1,
	substitue([Vend, Valeur],[Vend, V2], B, B2).




%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%    Coup Machine    %%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%


% On renvoie les 6 coups possibles, on inverse Garde et Vend pour 2 coups avec le même Déplacement, et on l'exécute avec les 3 déplacements possibles
%coups_possibles(Plateau, Joueur, ListeCoupsPossibles).		
coups_possibles([P, Pos, B, J1R, J2R], J, [C1, C2, C3, C4, C5, C6]):-
		coup_possible_ordi([P, Pos, B, J1R, J2R], [J, 1, Garde1, Vend1]),
		C1 = [J, 1, Garde1, Vend1],
		C2 = [J, 1, Vend1, Garde1 ],
		coup_possible_ordi([P, Pos, B, J1R, J2R], [J, 2, Garde2, Vend2]),
		C3 = [J, 2, Garde2, Vend2],
		C4 = [J, 2, Vend2, Garde2],
		coup_possible_ordi([P, Pos, B, J1R, J2R], [J, 3, Garde3, Vend3]),
		C5 = [J, 3, Garde3, Vend3],
		C6 = [J, 3, Vend3, Garde3].


%On simule les 6 coups pour avoir leur score associé, on détermine le plus élevé, puis on trouve le coup associé.
%meilleur_coup(+Plateau, -Coup).
meilleur_coup([P, Pos, B, J1R, J2R], [Joueur, D, Garde, Vend]):-
	coups_possibles([P, Pos, B, J1R, J2R], Joueur, [C1, C2, C3, C4, C5, C6]),
	simuler_coup_ordi([P, Pos, B, J1R, J2R], C1, Score1),
	simuler_coup_ordi([P, Pos, B, J1R, J2R], C2, Score2),
	simuler_coup_ordi([P, Pos, B, J1R, J2R], C3, Score3),
	simuler_coup_ordi([P, Pos, B, J1R, J2R], C4, Score4),
	simuler_coup_ordi([P, Pos, B, J1R, J2R], C5, Score5),
	simuler_coup_ordi([P, Pos, B, J1R, J2R], C6, Score6),
	maximum_liste([Score1, Score2, Score3, Score4, Score5, Score6], MeilleurScore),
	ListeCoupsScores = [[C1, Score1], [C2, Score2], [C2, Score2], [C3, Score3], [C4, Score4], [C5, Score5], [C6, Score6]],
	element([MeilleurCoup, MeilleurScore], ListeCoupsScores),
	nl, write('Le meilleur coup est '), write(MeilleurCoup), nl,
	[Joueur, D, Garde, Vend] = MeilleurCoup.

% Nous sert pour déterminer le maximum des scores
%maximum_liste(Liste, Max).
maximum_liste([X], X).
maximum_liste([T1, T2|Q], M):- T1 > T2, maximum_liste([T1|Q], M).
maximum_liste([T1, T2|Q], M):- T2 >= T1, maximum_liste([T2|Q], M).

%L'ordinateur (peu importe j1 ou j2) GARDE la céréale précédente, et VEND la suivante
coup_possible_ordi([P, Pos, B, J1R, J2R], [_, Deplacement, Garde, Vend]):-
	Y is Pos + Deplacement,	
	length(P, NbPiles),
	modulo(Y, NbPiles, Pos2),	
	positionPrec(Pos2, Prec, P),
	positionSuiv(Pos2, Suiv, P),
	nieme(Prec, P, [Garde|_]),
	nieme(Suiv, P, [Vend|_]).

% l'IA simule un coup et calcule le score du Joueur concerné
simuler_coup_ordi([P, Pos, B, J1R, J2R], [Joueur, D, Garde, Vend], Score):-
	delete_element([], P, Ptemp),		%on supprimer les éventuelles piles vides
	Y is Pos + D,
	length(Ptemp, NbPiles),	
	modulo(Y, NbPiles, Pos2),				
	add_reserve(Garde,Joueur,J1R,J2R,J1R2,J2R2),
	bourse_sortie([Vend, Valeur], B, B2),
	score_joueur(Joueur, B2, J1R2, J2R2, Score).





%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%    Prédicats de fin de jeu (résultats)   %%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%

% On retrouve le score à partir d'un élément dans la bourse
score_Elt(Elt, Bourse, S):-
	element([Elt, Valeur], Bourse),
	S is Valeur.

%Calcule le score d'un joueur à partir de sa réserve et de l'état de la Bourse actuelle
%score_reserve(ReserveJoueur, BourseActuelle, Score)
score_reserve([], BourseActuelle, 0).
score_reserve([T|Q], BourseActuelle, Score):-
	score_Elt(T, BourseActuelle, S),
	score_reserve(Q, BourseActuelle, SM),
	Score is S + SM.

% Calcule le score du joueur j1 à partir de sa réserve J1R
score_joueur(Joueur, Bourse, J1R, J2R, Score):-
	Joueur=='j1',
	score_reserve(J1R, Bourse, Score), !.

% Calcule le score du joueur j2 à partir de sa réserve J2R
score_joueur(Joueur, Bourse, J1R, J2R, Score):-
	Joueur=='j2',
	score_reserve(J2R, Bourse, Score).	

%Détermine le gagnant à partir des scores des joueurs 
%Cas où joueur J1 gagne
gagnant(Score1, Score2):-
	Score1>Score2,
	write('Le joueur 1 a gagné avec un score de '), write(Score1), nl,
	write('Le joueur 2 a perdu avec un score de '), write(Score2), nl, !.

%Cas où joueur J2 gagne
gagnant(Score1, Score2):-
	Score2>Score1,
	write('Le joueur 2 a gagné avec un score de '), write(Score2), nl,
	write('Le joueur 1 a perdu avec un score de '), write(Score1), nl, !.

%Cas où les 2 scores sont égaux
gagnant(Score1, Score2):-
	write('Les deux joueurs terminent à égalité avec un score de '), write(Score1).

% Calcule le nombre de piles de marchandises non vides (équivalent à length)
nb_Piles([], 0).
nb_Piles([T|Q], X):-
	nb_Piles(Q,Y),
	X is Y+1.





%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%    Boucle Humain/Humain    %%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%

% Permet de lancer une partie humain/humain :initialise le plateau et lance la boucle de jeu
jVSj:-  plateau_depart(Piles,Pos,Bourse,Res1,Res2), qui(Joueur), nl, nl,
	write('*********************TOUR DU JOUEUR '), write(Joueur), write('*********************'), nl,nl,
	boucle_JvsJ([Piles,Pos,Bourse,Res1,Res2], Joueur),!.

% boucle_JvsJ dans le cas où la fin du jeu est atteinte
boucle_JvsJ([Piles,Pos,Bourse,Res1,Res2], Joueur):- 
	delete_element([], Piles, P),		%on supprime les éventuelles piles vides et on renvoie P
	nb_Piles(Piles, NBPILES), NBPILES=<2, 
	write('*********************Partie terminée*********************'), nl,nl,
	score_reserve(Res1, Bourse, Score1),	%Score du Joueur 1
	score_reserve(Res2, Bourse, Score2),	%Score du Joueur 2
	alterner(Joueur, Joueur2),
	gagnant(Score1, Score2), !.

% boucle_JvsJ dans le cas où la fin du jeu n'est pas encore atteinte, les tours des differents joueurs s'enchainent
boucle_JvsJ([Piles,Pos,Bourse,Res1,Res2], Joueur):-
	delete_element([], Piles, P),		%on supprime les éventuelles piles vides et on renvoie P
	coup_possible([P, Pos, Bourse, Res1, Res2], [Joueur, Deplacement, Garde, Vend]),
	jouer_coup([P, Pos, Bourse, Res1, Res2], [Joueur, Deplacement, Garde, Vend], [PlateauN, PosN, BN, Res1N, Res2N]),
	nl,nl,nl,nl,
	alterner(Joueur, JoueurSuiv),
	write('*********************TOUR DU JOUEUR '), write(JoueurSuiv), write('*********************'), nl,nl,nl,
	plateauEncours(PlateauN, PosN, BN, Res1N, Res2N), nl,
	boucle_JvsJ([PlateauN, PosN, BN, Res1N, Res2N], JoueurSuiv).





%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Boucle IA/IA   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%

% Permet de lancer une partie ordinateur/ordinateur :initialise le plateau et lance la boucle de jeu
iaVSia:-  plateau_depart(Piles,Pos,Bourse,Res1,Res2), qui(Joueur), nl, nl,
	write('*********************TOUR DU JOUEUR '), write(Joueur), write('*********************'), nl,nl,
	boucle_IAvsIA([Piles,Pos,Bourse,Res1,Res2], Joueur), !.

% boucle_IAvsIA dans le cas où la fin du jeu est atteinte
boucle_IAvsIA([Piles,Pos,Bourse,Res1,Res2], Joueur):- 
	delete_element([], Piles, P),		%on supprime les éventuelles piles vides et on renvoie P
	nb_Piles(Piles, NBPILES), NBPILES=<2, 
	write('***************Partie terminée***************'), nl,nl,
	score_reserve(Res1, Bourse, Score1),	%Score du Joueur 1
	score_reserve(Res2, Bourse, Score2),	%Score du Joueur 2
	alterner(Joueur, Joueur2),
	gagnant(Score1, Score2), !.

% boucle_IAvsIA dans le cas où la fin du jeu n'est pas encore atteinte, les tours des differentes machines s'enchainent
boucle_IAvsIA([Piles,Pos,Bourse,Res1,Res2], Joueur):-
	delete_element([], Piles, P),		%on supprime les éventuelles piles vides et on renvoie P
	meilleur_coup([P, Pos, Bourse, Res1, Res2], [Joueur, Deplacement, Garde, Vend]),
	jouer_coup([P, Pos, Bourse, Res1, Res2], [Joueur, Deplacement, Garde, Vend], [PlateauN, PosN, BN, Res1N, Res2N]),
	nl,nl,nl,nl,
	alterner(Joueur, JoueurSuiv),
	write('*********************TOUR DU JOUEUR '), write(JoueurSuiv), write('*********************'), nl,nl,nl,
	plateauEncours(PlateauN, PosN, BN, Res1N, Res2N), nl,	
	boucle_IAvsIA([PlateauN, PosN, BN, Res1N, Res2N], JoueurSuiv).




%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Boucle Humain/IA    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%

% Permet de lancer une partie ordinateur/ordinateur :initialise le plateau et lance la boucle de jeu
jVSia:-  plateau_depart(Piles,Pos,Bourse,Res1,Res2), 
	qui(Joueur), nl, nl,
	boucle_JvsIA([Piles,Pos,Bourse,Res1,Res2], Joueur), !.

% boucle_JvsIA dans le cas où la fin du jeu est atteinte
boucle_JvsIA([Piles,Pos,Bourse,Res1,Res2], Joueur):- 
	nb_Piles(Piles, NBPILES), NBPILES=<2, 
	write('*********************Partie terminée*********************'), nl,nl,	
	score_reserve(Res1, Bourse, Score1),	%Score du Joueur 1
	score_reserve(Res2, Bourse, Score2),	%Score du Joueur 2
	alterner(Joueur, Joueur2),
	gagnant(Score1, Score2), !.

% boucle_IAvsIA dans le cas où la fin du jeu n'est pas encore atteinte, les tours des differentes machines s'enchainent
boucle_JvsIA([Piles,Pos,Bourse,Res1,Res2], Joueur):-
	write('*********************TOUR DU JOUEUR '), write(Joueur), write('*********************'), nl,nl,nl,
	plateauEncours(Piles,Pos,Bourse,Res1,Res2),
	coup_possible([Piles, Pos, Bourse, Res1, Res2], [Joueur, Deplacement, Garde, Vend]),
	jouer_coup([Piles, Pos, Bourse, Res1, Res2], [Joueur, Deplacement, Garde, Vend], [PlateauN, PosN, BN, Res1N, Res2N]),
	nl,nl,nl,nl,
	delete_element([], PlateauN, PN),                %on supprime les éventuelles piles vides et on renvoie P
	alterner(Joueur, JoueurSuiv),
	suite_boucle_IA([PN, PosN, BN, Res1N, Res2N], JoueurSuiv).


% Teste après boucle_JvsIA la terminaison du jeu après le coup de l'Humain si condition d'arrêt atteinte (fin du jeu si vrai)
suite_boucle_IA([Piles,Pos,Bourse,Res1,Res2], Joueur):-
	nb_Piles(Piles, NBPILES), NBPILES=<2, !,
	write('*********************Partie terminée avec Fin du jeu*********************'), nl,nl,	
	score_reserve(Res1, Bourse, Score1),	%Score du Joueur 1
	score_reserve(Res2, Bourse, Score2),	%Score du Joueur 2
	alterner(Joueur, Joueur2),
	gagnant(Score1, Score2), !.

% Rentre dans suite_boucle_IA si la condition d'arrêt n'est pas atteinte après le coup Humain et joue le coup de l'IA puis reboucle sur boucle_JvsIA
suite_boucle_IA([Piles,Pos,Bourse,Res1,Res2], Joueur):-
	write('*********************TOUR DE L IA '), write('*********************'), nl,nl,nl,
	plateauEncours(Piles,Pos,Bourse,Res1,Res2),
	meilleur_coup([Piles,Pos,Bourse,Res1,Res2], [Joueur, DeplacementIA, GardeIA, VendIA]),
	jouer_coup([Piles,Pos,Bourse,Res1,Res2], [Joueur, DeplacementIA, GardeIA, VendIA], [PlateauNN, PosNN, BNN, Res1NN, Res2NN]),
	nl,nl,nl,nl,
	delete_element([], PlateauNN, PNN),                 %on supprime les éventuelles piles vides et on renvoie P
	alterner(Joueur, JoueurSuiv),
	boucle_JvsIA([PNN, PosNN, BNN, Res1NN, Res2NN], JoueurSuiv).




%-------------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Boucle Menu    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------%
%Lance le menu du jeu
boucle_menu:- repeat, menu, !.

%Choisir une des 3 differentes parties ou quitte le jeu, si valeur mal saisie, il le précise te renvoie la question.
menu:- nl,nl,
	write('1. Partie Joueur VS Joueur'),nl,
	write('2. Partie Ordinateur vs Ordinateur'),nl,
	write('3. Partie Joueur vs Ordinateur'),nl,
	write('4. Quittez le programme'),nl,nl,
	write('Entrer un choix'),nl,
	read(Choix),nl, appel(Choix),
	Choix=4, nl.

appel(1):- write('Vous avez choisi le mode : Joueur Vs Joueur'),nl,nl,nl,jVSj,!.
appel(2):- write('Vous avez choisi le mode : Ordinateur vs Ordinateur'),nl,nl,nl, iaVSia,!.
appel(3):- write('Vous avez choisi le mode : Joueur vs Ordinateur'),nl,nl,nl,jVSia,!.
appel(4):- write('Merci d avoir joué !'), nl, write('Au revoir'),!.
appel(_):- write('Vous avez mal choisi').


Dans le cadre du programme portant sur la programmation Logique en IA02, il nous a été demandé d’implémenter en Prolog le jeu « Chicago Stock Exchange » complet composé de la partie Humain vs Humain, Humain vs Machine, Machine vs Machine en respectant la structures des données (cf p. 4) et les règles du jeu. 

Le Chicago Stock Exchange est un jeu de société qui se joue pratiquement sur un plateau. Il se base essentiellement sur des principes de finance et de bourse: moins on vend une marchandise, plus elle est se ratifie et devient chère. Les joueurs s’alternent en déplaçant successivement un trader. Ils récupèrent deux céréales (respectivement à gauche et à droite de la pile où est positionner le trader)à chaque tour, gardent une céréale et vendent l’autre sur le marché boursier. La vente décrémente la valeur en bourse de la céréale d’une unité . Le but du jeu est d’avoir le score le plus élevé, la stratégie étant de s’enrichir au maximum tout en appauvrissant l’adversaire.

