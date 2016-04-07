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

    syntax DecBubbleList          ::= List{DecBubble, ""} [token, klabel(DecBubbleListCons)]

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

                      <importList color="yellow"> .K </importList>

                      <events color="pink"> .Map </events>
                      <eventNum> 0 </eventNum>

                      <specName> "" </specName>
                      <specParams> .Params </specParams>
                      <decBubble> .K </decBubble>

                      <propNum> 0 </propNum>
                      <logicType> .K </logicType>
                      <formula> .K </formula>
                      <handlers> .HandlerDecList </handlers>

                      <runPlugin> false </runPlugin>

                      <err> .List </err>
                       </T>


/**
* Store the package info and import list.
*/
rule <k> X:OptionalPackageDec Y:ImportDecList Z:SpecDec => Z </k>
    <package> "" => toString(X) </package>
    <importList> .K => Y </importList>

/**
* Store the spec name and params.
*/
rule <k>X:Id (Ps:Params) SB:SpecBody => SB </k>
<specName> "" => Id2String(X) </specName>
<specParams> .Params => Ps </specParams>

/**
* Store the declarations info.
*/
rule <k> {(Decls:DecBubbleList => .K) Events:EventDecList
Props:PropertyDecList} </k>
    <decBubble> .K => Decls </decBubble>

//rule <k> {(Decl:DecBubble Decls:DecBubbleList => Decls) Events:EventDecList
//Props:PropertyDecList} </k>



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
* In case of error, the execution will be terminated and the error info
* will be stored in <err> cell.
*/
rule <k> {.K ((EM:EventModifier event (X:Id) (Ps:Params) Body:BlockBubble)
 Events:EventDecList) Props:PropertyDecList} => .K </k>
<events> Cur:Map </events>
<err> (.List => ListItem("Duplicate event " +String Id2String(X))) ErrList:List </err>
when (X in keys(Cur))

//No events left
rule
<k> {.K (.EventDecList) Props:PropertyDecList} => Props </k>

//add the first property and corresponding handlers
rule <k> Prop:PropertyDec Props:PropertyDecList => Props </k>
    <propNum> I:Int => I +Int 1 </propNum>
    <logicType> .K => getLogicName(Prop) </logicType>
    <formula> .K => getFormula(Prop) </formula>
    <handlers> .HandlerDecList => getHandlers(Prop)  </handlers>
    <runPlugin> false => true </runPlugin>

//No properties left
//rule <k>.PropertyDecList</k>
endmodule
