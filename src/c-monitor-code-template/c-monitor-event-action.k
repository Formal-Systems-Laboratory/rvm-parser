require "../rvm/rvm-compiler-core.k"
require "c-monitor-template-syntax.k"
require "../helper/code-gen.k"
require "../helper/util.k"

module C-MONITOR-EVENT-ACTION
    imports RVM-COMPILER-CORE
    imports C-MONITOR-TEMPLATE-SYNTAX
    imports CODE-GEN
    imports UTIL

    rule <k> $main4 => $eventFuncs(size(EL)) </k>
        <events> EL:List </events>

    rule <k> $eventFuncs(I:Int) => ($eFunc(0), $eventFuncs(I)) </k>
    when I >Int 0

    rule <k> $eventFuncs(I:Int) => .K </k>
    when I <=Int 0

    rule <k> $eFunc(I:Int), $eventFuncs(0) => .K </k>

    rule <k> $eFunc(I:Int), $eventFuncs(J:Int) => $eFunc(I +Int 1), $eventFuncs(J -Int 1) </k>
    <methodBody> .K => $eFunc(I) </methodBody>
    <tmp> _ => .List </tmp>
    when J >Int 0

    rule     <methodBody> $eFunc(I:Int) => $methHeader(I) {$mbody} </methodBody>

    //print method header
//    rule <methodBody> $methHeader(I:Int) {$mbody} => $mbody </methodBody>
//    <events> EL:List </events>

endmodule