require "mop-syntax.k"
require "domains.k"

module MOP-COMPILER-SYNTAX
    imports MOP-SYNTAX
    syntax NoBracket ::= r"[^<{}][^{}]*" [token, klabel('NoBracket)]
    syntax ParamsBubble ::= r"\\([^\\)]*\\)" [token, avoid, klabel('ParamsBubble)]
    syntax VarInitBubble ::=  r"[^<;][^;]*" [token, avoid, klabel('VarInitBubble)]
    syntax NoParentheses ::= r"[^()<][^()]*" [token, klabel('NoParentheses)]
endmodule

module MOP-COMPILER
    imports MOP-SYNTAX
    imports DOMAINS
    configuration <T> <k> $PGM:MOP  </k> </T>

    rule <k> (Pac:OptionalPackageDec Imp:ImportDecList Spec:SpecDec) => (.)</k>
endmodule