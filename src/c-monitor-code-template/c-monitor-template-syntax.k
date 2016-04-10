module C-MONITOR-TEMPLATE-SYNTAX

//the state transition function is encoded using int array.
syntax CTemplate ::= Include StateVarsInit ResetFunc StateTransitions EventActions

syntax CTemplate ::= "$CMonitor" Int Int  //the two ints are num of events and states resp.

syntax Include ::= "$incl"
syntax StateVarsInit ::= GlobalStateInit LocalStatesInit
syntax GlobalStateInit ::= "$globalInit"

syntax LocalStatesInit ::= "$localInit" "(" Int ")"
syntax LocalStatesInit ::= List{StateVar, ","}
syntax StateVar ::= "$sVar" "(" Int ")"


syntax ResetFunc ::= "#reset"

syntax StateTransitions ::= "$stateFuncs" "(" Int ")"
syntax StateTransitions ::= List{StateFunc, ","}
syntax StateFunc ::= "$sFunc" "(" Int ")"

syntax EventActions ::= "$eventFuncs" "(" Int ")"
syntax EventActions ::= List{EventFunc, ","}
syntax EventFunc ::= "eFunc" "(" Int ")"

rule $CMonitor NumOfEvents:Int NumOfStates:Int =>
 $incl $globalInit ($localInit(NumOfStates)) #reset
 ($stateFuncs(NumOfStates)) $eventFuncs(NumOfEvents)


endmodule