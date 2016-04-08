require "../syntax/fsm-syntax.k"

require "../../rvm/rvm-compiler-core.k"

module FSM
    imports FSM-SYNTAX
    imports RVM-COMPILER-CORE

    imports ERE-SYNTAX

/*First scan: Gathering the state ranks*/
rule    <logicType> fsm  </logicType>
    <formula> IT:Item IL:ItemList AL:AliasList => (IL AL) </formula>
    <runPlugin> true </runPlugin>
    <states> CurMap:Map => CurMap[getStateName(IT) <- I] </states>
//    <rawTransition> .K => getTransitionList(IT) </rawTransition>
    <stateNum> I:Int => I +Int 1 </stateNum>
    <scanNum> 0 </scanNum>

// if do not need this constraint, then comment the condition below as well as the next rule.
    when notBool (getStateName(IT) in keys(CurMap))

 //We may or may not forbid the behavior of defining transitions for the same state
 //in multiple places

rule <logicType> fsm  </logicType>
         <formula> IT:Item IL:ItemList AL:AliasList </formula>
             <states> CurMap:Map </states>
         <runPlugin> true => false </runPlugin>
             <scanNum> 0 </scanNum>
<err> (.List => ListItem("State " +String getStateName(IT) +String
        " defined in multiple places")) ErrList:List </err>
when (getStateName(IT) in keys(CurMap))


/*2nd scan starts: restore the formula for the second scan*/
rule <formula> .ItemList AL:AliasList => FC </formula>
     <formulaCopy> FC:K </formulaCopy>
     <runPlugin> true </runPlugin>
         <scanNum> 0 => 1 </scanNum>



/**consume the transition functions defined for the current state.*/
//rule    <rawTransition> (E:EventName -> SN:StateName) TL:TransitionList => TL </rawTransition>
//    <stateNum> I:Int </stateNum> //cur state has rank I -Int 1
//    <states> StateMap </states>
//        <stateTransformer> ... (E |->
//        (Func => Func[(I -Int 1) |-> StateMap[getStateName(SN)]]) ) ... </stateTransformer>
endmodule