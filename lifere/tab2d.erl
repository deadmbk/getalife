-module(tab2d).
-compile(export_all).
 
%------------------------------------------------ Standard Operations
 
create(X, Y) -> array:new([{size, X}, {default, array:new( [{size, Y}] )}]).
 
get(X, Y, Array) -> array:get(Y, array:get(X, Array)).
 
set(X, Y, Value, Array) ->
	Y_array = array:get(X, Array),
	New_y_array = array:set(Y, Value, Y_array),
	array:set(X, New_y_array, Array).
	
sizeW(Array) ->
	Y_array = array:get(0,Array),
	Y_array:size().
	
sizeH(Array) -> array:size(Array).

%------------------------------------------------- writeOut Array
	
writeOut(Array) ->
	writeX(Array,sizeH(Array),sizeW(Array),0).

writeX(Array,HS,WS,IX) when IX < HS ->
	writeY(Array,HS,WS,IX),
	writeX(Array,HS,WS,IX+1);

writeX(_,HS,_,HS) -> 
	io:format("\n").

writeY(Array,HS,WS,IX) -> writeY(Array,HS,WS,IX,0).

writeY(Array,HS,WS,IX,IY) when IY < WS ->
	io:format(" ~B",[get(IX,IY,Array)]),
	writeY(Array,HS,WS,IX,IY+1);
writeY(_,_,WS,_,WS) -> 
	io:format("\n").
	
%-------------------------------------------------- Zero Array

zeroArr(Array,Mode) -> zeroX(Array,tab2d:sizeH(Array),tab2d:sizeW(Array),Mode).

zeroX(Array,HS,WS,Mode) -> zeroX(Array,HS,WS,0,Mode).

zeroX(Array,HS,WS,IX,Mode) when IX<HS ->
	zeroX(zeroY(Array,HS,WS,IX,Mode),HS,WS,IX+1,Mode);

zeroX(Array,HS,_,HS,_) -> Array.

zeroY(Array,HS,WS,IX,Mode) -> zeroY(Array,HS,WS,IX,0,Mode).

zeroY(Array,HS,WS,IX,IY,Mode) when IY<WS ->
	case Mode of
		0 -> zeroY(tab2d:set(IX,IY,0,Array),HS,WS,IX,IY+1,Mode);
		1 -> zeroY(putWhatever(Array,IX,IY),HS,WS,IX,IY+1,Mode);
		2 -> zeroY(tab2d:set(IX,IY,IX*HS+IY,Array),HS,WS,IX,IY+1,Mode)
	end;
	
zeroY(Array,_,WS,_,WS,_) -> Array.

%------------------------------------------------- Join & Split Array for 4 nodes

split4(Array) ->
	S = tab2d:sizeH(Array),
	Step = trunc(S/4),
	D1 = tab2d:create(S,Step+1),
	D2 = tab2d:create(S,Step+2),
	D3 = tab2d:create(S,Step+2),
	D4 = tab2d:create(S,Step+1),
	split4(Array,S,Step,2*Step,3*Step,D1,D2,D3,D4).

split4(Array,S,St1,St2,St3,D1,D2,D3,D4) ->
	split4X(Array,S,St1,St2,St3,D1,D2,D3,D4,0).
	
split4X(Array,S,St1,St2,St3,D1,D2,D3,D4,IX) when IX < S ->
	Tmp1 = split4Y(Array,S,0,St1+1,D1,IX,0),
	Tmp2 = split4Y(Array,S,St1-1,St2+1,D2,IX,0),
	Tmp3 = split4Y(Array,S,St2-1,St3+1,D3,IX,0),
	Tmp4 = split4Y(Array,S,St3-1,S,D4,IX,0),
	split4X(Array,S,St1,St2,St3,Tmp1,Tmp2,Tmp3,Tmp4,IX+1);
	
split4X(_,S,_,_,_,D1,D2,D3,D4,S) -> {D1,D2,D3,D4}.
	
split4Y(Array,S,IY,K,D,IX,C) when IY < K ->
	El = tab2d:get(IX,IY,Array),
	Nowa = tab2d:set(IX,C,El,D),
	split4Y(Array,S,IY+1,K,Nowa,IX,C+1);

