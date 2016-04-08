require "../syntax/fsm-syntax.k"

require "../../rvm/rvm-compiler-core.k"

module FSM
    imports FSM-SYNTAX
    imports RVM-COMPILER-CORE

    imports ERE-SYNTAX

rule    <logicType> fsm  </logicType>
    <formula> IT:Item IL:ItemList AL:AliasList => (IL AL) </formula>
    <runPlugin> true </runPlugin>
    <states> CurMap:Map => CurMap[getStateName(IT) <- I] </states>
    <transitionFunction> .K => getTransitionList(IT) </transitionFunction>
    <stateNum> I:Int => I +Int 1 </stateNum>


rule    <transitionFunction> (E:EventName -> SN:StateName) TL:TransitionList => TL </transitionFunction>
          //...
endmodule