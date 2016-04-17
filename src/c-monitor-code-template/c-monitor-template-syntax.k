require "domains.k"

module C-MONITOR-TEMPLATE-SYNTAX
    imports DOMAINS

//the state transition function is encoded using int array.
syntax CTemplate ::= Include MainBody

syntax MainBody ::= GlobalStatesInit MainBody1

syntax MainBody1 ::= PropStatesInit MainBody2
syntax MainBody2 ::= ResetFunc MainBody3
syntax MainBody3 ::= StateTransitions EventActions

syntax CTemplate ::= "$CMonitor"

syntax Include ::= "$incl"

syntax GStateVar ::= "$gSVar" "(" Int ")"
syntax GlobalStatesInit ::= "$globalInit" "(" Int ")"
syntax GlobalStatesInit ::= GStateVar "," GlobalStatesInit

syntax StateVar ::= "$sVar" "(" Int ","  Int ")" //prop rank, state rank
//args of $localInit: the prop rank, the number of states in the property
syntax LocalStatesInit ::= "$localInit" "(" Int ","  Int ")"
syntax LocalStatesInit ::= StateVar "," LocalStatesInit

syntax PropStatesInit ::= "$pStates" "(" List ")"
syntax PropStatesInit ::= LocalStatesInit ":" PropStatesInit


syntax ResetFunc ::= "$reset"

syntax StateTransitions ::= "$stateFuncs" "(" Int ")"
syntax StateTransitions ::= List{StateFunc, ","}
syntax StateFunc ::= "$sFunc" "(" Int ")"

syntax EventActions ::= "$eventFuncs" "(" Int ")"
syntax EventActions ::= List{EventFunc, ","}
syntax EventFunc ::= "eFunc" "(" Int ")"

endmodule