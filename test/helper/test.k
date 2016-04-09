require "../../src/helper/util.k"

module TEST
imports UTIL


configuration
<T>
<k> $PGM:Int </k>
<start> false </start>
<data> .Map </data>
<result> .List </result>
</T>

rule <start> false => true </start>
<data> .Map => (((1 |-> 2):Map (2 |-> 0):Map) (0 |-> 1):Map):Map </data>

rule <start> true </start>
<data> M:Map </data>
<result> .List => toIntArray(M) </result>

endmodule