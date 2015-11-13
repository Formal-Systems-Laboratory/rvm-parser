require "domains.k"
require "logic/ere-syntax.k"
require "logic/ltl-syntax.k"
//require "logic/fsm-syntax.k"


module PACKAGE-SYNTAX
	imports DOMAINS-SYNTAX
syntax PackageName ::= IdList                           [klabel('PackageName)]
syntax PackageOrTypeName ::= Id                         [klabel('PackageOrTypeName)]
                           | PackageOrTypeName "." Id   [strict(1), klabel('PackageOrTypeName)]
syntax TypeName ::= Id                                  [klabel('TypeName)]
                  | PackageOrTypeName "." Id            [strict(1), klabel('TypeName)]


syntax ImportDec ::= "import" TypeName                  ";"  [klabel('TypeImportDec)]
                   | "import" PackageName       "." "*" ";"  [klabel('TypeImportOnDemandDec)]
                   | "import" "static" TypeName "." Id  ";"  [klabel('StaticImportDec)]
                   | "import" "static" TypeName "." "*" ";"  [klabel('StaticImportOnDemandDec)]

syntax PackageDec ::=  "package" PackageName ";"     [klabel('PackageDec)]
syntax OptionalPackageDec ::= PackageDec | None
syntax None ::= ""

syntax ImportDecList             ::= List{ImportDec,""}
syntax IdList                    ::= List{Id,"."}
endmodule


module JAVA-BUBBLE-SYNTAX
	imports DOMAINS-SYNTAX
	imports PACKAGE-SYNTAX
	syntax NoBracket ::= r"[^{}]+" [token]
    syntax BalancedBracket ::=
                               "{" BalancedBracket "}"
                             | BalancedBracket BalancedBracket [left, klabel('BBracketCombination)]
                             | NoBracket
                             | "{" "}"

    syntax BlockBubble ::=    "{" BalancedBracket "}" [prefer, token]
                            | "{" "}" [prefer, token]
	syntax Param ::= TypeName Id
	syntax Params                    ::= List{Param, ","}                [klabel('FormalParamList)]

    syntax DecStart ::= Id | Id DecStart

	syntax ClassDecBubble ::= DecStart BlockBubble

	syntax ParamsBubble ::= r"\\([^\\)]*\\)" [token, avoid]

	syntax MethodDecBubble ::= DecStart ParamsBubble BlockBubble

	syntax FieldDecBubble ::= Id VarInitBubble ";"

	syntax VarInitBubble ::=  r"[^;]+" [token, avoid]

	syntax DecBubble ::=  ClassDecBubble [token]
	                    | MethodDecBubble [token]
	                    | FieldDecBubble [token]


    context 'FormalParamList(HOLE,,_) [result(Param)]
    context 'FormalParamList(_,,HOLE) [result(Params)]
endmodule


module RVM-SYNTAX
	imports JAVA-BUBBLE-SYNTAX
	imports ERE-SYNTAX
	imports LTL-SYNTAX
	//imports FSM-SYNTAX
	imports PACKAGE-SYNTAX


	//top level sort (aka CompilationUnit)
	syntax RVM ::= OptionalPackageDec ImportDecList SpecDec


    syntax SpecDec ::= SpecDecHead SpecBody
    syntax SpecDecHead ::= Id "(" Params ")"
    //syntax SpecBody ::= "{" SpecBodyDecList  "}"
    syntax SpecBody ::= "{"  DecBubbleList EventDecList  PropertyDecList "}"

    //syntax SpecBodyDec ::= EventDec | PropertyDec //causes parsing problems in ere-syntax!

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
