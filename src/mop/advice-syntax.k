// based on https://eclipse.org/aspectj/doc/released/progguide/semantics-advice.html
require "pointcut-syntax.k"

module ADVICE-SYNTAX
    imports POINTCUT-SYNTAX

   syntax AdviceHeader ::= OptionalAdviceModifier AdviceSpec OptionalAdviceThrows ":" PointCut

   syntax AdviceSpec ::=   "before" "(" Formals")"
              | "after" "(" Formals ")" OptionalReturningThrowing
              | Type "around" "(" Formals ")"

   syntax Formal ::= Type Id

   syntax OptionalAdviceModifier ::= None | "strictfp"
   syntax OptionalAdviceThrows ::= None | "throws" TypeList
   syntax OptionalReturningThrowing ::= None | "returning" OptionalFormal  | "throwing" OptionalFormal
   syntax OptionalFormal ::= None | "(" Formal ")"


   syntax Formals ::= List{Formal, ","}
   syntax TypeList ::= List{Type, ","}


endmodule
