// based on https://eclipse.org/aspectj/doc/released/progguide/semantics-pointcuts.html
// with slight modifications
require "../common/type-syntax.k"
require "../common/java-bubble-syntax.k"


module ASPECTJ-POINTCUT-SYNTAX
    imports TYPE-SYNTAX
    imports JAVA-BUBBLE-SYNTAX

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
                        | "args" "(" TypeIdDoubleDotStarList ")" //the website first says it is type or id, but then says it can also be * or ..
                        //| "PointcutId" "("TypePattern or Id, ...")"
                        | "if" "(" BoolExpBubble ")"
                        | "!" AspectJPointCut                   [klabel('AJPointCutNot)]
                        | AspectJPointCut "&&" AspectJPointCut  [left, klabel('AJPointCutAnd)]
                        | AspectJPointCut "||" AspectJPointCut  [left, klabel('AJPointCutOr)]
                        | "(" AspectJPointCut ")"       [bracket]
    syntax priority 'AJPointCutNot > 'AJPointCutAnd > 'AJPointCutOr

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
    syntax TypeId ::= Type //| id (type includes id)
    syntax TypeIdDoubleDotStar ::= TypeId | ".." | "*"

    syntax ModifierList ::= List{JavaModifier, ""}
    syntax TypePatternDoubleDotList ::= List{TypePatternDoubleDot, ","}
    syntax TypePatternList ::= List{TypePattern, ","}
    syntax TypeIdList ::= List{TypeId, ","}
    syntax TypeIdDoubleDotStarList ::= List{TypeIdDoubleDotStar, ","}


    syntax OptionalPlus ::= None | "+"
    syntax OptionalTypePatternDot ::=  None | TypePattern "."
    syntax OptionalThrows ::= None | "throws" ThrowsPattern




    syntax TypePatternDoubleDot ::= TypePattern // | ".." (typepattern includes id and id includes .. - it is also possible to add this and require IdPattern not to start with ..)

endmodule


module POINTCUT-SYNTAX
    imports ASPECTJ-POINTCUT-SYNTAX

    syntax ExtendedPointCut ::=
                               "thread" "(" Id ")"
                             | "condition" "(" BoolExpBubble ")"
                             | "startThread" "(" ")" //it was not in http://fsl.cs.illinois.edu/index.php/JavaMOP4_Syntax but it was in some specifications in property-db

    syntax OptionalExtendedPointCut ::= None | "&&" ExtendedPointCutList

    syntax ExtendedPointCutList ::= List{ExtendedPointCut, "&&"}

    syntax PointCut ::= AspectJPointCut OptionalExtendedPointCut | ExtendedPointCut OptionalExtendedPointCut

endmodule

