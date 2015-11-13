
require "java/java-syntax.k"

require "logic/ere-syntax.k"

module RVM-SYNTAX
        imports JAVA-SYNTAX

        imports ERE-SYNTAX

        syntax CompilationUnit ::= OptionalPackageDec ImportDecList SpecDec  [klabel('CompilationUnit)]

        syntax SpecDec ::= SpecDecHead SpecBody

        syntax SpecDecHead ::= Id OptionalParams


        syntax OptionalParams                ::= Params                 [prefer, klabel('Some)] | None

        syntax SpecBody ::= "{" SpecBodyDecList  "}"

        syntax SpecBodyDec ::= EventDec | PropertyDec

        syntax EventDec ::= EventDecHead EventBody                           [klabel('EventDec)]

        syntax EventBody ::= Block                                       [klabel('EventBody)]

        syntax EventDecHead ::= "event" Id "(" Params ")"

        syntax PropertyDec ::= Property HandlerDecList

        syntax Property ::= LogicName ":" LogicFormula

        syntax HandlerDec ::= HandlerDecHead HandlerBody

        syntax HandlerDecHead ::= "@" LogicState

        syntax HandlerBody ::= Block



syntax SpecBodyDecList          ::= List{SpecBodyDec, ""}
syntax HandlerDecList          ::= List{HandlerDec, ""}

endmodule