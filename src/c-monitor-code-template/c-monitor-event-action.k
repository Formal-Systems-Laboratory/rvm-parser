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
    <tmpList> _ => .List </tmpList>
    when J >Int 0

    rule     <methodBody> $eFunc(I:Int) => $methHeader(I) {$mbody} </methodBody>

    //print method header
    rule <methodBody> $methHeader(I:Int) {$mbody} => $mbody2 </methodBody>
    <events> EL:List </events>
                          <specName> SN:String </specName>
                      //the params of each event, indexed by event id
                      <eventParams> EPs:List </eventParams>
                      //the list of event action code, indexed by event id.
                      <eventAction> EAs:List </eventAction>
    <code> Code:List
    //method header of event I.
    (.List => ListItem(printMethodHeader(SN, getStringI(EL, I), getStringI(EPs, I))))

    (.List => ListItem("{\n"))

    (.List => ListItem(getStringI(EAs, I))) //the event I's action code
    </code>

    //TODO state updates
    //TODO handler code
//    (.List => ListItem("\n}\n"))  //the closing curly brace

endmodule