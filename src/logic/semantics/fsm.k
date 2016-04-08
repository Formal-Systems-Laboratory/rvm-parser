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

//////////////////////////////////////////////////////////////////////////////////////////////////
/*2nd scan starts: restore the formula for the second scan*/
rule <formula> .ItemList AL:AliasList => FC </formula>
     <formulaCopy> FC:K </formulaCopy>
     <runPlugin> true </runPlugin>
     <stateNum> _:Int => -1 </stateNum>
         <scanNum> 0 => 1 </scanNum>

/*2nd scan: get the raw transition mapping associated with the current state
Inside the item:

s0[e1 -> s1
e2 -> s2]

The raw transitions associated with state s0 is: e1 -> s1, e2 -> s2.
*/
rule    <logicType> fsm  </logicType>
    <formula> IT:Item IL:ItemList AL:AliasList => (IL AL) </formula>
    <stateNum> I:Int => I +Int 1 </stateNum>
    <rawTransition> .K => getTransitionList(IT) </rawTransition>
    <scanNum> 1 </scanNum>

/**consume the transition functions defined for the current state.*/
rule    <rawTransition> (E:EventName -> SN:StateName) TL:TransitionList => TL </rawTransition>
    <stateNum> I:Int </stateNum>
    <states> StateMap:Map </states>
        <stateTransformer> BigMap:Map => BigMap[E:EventName <-
        (I |-> lookup(StateMap, getStateName(SN)):Int):Map]
        </stateTransformer>
    <scanNum> 1 </scanNum>
    when notBool (E in keys(BigMap))

rule    <rawTransition> (E:EventName -> SN:StateName) TL:TransitionList => TL </rawTransition>
    <stateNum> I:Int </stateNum>
    <states> StateMap:Map </states>
        <stateTransformer> BigMap:Map => BigMap[E <-
        (lookup(BigMap, E)[I <- lookup(StateMap, getStateName(SN)):Int])]
        </stateTransformer>
    <scanNum> 1 </scanNum>
    when E in keys(BigMap)



rule <rawTransition> .TransitionList => .K </rawTransition>
    <scanNum> 1 </scanNum>

endmodule