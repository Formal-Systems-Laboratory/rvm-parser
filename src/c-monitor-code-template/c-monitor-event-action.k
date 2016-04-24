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

    rule <k> $eventFuncs(I:Int) => ($eFunc(0), $eventFuncs(I -Int 1)) </k>
    when I >Int 0

    rule <k> $eventFuncs(I:Int) => .K </k>
    when I <=Int 0

    rule <k> $eFunc(I:Int), $eventFuncs(0) => .K </k>
            <events> EL:List </events>
    when I >=Int size(EL)
endmodule