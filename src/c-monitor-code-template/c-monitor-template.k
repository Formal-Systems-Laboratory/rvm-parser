require "../rvm/rvm-compiler-core.k"
require "c-monitor-template-syntax.k"
require "import.k"

module C-MONITOR-TEMPLATE
    imports RVM-COMPILER-CORE
    imports C-MONITOR-TEMPLATE-SYNTAX
    imports IMPORT


rule <start> false => true </start>
<k> _:K => $CMonitor 2 3 </k>

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


rule <k> ($localInit(1) M:MainBody2) =>
 (($sVar(0)) M)</k>

rule <k> ($localInit(I:Int) M:MainBody2) =>
 (($sVar(I -Int 1), $localInit(I -Int 1)) M)
</k>
when I >Int 1
endmodule