require "domains.k"

module LTL-SYNTAX
    imports DOMAINS-SYNTAX

syntax LogicName ::= "ltl"

syntax LogicFormula ::= LTLFormula

syntax LTLFormula ::=
           "true"
         | "false"
         | Id
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
         > LTLFormula "and" LTLFormula  [left]
         > LTLFormula "or" LTLFormula   [left]
         > LTLFormula "xor" LTLFormula  [left]
         > LTLFormula "=>" LTLFormula   [left]
         > LTLFormula "<=>" LTLFormula  [left]

syntax Id ::= "o" [avoid, token]
            | "U" [avoid, token]
            | "S" [avoid, token]

syntax LogicState ::= "violation"

syntax EventName ::= Id

endmodule

