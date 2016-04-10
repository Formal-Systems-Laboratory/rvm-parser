require "../rvm/rvm-compiler-core.k"
require "c-monitor-template-syntax.k"

module IMPORT
        imports RVM-COMPILER-CORE
        imports C-MONITOR-TEMPLATE-SYNTAX

        rule <k> $incl => . ... </k>
        <code> (.List => ListItem("#include <stdio.h>\n"
                        +String "#include <stdlib.h>\n") )
         _:List </code>


endmodule