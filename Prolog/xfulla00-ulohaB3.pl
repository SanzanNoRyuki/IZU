/******************************************************************************
 * @project 1. domaca uloha z IZU (ulohaB3)
 * @file xfulla00-ulohaB3.pl
 *
 * @author Roman Fulla <xfulla00>
 * @date 06.04.2020
 ******************************************************************************/

/* Zisti, ci je zadana hodnota v zozname identifikatorov s najvyssou priemernou cenou */
ulohaB3(L, MAXIDT) :-
    maxlist(L, MaxList),
    member(MAXIDT, MaxList).

/* Vyberie identifikatory objektov s najvacsou priemernou cenou */
maxlist(List, Result) :-
    getmaxprice(List, MaxPrice),
    maxlist(List, List, MaxPrice, Result).
maxlist([], _, _, Result) :-
    Result = [].
maxlist(Iter, List, MaxPrice, Result) :-
    getfirst(Iter, I, _, Rest),
    averageprice(I, List, AvgPrice),
    pricecheck(Rest, List, MaxPrice, AvgPrice, I, Result).

/* Rozhodne co sa stane s vysledkom */
pricecheck(Iter, List, MaxPrice, AvgPrice, I, Result) :-
    MaxPrice =:= AvgPrice,
    maxlist(Iter, List, MaxPrice, OldResult),
    append(OldResult, [I], Result).
pricecheck(Iter, List, MaxPrice, AvgPrice, _, Result) :-
    MaxPrice > AvgPrice,
    maxlist(Iter, List, MaxPrice, Result).

/* Vypocita priemernu cenu k danemu identifikatoru */
averageprice(IDT, List, Result) :-
    averageprice(IDT, List, 0, 0, Result).
averageprice(_, [], Sum, Count, Result) :-
    Result is Sum / Count.
averageprice(IDT, List, Sum, Count, Result) :-
    getfirst(List, I, P, Rest),
    P > 0,
    averagecheck(I, P, IDT, Rest, Sum, Count, Result).

/* Rozhodne co sa stane s premennymi "Sum" a "Count" */
averagecheck(I, P, IDT, Iter, Sum, Count, Result) :-
    I =:= IDT,
    NewSum is Sum + P,
    NewCount is Count + 1,
    averageprice(IDT, Iter, NewSum, NewCount, Result).
averagecheck(I, _, IDT, Iter, Sum, Count, Result) :-
    I \= IDT,
    averageprice(IDT, Iter, Sum, Count, Result).

/* Ziska prvy prvok daneho zoznamu */
getfirst([obj(X, Y)|Z], I, P, Rest) :-
    I = X,
    P = Y,
    Rest = Z.

/* Ziska maximalnu priemernu cenu v zozname */
getmaxprice(List, Result) :-
    getmaxprice(List, List, Result).
getmaxprice([], _, Result) :-
    Result = 0.
getmaxprice(Iter, List, Result) :-
    getfirst(Iter, I, _, Rest),
    averageprice(I, List, AvgPrice),
    getmaxprice(Rest, List, MaxPrice),
    maxpricecheck(AvgPrice, MaxPrice, Result).

/* Rozhodne co sa stane s maximalnou cenou */
maxpricecheck(AvgPrice, MaxPrice, Result) :-
    MaxPrice < AvgPrice,
    Result = AvgPrice.
maxpricecheck(AvgPrice, MaxPrice, Result) :-
    MaxPrice >= AvgPrice,
    Result = MaxPrice.
