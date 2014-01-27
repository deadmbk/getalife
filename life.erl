    -module(life).
    -import(file_io,[]).
    -export([test_time/2, run/0, next/1, next/2]).
     
    run() ->
            compile:file(tab2d),
            compile:file(file_io),
            compile:file(worker),
            net_adm:world().
     
    odbieracz(T1,T2,I) when I /= 3 ->
            receive
                    {1,W1} ->
                            odbieracz(W1,T2,I+1);
                    {2,W2} ->
                            odbieracz(T1,W2,I+1)
            end;
           
    odbieracz(T1,T2,3) -> {T1,T2}.        
           
    odbieracz(T1,T2,T3,T4,I) when I /= 5 ->
            receive
                    {1,W1} ->
                            odbieracz(W1,T2,T3,T4,I+1);
                    {2,W2} ->
                            odbieracz(T1,W2,T3,T4,I+1);
                    {3,W3} ->
                            odbieracz(T1,T2,W3,T4,I+1);
                    {4,W4} ->
                            odbieracz(T1,T2,T3,W4,I+1)
            end;
     
    odbieracz(T1,T2,T3,T4,5) -> {T1,T2,T3,T4}.
     
    odbieracz(T1,T2,T3,T4,T5,T6,T7,T8,I) when I /= 9 ->
            receive
                    {1,W1} ->
                            odbieracz(W1,T2,T3,T4,T5,T6,T7,T8,I+1);
                    {2,W2} ->
                            odbieracz(T1,W2,T3,T4,T5,T6,T7,T8,I+1);
                    {3,W3} ->
                            odbieracz(T1,T2,W3,T4,T5,T6,T7,T8,I+1);
                    {4,W4} ->
                            odbieracz(T1,T2,T3,W4,T5,T6,T7,T8,I+1);
                    {5,W5} ->
                            odbieracz(T1,T2,T3,T4,W5,T6,T7,T8,I+1);
                    {6,W6} ->
                            odbieracz(T1,T2,T3,T4,T5,W6,T7,T8,I+1);
                    {7,W7} ->
                            odbieracz(T1,T2,T3,T4,T5,T6,W7,T8,I+1);
                    {8,W8} ->
                            odbieracz(T1,T2,T3,T4,T5,T6,T7,W8,I+1)
            end;
     
    odbieracz(T1,T2,T3,T4,T5,T6,T7,T8,9) -> {T1,T2,T3,T4,T5,T6,T7,T8}.
     
    %----------------------------------------------next------------------
     
    dlugosc(T,Nodes,L) when L >= 8 ->
            start(T,Nodes,8);
     
    dlugosc(T,Nodes,L) when L >= 4 ->
            start(T,Nodes,4);
     
     
    dlugosc(T,Nodes,L) when L >= 2 ->
            start(T,Nodes,2);
     
    dlugosc(_,_,_L) ->
            {error}.
           
           
    start(T,Nodes,N) when N == 2 ->
            [H|TA] = Nodes,
            [H1|_] = TA,
           
            PID1 = spawn(H,worker,main,[1]),
            PID2 = spawn(H1,worker,main,[2]),
           
            {T1,T2} = tab2d:split2(T),
     
            PID1 ! {self(),T1},
            PID2 ! {self(),T2},
     
            {W1,W2} = odbieracz(T1,T2,1),
     
            tab2d:join2(W1,W2);
     
    start(T,Nodes,N) when N == 4 ->
            [H|TA] = Nodes,
            [H1|TA2] = TA,
            [H2|TA3] = TA2,
            [H3|_] = TA3,
            PID1 = spawn(H,worker,main,[1]),
            PID2 = spawn(H1,worker,main,[2]),
            PID3 = spawn(H2,worker,main,[3]),
            PID4 = spawn(H3,worker,main,[4]),
     
            {T1,T2,T3,T4} = tab2d:split4(T),
     
            PID1 ! {self(),T1},
            PID2 ! {self(),T2},
            PID3 ! {self(),T3},
            PID4 ! {self(),T4},
            {W1,W2,W3,W4} = odbieracz(T1,T2,T3,T4,1),
     
            tab2d:join4(W1,W2,W3,W4);
           
    start(T,Nodes,_N) ->
            [H|TA] = Nodes,
            [H1|TA2] = TA,
            [H2|TA3] = TA2,
            [H3|TA4] = TA3,
            [H4|TA5] = TA4,
            [H5|TA6] = TA5,
            [H6|TA7] = TA6,
            [H7|_] = TA7,
                   
            PID1 = spawn(H,worker,main,[1]),
            PID2 = spawn(H1,worker,main,[2]),
            PID3 = spawn(H2,worker,main,[3]),
            PID4 = spawn(H3,worker,main,[4]),
            PID5 = spawn(H4,worker,main,[5]),
            PID6 = spawn(H5,worker,main,[6]),
            PID7 = spawn(H6,worker,main,[7]),
            PID8 = spawn(H7,worker,main,[8]),
     
            {T1,T2,T3,T4,T5,T6,T7,T8} = tab2d:split8(T),
           
            PID1 ! {self(),T1},
            PID2 ! {self(),T2},
            PID3 ! {self(),T3},
            PID4 ! {self(),T4},
            PID5 ! {self(),T5},
            PID6 ! {self(),T6},
            PID7 ! {self(),T7},
            PID8 ! {self(),T8},
     
            {W1,W2,W3,W4,W5,W6,W7,W8} = odbieracz(T1,T2,T3,T4,T5,T6,T7,T8,1),
     
            tab2d:join8(W1,W2,W3,W4,W5,W6,W7,W8).
           
    next({T,NODES}) ->
            dlugosc(T,NODES,length(NODES)).
     
    next({T,NODES},IT) -> loopnext({T,NODES},IT,0).
     
    loopnext({T,NODES},IT,N) when N<IT ->
                loopnext({next({T,NODES}),NODES},IT,N+1);
     
    loopnext({T,_},IT,IT) -> T.
     
    %------------------------------------------------------ test time
     
    test_time(P,N) ->
            test_avg(life,next,P,N).
     
    test_avg(M, F, A, N) when N > 0 ->
        L = test_loop(M, F, A, N, []),
        Length = length(L),
        Min = lists:min(L),
        Max = lists:max(L),
        Med = lists:nth(round((Length / 2)), lists:sort(L)),
        Avg = round(lists:foldl(fun(X, Sum) -> X + Sum end, 0, L) / Length),
        io:format("Range: ~b - ~b mics~n"
              "Median: ~b mics~n"
              "Average: ~b mics~n",
              [Min, Max, Med, Avg]),
        Med.
     
    test_loop(_M, _F, _A, 0, List) ->
        List;
    test_loop(M, F, A, N, List) ->
        {T, Result} = timer:tc(M, F, [A]),
        {_,Nodes} = A,
        test_loop(M, F, {Result,Nodes}, N - 1, [T|List]).

