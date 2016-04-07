require "domains.k"
require "boolop-syntax.k"

module LTL-SYNTAX
    imports BOOL-SYNTAX
    imports DOMAINS-SYNTAX
    imports BOOLOP-SYNTAX

syntax LogicName ::= "ltl"

syntax LogicFormula ::= LTLFormula

syntax LTLFormula ::= Bool
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

syntax Id ::= r"(?<![A-Za-z0-9\\_])(o|U|S)" [avoid, token, klabel('IdLogic)]

syntax LogicState ::= "violation"

syntax EventName ::= Id

endmodule

