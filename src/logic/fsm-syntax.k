require "domains.k"

module FSM-SYNTAX
    imports DOMAINS-SYNTAX

syntax LogicName ::= "fsm"

syntax LogicFormula ::= FSMFormula

syntax FSMFormula ::= ItemList AliasList

syntax LogicState ::= StateName | GroupName | "fail"

syntax Item ::= StateName "[" TransitionList "]"
syntax Transition ::= Id "->" StateName | "default" StateName

syntax Alias ::= "alias" GroupName "=" StateNameList


syntax StateName ::= Id
syntax GroupName ::= Id

syntax ItemList ::= List{Item, ""}
syntax AliasList ::= List{Alias, ""}
syntax TransitionList ::= List{Transition, ""}
syntax StateNameList ::= List{StateName, ","}



endmodule

