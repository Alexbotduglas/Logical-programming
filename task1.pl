%член списка
memb([X|Xs],X):-!.
memb([_|Xs],X):-
	memb(Xs,X).
%перестановки списка	
selct(X,[X|Xs],Xs).
selct(X,[Y|Xs],[Y|Zs]):-selct(X,Xs,Zs).

perm(L,[X|P]):-selct(X,L,L1),perm(L1,P).
perm([],[]).
%удаление всех включений элемента из списка
remove([],X,[]):-!.
remove([X|Xs],X,Zs):-
	remove(Xs,X,Zs).
remove([X|Xs],Z,[X|Zs]):-
	X\=Z,
	remove(Xs,Z,Zs).	
%проверка на подсписок списка
prefx([X|Xs],[Y|Ys]):-
	X=Y,
	prefx(Xs,Ys).	
prefx([],_):-!.
sufx(Xs,[_|Ys]):-
	sufx(Xs,Ys).	
sufx(Xs,Xs):-!.
sublst(Xs,Ys):-
	prefx(Ps,Ys),sufx(Xs,Ps),!.
%конкатенация
app([],Zs,Zs):-!.
app([X|Xs],Ys,[X|Zs]):-
	app(Xs,Ys,Zs).
%длина списка
leng([],0):-!.
leng([_|Xs],N):-leng(Xs,M),N is M+1.
%вставка в список с встроенными предикатами
list_insert(X,1,L,[X|O]):-
	append([],L,O),!.

list_insert(X,I,[Y|L],[Y|O]):-
	I1 is I-1,
	list_insert(X,I1,L,O).
%вставка в список без встроенных предикатов 	
list_insert(X,0,[],[]):-!.

list_insert(X,0,[Y|L],[Y|O]):-
	list_insert(X,0,L,O),!.
	
list_insert(X,1,L,[X|O]):-
	list_insert(X,0,L,O),!.
	
list_insert(X,I,[Y|L],[Y|O]):-
	I1 is I-1,
	list_insert(X,I1,L,O).
%поиск позиции первого отрицательного элемента без встр предикатов
proc(['find'],0):-!.
proc([X|L],N):- 
	X<0,!,
	proc(['find'],N1),
	N is N1+1.
proc([X|L],N):- 
	proc(L,N1),
	N is N1+1.
%поиск позиции первого отрицательного элемента с встр предикатами
proc(L,N):- 
	length(L,P),
	indx(L,N,P),
	N\=0,
	!.
indx([],0,_):-!.
indx([X|L],N,P):- 
	X<0,
	!,
	indx([],0,N),
	length(L,G),
	N is P-G.
indx([X|L],N,P):- 
	indx(L,N,P).
%пример совместного использования предикатов : добавление на позицию I N символов X
list_insert(X,1,L,[X|O]):-
	append([],L,O),!.
	
list_insert(X,I,[Y|L],[Y|O]):-
	I1 is I-1,
	list_insert(X,I1,L,O).
get(X,I,N,L,O):-
	change(X,I,N,L,O).
	
change(_,_,0,L,A):-
	append([],L,A),
	!.
change(X,I,N,L,A):-
	list_insert(X,I,L,Z),
	N1 is N-1,
	change(X,I,N1,Z,A).
	