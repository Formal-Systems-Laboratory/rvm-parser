module C-MONITOR-TEMPLATE-SYNTAX

//the state transition function is encoded using int array.
syntax CTemplate ::= Include MainBody

syntax MainBody ::= GlobalVarDecls MainBody1

syntax MainBody1 ::= LocalStatesInit MainBody2
syntax MainBody2 ::= ResetFunc MainBody3
syntax MainBody3 ::= StateTransitions EventActions

syntax CTemplate ::= "$CMonitor" Int Int  //the two ints are num of events and states resp.

syntax Include ::= "$incl"
syntax GlobalVarDecls ::= "$globalInit"

syntax StateVar ::= "$sVar" "(" Int ")"
syntax LocalStatesInit ::= "$localInit" "(" Int ")"
syntax LocalStatesInit ::= StateVar "," LocalStatesInit

syntax ResetFunc ::= "$reset"

syntax StateTransitions ::= "$stateFuncs" "(" Int ")"
syntax StateTransitions ::= List{StateFunc, ","}
syntax StateFunc ::= "$sFunc" "(" Int ")"

syntax EventActions ::= "$eventFuncs" "(" Int ")"
syntax EventActions ::= List{EventFunc, ","}
syntax EventFunc ::= "eFunc" "(" Int ")"

rule $CMonitor NumOfEvents:Int NumOfStates:Int =>
 $incl $globalInit ($localInit(NumOfStates)) $reset
 ($stateFuncs(NumOfStates)) $eventFuncs(NumOfEvents)
 when NumOfEvents >Int 0 andBool NumOfStates >Int 0

endmodule