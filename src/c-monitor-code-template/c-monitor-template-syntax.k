require "domains.k"

module C-MONITOR-TEMPLATE-SYNTAX
    imports DOMAINS

//the state transition function is encoded using int array.
syntax CTemplate ::= Include MainBody

syntax MainBody ::= GlobalStatesInit MainBody1

syntax MainBody1 ::= PropStatesInit MainBody2
syntax MainBody2 ::= ResetFunc MainBody3
syntax MainBody3 ::= StateTransitions MainBody4
syntax MainBody4 ::= EventMethods

syntax CTemplate ::= "$CMonitor"
syntax Include ::= "$incl"
syntax MainBody ::= "$main"
syntax MainBody1 ::= "$main1"
syntax MainBody2 ::= "$main2"
syntax MainBody3 ::= "$main3"
syntax MainBody4 ::= "$main4"


syntax GStateVar ::= "$gSVar" "(" Int ")"
syntax GlobalStatesInit ::= "$globalInit" "(" Int ")"
syntax GlobalStatesInit ::= GStateVar "," GlobalStatesInit

syntax StateVar ::= "$sVar" "(" Int ","  Int ")" //prop rank, state rank
//args of $localInit: the prop rank, the number of states in the property
syntax LocalStatesInit ::= "$localInit" "(" Int ","  Int ")"
syntax LocalStatesInit ::= StateVar "," LocalStatesInit

syntax PropStatesInit ::= "$pStates" "(" Int ")"
syntax PropStatesInit ::= LocalStatesInit ":" PropStatesInit


syntax ResetFunc ::= "$reset"

//the state functions are indexed by property rank and event rank
syntax StateTransitions ::= "$stateFuncs" "(" Int "," Int ")"
syntax StateFunc ::= "$sFunc" "(" Int "," Int ")"
syntax StateTransitions ::= StateFunc
                        | StateFunc "," StateTransitions
                        | "$emptyTransition"

syntax EventMethods ::= "$eventFuncs" "(" Int ")"
syntax EventMethod ::= "$eFunc" "(" Int ")"
syntax EventMethods ::= EventMethod | EventMethod "," EventMethods

//the structure of an event action method
//based on the configuration, the same method body prototype
//can be rewritten to different concrete method bodies.
syntax MethodHeader ::= "$methHeader" "(" Int ")"

syntax EventAction ::= "$eAction" "(" Int ")"

//update the states in each property.
syntax MonitorStateUpdates ::= "$stateUpdates" "(" Int ")"
syntax MonitorStateUpdate ::= "$sUpdate" "(" Int ")"
syntax MonitorStateUpdates ::= MonitorStateUpdate
                            | MonitorStateUpdate ",," MonitorStateUpdates

syntax HandlerActions ::= "$handlers"

syntax MethodBody ::= EventAction ";;" MethodBody2
syntax MethodBody2 ::= MonitorStateUpdates ";;" HandlerActions

syntax EventMethod ::= MethodHeader "{" MethodBody "}"

syntax MethodBody ::= "$mbody"
syntax MethodBody2 ::= "$mbody2"

//in the section of monitor state updates, there are two parts:
//1. update the current state of the monitor,
//2. update the state predicates for each state in the automata (whether that state is on)
syntax MonitorStateUpdate ::= GlobalStateUpdate "," LocalStateUpdates
//the int argument is the property rank of the state var
syntax GlobalStateUpdate ::= "$gsUpdate" "(" Int ")"

//the arg is the number of states in the current property
syntax LocalStateUpdates ::= "$lsUpdates" "(" Int ")"

//by querying the configuration, we can build the entry of state name (string) |-> state rank (int)
syntax LocalStateUpdate ::= "$lsUpdate" "(" Int ")"

syntax LocalStateUpdates ::= LocalStateUpdate | LocalStateUpdate LocalStateUpdates

endmodule