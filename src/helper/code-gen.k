require "../rvm/rvm-syntax.k"
require "domains.k"

module CODE-GEN
    imports RVM-SYNTAX
    imports DOMAINS-SYNTAX

    syntax String ::= getGlobalStateVarInit(Int) [function]
    rule getGlobalStateVarInit(I:Int) => "static int Prop_" +String
              Int2String(I) +String "_RVC_state = 0;\n"
endmodule