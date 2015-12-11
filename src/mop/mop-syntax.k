require "domains.k"
require "../common/common-syntax.k"
require "advice-syntax.k"


module MOP-CCOMMON
	imports COMMON-CCOMMON
	imports ADVICE-CCOMMON


	//top level sort (aka CompilationUnit)
	syntax MOP ::= OptionalPackageDec ImportDecList SpecDec [prefer, klabel('MOP)]



    syntax SpecDec ::= SpecDecHead SpecBody
    syntax SpecDecHead ::= Id "(" Params ")"

    syntax SpecBody ::= "{"  DecBubbleList EventDecList  PropertyDecList "}"


	syntax EventDec ::= EventDecHead EventBody
	syntax EventDecHead ::= EventModifier "event" Id AdviceHeader
    syntax EventBody ::= BlockBubble
    syntax EventModifier ::= "creation" | None


syntax EventDecList          ::= List{EventDec, ""} [klabel('EventDecList)]

endmodule


module MOP-SYNTAX
    imports MOP-CCOMMON
    imports COMMON-SYNTAX
    imports ADVICE-SYNTAX
endmodule