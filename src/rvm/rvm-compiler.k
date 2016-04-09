require "rvm-syntax.k"
require "domains.k"
require "rvm-compiler-core.k"
require "../helper/print-ast.k"

require "../logic/semantics/fsm.k"

module RVM-COMPILER
    imports RVM-SYNTAX
    imports RVM-COMPILER-CORE
    imports PRINT-AST

    imports FSM

    syntax KResult ::= "error"

/**
* Store the package info and import list.
*/
rule <k> X:OptionalPackageDec Y:ImportDecList Z:SpecDec => Z </k>
    <package> "" => toString(X) </package>
    <importList> .K => Y </importList>

/**
* Store the spec name and params.
*/
rule <k>X:Id (Ps:Params) SB:SpecBody => SB </k>
<specName> "" => Id2String(X) </specName>
<specParams> .Params => Ps </specParams>

/**
* Store the declarations info.
*/
rule <k> {(Decls:DecBubbleList => .K) Events:EventDecList
Props:PropertyDecList} </k>
    <decBubble> .K => Decls </decBubble>

//rule <k> {(Decl:DecBubble Decls:DecBubbleList => Decls) Events:EventDecList
//Props:PropertyDecList} </k>



/**
* Extract and store the first event in the event list if we haven't encountered it before.
*/
rule <k> {.K ((EM:EventModifier event (X:Id) (Ps:Params) Body:BlockBubble)
 Events:EventDecList => Events) Props:PropertyDecList} </k>
<events> (.Set => SetItem(X)) Cur:Set  </events>

<stateTransformer>
  ...

  (.Bag => <eventFunc>
    <event> X </event>
    ...
    </eventFunc>)
</stateTransformer>

<eventNum> I:Int => I +Int 1 </eventNum>
when notBool (X in Cur)

/**
* Report error if an event is defined multiple times.
* In case of error, the execution will be terminated and the error info
* will be stored in <err> cell.
*/
rule <k> {.K ((EM:EventModifier event (X:Id) (Ps:Params) Body:BlockBubble)
 Events:EventDecList) Props:PropertyDecList} => .K </k>
<events> Cur:Set </events>
<err> (.List => ListItem("Duplicate event " +String Id2String(X))) ErrList:List </err>
when (X in Cur)

//No events left
rule
<k> {.K (.EventDecList) Props:PropertyDecList} => Props </k>

//add the first property and corresponding handlers
rule <k> Prop:PropertyDec Props:PropertyDecList => Props </k>
    <propNum> I:Int => I +Int 1 </propNum>
    <logicType> .K => getLogicName(Prop) </logicType>
    <formula> .K => getFormula(Prop) </formula>
    <formulaCopy> .K => getFormula(Prop) </formulaCopy>
    <handlers> .HandlerDecList => getHandlers(Prop)  </handlers>
    <runPlugin> false => true </runPlugin>

//No properties left
//rule <k>.PropertyDecList</k>

endmodule
