%задание 1
mark(Student,[Student,Mark,M]):-
	get_marks(Student,Mark,Pass),
	Pass = 2,
	M = 'dont pass exams',
	!;
	get_marks(Student,Mark,Pass),
	M = 'pass exams',!.

check([2|_],2):-!.
check([],1):-!.
check([M|Marks],Pass):-
	check(Marks,Pass).
	
get_marks(Y,Mark,Pass):-
	findall(Mrk,grade(_,Y,_,Mrk),Marks),
	get_sum_mark(Marks,M),
	check(Marks,Pass),
	length(Marks,Len),
	Mark is M / Len.

get_sum_mark([],0).
get_sum_mark([Y|Marks],M):-
	get_sum_mark(Marks,N),
	M is N + Y.

students_marks(Student,X):-
	mark(Student,X).
%задание 2
count([],0).
count([_|S],Number):-
	count(S,N),
	Number is N + 1.

get_dont_passed([],[]).
get_dont_passed(N,[N,Number]):-
	findall(N,grade(_,_,N,2),Subj),
	count(Subj,Number).
	
dont_pass_exams(Subject,X):-
	get_dont_passed(Subject,X).
%задание 3
no_repeats([], []):-!.
no_repeats([X|Xs], Ys):-
	member(X, Xs),!,
	no_repeats(Xs, Ys).
no_repeats([X|Xs], [X|Ys]):-
	no_repeats(Xs, Ys).
	
sum_mark([],0).
sum_mark([Y|Marks],M):-
	sum_mark(Marks,N),
	M is N + Y.
	
calc_max_group_mark([],Result,Max):-
	Result = Max,!.
calc_max_group_mark([M|Marks],Result,Max):-
	M > Max,
	calc_max_group_mark(Marks,Result,M);
	calc_max_group_mark(Marks,Result,Max).
	
get_average_marks([],[]):-!.
get_average_marks([S|Students],[Max|M]):-
	findall(X,grade(_,S,_,X),Marks),
	sum_mark(Marks,N),
	length(Marks,Len),
	Max is N / Len,
	get_average_marks(Students,M).

make_list(G,[G,Max]):-
	findall(S,grade(G,S,_,_),Stud),
	no_repeats(Stud,Students),
	get_average_marks(Students,Marks),
	calc_max_group_mark(Marks,Max,0).

max_mark(Group,X):-
	make_list(Group,X),!.