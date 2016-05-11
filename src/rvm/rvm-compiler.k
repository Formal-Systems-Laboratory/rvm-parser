require "rvm-syntax.k"
require "domains.k"
require "rvm-compiler-core.k"
require "../helper/print-ast.k"
require "../../src/helper/util.k"

////
module RVM-COMPILER
    imports RVM-SYNTAX
    imports RVM-COMPILER-CORE
    imports PRINT-AST
    imports UTIL

    syntax KResult ::= "error"

/**
* Store the package info and import list.
*/
rule <k> X:OptionalPackageDec Y:ImportDecList Z:SpecDec => Z </k>
    <package> "" => PackageDec2String(X) </package>
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
<propSize> I:Int => sizeOf(Props) </propSize>




/**
* Extract and store the first event in the event list if we haven't encountered it before.
*/
rule
<phase> 0 </phase>
<k> {.K ((EM:EventModifier event (X:Id) (Ps:Params) Body:BlockBubble)
 Events:EventDecList => Events) Props:PropertyDecList} </k>
<events> L:List (.List => ListItem(Id2String(X))) </events>
<eventAction> EA:List (.List => ListItem(Block2Str(Body))) </eventAction>

//the params of each event, indexed by event id
<eventParams> EP:List (.List => ListItem(Params2Str(Ps))) </eventParams>

<eventFuncs>
  ...

  (.Bag =>
                              <eventFunc>
                                  <event> X:Id </event>
                                  <props>
                                    <prop>
                                      <prank> PS -Int 1 </prank>
                                      <func> .Map </func>
                                      <intArr> .List </intArr>
                                    </prop>
                                  </props>
                              </eventFunc>
  )
</eventFuncs>
<propSize> PS:Int </propSize>
<k2> .K => PS -Int 1 </k2>

when notBool (Id2String(X) in L)

//construct initial props cells
rule
<events> L:List </events>
<eventFuncs>
  ...

                              <eventFunc>
                                  <event> X:Id </event>
                                  <props>
                                    (.Bag => <prop>
                                               <prank> PS -Int 1 </prank>
                                               <func> .Map </func>
                                                <intArr> .List </intArr>
                                               </prop>)
                                    ...
                                  </props>
                              </eventFunc>

  ...
</eventFuncs>
<k2> PS:Int => PS -Int 1 </k2>
when PS >Int 0 andBool isLastItem(L, X)

rule <k2> 0 => .K </k2>


/**
* Report error if an event is defined multiple times.
* In case of error, the execution will be terminated and the error info
* will be stored in <err> cell.
*/
rule <k> {.K ((EM:EventModifier event (X:Id) (Ps:Params) Body:BlockBubble)
 Events:EventDecList) Props:PropertyDecList} => .K </k>
<events> EL:List </events>
<err> (.List => ListItem("Duplicate event " +String Id2String(X))) ErrList:List </err>
when (Id2String(X) in EL)

//No events left
rule
<k> {.K (.EventDecList) Props:PropertyDecList} => Props </k>
    <phase> 0 => 1 </phase>


//add the property formula and corresponding handlers
rule <k> Prop:PropertyDec Props:PropertyDecList => Props </k>
    <propNum> I:Int => I +Int 1 </propNum>
    <logicType> .K => getLogicName(Prop) </logicType>
    <formula> .K => getFormula(Prop) </formula>
    <formulaCopy> .K => getFormula(Prop) </formulaCopy>
    <handler> .HandlerDecList => getHandlers(Prop) </handler>
    <runPlugin> false => true </runPlugin>

//No properties left
rule <k> .PropertyDecList => . </k>
<runPlugin> false </runPlugin>
<states> M:Map => .Map </states>

endmodule
