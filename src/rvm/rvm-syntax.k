require "domains.k"
require "../common/type-syntax.k"
require "../logic/logic-syntax.k"


module PACKAGE-SYNTAX
	imports TYPE-SYNTAX

syntax ImportDec ::= "import" TypeName                  ";"  [klabel('TypeImportDec)]
                   | "import" PackageName       "." "*" ";"  [klabel('TypeImportOnDemandDec)]
                   | "import" "static" TypeName "." Id  ";"  [klabel('StaticImportDec)]
                   | "import" "static" TypeName "." "*" ";"  [klabel('StaticImportOnDemandDec)]

syntax PackageDec ::=  "package" PackageName ";"     [klabel('PackageDec)]
syntax OptionalPackageDec ::= PackageDec | None
syntax None ::= ""

syntax ImportDecList             ::= List{ImportDec,""}

endmodule


module JAVA-BUBBLE-SYNTAX
	imports PACKAGE-SYNTAX
	syntax NoBracket ::= r"[^{}]+" [token]
    syntax BalancedBracket ::=
                               "{" BalancedBracket "}"
                             | BalancedBracket BalancedBracket [left, klabel('BBracketCombination)]
                             | NoBracket
                             | "{" "}"

    syntax BlockBubble ::=    "{" BalancedBracket "}" [prefer, token]
                            | "{" "}" [prefer, token]

    syntax DecStart ::= Id | Id DecStart

	syntax ClassDecBubble ::= DecStart BlockBubble

	syntax ParamsBubble ::= r"\\([^\\)]*\\)" [token, avoid]

	syntax MethodDecBubble ::= DecStart ParamsBubble BlockBubble

	syntax FieldDecBubble ::= Id VarInitBubble ";"

	syntax VarInitBubble ::=  r"[^;]+" [token, avoid]

	syntax DecBubble ::=  ClassDecBubble [token]
	                    | MethodDecBubble [token]
	                    | FieldDecBubble [token]



endmodule


module RVM-SYNTAX
	imports JAVA-BUBBLE-SYNTAX
	imports LOGIC-SYNTAX
	imports PACKAGE-SYNTAX


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
