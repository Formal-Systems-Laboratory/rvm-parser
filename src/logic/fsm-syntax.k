require "domains.k"

module FSM-SYNTAX
    imports DOMAINS-SYNTAX

syntax LogicName ::= "fsm"

syntax LogicFormula ::= FSMFormula

syntax FSMFormula ::= ItemList AliasList

syntax LogicState ::= StateName | GroupName | "fail"

syntax Item ::= StateName "[" TransitionList "]"
syntax Transition ::= EventName "->" StateName | "default" StateName

syntax Alias ::= "alias" GroupName "=" StateNameList


syntax StateName ::= Id
syntax GroupName ::= Id
syntax EventName ::= Id

syntax ItemList ::= List{Item, ""}                  [klabel('ItemList)]
syntax AliasList ::= List{Alias, ""}                [klabel('AliasList)]
syntax TransitionList ::= List{Transition, ""}      [klabel('TransitionList)]
syntax StateNameList ::= List{StateName, ","}       [klabel('StateNameList)]



endmodule

