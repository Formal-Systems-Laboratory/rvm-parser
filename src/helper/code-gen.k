require "../rvm/rvm-syntax.k"
require "domains.k"

module CODE-GEN
    imports RVM-SYNTAX
    imports DOMAINS-SYNTAX

//the code for resetting global state var i
syntax String ::= resetGlobalStateI(Int) [function]
rule resetGlobalStateI(I:Int) => "Prop_" +String
                    Int2String(I) +String "_RVC_state = 0;\n"

    syntax String ::= getGlobalStateVarInit(Int) [function]
    rule getGlobalStateVarInit(I:Int) => "static int " +String resetGlobalStateI(I)

    /*Return the string of reset function, given the name of the specification,
    and the number of properties*/
    syntax String ::= printResetFunc(String, Int) [function]

    rule printResetFunc(SpecName:String, 0) => ""

    rule printResetFunc(SpecName:String, I:Int) => "void __RVC_" +String SpecName
     +String "_reset(void)\n" +String "{\n" +String resetGlobalStates(I) +String "}"
    when I =/=Int 0

    syntax String ::= resetGlobalStates(Int) [function]
    rule resetGlobalStates(I:Int) => "" when I <=Int 0
    rule resetGlobalStates(1) => resetGlobalStateI(0)
    rule resetGlobalStates(I:Int) => resetGlobalStates(I -Int 1) +String
                        resetGlobalStateI(I -Int 1) when I >Int 1

endmodule