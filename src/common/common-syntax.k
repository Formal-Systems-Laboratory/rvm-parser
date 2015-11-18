require "type-syntax.k"
require "package-syntax.k"
require "java-bubble-syntax.k"
require "property-syntax.k"

module COMMON-SYNTAX
    imports TYPE-SYNTAX
    imports PACKAGE-SYNTAX
    imports JAVA-BUBBLE-SYNTAX
    imports PROPERTY-SYNTAX

    syntax None ::= ""
    syntax Id ::= "size" | "in" | "set" | "map" [token, avoid]

endmodule