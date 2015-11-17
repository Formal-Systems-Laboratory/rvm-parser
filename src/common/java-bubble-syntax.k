require "package-syntax.k"

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