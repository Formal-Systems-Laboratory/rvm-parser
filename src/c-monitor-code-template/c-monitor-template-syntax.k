require "domains.k"

module C-MONITOR-TEMPLATE-SYNTAX
    imports DOMAINS

//the state transition function is encoded using int array.
syntax CTemplate ::= Include MainBody

syntax MainBody ::= GlobalStatesInit MainBody1

syntax MainBody1 ::= PropStatesInit MainBody2
syntax MainBody2 ::= ResetFunc MainBody3
syntax MainBody3 ::= StateTransitions MainBody4
syntax MainBody4 ::= EventActions

syntax CTemplate ::= "$CMonitor"
syntax Include ::= "$incl"
syntax MainBody ::= "$main"
syntax MainBody1 ::= "$main1"
syntax MainBody2 ::= "$main2"
syntax MainBody3 ::= "$main3"
syntax MainBody4 ::= "$main4"


syntax GStateVar ::= "$gSVar" "(" Int ")"
syntax GlobalStatesInit ::= "$globalInit" "(" Int ")"
syntax GlobalStatesInit ::= GStateVar "," GlobalStatesInit

syntax StateVar ::= "$sVar" "(" Int ","  Int ")" //prop rank, state rank
//args of $localInit: the prop rank, the number of states in the property
syntax LocalStatesInit ::= "$localInit" "(" Int ","  Int ")"
syntax LocalStatesInit ::= StateVar "," LocalStatesInit

syntax PropStatesInit ::= "$pStates" "(" Int ")"
syntax PropStatesInit ::= LocalStatesInit ":" PropStatesInit


syntax ResetFunc ::= "$reset"

//the state functions are indexed by property rank and event rank
syntax StateTransitions ::= "$stateFuncs" "(" Int "," Int ")"
syntax StateFunc ::= "$sFunc" "(" Int "," Int ")"
syntax StateTransitions ::= StateFunc
                        | StateFunc "," StateTransitions
                        | "$emptyTransition"

syntax EventActions ::= "$eventFuncs" "(" Int ")"
syntax EventFunc ::= "$eFunc" "(" Int ")"
syntax EventActions ::= EventFunc
                    | EventFunc "," EventActions
                    | "$emptyEventActions"

endmodule