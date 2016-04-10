module C-MONITOR-TEMPLATE-SYNTAX

//the state transition function is encoded using int array.
syntax CTemplate ::= Include StateVarsInit ResetFunc StateTransitions EventActions

syntax CTemplate ::= "$CMonitor" Int Int  //the two ints are num of events and states resp.

syntax Include ::= "$incl"
syntax StateVarsInit ::= GlobalStateInit LocalStatesInit
syntax GlobalStateInit ::= "$globalInit"
syntax LocalStatesInit ::= "$localInit" Int

syntax ResetFunc ::= "$reset"

syntax StateTransitions ::= "$stateFuncs" Int

syntax EventActions ::= "$eventFuncs" Int

rule $CMonitor NumOfEvents:Int NumOfStates:Int =>
 $incl $globalInit ($localInit NumOfStates):LocalStatesInit $reset
 ($stateFuncs NumOfStates):StateTransitions ($eventFuncs NumOfEvents):EventActions


endmodule