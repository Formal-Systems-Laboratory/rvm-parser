// based on https://eclipse.org/aspectj/doc/released/progguide/semantics-advice.html
require "pointcut-syntax.k"

module ADVICE-CCOMMON
    imports POINTCUT-CCOMMON

   syntax AdviceHeader ::= OptionalAdviceModifier AdviceSpec OptionalAdviceThrows ":" PointCut

   syntax OptionalAdviceModifier
   syntax AdviceSpec
   syntax OptionalAdviceThrows


endmodule


module ADVICE-SYNTAX
    imports ADVICE-CCOMMON
    imports POINTCUT-SYNTAX

       syntax AdviceSpec ::=   "before" "(" Formals")"
                  | "after" "(" Formals ")" OptionalReturningThrowing
                  | Type "around" "(" Formals ")"

       syntax Formal ::= Type Id

       syntax OptionalAdviceModifier ::= None | "strictfp"
       syntax OptionalAdviceThrows ::= None | "throws" TypeList
       syntax OptionalReturningThrowing ::= None | "returning" OptionalFormal  | "throwing" OptionalFormal
       syntax OptionalFormal ::= None | "(" Formal ")"


       syntax Formals ::= List{Formal, ","} [klabel('Formals)]
       syntax TypeList ::= List{Type, ","}  [klabel('TypeList)]
endmodule