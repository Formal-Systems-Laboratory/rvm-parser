require "domains.k"

module CFG-SYNTAX
    imports DOMAINS-SYNTAX

syntax LogicName ::= "cfg"

syntax LogicFormula ::= CFGFormula

syntax CFGFormula ::= ProductionList

syntax LogicState ::= "match" | "fail"

syntax Production ::= NonTerminalName "->" RightHandSideList
syntax RightHandSide ::= "epsilon" | NonTerminalEventName NonTerminalEventNameList

syntax NonTerminalEventName ::= NonTerminalName | EventName
syntax NonTerminalName ::= Id
syntax EventName ::= Id

syntax NonTerminalEventNameList ::= List{NonTerminalEventName, ""}  [klabel('NonTerminalEventNameList)]
syntax RightHandSideList ::= List{RightHandSide, "|"}   [klabel('RightHandSideList)]
syntax ProductionList ::= List{Production, ","}         [klabel('ProductionList)]



endmodule

