module UTIL

/*This function takes an int -> int map as input, sort it via keys and return the values as a list*
* If an event does not map a given state to any normal state, then it maps to error state,
and the error state is by default having rank 'size' of the number of normal states*/
/*The int represents the number of the states*/
syntax List ::= toIntArray(Map, Int) [function]
rule toIntArray(M:Map, I:Int) => toIntArray(M, 0, I)

/*The second int is the index of the current state, the third is the number of states.*/
syntax List ::= toIntArray(Map, Int, Int) [function]

rule toIntArray(M:Map, Cur:Int, Siz:Int) => ListItem(Siz) when Cur ==Int Siz

rule toIntArray(M:Map, I:Int, Siz:Int) =>
        ListItem(M[I]) toIntArray(M, I +Int 1, Siz)
        when I <Int Siz andBool (I in keys(M))

//if the input state is not mapped to any state by the map, then map it to the error state,
//which has the index equal to the total number of states.
rule toIntArray(M:Map, I:Int, Siz:Int) =>
        ListItem(Siz) toIntArray(M, I +Int 1, Siz)
        when I <Int Siz andBool notBool(I in keys(M))


/*Return the corresponding key from a string-to-int map for a given int value*/
syntax String ::= getStrKey(Map, Int) [function]

rule getStrKey((S:String |-> V:Int) M:Map, V) => S

rule getStrKey((_:String |-> V1:Int) M:Map, V2:Int) => getStrKey(M, V2)
when V1 =/=Int V2

/*Get the size of a list of maps*/
syntax Int ::= getSize(List, Int) [function]
rule getSize(.List, I:Int) => 0
rule getSize(ListItem(M:Map), 0) => size(M)
rule getSize(ListItem(M:Map), I:Int) => 0 when I =/=Int 0

rule getSize(ListItem(M:Map) L:List, 0) => size(M)
rule getSize(ListItem(M:Map) L:List, I:Int) => getSize(L, I -Int 1) when I >Int 0
rule getSize(ListItem(M:Map) L:List, I:Int) => 0 when I <Int 0

/*test whether the given item is the last item of the list*/
syntax Bool ::= isLastItem(List, Id) [function]
rule isLastItem(.List, T:Id) => false
rule isLastItem(ListItem(X:String), Y:Id) => X ==String Id2String(Y)
rule isLastItem(ListItem(X:String) L:List, Y:Id) => isLastItem(L, Y)

//get the no. i map in the map list
syntax Map ::= getMapI(List, Int) [function]
rule getMapI(.List, I:Int) => .Map
rule getMapI(ListItem(M:Map), 0) => M
rule getMapI(ListItem(M:Map), I:Int) => .Map when I =/=Int 0

rule getMapI(ListItem(M:Map) L:List, 0) => M
rule getMapI(ListItem(M:Map) L:List, I:Int) => .Map when I <Int 0
rule getMapI(ListItem(M:Map) L:List, I:Int) =>
     getMapI(L, I -Int 1) when I >Int 0

//get the no. i id name in a string list
syntax String ::= getStringI(List, Int) [function]
rule getStringI(.List, I:Int) => ""
rule getStringI(ListItem(X:String), 0) => X
rule getStringI(ListItem(X:String), I:Int) => "" when I =/=Int 0

rule getStringI(ListItem(X:String) L:List, 0) => X
rule getStringI(ListItem(X:String) L:List, I:Int) => "" when I <Int 0
rule getStringI(ListItem(X:String) L:List, I:Int) =>
     getStringI(L, I -Int 1) when I >Int 0


endmodule


