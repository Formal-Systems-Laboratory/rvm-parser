require "../rvm/rvm-syntax.k"
require "domains.k"

module CODE-GEN
    imports RVM-SYNTAX
    imports DOMAINS-SYNTAX

syntax String ::= staticIntPrefix(String) [function]
rule staticIntPrefix(Str:String) => "static int " +String Str

syntax String ::= constPrefix(String) [function]
rule constPrefix(Str:String) => "const " +String Str

syntax String ::= propertyPrefix(Int) [function]
rule propertyPrefix(I:Int) => "Prop_" +String Int2String(I) +String "_"

syntax String ::= globalStateVarI(Int) [function]
rule globalStateVarI(I:Int) => propertyPrefix(I) +String "RVC_state"

//the code for resetting global state var i
syntax String ::= resetGlobalStateI(Int) [function]
rule resetGlobalStateI(I:Int) => globalStateVarI(I) +String " = 0;\n"

    syntax String ::= getGlobalStateVarInit(Int) [function]
    rule getGlobalStateVarInit(I:Int) => staticIntPrefix(resetGlobalStateI(I))

    /*Return the string of reset function, given the name of the specification,
    and the number of properties*/
    syntax String ::= printResetFunc(String, Int) [function]
    syntax String ::= printResetFuncHeader(String, Int) [function]

rule printResetFuncHeader(SpecName:String, I:Int) => "void __RVC_" +String SpecName
     +String "_reset(void)"

    rule printResetFunc(SpecName:String, 0) => ""

    rule printResetFunc(SpecName:String, I:Int) => printResetFuncHeader(SpecName, I)
     +String "\n{\n" +String resetGlobalStates(I) +String "}\n"
    when I =/=Int 0

    syntax String ::= resetGlobalStates(Int) [function]
    rule resetGlobalStates(I:Int) => "" when I <=Int 0
    rule resetGlobalStates(1) => resetGlobalStateI(0)
    rule resetGlobalStates(I:Int) => resetGlobalStates(I -Int 1) +String
                        resetGlobalStateI(I -Int 1) when I >Int 1

////////////////////////////////////////////////////////////////////////////////////
///////////////The code for local state var initialization
//the three args are spec name, property rank and state name
syntax String ::= localStateVarI(String, Int, String)  [function]
rule localStateVarI(SpecName:String, P:Int, StateName:String) =>
    SpecName +String "_" +String propertyPrefix(P) +String StateName

syntax String ::= localStateVarInit(String, Int, String)  [function]
rule localStateVarInit(SpecName:String, P:Int, StateName:String) =>
    ("int " +String localStateVarI(SpecName:String, P:Int, StateName:String)
    +String " = 0;")
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

rule addCurlyBraces(Str:String) => ("{" +String Str +String "}")

rule printIntSeq(.List) => ""
rule printIntSeq(ListItem(I:Int)) => Int2String(I)
rule printIntSeq(ListItem(I:Int) ListItem(J:Int)) =>
    Int2String(I) +String ", " +String Int2String(J)
rule printIntSeq(ListItem(I:Int) ListItem(J:Int) L:List) =>
Int2String(I) +String ", " +String Int2String(J) +String ", " +String printIntSeq(L)

rule printIntArr(L:List) => addCurlyBraces(printIntSeq(L))

//args are spec name, property rank, event name and transition function array
syntax String ::= stateTransitionPropXEventE(String, Int, String, List) [function]
//only one property in the spec
syntax String ::= stateTransitionPropXEventE(String, String, List) [function]

rule stateTransitionPropXEventE(Spec:String, X:Int, Event:String, L:List)
 => (constPrefix(staticIntPrefix(propXEventE(Spec, X, Event)))
 +String "[]= " +String printIntArr(L) +String ";")

rule stateTransitionPropXEventE(Spec:String, Event:String, L:List)
 => (constPrefix(staticIntPrefix(propXEventE(Spec, Event))) +String "[] = "
 +String printIntArr(L) +String ";")

////////////print method header given the spec name, event name and args
syntax String ::= printMethodHeader(String, String, String) [function]
rule printMethodHeader(SpecName:String, EventName:String, Args:String)
 => "void __RVC_" +String SpecName +String "_" +String
 EventName +String "(" +String Args +String ")"

////////////the two args are global state var name and transition function name
syntax String ::= globalStateUpdate(String, String) [function]
rule globalStateUpdate(GSV:String, TF:String) =>
    GSV +String " = " +String TF +String "[" +String GSV +String "];"

/////////////the three args are local state var, global state var, state rank
syntax String ::= localStateUpdate(String, String, Int) [function]
rule localStateUpdate(LSV:String, GSV:String, SR:Int) =>
    LSV +String " = " +String GSV +String " == " +String Int2String(SR)

////////////////////////////////////////////////////////////////////////////////
//generate the event handler code
//the complete code will be generated by structural induction.
//given the <handlersList>, in the form of a map of (string |-> string)
//return the map of state name to handler code string
syntax List ::= getHandlerCode(Map) [function]

//handling map
rule getHandlerCode(.Map) => .List

rule getHandlerCode(K:String |-> V:String) => ListItem("if (" +String K +String ") {\n"
    +String V +String "\n}")

rule getHandlerCode((K:String |-> V:String) M:Map) =>
ListItem("if (" +String K +String "){\n" +String V +String "\n}")
getHandlerCode(M)

//wrap the given content with the C's header file's template
//two args are: 1) main part of the header file, 2) spec name
//the wrapper code will be generated based on the spec name
syntax String ::= addCTemplate(String, String)  [function]
rule addCTemplate(Content:String, SpecName:String)
 => "#ifndef __RVC_" +String SpecName +String "_MONITOR_H\n"
 +String "#define __RVC_" +String SpecName +String "_MONITOR_H\n\n"
+String Content +String "\n\n#endif"

endmodule