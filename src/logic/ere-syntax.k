require "domains.k"

module ERE-SYNTAX
    imports DOMAINS-SYNTAX

syntax LogicName ::= "ere"

syntax LogicFormula ::= EREFormula

syntax EREFormula ::=
           "empty"
         | "epsilon"
         | Id
         | "~" EREFormula
         > EREFormula "*"
         | EREFormula "+"
         > EREFormula EREFormula [left, klabel('EREConcat)]
         | "(" EREFormula ")"   [bracket]
         > EREFormula "&" EREFormula    [left]
         > EREFormula "|" EREFormula    [left]


syntax LogicState ::= "match" | "fail"

endmodule

