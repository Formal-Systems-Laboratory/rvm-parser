require "domains.k"

module SRS-SYNTAX
    imports DOMAINS-SYNTAX

syntax LogicName ::= "srs"

syntax LogicFormula ::= SRSFormula

syntax SRSFormula ::= RuleList

syntax LogicState ::= SRSState

syntax SRSState ::= "succeed" | "fail"

syntax Rule ::= SRSLeftHandSide "->" SRSRightHandSide

syntax SRSLeftHandSide ::= OptionalBegin SRSString OptionalEnd  [avoid]
syntax SRSRightHandSide ::= SRSString | "#" SRSState | "#epsilon"

syntax OptionalBegin ::= "^" | None
syntax OptionalEnd ::= "$" | None
syntax None

syntax SRSString ::= Id | Id SRSString

syntax RuleList ::= List{Rule, "."}  [klabel('RuleList)]

syntax EventName ::= Id

endmodule

