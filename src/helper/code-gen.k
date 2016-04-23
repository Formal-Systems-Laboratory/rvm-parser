require "../rvm/rvm-syntax.k"
require "domains.k"

module CODE-GEN
    imports RVM-SYNTAX
    imports DOMAINS-SYNTAX

syntax String ::= staticIntPrefix(String) [function]
rule staticIntPrefix(S:String) => "static int " +String S

syntax String ::= const(String) [function]
rule const(S:String) => "const " +String S

syntax String ::= propertyPrefix(Int) [function]
rule propertyPrefix(I:Int) => "Prop_" +String Int2String(I) +String "_"

//the code for resetting global state var i
syntax String ::= resetGlobalStateI(Int) [function]
rule resetGlobalStateI(I:Int) => propertyPrefix(I) +String "RVC_state = 0;\n"

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

///////////////////Get the code of state transition functions///////////////////////

/*Return the state transition function for Spec S, property X, event E*/
syntax String ::= propXEventE(String, Int, String) [function]
/*The version for spec which only has one property: the args are spec name s and event name e*/
syntax String ::= propXEventE(String, String) [function]

rule propXEventE(SpecName:String, X:Int, EventName:String) =>
    SpecName +String "_" +String propertyPrefix(X) +String EventName

rule propXEventE(SpecName:String, EventName:String) =>
    SpecName +String "_" +String EventName

syntax String ::= printIntArr(List) [function]
syntax String ::= addCurlyBraces(String) [function]
syntax String ::= printIntSeq(List) [function]

rule addCurlyBraces(S:String) => "{" +String S +String "}"

rule printIntSeq(.List) => ""
rule printIntSeq(ListItem(I:Int)) => Int2String(I)
rule printIntSeq(ListItem(I:Int) L:List) => Int2String(I) +String ", " +String printIntSeq(L)
rule printIntArr(L:List) => addCurlyBraces(printIntSeq(L))

syntax String ::= stateTransitionPropXEventE(String, Int, String, List) [function]
//only one property in the spec
syntax String ::= stateTransitionPropXEventE(String, String, List) [function]

rule stateTransitionPropXEventE(Spec:String, X:Int, Event:String, L:List)
 => const(staticIntPrefix(propXEventE(Spec, X, Event))) +String "[] = " +String
 printIntArr(L) +String ";"

rule stateTransitionPropXEventE(Spec:String, Event:String, L:List)
 => const(staticIntPrefix(propXEventE(Spec, Event))) +String "[] = " +String
 printIntArr(L) +String ";"

 
endmodule