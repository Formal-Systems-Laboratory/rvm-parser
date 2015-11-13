require "domains.k"
require "boolop-syntax.k"

module LTL-SYNTAX
    imports DOMAINS-SYNTAX
    imports BOOLOP-SYNTAX

syntax LogicName ::= "ltl"

syntax LogicFormula ::= LTLFormula

syntax LTLFormula ::=
           "true"
         | "false"
         | EventName
         | "(" LTLFormula ")"           [bracket]
         > "[]" LTLFormula
         > "[*]" LTLFormula
         > "<>" LTLFormula
         > "<*>" LTLFormula
         > "o" LTLFormula
         > "(*)" LTLFormula
         > "!" LTLFormula
         > LTLFormula "U" LTLFormula    [left]
         > LTLFormula "~U" LTLFormula   [left]
         > LTLFormula "S" LTLFormula    [left]
         > LTLFormula "~S" LTLFormula   [left]
         > LTLFormula And LTLFormula  [left, klabel('LTLAnd)]
         > LTLFormula Or LTLFormula   [left, klabel('LTLOr)]
         > LTLFormula Xor LTLFormula  [left,klabel('LTLXor)]
         > LTLFormula Implies LTLFormula   [left, klabel('LTLImp)]
         > LTLFormula Equivalent LTLFormula  [left, klabel('LTLEq)]

syntax Id ::= "o" [avoid, token]
            | "U" [avoid, token]
            | "S" [avoid, token]

syntax LogicState ::= "violation"

syntax EventName ::= Id

endmodule

