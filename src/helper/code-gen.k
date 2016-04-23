require "../rvm/rvm-syntax.k"
require "domains.k"

module CODE-GEN
    imports RVM-SYNTAX
    imports DOMAINS-SYNTAX

syntax String ::= staticIntPrefix(String) [function]
rule staticIntPrefix(S:String) => "static int " +String S

syntax String ::= const(String) [function]
rule const(S:String) => "const " +String S

syntax String ::= propPrefix(Int) [function]
rule propPrefix(I:Int) => "Prop_" +String Int2String(I) +String "_"

//the code for resetting global state var i
syntax String ::= resetGlobalStateI(Int) [function]
rule resetGlobalStateI(I:Int) => propPrefix(I) +String "RVC_state = 0;\n"

    syntax String ::= getGlobalStateVarInit(Int) [function]
    rule getGlobalStateVarInit(I:Int) => staticIntPrefix(resetGlobalStateI(I))

    /*Return the string of reset function, given the name of the specification,
    and the number of properties*/
    syntax String ::= printResetFunc(String, Int) [function]

    rule printResetFunc(SpecName:String, 0) => ""

    rule printResetFunc(SpecName:String, I:Int) => "void __RVC_" +String SpecName
     +String "_reset(void)\n" +String "{\n" +String resetGlobalStates(I) +String "}"
    when I =/=Int 0

    syntax String ::= resetGlobalStates(Int) [function]
    rule resetGlobalStates(I:Int) => "" when I <=Int 0
    rule resetGlobalStates(1) => resetGlobalStateI(0)
    rule resetGlobalStates(I:Int) => resetGlobalStates(I -Int 1) +String
                        resetGlobalStateI(I -Int 1) when I >Int 1

/*Return the state transition function for Spec S, property X, event E, given that
the spec does not have multiple properties*/
syntax String ::= propXEventE(String, Int, String) [function]
/*The version for spec without extra properties: spec name s and event name e*/
syntax String ::= propXEventE(String, String) [function]

syntax String ::= printIntArr(List) [function]
syntax String ::= stateTransitionPropXEventE(Int, String, String, List) [function]

//rule propXEventE(S:String, X:Int, E:String) =>


endmodule