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
        <states> _:Map => .Map </states>
        <code> CL:List (.List => ListItem("\n")) </code>

    rule <k> $eventFuncs(I:Int) => ($eFunc(0), $eventFuncs(I)) </k>
    when I >Int 0

    rule <k> $eventFuncs(I:Int) => .K </k>
    when I <=Int 0

    rule <k> $eFunc(I:Int), $eventFuncs(0) => .K </k>
    <methodBody> .K </methodBody>
    <k2> .K </k2>

    rule <k> $eFunc(I:Int), $eventFuncs(J:Int) => $eFunc(I +Int 1), $eventFuncs(J -Int 1) </k>
    <methodBody> .K => $eFunc(I) </methodBody>
    <tmpList> _ => .List </tmpList>
            <code> CL:List (.List => ListItem("\n")) </code>
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

    <header> HeaderCode:List (.List =>
        ListItem(printMethodHeader(SN, getStringI(EL, I), getStringI(EPs, I)) +String ";"))
    </header>

    //store the current event name which will be used to infer event transition function.
    <tmpList> .List => ListItem(getStringI(EL, I)) </tmpList>


//////////////////////////////////////////////////////////////////////////////
    //state updates
   rule <methodBody> $mbody2 => ($stateUpdates(PS) ;; $handlers) </methodBody>
        <propSize> PS:Int </propSize>

   rule <methodBody> ($stateUpdates(PS:Int) ;; $handlers) =>
        $sUpdate(0) ,, $stateUpdates(PS) ;; $handlers
        </methodBody>

   rule <methodBody>
        ($sUpdate(I:Int) ,, $stateUpdates(PS:Int) ;; $handlers)
        => $handlers
        </methodBody>
        when PS <=Int 0

   rule <methodBody>
            ($sUpdate(I:Int) ,, $stateUpdates(PS:Int) ;; $handlers) =>
            ($sUpdate(I +Int 1) ,, $stateUpdates(PS -Int 1) ;; $handlers)
            </methodBody>

            <k2> .K => $gsUpdate(I), $lsUpdates(getSize(SML, I)) </k2>
          <stateNameMap> SML:List </stateNameMap>

            //cache the state map of property I
            <states> .Map => getMapI(SML, I) </states>

          <propNum> _:Int => I </propNum> //the cur property rank is I
when PS >Int 0

//finish the state updates code
       rule <methodBody>
            ($sUpdate(I:Int) ,, $stateUpdates(0) ;; $handlers) =>
            $handlers
            </methodBody>
            <k2> .K </k2>

//generate global state update code
//when the property size > 1, the event transition function will have property rank as prefix
rule <k2> $gsUpdate(I:Int), $lsUpdates(J:Int) => $lsUpdates(J) </k2>
     <specName> SN:String </specName>
     <tmpList> ListItem(EN:String) </tmpList> //the tmpList stores the current event name
<code> C:List (.List => ListItem(
globalStateUpdate(globalStateVarI(I), propXEventE(SN, I, EN))
))
</code>
<propSize> PS:Int </propSize>
when PS >Int 1

//only a single property is defined
rule <k2> $gsUpdate(I:Int), $lsUpdates(J:Int) => $lsUpdates(J) </k2>
     <specName> SN:String </specName>
     <tmpList> ListItem(EN:String) </tmpList> //the tmpList stores the current event name
<code> C:List (.List => ListItem(
globalStateUpdate(globalStateVarI(I), propXEventE(SN, EN))
))
</code>
<propSize> PS:Int </propSize>
when PS <=Int 1

//update local states
rule <k2> $lsUpdate(I:Int) $lsUpdates(0) => .K </k2>
<states> M:Map => .Map </states>


rule <k2> $lsUpdates(I:Int) => $lsUpdate(0) $lsUpdates(I) </k2>

rule <k2> $lsUpdate(I:Int) $lsUpdates(J:Int) => $lsUpdate(I +Int 1) $lsUpdates(J -Int 1) </k2>
<propNum> G:Int </propNum>
<states> M:Map </states>
//the three args are local state var, global state var, state rank
<code> C:List (.List => ListItem(localStateUpdate(getStrKey(M, I), globalStateVarI(G), I)))
</code>
when J >Int 0

//handler code and closing parenthesis
rule <methodBody> $handlers => .K </methodBody>
<k2> .K </k2>
<handlersList> HDM:Map </handlersList>
<code> C:List (.List => getHandlerCode(HDM)) (.List => ListItem("\n}\n")) </code>

endmodule