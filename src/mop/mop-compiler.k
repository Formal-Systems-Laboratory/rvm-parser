require "mop-syntax.k"
require "domains.k"

module MOP-COMPILER-SYNTAX
    imports MOP-SYNTAX
    imports DOMAINS-SYNTAX

    syntax NoBracket ::= r"[^<{}][^{}]*" [token, klabel('NoBracket)]
    syntax ParamsBubble ::= r"\\([^\\)]*\\)" [token, avoid, klabel('ParamsBubble)]
    syntax VarInitBubble ::=  r"[^<;][^;]*" [token, avoid, klabel('VarInitBubble)]
    syntax NoParentheses ::= r"[^()<][^()]*" [token, klabel('NoParentheses)]

    syntax BoolExpBubble ::= BalancedParentheses [token, klabel('BoolExpBubble)] //TODO:removed prefer (for MOP production), check amb

    syntax DecBubbleList          ::= List{DecBubble, ""} [token, klabel('DecBubbleList)]

    syntax DecBubble ::=  ClassDecBubble [token, klabel('DecBubbleClass)]
                            | MethodDecBubble [token, klabel('DecBubbleMethod)]
                            | FieldDecBubble [token, klabel('DecBubbleField)]

    syntax BlockBubble ::= "{" BalancedBracket "}" [prefer, token, klabel('BlockBubble)]
                             | "{" "}" [prefer, token, klabel('BlockBubbleEmpty)]
endmodule

module MOP-COMPILER
    imports MOP-SYNTAX

    configuration <T> <k> $PGM:MOP  </k> </T>
    rule <k> ... `Spec:SpecDec => .K` ...</k>
endmodule