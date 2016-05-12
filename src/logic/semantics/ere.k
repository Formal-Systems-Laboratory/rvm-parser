require "../syntax/ere-syntax.k"

require "../../rvm/rvm-compiler-core.k"


module ERE
    imports RVM-COMPILER-CORE
    imports ERE-SYNTAX

//test rule
rule
<logicType> ere  </logicType>
<formula> _:EREFormula => .K </formula>
<runPlugin> true </runPlugin>

endmodule