split4Y(_,_,K,K,D,_,_) -> D.	
	
	

    join4(A1,A2,A3,A4) ->
            HS = tab2d:sizeH(A1),
            New = tab2d:create(HS,HS),
            Step = trunc(HS/4),
            join4X(New,A1,A2,A3,A4,HS,Step,0).
           
    join4X(Dest,A1,A2,A3,A4,HS,Step,IX) when IX < HS ->
            W1 = join4Y(Dest,A1,0,IX,0,Step+1),
            W2 = join4Y(W1,A2,Step,IX,1,Step+1),
            W3 = join4Y(W2,A3,2*Step,IX,1,Step+1),
            W4 = join4Y(W3,A4,3*Step,IX,1,Step+1),
            join4X(W4,A1,A2,A3,A4,HS,Step,IX+1);
     
    join4X(Dest,_,_,_,_,HS,_,HS) -> Dest.
                   
    join4Y(Dest,Src,Pocz,IX,IY,WS) when IY < WS ->
            El = tab2d:get(IX,IY,Src),
            Nowa = tab2d:set(IX,Pocz,El,Dest),
            join4Y(Nowa,Src,Pocz+1,IX,IY+1,WS);
     
    join4Y(Dest,_,_,_,WS,WS) -> Dest.



%----------------------------------------------------- Join & Split for 8 nodes

	

    split8(Array) ->
            S = tab2d:sizeH(Array),
            Step = trunc(S/8),
            D1 = tab2d:create(S,Step+1),
            D2 = tab2d:create(S,Step+2),
            D3 = tab2d:create(S,Step+2),
            D4 = tab2d:create(S,Step+2),
            D5 = tab2d:create(S,Step+2),
            D6 = tab2d:create(S,Step+2),
            D7 = tab2d:create(S,Step+2),
            D8 = tab2d:create(S,Step+1),
           
            split8(Array,S,Step,2*Step,3*Step,4*Step,5*Step,6*Step,7*Step,D1,D2,D3,D4,D5,D6,D7,D8).
     
    split8(Array,S,St1,St2,St3,St4,St5,St6,St7,D1,D2,D3,D4,D5,D6,D7,D8) ->
            split8X(Array,S,St1,St2,St3,St4,St5,St6,St7,D1,D2,D3,D4,D5,D6,D7,D8,0).
           
    split8X(Array,S,St1,St2,St3,St4,St5,St6,St7,D1,D2,D3,D4,D5,D6,D7,D8,IX) when IX < S ->
            Tmp1 = split8Y(Array,S,0,St1+1,D1,IX,0),
            Tmp2 = split8Y(Array,S,St1-1,St2+1,D2,IX,0),
            Tmp3 = split8Y(Array,S,St2-1,St3+1,D3,IX,0),
            Tmp4 = split8Y(Array,S,St3-1,St4+1,D4,IX,0),
            Tmp5 = split8Y(Array,S,St4-1,St5+1,D5,IX,0),
            Tmp6 = split8Y(Array,S,St5-1,St6+1,D6,IX,0),
            Tmp7 = split8Y(Array,S,St6-1,St7+1,D7,IX,0),
            Tmp8 = split8Y(Array,S,St7-1,S,D8,IX,0),
            split8X(Array,S,St1,St2,St3,St4,St5,St6,St7,Tmp1,Tmp2,Tmp3,Tmp4,Tmp5,Tmp6,Tmp7,Tmp8,IX+1);
           
    split8X(_,S,_,_,_,_,_,_,_,D1,D2,D3,D4,D5,D6,D7,D8,S) -> {D1,D2,D3,D4,D5,D6,D7,D8}.
           
    split8Y(Array,S,IY,K,D,IX,C) when IY < K ->
            El = tab2d:get(IX,IY,Array),
            Nowa = tab2d:set(IX,C,El,D),
            split8Y(Array,S,IY+1,K,Nowa,IX,C+1);
     
    split8Y(_,_,K,K,D,_,_) -> D.
     
    join8(A1,A2,A3,A4,A5,A6,A7,A8) ->
            HS = tab2d:sizeH(A1),
            New = tab2d:create(HS,HS),
            Step = trunc(HS/8),
            join8X(New,A1,A2,A3,A4,A5,A6,A7,A8,HS,Step,0).
           
    join8X(Dest,A1,A2,A3,A4,A5,A6,A7,A8,HS,Step,IX) when IX < HS ->
            W1 = join8Y(Dest,A1,0,IX,0,Step+1),
            W2 = join8Y(W1,A2,Step,IX,1,Step+1),
            W3 = join8Y(W2,A3,2*Step,IX,1,Step+1),
            W4 = join8Y(W3,A4,3*Step,IX,1,Step+1),
            W5 = join8Y(W4,A5,4*Step,IX,1,Step+1),
            W6 = join8Y(W5,A6,5*Step,IX,1,Step+1),
            W7 = join8Y(W6,A7,6*Step,IX,1,Step+1),
            W8 = join8Y(W7,A8,7*Step,IX,1,Step+1),
            join8X(W8,A1,A2,A3,A4,A5,A6,A7,A8,HS,Step,IX+1);
     
    join8X(Dest,_,_,_,_,_,_,_,_,HS,_,HS) -> Dest.
                   
    join8Y(Dest,Src,Pocz,IX,IY,WS) when IY < WS ->
            El = tab2d:get(IX,IY,Src),
            Nowa = tab2d:set(IX,Pocz,El,Dest),
            join8Y(Nowa,Src,Pocz+1,IX,IY+1,WS);
     
    join8Y(Dest,_,_,_,WS,WS) -> Dest.




	
