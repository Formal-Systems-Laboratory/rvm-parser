module C-MONITOR-TEMPLATE-SYNTAX

//the state transition function is encoded using int array.
syntax CTemplate ::= Include StateVarsInit ResetFunc StateTransitions EventActions

syntax Include ::= "$incl"
syntax StateVarsInit ::= GlobalStateInit LocalStatesInit
syntax GlobalStateInit ::= "$globalInit"
syntax LocalStatesInit ::= "localInit"

endmodule