require "../rvm/rvm-compiler-core.k"
require "c-monitor-template-syntax.k"

module C-MONITOR-TEMPLATE
    imports RVM-COMPILER-CORE
    imports C-MONITOR-TEMPLATE-SYNTAX

rule
<lang> "c" </lang>
<runPlugin> false </runPlugin>
<startCodeGen> true => false </startCodeGen>
<k> _:K => $CMonitor </k>


rule //TODO:debug
<lang> "c" </lang>
<runPlugin> false </runPlugin>
 <events> EL:List </events>

 <stateNameMap> SNM:List </stateNameMap>
 <k>
 $CMonitor =>
 $incl $globalInit(size(SNM)) ($pStates(SNM)) $reset
 ($stateFuncs(size(EL) *Int size(SNM))) $eventFuncs(size(EL))
 </k>
 when size(EL) >Int 0



//generate the include part.
//TODO: incorporate the user provided includes
rule <k> $incl M:MainBody => M </k>
     <code> (.List => ListItem("#include <stdio.h>\n"
                        +String "#include <stdlib.h>\n") )
         L:List </code>

//rewrite the global var declarations.
rule <k> $globalInit(0) M:MainBody1 => M </k>

rule <k> $globalInit(I:Int) M:MainBody1 => $globalInit(I -Int 1) M
     </k>
<code> (.List => ListItem(getGlobalStateVarInit(I -Int 1))) L:List </code>
when I >Int 0

//handling the local state vars initializations.
//rule <k> ($localInit(0) M:MainBody2) => M </k>
//<tmp> L:List => .List </tmp> //the local state vars are stored in tmp cell
//<code> C:List (.List => L) </code>
//
//rule <k> ($localInit(I:Int) M:MainBody2) =>
// (($sVar(I -Int 1), $localInit(I -Int 1)) M)
//</k>
//when I >=Int 1
//
//rule <k> (($sVar(I:Int), $localInit(J:Int)) M:MainBody2) =>
//    (($localInit(J:Int)) M) </k>
//
//<states> StateMap:Map </states>
//<tmp> (.List => ListItem(getStrKey(StateMap, I))) L:List </tmp>
//
//rule <k> $reset M:MainBody3 => M </k>
//<specName> SN:String </specName>
//<code> Code:List (.List => ListItem(printResetFunc(SN))) </code>

endmodule