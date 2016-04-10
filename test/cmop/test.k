require "../../src/c-monitor-code-template/c-monitor-template-syntax.k"
module TEST
imports C-MONITOR-TEMPLATE-SYNTAX

configuration
 <T> <k> $PGM:Int </k>
 <start> false </start>
  </T>

rule <start> false => true </start>
<k> _:K => $CMonitor 2 3 </k>

endmodule