require "../syntax/fsm-syntax.k"

require "../../rvm/rvm-compiler-core.k"

module FSM
    imports FSM-SYNTAX
    imports RVM-COMPILER-CORE

    imports ERE-SYNTAX

rule    <logicType> fsm  </logicType>
    <formula> _:FSMFormula => .K </formula>
    <runPlugin> true </runPlugin>


endmodule