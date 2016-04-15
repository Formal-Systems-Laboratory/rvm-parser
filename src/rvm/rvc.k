require "rvm-syntax.k"
require "rvm-compiler.k"
require "logic-plugins-shell.k"
require "../c-monitor-code-template/c-monitor-template.k"

module RVC-SYNTAX
    imports RVM-COMPILER-SYNTAX

endmodule

module RVC
    imports RVC-SYNTAX
    imports RVM-COMPILER-CORE

    imports RVM-COMPILER

    imports LOGIC-PLUGINS-SHELL
    imports C-MONITOR-TEMPLATE


endmodule
