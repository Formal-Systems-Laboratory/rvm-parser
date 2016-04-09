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
endmodule


