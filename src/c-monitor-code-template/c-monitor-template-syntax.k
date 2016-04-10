module C-MONITOR-TEMPLATE-SYNTAX

//the state transition function is encoded using int array.
syntax CTemplate ::= Include StateVarsInit ResetFunc StateTransitions EventActions

syntax CTemplate ::= "$CMonitor"

syntax Include ::= "$incl"
syntax StateVarsInit ::= GlobalStateInit LocalStatesInit
syntax GlobalStateInit ::= "$globalInit"
syntax LocalStatesInit ::= "$localInit"

syntax ResetFunc ::= "$reset"

syntax StateTransitions ::= "$stateFuncs"

syntax EventActions ::= "$eventFuncs"

rule $CMonitor => $incl $globalInit $localInit $reset $stateFuncs $eventFuncs

endmodule