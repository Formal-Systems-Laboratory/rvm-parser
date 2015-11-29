require "package-syntax.k"

module JAVA-BUBBLE-SYNTAX
	imports PACKAGE-SYNTAX
	//syntax NoBracket ::= r"[^{}]+" [token]
	//temp workaround for https://github.com/kframework/k/issues/1863
	syntax NoBracket ::= r"[^<{}][^{}]*" [token, klabel('NoBracket)]
    syntax BalancedBracket ::=
                               "{" BalancedBracket "}"          [klabel('BBracketBlock)]
                             | BalancedBracket BalancedBracket  [left, klabel('BBracketCombination)]
                             | NoBracket                        [klabel('BBracketAtom)]
                             | "{" "}"                          [klabel('BBracketEmpty)]

    syntax BlockBubble ::=    "{" BalancedBracket "}" [prefer, token, klabel('BlockBubble)]
                            | "{" "}" [prefer, token, klabel('BlockBubbleEmpty)]

    syntax DecStart ::= IdModifier | IdModifier DecStart

    syntax IdModifier ::= Id | JavaModifier

	syntax ClassDecBubble ::= DecStart BlockBubble

	syntax ParamsBubble ::= r"\\([^\\)]*\\)" [token, avoid, klabel('ParamsBubble)]

	syntax MethodDecBubble ::= DecStart ParamsBubble BlockBubble

	syntax FieldDecBubble ::= Id VarInitBubble ";"

	//syntax VarInitBubble ::=  r"[^;]+" [token, avoid]
    //temp workaround for https://github.com/kframework/k/issues/1863
    syntax VarInitBubble ::=  r"[^<;][^;]*" [token, avoid, klabel('VarInitBubble)]

	syntax DecBubble ::=  ClassDecBubble [token, klabel('DecBubbleClass)]
	                    | MethodDecBubble [token, klabel('DecBubbleMethod)]
	                    | FieldDecBubble [token, klabel('DecBubbleField)]

	//syntax NoParentheses ::= r"[^()]+" [token]
	//temp workaround for https://github.com/kframework/k/issues/1863
	syntax NoParentheses ::= r"[^()<][^()]*" [token, klabel('NoParentheses)]

	syntax BalancedParentheses ::=
                                   "(" BalancedParentheses ")"
                                 | BalancedParentheses BalancedParentheses [left, klabel('BParenthesesCombination)]
                                 | NoParentheses
                                 | "(" ")"

    syntax BoolExpBubble ::= BalancedParentheses [token, klabel('BoolExpBubble)] //TODO:removed prefer (for MOP production), check amb

	syntax DecBubbleList          ::= List{DecBubble, ""} [token, klabel('DecBubbleList)]

	syntax JavaModifier ::= "abstract" | "final" | "interface" | "native" | "private" | "protected" | "public" | "static" | "strict" | "synchronized" | "transient" | "volatile"


endmodule