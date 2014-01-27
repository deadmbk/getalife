-module(worker).
-import(tab2d,[]).
-compile(export_all).

main(NR) ->
	receive
		{From,T} ->
			W = iterate(T),
			From ! {NR,W}
	end.
		
iterate(T) -> 
	HS = tab2d:sizeH(T),
	WS = tab2d:sizeW(T),
	iterateX(T,T,HS-1,WS-1,1).

iterateX(T,TN,HS,WS,IX) when IX < HS ->
	iterateX(T,iterateY(T,TN,HS,WS,IX),HS,WS,IX+1);

iterateX(_,TN,HS,_,HS) -> TN.

iterateY(T,TN,HS,WS,IX) -> iterateY(T,TN,HS,WS,IX,1).

iterateY(T,TN,HS,WS,IX,IY) when IY < WS ->
	Sum = tab2d:get(IX-1,IY-1,T)+tab2d:get(IX-1,IY,T)+tab2d:get(IX-1,IY+1,T)+tab2d:get(IX,IY-1,T)+tab2d:get(IX,IY+1,T)+tab2d:get(IX+1,IY-1,T)+tab2d:get(IX+1,IY,T)+tab2d:get(IX+1,IY+1,T),
	Point = tab2d:get(IX,IY,T),

	W = if  (Point == 1) and ((Sum == 2) or (Sum == 3)) -> 1;
			(Point == 1) and ((Sum < 2) or (Sum > 3)) -> 0;
			(Point == 0) and (Sum == 3) -> 1;
			(Point == 0) and (Sum /= 3) -> 0
		end,
	iterateY(T,tab2d:set(IX,IY,W,TN),HS,WS,IX,IY+1);

iterateY(_,TN,_,WS,_,WS) -> TN.
