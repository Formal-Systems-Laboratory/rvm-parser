require "domains.k"

module BOOLOP-SYNTAX
    imports DOMAINS-COMMON
syntax Not ::= "!" | "not"
syntax And ::= "/\\" | "and" | "&&"
syntax Or ::= "\\/" | "or" | "||"
syntax Xor ::= "++" | "xor" | "^"
syntax Implies ::= "=>" | "implies"
syntax Equivalent ::= "<=>" | "<->"

endmodule