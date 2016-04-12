require "../../src/c-monitor-code-template/c-monitor-template-syntax.k"

module TEST
imports C-MONITOR-TEMPLATE-SYNTAX

configuration
 <T> <k> $PGM:Int </k>
 <start> false </start>
 <code> .List </code>
 <states> .Map </states>
  </T>

rule <start> false => true </start>
<k> _:K => $CMonitor 2 3 </k>
<states> .Map => (("Safe" |-> 0) ("Unsafe" |-> 1)
 ("good" |-> 2) ("bad" |-> 3))</states>

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


rule <k> ($localInit(0) M:MainBody2) =>
 M </k>

rule <k> ($localInit(I:Int) M:MainBody2) =>
 (($sVar(I -Int 1), $localInit(I -Int 1)) M)
</k>
when I >=Int 1

rule <k> (($sVar(I:Int), $localInit(J:Int)) M:MainBody2) =>
    (($localInit(J:Int)) M) </k>

<states> ... (SN:String |-> I) ... </states>
<code> L:List (.List => ListItem(SN)) </code>
endmodule