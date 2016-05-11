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

    syntax BlockBubble ::= "{" BalancedBracket "}" [prefer, token, klabel(BlockBubbleLabel)]
                             | EmptyBlock



    syntax IdPattern ::=  //id  with * and .. wildcards (it can start with * but not with .. , same about end)
                   // r"(?<!([A-Za-z0-9\\_]|\\*))([A-Za-z\\_]|\\*)([A-Za-z0-9\\_]|(\\.\\.)|\\*|\\.)*([A-Za-z\\_]|\\*)"     [token]
                     r"(?<!([A-Za-z0-9\\_]|\\*))([A-Za-z\\_]|\\*)([A-Za-z0-9\\_]|(\\.\\.)|\\*)*([A-Za-z\\_]|\\*)"     [token,reject2("new"), klabel('IdPattern)]
                   | r"(?<!([A-Za-z0-9\\_]|\\*))([A-Za-z\\_]|\\*)" [token,klabel('IdPatternSingleChar)]

endmodule

module RVM-COMPILER-CORE
    imports RVM-SYNTAX

    configuration <T>
                      <phase> 0 </phase>

                      <k> $PGM:RVM  </k>

                      <package color="black"> "" </package>

                      <importList color="yellow"> .K </importList>

                      <events color="pink"> .List </events> //list of event name strings
                      //the params of each event, indexed by event id
                      <eventParams> .List </eventParams>
                      //the list of event action code, indexed by event id.
                      <eventAction> .List </eventAction>

                      <specName> "" </specName>
                      <specParams> .Params </specParams>
                      <decBubble> .K </decBubble>

                      <propNum> -1 </propNum> //the property rank
                      <propSize> 0 </propSize> //the number of properties

/////////////////////////////Logic Plugin cells starts////////////////////////////////////////////

                      <logicType> .K </logicType>
                      <formula> .K </formula>

                      <runPlugin> false </runPlugin>

//map a state name(string) to its integer rank, temporary working cell
                      <states> .Map </states>

// Each ListItem is a map from states name to state rank (string -> int),
//indexed by property rank
                      <stateNameMap> .List </stateNameMap>

                      <curStateRank> 0 </curStateRank>

                      //the raw transition defined in the rvm spec, indexed by states
                      <rawTransition> .K </rawTransition>

                      <readyNum> 0 </readyNum>

                      //the state transformation function, indexed by events
                      <eventFuncs color="blue">
                            <eventFunc multiplicity="*" >
                                <event> .K </event>
                                <props>
                                  <prop multiplicity="*">
                                    <prank> -1 </prank>
                                    <func> .Map </func>
                                    <intArr> .List </intArr>
                                  </prop>
                                </props>
                            </eventFunc>
                       </eventFuncs>

                      //we may need to traverse formula to get state numbers
                      //in the first scan, use this tmp cell for saving state transitions
                      //which will be restored in the second scan.
                      <formulaCopy> .K </formulaCopy>
                        <scanNum> 0 </scanNum>

                      <aliasSet> .K </aliasSet>

///////////////////////Specific for FSM//////////////////////////////////////////////////////

/////////////////////////////////Logic Plugin cells ends///////////////////////////////////////////
                      //the map element maps state name to handler code string
                      <handlersList> .Map </handlersList>

                      <handler> .HandlerDecList </handler>

                      <err> .List </err>

///////////////////////////////Code Generation//////////////////////////////////////////////////
                     <lang> "c" </lang> //the default target language for the generated monitor code
                     <code> .List </code>
                     <tmpList> .List </tmpList> //temporary cell for manipulation.
                     <methodBody> .K </methodBody>
                     <k2> .K </k2> //additional computation cell

        ///////specific for monitor code in language C
        <header> .List </header>
                       </T>

endmodule
