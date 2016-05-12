require "domains.k"

module ERE-SYNTAX
    imports DOMAINS-SYNTAX

syntax LogicName ::= "ere"

syntax LogicFormula ::= EREFormula

syntax EREFormula ::=
           "empty"                  [klabel('EREEmp)]
         | "epsilon"                [klabel('EREEps)]
         | EventName                [klabel('EREAtom)]
         | "~" EREFormula           [klabel('ERENot)]
         > EREFormula "*"           [klabel('EREStar)]
         | EREFormula "+"           [klabel('EREPlus)]
         > EREFormula EREFormula [left, klabel('EREConcat)]
         | "(" EREFormula ")"   [bracket]
         > EREFormula "&" EREFormula    [left, klabel('EREAnd)]
         > EREFormula "|" EREFormula    [left, klabel('EREOr)]


syntax LogicState ::= "match" | "fail"

syntax EventName ::= Id

endmodule

