require "../rvm/rvm-compiler-core.k"
require "c-monitor-template-syntax.k"
require "../helper/code-gen.k"
require "../helper/util.k"

module C-MONITOR-TEMPLATE
    imports RVM-COMPILER-CORE
    imports C-MONITOR-TEMPLATE-SYNTAX
    imports CODE-GEN
    imports UTIL

rule
<lang> "c" </lang>
<runPlugin> false </runPlugin>
<startCodeGen> true => false </startCodeGen>
<k> _:K => $CMonitor </k>


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
                      ListItem("#include <stdlib.h>") )
     </code>

/////////
 rule <k> $main => $globalInit(PS) $main1 </k>
<propSize> PS:Int </propSize>


//rewrite the global var declarations.
rule <k> $globalInit(0) $main1 => $main1 </k>

rule <k> ($globalInit(I:Int) $main1) =>  ($globalInit(I -Int 1) $main1)
     </k>
<code> L:List (.List => ListItem(getGlobalStateVarInit(I -Int 1))) </code>
when I >Int 0

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
<tmp> L:List => .List </tmp> //the local state vars are stored in tmp cell
<code> C:List (.List => L) </code>

rule <k> ($localInit(R:Int, I:Int):$pStates(P:Int) $main2) =>
 (($sVar(R, I -Int 1), $localInit(R, I -Int 1)):$pStates(P) $main2)
</k>
when I >=Int 1

rule <k> (($sVar(R:Int, I:Int), $localInit(R, J:Int)):$pStates(P:Int) $main2) =>
    (($localInit(R, J):$pStates(P)) $main2) </k>

<states> StateMap:Map </states>
<tmp> (.List => ListItem(getStrKey(StateMap, I))) L:List </tmp>

rule $main2 => $reset $main3

rule <k> $reset $main3 => $main3 </k>
<specName> SN:String </specName>
<propSize> P:Int </propSize>
<code> Code:List (.List => ListItem(printResetFunc(SN, P):String)) </code>
endmodule