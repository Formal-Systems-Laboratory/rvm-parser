require "../logic/syntax/logic-syntax.k"
require "java-bubble-syntax.k"

module PROPERTY-SYNTAX
    imports LOGIC-SYNTAX
    imports JAVA-BUBBLE-SYNTAX
	syntax PropertyDec ::= Property HandlerDecList
	syntax Property ::= LogicName ":" LogicFormula

    syntax HandlerDec ::= HandlerDecHead HandlerBody
	syntax HandlerDecHead ::= "@" LogicState
	syntax HandlerBody ::= BlockBubble

	syntax HandlerDecList          ::= List{HandlerDec, ""}		[klabel('HandlerDecList)]
	syntax PropertyDecList          ::= List{PropertyDec, ""}	[klabel('PropertyDecList)]
endmodule