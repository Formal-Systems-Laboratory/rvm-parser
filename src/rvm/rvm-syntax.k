require "domains.k"
require "../common/common-syntax.k"
require "../logic/logic-syntax.k"


module RVM-SYNTAX
	imports COMMON-SYNTAX
	imports LOGIC-SYNTAX


	//top level sort (aka CompilationUnit)
	syntax RVM ::= OptionalPackageDec ImportDecList SpecDec


    syntax SpecDec ::= SpecDecHead SpecBody
    syntax SpecDecHead ::= Id "(" Params ")"
    //syntax SpecBody ::= "{" SpecBodyDecList  "}"
    syntax SpecBody ::= "{"  DecBubbleList EventDecList  PropertyDecList "}"

    //syntax SpecBodyDec ::= EventDec | PropertyDec //causes parsing problems

	syntax EventDec ::= EventDecHead EventBody
	syntax EventDecHead ::= EventModifier "event" Id "(" Params ")"
    syntax EventBody ::= BlockBubble
    syntax EventModifier ::= "creation" | None

	syntax PropertyDec ::= Property HandlerDecList
	syntax Property ::= LogicName ":" LogicFormula

    syntax HandlerDec ::= HandlerDecHead HandlerBody
	syntax HandlerDecHead ::= "@" LogicState
	syntax HandlerBody ::= BlockBubble

syntax DecBubbleList          ::= List{DecBubble, ""} [token]
//syntax SpecBodyDecList          ::= List{SpecBodyDec, ""}
syntax HandlerDecList          ::= List{HandlerDec, ""}
syntax EventDecList          ::= List{EventDec, ""}
syntax PropertyDecList          ::= List{PropertyDec, ""}
syntax None ::= ""

syntax Id ::= "size" | "in" [token, avoid]
endmodule
