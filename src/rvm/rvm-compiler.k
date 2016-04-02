require "rvm-syntax.k"
require "domains.k"
require "../helper/print-ast.k"


module RVM-COMPILER-SYNTAX
    imports RVM-SYNTAX
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





        syntax IdPattern ::=  //id  with * and .. wildcards (it can start with * but not with .. , same about end)
                   // r"(?<!([A-Za-z0-9\\_]|\\*))([A-Za-z\\_]|\\*)([A-Za-z0-9\\_]|(\\.\\.)|\\*|\\.)*([A-Za-z\\_]|\\*)"     [token]
                     r"(?<!([A-Za-z0-9\\_]|\\*))([A-Za-z\\_]|\\*)([A-Za-z0-9\\_]|(\\.\\.)|\\*)*([A-Za-z\\_]|\\*)"     [token,reject2("new"), klabel('IdPattern)]
                   | r"(?<!([A-Za-z0-9\\_]|\\*))([A-Za-z\\_]|\\*)" [token,klabel('IdPatternSingleChar)]

endmodule

module RVM-COMPILER
    imports RVM-SYNTAX
    imports PRINT-AST

    configuration <T> <k> $PGM:RVM  </k>
                        <package color="black"> "" </package>

                      <importList color="yellow"> .ImportDecList </importList>

                      <events color="pink"> .Map </events>

                      <states color="blue"> .Map </states>

                      <specName> "" </specName>
                      <specParams> .Params </specParams>
                      <decBubble> .DecBubbleList </decBubble>
                      <>
                       </T>

rule <k> X:OptionalPackageDec Y:ImportDecList Z:SpecDec => Z </k>
    <package> _ => toString(X) </package>
    <importList> _ => Y </importList>




endmodule
