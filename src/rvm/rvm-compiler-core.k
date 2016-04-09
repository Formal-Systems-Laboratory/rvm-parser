require "rvm-syntax.k"

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

module RVM-COMPILER-CORE
    imports RVM-SYNTAX

    configuration <T> <k> $PGM:RVM  </k>
                        <package color="black"> "" </package>

                      <importList color="yellow"> .K </importList>

                      <events color="pink"> .Set </events> //map an event to its number
                      <eventNum> 0 </eventNum>

                      <specName> "" </specName>
                      <specParams> .Params </specParams>
                      <decBubble> .K </decBubble>

                      <propNum> 0 </propNum>

/////////////////////////////Logic Plugin cells starts////////////////////////////////////////////

                      <logicType> .K </logicType>
                      <formula> .K </formula>

                      <runPlugin> false </runPlugin>

                      <states> .Map </states> //map a state to its number
                      <stateNum> 0 </stateNum>

                      //the raw transition defined in the rvm spec, indexed by states
                      <rawTransition> .K </rawTransition>

                      //the state transformation function, indexed by events
                      <stateTransformer color="blue">
                            <eventFunc multiplicity="*" >
                                <event> .K </event>
                                <func> .Map </func>
                                <intArr> .List </intArr>
                            </eventFunc>
                       </stateTransformer>

                      //we may need to traverse formula to get state numbers
                      //in the first scan, use this tmp cell for saving state transitions
                      //which will be restored in the second scan.
                      <formulaCopy> .K </formulaCopy>
                        <scanNum> 0 </scanNum>

                      <aliasSet> .K </aliasSet>

                      <k2> .K </k2> //additional computation cell
///////////////////////Specific for FSM//////////////////////////////////////////////////////

/////////////////////////////////Logic Plugin cells ends///////////////////////////////////////////
                      <handlers> .HandlerDecList </handlers>

                      <err> .List </err>
                       </T>

endmodule
