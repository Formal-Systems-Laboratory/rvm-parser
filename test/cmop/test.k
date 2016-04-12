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


rule <k> ( ($incl => .) $globalInit:GlobalStateInit ($localInit(NumOfStates)):LocalStatesInit
$reset:ResetFunc
         ($stateFuncs(NumOfStates)):StateTransitions ($eventFuncs(NumOfEvents)):EventActions)  </k>
        <code> (.List => ListItem("#include <stdio.h>\n"
                        +String "#include <stdlib.h>\n") )
         L:List </code>

rule <k> . ($globalInit:GlobalStateInit => .) ($localInit(NumOfStates)):LocalStatesInit
           $reset:ResetFunc
                    ($stateFuncs(NumOfStates)):StateTransitions ($eventFuncs(NumOfEvents)):EventActions
     </k>
<code> (.List => ListItem("static int __RVC_state = 0;\n")) L:List </code>
endmodule