require "../rvm/rvm-compiler-core.k"
require "c-monitor-template-syntax.k"

module C-MONITOR-TEMPLATE
    imports RVM-COMPILER-CORE
    imports C-MONITOR-TEMPLATE-SYNTAX

rule
<lang> "c" </lang>
<runPlugin> false </runPlugin>

<startCodeGen> true => false </startCodeGen>
<events> EL:List </events>

<propNum> PN:Int </propNum>

<states> SM:Map </states>
//this rule currently only handle the single property spec...
<k> _:K => $CMonitor size(EL) size(SM) </k> //the two arguments are num of events and states resp.

//generate the include part.
//TODO: incorporate the user provided includes
rule <k> $incl M:MainBody => M </k>
     <code> (.List => ListItem("#include <stdio.h>\n"
                        +String "#include <stdlib.h>\n") )
         L:List </code>

//rewrite the global var declarations.
rule <k> G:GlobalVarDecls M:MainBody1 => M
     </k>
<code> (.List => ListItem("static int __RVC_state = 0;\n")) L:List </code>

//handling the local state vars initializations.
rule <k> ($localInit(0) M:MainBody2) => M </k>
<tmp> L:List => .List </tmp> //the local state vars are stored in tmp cell
<code> C:List (.List => L) </code>

rule <k> ($localInit(I:Int) M:MainBody2) =>
 (($sVar(I -Int 1), $localInit(I -Int 1)) M)
</k>
when I >=Int 1

rule <k> (($sVar(I:Int), $localInit(J:Int)) M:MainBody2) =>
    (($localInit(J:Int)) M) </k>

<states> StateMap:Map </states>
<tmp> (.List => ListItem(getStrKey(StateMap, I))) L:List </tmp>

rule <k> $reset M:MainBody3 => M </k>
<specName> SN:String </specName>
<code> Code:List (.List => ListItem(printResetFunc(SN))) </code>

endmodule