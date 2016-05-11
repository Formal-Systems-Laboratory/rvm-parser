require "../rvm/rvm-compiler-core.k"
require "c-monitor-template-syntax.k"
require "../helper/code-gen.k"
require "../helper/util.k"

require "c-monitor-event-action.k"

module C-MONITOR-TEMPLATE
    imports RVM-COMPILER-CORE
    imports C-MONITOR-TEMPLATE-SYNTAX
    imports C-MONITOR-EVENT-ACTION

    imports CODE-GEN
    imports UTIL

rule
<lang> "c" </lang>
<runPlugin> false </runPlugin>
<phase> 1 => 2 </phase>
<k> .K => $CMonitor </k>


rule
<lang> "c" </lang>
<runPlugin> false </runPlugin>
 <k>
 $CMonitor =>
 $incl $main
 </k>

//generate the include part.
//TODO: incorporate the user provided includes
rule <k> $incl $main => $main </k>
     <code> L:List (.List => ListItem("#include <stdio.h>")
                      ListItem("#include <stdlib.h>\n") )
     </code>

//incorporate the user provided declarations
rule <k> $main </k>
<decBubble> DBL:DecBubbleList => .K </decBubble>
              <code> L:List (.List =>
               ListItem(declBubbleList2String(DBL)))
              </code>

/////////
//rewrite the global var declarations.
 rule <k> $main => $globalInit(0) $main1 </k>

rule <k> $globalInit(P:Int) $main1 => $main1 </k>
<propSize> PS:Int </propSize>
when P >=Int PS

rule <k> ($globalInit(I:Int) $main1) =>  ($globalInit(I +Int 1) $main1)
     </k>
<code> L:List (.List => ListItem(getGlobalStateVarInit(I))) </code>
<propSize> PS:Int </propSize>
when I <Int PS

//////////////////////////////////////////
rule $main1 => $pStates(0) $main2

rule <k> $pStates(I:Int) $main2 => $main2 </k>
     <propSize> PN:Int </propSize> //the number of properties
    when I >=Int PN

rule <k> $pStates(I:Int) $main2 => ($localInit(I, getSize(L, I)) : $pStates(I +Int 1))
 $main2 </k>
     <propSize> PN:Int </propSize> //the number of properties
     <stateNameMap> L:List </stateNameMap>
     <states> _:Map => getMapI(L, I) </states>
    when I <Int PN

//*handling the local state vars initializations. */
rule <k> ($localInit(R:Int, 0):$pStates(I:Int) $main2) => ($pStates(I) $main2) </k>
<tmpList> L:List => .List </tmpList> //the local state vars are stored in tmp cell
<code> C:List (.List => L) </code>

rule <k> ($localInit(R:Int, I:Int):$pStates(P:Int) $main2) =>
 (($sVar(R, I -Int 1), $localInit(R, I -Int 1)):$pStates(P) $main2)
</k>
when I >=Int 1

rule <k> (($sVar(R:Int, I:Int), $localInit(R, J:Int)):$pStates(P:Int) $main2) =>
    (($localInit(R, J):$pStates(P)) $main2) </k>

<states> StateMap:Map </states>
<specName> SpecName:String </specName>
//localStateVarInit(SpecName:String, R:Int, StateName:String)
//state name: getStrKey(StateMap, I)
<tmpList> (.List => ListItem(localStateVarInit(SpecName, R, getStrKey(StateMap, I))))
    L:List </tmpList>

rule $main2 => $reset $main3

rule <k> $reset $main3 => $main3 </k>
<specName> SN:String </specName>
<propSize> P:Int </propSize>
<code> Code:List (.List => ListItem(printResetFunc(SN, P):String)) </code>
<header> Header:List (.List =>
ListItem(printResetFuncHeader(SN, P) +String ";")) </header>

//rewrite $main3 to state transitions and $main4
rule
<propSize> P:Int </propSize>
<events> L:List </events>
<k> $main3 => ($stateFuncs(P, size(L))  $main4) </k>

rule <k> ($stateFuncs(P:Int, E:Int) $main4) => (getListofStateFuncs(0, 0, P, E) $main4) </k>

//gen the state transition function from the structure
 rule <k>($emptyTransition $main4) => $main4 </k>

//print transition function (multiple properties in one spec)
 rule
 <k> (($sFunc(I:Int, J:Int):StateFunc, L:StateTransitions) $main4) => (L $main4) </k>
 <events> EL:List </events>
      <event> X:Id </event>
      <props>
        ...
         <prop>
           <prank> I </prank>
           <func> M:Map </func>
           <intArr> IA:List </intArr>
         </prop>
         ...
      </props>
 <specName> SN:String </specName>
 <propSize> PS:Int </propSize>
 <code> Code:List (.List =>
 ListItem(stateTransitionPropXEventE(SN, I, Id2String(X), IA))) </code>
when
    (getStringI(EL, J) ==String Id2String(X)) andBool
     PS >Int 1

//single property
 rule
 <k> (($sFunc(I:Int, J:Int):StateFunc, L:StateTransitions) $main4) => (L $main4) </k>
 <events> EL:List </events>
      <event> X:Id </event>
      <props>
        ...
         <prop>
           <prank> I </prank>
           <func> M:Map </func>
           <intArr> IA:List </intArr>
         </prop>
         ...
      </props>
 <specName> SN:String </specName>
 <propSize> PS:Int </propSize>
 <code> Code:List (.List =>
 ListItem(stateTransitionPropXEventE(SN, Id2String(X), IA))) </code>
when getStringI(EL, J) ==String Id2String(X)
    andBool PS <=Int 1

//////////////////////////////////////////////////////////////////////////////////
//generate the output monitor file and header file
    rule <phase> 2 => 3 </phase>
        //the output c file name and header file name are stored in cell <k> and <k2> resp.
        <k> .K => "__RVC_" +String SN +String "_Monitor.c" </k>
        <k2> .K => "__RVC_" +String SN +String "_Monitor.h"  </k2>
        <methodBody> .K </methodBody>
        <specName> SN:String </specName>

    rule <phase> 3 </phase>
    <k> OutCFileName:String => #write(#open(OutCFileName), StringList2String(CL)) </k>
    <code> CL:List => .List </code>

    //generate the output header file
    <k2> OutHFileName:String => #write(#open(OutHFileName),
    addCTemplate(StringList2String(HL), SN)) </k2>
    <header> HL:List => .List </header>
    <specName> SN:String </specName>

//////////////////////////////////////////////////////////////////////////////////

endmodule