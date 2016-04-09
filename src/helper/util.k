module UTIL

/*This function takes an int -> int map as input, sort it via keys and return the values as a list*
* If an event does not map a given state to any normal state, then it maps to error state,
and the error state is by default having rank 'size' of the number of normal states*/
syntax List ::= toIntArray(Map) [function]
/*The second int is the size of the current map, the third is the size of the original complete map.*/
syntax List ::= toIntArray(Map, Int, Int) [function]

rule toIntArray(.Map) => ListItem(0) //if no normal state, then there is only one error state.

rule toIntArray(M:Map) => toIntArray(M, size(M), size(M))

rule toIntArray(((Siz -Int I) |-> V:Int) M:Map, I:Int, Siz:Int) =>
        ListItem(V) toIntArray(M, I -Int 1, Siz)

endmodule