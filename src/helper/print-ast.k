require "../rvm/rvm-syntax.k"
require "../c-monitor-code-template/c-monitor-template-syntax.k"
require "domains.k"

module PRINT-AST
    imports RVM-SYNTAX
    imports DOMAINS-SYNTAX
    imports C-MONITOR-TEMPLATE-SYNTAX

    //print package ast
    syntax String ::=  PackageDec2String(OptionalPackageDec) [function]
    rule PackageDec2String(package X:PackageName ;) => "package " +String PackageName2String(X)
                                                                  +String ";"
    rule PackageDec2String(None:OptionalPackageDec) => "\n"

    syntax String ::= PackageName2String(PackageName) [function]
    rule PackageName2String(X:Id) => Id2String(X)
    rule PackageName2String(P:PackageName . X:Id) => PackageName2String(P) +String "." +String Id2String(X)

    //get logic name
    syntax LogicName ::= getLogicName(PropertyDec) [function]
    rule getLogicName(LN:LogicName : F:LogicFormula HDL:HandlerDecList) => LN

    //get formula
    syntax LogicFormula ::= getFormula(PropertyDec) [function]
    rule getFormula(LN:LogicName : F:LogicFormula HDL:HandlerDecList) => F

    //get handlers of the given property
    syntax HandlerDecList ::= getHandlers(PropertyDec) [function]
    rule getHandlers(LN:LogicName : F:LogicFormula HDL:HandlerDecList) => HDL

    //get event name in string
    syntax String ::= getEventName(EventName) [function]
    rule getEventName(E:Id) => Id2String(E)

    //get state name from an item
    syntax String ::= getStateName(Item) [function]
    syntax String ::= printStateName(StateName) [function]

    syntax TransitionList ::= getTransitionList(Item) [function]

    rule getStateName(SN:StateName[TL:TransitionList]) => printStateName(SN)
    rule printStateName(SN:Id) => Id2String(SN)

    rule getTransitionList(SN:StateName[TL:TransitionList]) => TL

syntax Int ::= sizeOf(PropertyDecList) [function]
rule sizeOf(.PropertyDecList) => 0
rule sizeOf(Prop:PropertyDec Props:PropertyDecList) => 1 +Int sizeOf(Props)

//given the number of properties and events, generate a list of state transition functions,
//indexed by property rank and event rank
//the first two args are the current prop rank and event rank, the third and fourth args are the
//total number of properties and events resp.
syntax StateTransitions ::= getListofStateFuncs(Int, Int, Int, Int) [function]
rule getListofStateFuncs(I:Int, J:Int, PN:Int, EN:Int) => $emptyTransition
when I >=Int PN

rule getListofStateFuncs(I:Int, J:Int, PN:Int, EN:Int) => getListofStateFuncs(I +Int 1, 0, PN, EN)
when I <Int PN andBool J >=Int EN

rule getListofStateFuncs(I:Int, J:Int, PN:Int, EN:Int) =>
($sFunc(I, J):StateFunc , getListofStateFuncs(I, J +Int 1, PN, EN))
when I <Int PN andBool J <Int EN

/**
* Print the method parameters.
*/
syntax String ::= Params2Str(Params) [function]
syntax String ::= Param2Str(Param) [function]
syntax String ::= Type2Str(Type) [function]
syntax String ::= VarDecId2Str(VarDecId) [function]

rule Params2Str(.Params) => ""
rule Params2Str(P:Param) => Param2Str(P)
rule Params2Str(P:Param, .Params) => Param2Str(P)
rule Params2Str(P:Param, Ps:Params) => Param2Str(P) +String ", " +String Params2Str(Ps)

rule Param2Str(T:Type V:VarDecId) => Type2Str(T) +String " " +String VarDecId2Str(V)

//Type ::= TypeName | ArrayType
syntax String ::= TypeName2String(TypeName) [function]
syntax String ::= ArrayType2String(ArrayType) [function]

rule Type2Str(T:TypeName) => TypeName2String(T)
rule Type2Str(AT:ArrayType) => ArrayType2String(AT)

rule TypeName2String(X:Id) => Id2String(X)
rule TypeName2String(T:TypeName . X:Id) => TypeName2String(T) +String "." +String Id2String(X)

rule ArrayType2String(T:Type []) => Type2Str(T) +String "[]"

//VarDecId ::= Id Dims
syntax String ::= Dims2Str(Dims)
rule VarDecId2Str(X:Id) => Id2String(X)
rule VarDecId2Str(X:Id Ds:Dims) => Id2String(X) +String Dims2Str(Ds)
rule Dims2Str(D:Dim) => "[]"
rule Dims2Str(D:Dim Ds:Dims) => "[]" +String Dims2Str(Ds)

/**
Print the method body.
*/
syntax String ::= Block2Str(BlockBubble)
[function, hook(STRING.token2string), klabel(Block2StringFunc)]

/**Get the state name from a handler dec head.*/
syntax String ::= getStateNameOf(LogicState) [function]
rule getStateNameOf(fail) => "fail"
rule getStateNameOf(X:Id) => Id2String(X)

/*Get the string of handler code*/
syntax String ::= getHandlerCodeStr(HandlerBody) [function]
rule getHandlerCodeStr(BB:BlockBubble) => Block2Str(BB)

/*Print the Decl list as string*/
syntax String ::= declBubbleList2String(DecBubbleList) [function, hook(STRING.token2string)]

endmodule