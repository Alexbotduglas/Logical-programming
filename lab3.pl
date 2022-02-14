check_place(Mis,Kan):-
	Mis>=Kan;% мессионеров больше каннибалов
	Mis=0.% или мессионеров нет 
check_goat(Lmis,Lkan):-
	Lmis+Lkan=<3. % в лодке максимум три человека 

	
get_back(PeopleNum,Rvalue):-
	PeopleNum=0,Rvalue is 0,!;% если на левом берегу не осталось людей , то никого обратно не возвращаем
	PeopleNum>0,Rvalue is 1,!.% иначе возвращаем хотя бы одного

print_list([]).	
print_list([L|Path]):-
	write(L),nl,
	print_list(Path).
	
check_back(A,B,C,D):-
	A\=C;
	B\=D.

prolong([[Mis,Kan,Rmis,Rkan]|T],[[Mis2,Kan2,Rmis2,Rkan2],[Mis,Kan,Rmis,Rkan]|T],[Lkan,Lmis,Backkan,Backmis]):-
	move([Mis,Kan,Rmis,Rkan],[Mis2,Kan2,Rmis2,Rkan2,Lkan,Lmis,Backkan,Backmis]),
	\+member([Mis2,Kan2,Rmis2,Rkan2],[[Mis,Kan,Rmis,Rkan]|T]).

move([Mis,Kan,Rmis,Rkan],[Mis2,Kan2,Rmis2,Rkan2,Lkan,Lmis,Backkan,Backmis]):-
	check_place(Mis,Kan),
	check_place(Rmis,Rkan),
		
	between(1,Mis,Lmis),
	between(1,Kan,Lkan),
	
	check_place(Lmis,Lkan),
	check_goat(Lmis,Lkan),
	
	Mis1 is Mis-Lmis,
	Kan1 is Kan-Lkan,
	
	check_place(Mis1,Kan1),
	
	PeopleNum is Mis1+Kan1,
	get_back(PeopleNum,Rvalue),
	
	Rmis1 is Lmis+Rmis,
	Rkan1 is Lkan+Rkan,
	check_place(Rmis1,Rkan1),
	
	between(0,Rmis1,Backmis),
	between(0,Rkan1,Backkan),
	
	check_back(Backkan,Backmis,Lkan,Lmis),
	
	Backmis+Backkan>=Rvalue,
	
	Rmis2 is Rmis1-Backmis,
	Rkan2 is Rkan1-Backkan,
	check_place(Rmis2,Rkan2),
	check_place(Backmis,Backkan),
	check_goat(Backmis,Backkan),
	
	Mis2 is Mis1+Backmis,
	Kan2 is Kan1+Backkan,
	check_place(Mis2,Kan2).


search_id(Way):-
	id([[3,3,0,0]],[],Way,5),
	write('all states off people (first two - real_timisioners and kannibals on left side'),nl,
	write('second two - on right side):'),nl,!.
	
	
id([[0,0,3,3]|Path],PathTwo,[[0,0,3,3]|Path],_):-
	reverse(PathTwo,Print),
	print_list(Print).
id([[Mis,Kan,Rmis,Rkan]|Path],PathTwo,Way,MaxDepth):-
	MaxDepth>0,
	MaxD is MaxDepth-1,
	prolong([[Mis,Kan,Rmis,Rkan]|Path],[[Mis2,Kan2,Rmis2,Rkan2]|Prolonged_List],[Lkan,Lmis,Backkan,Backmis]),
	id([[Mis2,Kan2,Rmis2,Rkan2]|Prolonged_List],
	[['at the begin on left kan,mis:',Kan,Mis,
	'Mis ,Kan on boat to right:',Lmis,Lkan,
	'Back to left mis, kan:',Backmis,Backkan,
	'remain on right kan,mis:',Rkan2,Rmis2,
	'in the end on left:',Mis2,Kan2]|PathTwo],Way,MaxD).

search_dpth(Way):-
	dpth([[3,3,0,0]],[],Way),
	write('all states off people (first two - real_timisioners and kannibals on left side'),nl,
	write('second two - on right side):'),nl,!.
	
dpth([[0,0,3,3]|Path],PathTwo,[[0,0,3,3]|Path]):-
	reverse(PathTwo,Print),
	print_list(Print).
dpth([[Mis,Kan,Rmis,Rkan]|Path],PathTwo,Way):-
	
	prolong([[Mis,Kan,Rmis,Rkan]|Path],[[Mis2,Kan2,Rmis2,Rkan2]|Prolonged_List],[Lkan,Lmis,Backkan,Backmis]),
	dpth([[Mis2,Kan2,Rmis2,Rkan2]|Prolonged_List],
	[['at the begin on left kan,mis:',Kan,Mis,
	'Mis ,Kan on boat to right:',Lmis,Lkan,
	'Back to left mis, kan:',Backmis,Backkan,
	'remain on right kan,mis:',Rkan2,Rmis2,
	'in the end on left:',Mis2,Kan2]|PathTwo],Way).

	
search_bdth(Way):-
	bdth([[[3,3,0,0]]],[0,0,3,3],Way),
	write('all states off people (first two - real_timisioners and kannibals on left side'),nl,
	write('second two - on right side):'),nl,!.
	
bdth([[X|T]|_],X,[X|T]):-!.
bdth([P|Qi],X,Res):-
	findall(Prolonged_list,prolong(P,Prolonged_list,[_,_,_,_]),List),
	sort(List,Uniq_list),
	append(Qi,Uniq_list,Qo),!,
	bdth(Qo,X,Res).