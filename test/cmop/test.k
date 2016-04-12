require "../../src/c-monitor-code-template/c-monitor-template-syntax.k"

module TEST
imports C-MONITOR-TEMPLATE-SYNTAX

configuration
 <T> <k> $PGM:Int </k>
 <start> false </start>
 <code> .List </code>
  </T>

rule <start> false => true </start>
<k> _:K => $CMonitor 2 3 </k>

rule <k> $incl M:MainBody => M </k>
     <code> (.List => ListItem("#include <stdio.h>\n"
                        +String "#include <stdlib.h>\n") )
         L:List </code>

//rewrite the global var declarations.
rule <k> G:GlobalVarDecls M:MainBody1 => M
     </k>
<code> (.List => ListItem("static int __RVC_state = 0;\n")) L:List </code>


//rule ($localInit(1) => $sVar(0))
//
//rule $localInit(I:Int) => $sVar(I -Int 1), $localInit(I -Int 1)
//when I >Int 1

endmodule