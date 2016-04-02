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

    syntax KResult ::= "error"

    configuration <T> <k> $PGM:RVM  </k>
                        <package color="black"> "" </package>

                      <importList color="yellow"> .ImportDecList </importList>

                      <events color="pink"> .Map </events>
                      <eventNum> 0 </eventNum>

                      <states color="blue"> .Map </states>
                      <stateNum> 0 </stateNum>

                      <specName> "" </specName>
                      <specParams> .Params </specParams>
                      <decBubble> "" </decBubble>

                       </T>


/**
* Store the package info and import list.
*/
rule <k> X:OptionalPackageDec Y:ImportDecList Z:SpecDec => Z </k>
    <package> _ => toString(X) </package>
    <importList> _ => Y </importList>

/**
* Store the spec name and params.
*/
rule <k>X:Id (Ps:Params) SB:SpecBody => SB </k>
<specName> "" => Id2String(X) </specName>
<specParams> .Params => Ps </specParams>

/**
* Store the declarations info.
*/
rule <k> {(Decls:DecBubbleList => .K) Events:EventDecList  Props:PropertyDecList} </k>
    <decBubble> "" => toString(Decls) </decBubble>

/**
* Extract and store the first event in the event list if we haven't encountered it before.
*/
rule <k> {.K ((EM:EventModifier event (X:Id) (Ps:Params) Body:BlockBubble)
 Events:EventDecList => Events) Props:PropertyDecList} </k>
<events> (.Map => (X |-> I)) Cur:Map  </events>
<eventNum> I:Int => I +Int 1 </eventNum>
when notBool (X in keys(Cur))

/**
* Report error if an event is defined multiple times.
*/
//rule <k> ({(.K) EM:EventModifier event X:Id (Ps:Params) B:Body
//ED:EventDecList PD:PropertyDecList}) => .K </k>
//<events> Cur:Map  </events>
//when X in keys(Cur)

//No events left?

endmodule
