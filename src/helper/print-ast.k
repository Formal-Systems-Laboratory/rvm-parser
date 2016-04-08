require "../rvm/rvm-syntax.k"
require "domains.k"

module PRINT-AST
    imports RVM-SYNTAX
    imports DOMAINS-SYNTAX

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

endmodule