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




	