-module(file_io).
-export([readFile/1, write2file/3]).
-import(tab2d,[]).
	
readFile(FileName) ->
		{Fd,Size} = lifeRead(FileName),
		Length = trunc(math:pow(2,Size)),
		T = getData(Fd,tab2d:create(Length,Length),Length,Length*Length),
		file:close(Fd),
		T.
		
lifeRead(FileName) ->
		{ok,FD} = file:open(FileName,[read,compressed]),		
		case io:get_line(FD,"") of 
				eof -> io:format("~nKoniec~n",[]);
				{error,Reason} -> io:format("~s~n",[Reason]);
				Data -> {Int, _} = string:to_integer(string:substr(Data,1,string:len(Data)-1)), {FD,Int} 
		end.

readData(FD,Array,Cols,Rows,Len,Count) -> 
		case file:read(FD,1) of 
				{ok,Data} -> 
					case Data of
						"1" -> Arr = tab2d:set(Len-1-Rows,Len-1-Cols,1,Array), getData(FD,Arr,Len,Count-1); 
						"0" -> Arr = tab2d:set(Len-1-Rows,Len-1-Cols,0,Array), getData(FD,Arr,Len,Count-1);
						" " -> getData(FD,Array,Len,Count);
						"\n" -> getData(FD,Array,Len,Count)
					end;
				eof -> io:format("~nKoniec~n",[]);
				{error,Reason} -> io:format("~s~n",[Reason])
		end.

getData(_,Array,_,0) -> Array;

getData(FD,Array,Len,Count) ->
		Cols = (Count-1) rem Len,
		Rows = trunc((Count-1)/Len),
		readData(FD,Array,Cols,Rows,Len,Count).

    
write2file(FileName,Tab,Len) -> 
		{ok,Device} = file:open(FileName,[write, compressed]),
		writeOut(Device,Tab,Len),
		file:close(Device).

writeOut(Device,Array,Len) -> 
		io:format(Device,"~B~n",[Len]),
		writeX(Device,Array,tab2d:sizeH(Array),tab2d:sizeW(Array),0). 

writeX(Device,Array,HS,WS,IX) when IX < HS -> writeY(Device,Array,HS,WS,IX), 
					writeX(Device,Array,HS,WS,IX+1); 

writeX(_,_,HS,_,HS) -> io:format(""). 

writeY(Device,Array,HS,WS,IX) -> writeY(Device,Array,HS,WS,IX,0). 

writeY(Device,Array,HS,WS,IX,IY) when IY < WS -> 
		io:format(Device,"~B",[tab2d:get(IX,IY,Array)]),
		writeY(Device,Array,HS,WS,IX,IY+1);
		
writeY(Device,_,_,WS,_,WS) -> io:format(Device,"~n",[]). 



		

