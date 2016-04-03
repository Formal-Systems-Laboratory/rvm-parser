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

    //print declaration ast
    syntax String ::= toString(DecBubbleList)  [function]
    rule toString(DB:DecBubbleList) => "foo dec bubble list" //TODO

    //print logic name
    syntax String ::= getLogicName(PropertyDec) [function]

    //print formula
    syntax String ::= getFormula(PropertyDec) [function]

    //print handlers of the given property
    syntax String ::= getHandlers(PropertyDec) [function]


endmodule