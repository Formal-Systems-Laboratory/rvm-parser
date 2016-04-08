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

// if do not need this constraint, then comment the condition below as well as the next rule.
    when notBool (getStateName(IT) in keys(CurMap))

 //We may or may not forbid the behavior of defining transitions for the same state
 //in multiple places

rule <logicType> fsm  </logicType>
         <formula> IT:Item IL:ItemList AL:AliasList </formula>
             <states> CurMap:Map </states>
         <runPlugin> true => false </runPlugin>
<err> (.List => ListItem("State " +String getStateName(IT) +String
        " defined in multiple places")) ErrList:List </err>
when (getStateName(IT) in keys(CurMap))

//rule    <transitionFunction> (E:EventName -> SN:StateName) TL:TransitionList => TL
//</transitionFunction>
          //...
endmodule