%----------------------------------------------------- Still,Oscilators,Spaceships

%3x3
putGlider(Array,IX,IY) ->
	tab2d:set(IX+2,IY+1,1,tab2d:set(IX+1,IY+2,1,tab2d:set(IX+1,IY+1,1,tab2d:set(IX,IY+2,1,tab2d:set(IX,IY,1,Array))))).
%4x5	
putLWSS(Array,IX,IY) ->
	tab2d:set(IX+3,IY+3,1,tab2d:set(IX+3,IY+2,1,tab2d:set(IX+3,IY+1,1,tab2d:set(IX+3,IY,1,tab2d:set(IX+2,IY+4,1,tab2d:set(IX+2,IY,1,tab2d:set(IX+1,IY,1,tab2d:set(IX,IY+4,1,tab2d:set(IX,IY+1,1,Array))))))))).

%2x2	
putBlock(Array,IX,IY) ->
	tab2d:set(IX+1,IY+1,1,tab2d:set(IX+1,IY,1,tab2d:set(IX,IY+1,1,tab2d:set(IX,IY,1,Array)))).

%3x3	
putBoat(Array,IX,IY) ->
	tab2d:set(IX+2,IY+1,1,tab2d:set(IX+1,IY+2,1,tab2d:set(IX+1,IY,1,tab2d:set(IX,IY+1,1,tab2d:set(IX,IY,1,Array))))).

%3x3	
putBlinker(Array,IX,IY) ->
	tab2d:set(IX,IY+2,1,tab2d:set(IX,IY+1,1,tab2d:set(IX,IY,1,Array))).
	
%4x4	
putFrog(Array,IX,IY) ->
	tab2d:set(IX+3,IY+1,1,tab2d:set(IX+2,IY+1,1,tab2d:set(IX+1,IY+1,1,tab2d:set(IX+2,IY,1,tab2d:set(IX+1,IY,1,tab2d:set(IX,IY,1,Array)))))).
	
putWhatever(Array,IX,IY) ->
	N = randomize(100),
	if N =< 33 ->
		tab2d:set(IX,IY,1,Array);
	   true -> tab2d:set(IX,IY,0,Array)
	end.
	
%----------------------------------------------------Random Array

randomArr(S) -> tab2d:zeroArr(tab2d:create(num2Size(S),num2Size(S)),1).
	
patternArr(S) ->
	Size = num2Size(S),
	Array = tab2d:zeroArr(tab2d:create(Size,Size),0),
	L = round(Size/math:pow(2,2)),
	B = round(Size/math:sqrt(L)),
	putObjX(Array,Size,B,round(B/2),round(B/2)).
	
putObjX(Array,S,B,IX,IY) when IX < S ->
	putObjX(putObjY(Array,S,B,IX,IY),S,B,IX+B,IY);

putObjX(Array,S,_,IX,_) when IX >= S -> Array.
	
putObjY(Array,S,B,IX,IY) when IY < S ->
	putObjY(putObj(Array,IX,IY),S,B,IX,IY+B);
	
putObjY(Array,S,_,_,IY) when IY >= S -> Array.
	
putObj(Array,IX,IY) ->	
	C = randomize(6),
	case C of
		1 -> putGlider(Array,IX,IY);
		2 -> putLWSS(Array,IX,IY);
		3 -> putBlock(Array,IX,IY);
		4 -> putBoat(Array,IX,IY);
		5 -> putBlinker(Array,IX,IY);
		6 -> putFrog(Array,IX,IY)
	end.
	
%----------------------------------------------Proper Random

randomize(X) ->
	{S1, S2, S3} = random:seed(),
	{V1, V2, V3} = now(),
	random:seed(V1+S1, V2+S2, V3+S3),
	random:uniform(X).
	
	
num2Size(N) -> trunc(math:pow(2,N)).
	

