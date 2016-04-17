require "../syntax/fsm-syntax.k"
require "../../rvm/rvm-compiler-core.k"

require "../../helper/print-ast.k"
require "../../helper/util.k"

module FSM
    imports FSM-SYNTAX
    imports RVM-COMPILER-CORE
    imports PRINT-AST
    imports UTIL

/*First scan: Gathering the state ranks*/
rule    <logicType> fsm  </logicType>
    <formula> IT:Item IL:ItemList AL:AliasList => (IL AL) </formula>
    <runPlugin> true </runPlugin>
    <states> CurMap:Map => CurMap[getStateName(IT) <- size(CurMap)] </states>
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
rule
    <logicType> fsm  </logicType>
    <formula> .ItemList AL:AliasList => FC </formula>
     <formulaCopy> FC:K </formulaCopy>
     <runPlugin> true </runPlugin>
     <curStateRank> _:Int => -1 </curStateRank>
         <scanNum> 0 => 1 </scanNum>

/*2nd scan: get the raw transition mapping associated with the current state
Inside the item:

s0[e1 -> s1
e2 -> s2]

The raw transitions associated with state s0 is: e1 -> s1, e2 -> s2.
*/
rule    <logicType> fsm  </logicType>
    <formula> IT:Item IL:ItemList AL:AliasList => (IL AL) </formula>
    <curStateRank> I:Int => I +Int 1 </curStateRank>
    <rawTransition> .K => getTransitionList(IT) </rawTransition>
        <runPlugin> true </runPlugin>
    <scanNum> 1 </scanNum>

/**consume the transition functions defined for the current state.*/
/*Handle unknown event*/
rule <k> _ => .K </k>
    <logicType> fsm  </logicType>
    <rawTransition> (E:EventName -> SN:StateName) TL:TransitionList </rawTransition>
        <events> EL:List </events>
    <scanNum> 1 </scanNum>
    <err> (.List => ListItem("Undefined event " +String getEventName(E))) ErrList:List </err>
    <runPlugin> true => false </runPlugin>
    when notBool (getEventName(E) in EL)

/*Handle unknown state*/
rule <k> _ => .K </k>
    <logicType> fsm  </logicType>
    <rawTransition> (E:EventName -> SN:StateName) TL:TransitionList </rawTransition>
        <states> SM:Map </states>
    <scanNum> 1 </scanNum>
    <err> (.List => ListItem("Undefined state " +String printStateName(SN))) ErrList:List </err>
    <runPlugin> true => false </runPlugin>
    when notBool (printStateName(SN) in keys(SM))

////////////////////////////////////////////////////////////////////
/*Update the event transition function for event E and property P.*/
rule    <logicType> fsm  </logicType>
        <propNum> P:Int </propNum>

        <rawTransition> (E:EventName -> SN:StateName) TL:TransitionList => TL </rawTransition>
        <curStateRank> S1:Int </curStateRank>
        <states> SM:Map (printStateName(SN):String |-> S2:Int):Map </states>
        <eventFuncs>
            ...

            <eventFunc>
             <event> E </event>
             <props>
             ...

             <prop>
             <prank> P </prank>
             <func> (.Map => (S1 |-> S2):Map) M:Map  </func>
            ...
            </prop>

            ...
            </props>
             </eventFunc>

             ...
        </eventFuncs>
    <scanNum> 1 </scanNum>  [prefer]

////////////////////////////////////////////////

rule
<logicType> fsm  </logicType>
<rawTransition> .TransitionList => .K </rawTransition>
    <runPlugin> true </runPlugin>
    <scanNum> 1 </scanNum>

/*when all the computation related to the formula completes,
translate the transition function from map to int array*/
rule    <logicType> fsm  </logicType>
        <states> AllStatesMap:Map </states>
         <formula> .ItemList .AliasList </formula>
         <rawTransition> .K </rawTransition>
         <propNum> PN:Int </propNum>

         <readyNum> N:Int => N +Int 1 </readyNum>

         <eventFunc>
         ...
         <prank> PN </prank>
         <func> SM:Map </func>
         <intArr> .List => toIntArray(SM, size(AllStatesMap)) </intArr>
         </eventFunc>
         <scanNum> 1 </scanNum>
         <runPlugin> true </runPlugin>

/*All the event transition functions have been generated,
stop the processing of the current property,
reset the cells and wait for the processing of the next property*/
rule <readyNum> N:Int => 0 </readyNum>
<logicType> _:K => .K </logicType>
     <events> EL:List </events>
     <runPlugin> true => false </runPlugin>
     <states> SM:Map => .Map </states>
     <scanNum> _:Int => 0 </scanNum>
     <formula> _:K => .K </formula>
     <formulaCopy> _:K => .K </formulaCopy>

 <stateNameMap> SL:List (.List => ListItem(SM)) </stateNameMap>
    //TODO: process the handlers cell
     <handlers> _:HandlerDecList => .HandlerDecList </handlers>
when N ==Int size(EL)

endmodule