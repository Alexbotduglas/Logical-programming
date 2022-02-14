name('andrej').
name('vitya').
name('tolya').
name('dima').
name('yura').
%Андрей говорит , что это Витя или Толя
said('andrej',H):-
	H='vitya'.
said('andrej',H):-
	H='tolya'.
%Витя говорит , что это не он и не Юра
said('vitya',H):-
	H\='vitya',
	H\='yura'.
%Дима говорит , что прав Витя и неправ Андрей или наоборот
said('dima',H):-
	\+said('andrej',H),
	said('vitya',H).
said('dima',H):-
	said('andrej',H),
	\+said('vitya',H).
	
%Юрий говорит , что Дима неправ
said('yura',H):-
	\+said('dima',H).
%Отец говорит , что не менее трех сказали правду 
fathersaid([X,Y,Z,S],H):-
	said(X,H),
	said(Y,H),
	said(Z,H),
	said(S,H);
	said(X,H),
	said(Y,H),
	said(Z,H),
	\+said(S,H),!.
unique([]).
unique([L|List]):-
	\+member(L,List),
	L\='tolya',
	unique(List).
break(H):-
	name(X),
	name(Y),
	name(Z),
	name(W),
	unique([X,Y,Z,W]),
	Boys=[X,Y,Z,W],
	permutation(Boys,List),
	fathersaid(List,H),!.