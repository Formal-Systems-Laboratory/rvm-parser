require "../rvm/rvm-syntax.k"
require "../c-monitor-code-template/c-monitor-template-syntax.k"
require "domains.k"

module PRINT-AST
    imports RVM-SYNTAX
    imports DOMAINS-SYNTAX
    imports C-MONITOR-TEMPLATE-SYNTAX

    //print package ast
    syntax String ::=  toString(OptionalPackageDec) [function]
    rule toString(package X:PackageName ;) => "package " +String toString(X) +String ";"
    rule toString(None:OptionalPackageDec) => "\n"  [owise]

    syntax String ::= toString(PackageName) [function]
    rule toString(X:Id) => Id2String(X)
    rule toString(P:PackageName . X:Id) => toString(P) +String "." +String Id2String(X)

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
rule getListofStateFuncs(I:Int, J:Int, PN:Int, EN:Int) => .List
when I >=Int PN

rule getListofStateFuncs(I:Int, J:Int, PN:Int, EN:Int) => getListofStateFuncs(I +Int 1, 0, PN, EN)
when I <Int PN andBool J >=Int EN

rule getListofStateFuncs(I:Int, J:Int, PN:Int, EN:Int) =>
($sFunc(I, J):StateFunc , getListofStateFuncs(I, J +Int 1, PN, EN))
when I <Int PN andBool J <Int EN


endmodule