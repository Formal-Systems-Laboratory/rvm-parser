require "../syntax/fsm-syntax.k"

require "../../rvm/rvm-compiler-core.k"

require "../../helper/util.k"

module FSM
    imports FSM-SYNTAX
    imports RVM-COMPILER-CORE
    imports UTIL

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
/*Handle unknown event*/
rule    <rawTransition> (E:EventName -> SN:StateName) TL:TransitionList </rawTransition>
        <events> Es:Set </events>
    <scanNum> 1 </scanNum>
    <err> (.List => ListItem("Undefined event " +String getEventName(E))) ErrList:List </err>
    <runPlugin> true => false </runPlugin>
    when notBool E in Es

/*Handle unknown state*/
rule    <rawTransition> (E:EventName -> SN:StateName) TL:TransitionList </rawTransition>
        <states> SM:Map </states>
    <scanNum> 1 </scanNum>
    <err> (.List => ListItem("Undefined state " +String printStateName(SN))) ErrList:List </err>
    <runPlugin> true => false </runPlugin>
    when notBool (printStateName(SN) in keys(SM))

rule    <rawTransition> (E:EventName -> SN:StateName) TL:TransitionList => TL </rawTransition>
        <stateNum> S1:Int </stateNum>
        <states> SM:Map (printStateName(SN):String |-> S2:Int):Map </states>
        <stateTransformer>
            ...

            <eventFunc>
             <event> E </event>
             <func> (.Map => S1 |-> S2) M:Map  </func>
            ...
             </eventFunc>

             ...
        </stateTransformer>
    <scanNum> 1 </scanNum>



rule <rawTransition> .TransitionList => .K </rawTransition>
    <scanNum> 1 </scanNum>

/*when all the computation related to the formula completes,
translate the transition function from map to int array*/
rule    <states> AllStatesMap:Map </states>
         <formula> .ItemList .AliasList </formula>
         <rawTransition> .K </rawTransition>
         <eventFunc>
         ...
         <func> SM:Map </func>
         <intArr> .List => toIntArray(SM, size(AllStatesMap)) </intArr>
         </eventFunc>
         <scanNum> 1 </scanNum>

endmodule