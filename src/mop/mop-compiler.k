require "mop-syntax.k"
require "domains.k"

module MOP-COMPILER-SYNTAX
    imports MOP-SYNTAX
endmodule

module MOP-COMPILER
    imports MOP-COMPILER-SYNTAX
    imports DOMAINS

    configuration <T> <k> $PGM:MOP </k> </T>
endmodule