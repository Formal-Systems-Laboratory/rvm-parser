// based on https://eclipse.org/aspectj/doc/released/progguide/semantics-pointcuts.html
// with slight modifications
require "../common/type-syntax.k"


module ASPECTJ-POINTCUT-SYNTAX
    imports TYPE-SYNTAX

    syntax AspectJPointCut ::=   "call" "(" MethodPattern ")"
                        | "execution" "(" MethodPattern ")"
                        | "get" "(" FieldPattern ")"
                        | "set""(" FieldPattern ")"
                        | "call" "(" ConstructorPattern ")"
                        | "execution" "(" ConstructorPattern ")"
                        | "initialization" "(" ConstructorPattern ")"
                        | "preinitialization" "(" ConstructorPattern ")"
                        | "staticinitialization" "(" TypePattern ")"
                        | "handler" "(" TypePattern ")"
                        | "adviceexecution" "(" ")"
                        | "within" "(" TypePattern ")"
                        | "withincode" "(" MethodPattern ")"
                        | "withincode" "(" ConstructorPattern ")"
                        | "cflow" "(" AspectJPointCut ")"
                        | "cflowbelow" "(" AspectJPointCut ")"
                        | "this" "(" TypeId ")"
                        | "target" "(" TypeId ")"
                        | "args" "(" TypeIdList ")"
                        //| "PointcutId" "("TypePattern or Id, ...")"
                        //| "if" "(" BoolExpBubble ")"      //later
                        | "!" AspectJPointCut
                        | AspectJPointCut "&&" AspectJPointCut  [left, klabel('AJPointCutAnd)]
                        | AspectJPointCut "||" AspectJPointCut  [left, klabel('AJPointCutOr)]
                        | "(" AspectJPointCut ")"       [bracket]
    syntax priority 'AJPointCutAnd > 'AJPointCutOr

    syntax MethodPattern ::= ModifiersPattern TypePattern OptionalTypePatternDot IdPattern "(" TypePatternDoubleDotList ")" OptionalThrows

    syntax ConstructorPattern ::= ModifiersPattern  OptionalTypePatternDot "new" "(" TypePatternDoubleDotList ")" OptionalThrows [prefer]

    syntax FieldPattern ::= ModifiersPattern TypePattern OptionalTypePatternDot IdPattern

    syntax ThrowsPattern ::=  TypePatternList

    syntax TypePattern ::= IdPattern OptionalPlus Dims
               | "!" TypePattern
               | TypePattern "&&" TypePattern   [left, klabel('TypePatAnd)]
               | TypePattern "||" TypePattern   [left, klabel('TypePatOr)]
               | "(" TypePattern ")"        [bracket]
    syntax priority 'TypePatAnd > 'TypePatOr

    syntax ModifiersPattern ::= ModifierList | "!" ModifierList

    syntax IdPattern ::=  r"(?<!([A-Za-z0-9\\_]|(\\.\\.)|\\*))([A-Za-z\\_]|(\\.\\.)|\\*)([A-Za-z0-9\\_]|(\\.\\.)|\\*)*"     [token] //id with * and .. wildcards
    syntax TypeId ::= Type //or id, type includes id

    syntax ModifierList ::= List{Modifier, ""}
    syntax TypePatternDoubleDotList ::= List{TypePatternDoubleDot, ","}
    syntax TypePatternList ::= List{TypePattern, ","}
    syntax TypeIdList ::= List{TypeId, ","}


    syntax OptionalPlus ::= None | "+"
    syntax OptionalTypePatternDot ::=  None | TypePattern "."
    syntax OptionalThrows ::= None | "throws" ThrowsPattern



    syntax Modifier ::= "abstract" | "final" | "interface" | "native" | "private" | "protected" | "public" | "static" | "strict" | "synchronized" | "transient" | "volatile"
    syntax TypePatternDoubleDot ::= TypePattern | ".."

endmodule


module POINTCUT-SYNTAX
    imports ASPECTJ-POINTCUT-SYNTAX

    syntax ExtendedPointCut ::=
                               "thread" "(" Id ")"
                           //| "condition" "(" BoolExpBubble ")"      //later

    syntax OptionalExtendedPointCut ::= None | "&&" ExtendedPointCutList

    syntax ExtendedPointCutList ::= List{ExtendedPointCut, "&&"}

    syntax PointCut ::= AspectJPointCut OptionalExtendedPointCut | ExtendedPointCut OptionalExtendedPointCut

endmodule

