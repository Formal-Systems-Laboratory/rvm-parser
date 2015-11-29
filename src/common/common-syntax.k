require "type-syntax.k"
require "package-syntax.k"
require "java-bubble-syntax.k"
require "property-syntax.k"

module COMMON-SYNTAX
    imports TYPE-SYNTAX
    imports PACKAGE-SYNTAX
    imports JAVA-BUBBLE-SYNTAX
    imports PROPERTY-SYNTAX

    syntax None ::= "" [klabel('None)]
    //syntax Id ::= "size" [token, avoid] | "in" [token, avoid] | "set" [token, avoid] | "map" [token, avoid] | "get" [token, avoid]
    syntax Id ::= r"(?<![A-Za-z0-9\\_])((size)|(in)|(set)|(map)|(get))"    [token, avoid, klabel('IdReserved)]

endmodule