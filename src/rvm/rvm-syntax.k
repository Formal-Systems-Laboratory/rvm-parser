require "domains.k"
require "../common/common-syntax.k"


module RVM-SYNTAX
	imports COMMON-SYNTAX


	//top level sort (aka CompilationUnit)
	syntax RVM ::= OptionalPackageDec ImportDecList SpecDec  [prefer, klabel('RVM)]


    syntax SpecDec ::= SpecDecHead SpecBody
    syntax SpecDecHead ::= Id "(" Params ")"
    //syntax SpecBody ::= "{" SpecBodyDecList  "}"
    syntax SpecBody ::= "{"  DecBubbleList EventDecList  PropertyDecList "}"

    //syntax SpecBodyDec ::= EventDec | PropertyDec //causes parsing problems

	syntax EventDec ::= EventDecHead EventBody
	syntax EventDecHead ::= EventModifier "event" Id "(" Params ")"
    syntax EventBody ::= BlockBubble
    syntax EventModifier ::= "creation" | None


//syntax SpecBodyDecList          ::= List{SpecBodyDec, ""}
syntax EventDecList          ::= List{EventDec, ""}      [klabel('EventsDecList)]

endmodule
