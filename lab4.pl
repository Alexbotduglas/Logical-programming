delete_particles([],[]). % удаление частиц из списка , для упрощения дальнейшей обработки	
delete_particles([Word|Res],[Word|Res1]):-
	(\+particle(Word);Word='ne'), % если это не частица или частица 'ne' 
	delete_particles(Res,Res1). 
delete_particles([_|Res],Res1):-
	delete_particles(Res,Res1). % иначе просто не добавляем этот элемент в список
	
% данный предикат улучшает входной список , вставляя в некоторых местах глаголы и имена  
% например , если перед глаголом нет имени , то он вставляет последнее прочитанное имя перед глаголом 
parser([],_,_,_,_,Res,Res1):- 
	reverse(Res,Rs),
	delete_particles(Rs,Res1).
parser([Word|List],PrevWord,LastName,LastVerb,Ne,Result,Res):- 

	% для удаления из запятых , так как в программе они не нужны
	(Word=(','),parser(List,PrevWord,LastName,LastVerb,Ne,Result,Res),!); 
	
	% для случая , такого типа : миша любит мячики 
	% и кубики -> миша любит мячики и миша любит кубики
	(\+names(Word), 
	\+verbs(Word),
	\+particle(Word),
	particle(PrevWord),
	PrevWord='i',
	((Ne='F',
	parser(List,Word,LastName,LastVerb,Ne,[Word,LastVerb,LastName|Result],Res),!);
	(Ne='ne',
	parser(List,Word,LastName,LastVerb,Ne,[Word,LastVerb,Ne,LastName|Result],Res),!)));
	
	% Если это имя , то просто добавляем его в список
	(names(Word),Ne='F',
	parser(List,Word,Word,LastVerb,Ne,[Word|Result],Res),!);
	
	% для случая , такого типа : миша любит мячики и 
	% любит кубики -> миша любит мячики и миша любит кубики
	(verbs(Word),
	\+names(PrevWord),
	particle(PrevWord),
	PrevWord\='ne',
	parser(List,Word,LastName,Word,Ne,[Word,LastName|Result],Res),!);
	
	% для случая , такого типа : миша любит мячики и не любит кубики -> 
	% миша любит мячики и миша не любит кубики
	(particle(Word),
	\+names(PrevWord),
	Word='ne',
	parser(List,Word,LastName,LastVerb,Ne,[Word,LastName|Result],Res),!);
	
	% если это глагол и случай не относится ни к 
	% какому другому случаю , то просто записываем данный глагол как последний прочитанный глагол
	(verbs(Word),particle(PrevWord),PrevWord='ne',
	parser(List,Word,LastName,Word,'ne',[Word|Result],Res),!);
	
	% иначе просто записываем слово в список
	parser(List,Word,LastName,LastVerb,Ne,[Word|Result],Res),!.
	
particle(X):-
	member(X,['ne','no','i','a']).
names(X):-
	member(X,['sasha','masha','petya']).
verbs(X):-
	member(X,['lubit']).

final([],[]).% получаем список структур
final([Name,'ne',_,What|TempRes],[Head|Tail]):-
	Head=..['dont_like',Name,What], % оператор создания структуры
	final(TempRes,Tail).
final([Name,_,What|TempRes],[Head|Tail]):-
	Head=..['like',Name,What],
	final(TempRes,Tail).
	
decompose(List,Result):-
	parser(List,'F','F','F','F',[],TempRes),
	final(TempRes,Result),!.