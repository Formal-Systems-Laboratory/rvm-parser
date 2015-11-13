//Work in progress

module CLASS-SYNTAX
    syntax ClassMemberDec ::= FieldDec | ClassDec | MethodDec | InterfaceDec | SemiColon


syntax ClassDecHead ::=
    ClassModList "class" Id OptionalTypeParams OptionalSuper OptionalInterfaces
                                                                        [klabel('ClassDecHead)]
syntax ClassBody ::= BlockBubble                           [klabel('ClassBody)]

syntax ClassDec ::= ClassDecHead ClassBody                              [klabel('ClassDec)]
syntax ClassDec ::= EnumDec

syntax ClassMod ::= "public" | "private" | "protected" | "abstract" | "final" | "static" | "strictfp"



syntax Super ::= "extends" JavaClassType                                [klabel('SuperDec)]
syntax Interfaces ::= "implements" InterfaceTypeList                    [klabel('ImplementsDec)]






syntax SemiColon ::= ";"                                                [klabel('SemiColon)]





syntax EnumDecHead ::= AnnoClassModList "enum" Id OptionalInterfaces    [klabel('EnumDecHead)]
syntax EnumBody ::= BlockBubble
syntax EnumDec ::= EnumDecHead EnumBody                                 [klabel('EnumDec)]



//@ \subsection{FieldDeclarations.sdf}
syntax FieldDec ::= AnnoFieldModList Type VarDecList ";"                [klabel('FieldDec)]

syntax VarDec ::= VarDecId                                              [klabel('VarDec)]
                | VarDecId "=" VarInit                                  [klabel('VarDec)]

syntax VarDecId ::= Id | Id Dims                                        [klabel('ArrayVarDecId)]

syntax VarInit ::= Exp | ArrayInit

syntax FieldMod ::= Public
                  | Private
                  | Protected
                  | Final
                  | Static
                  | Transient
                  | Volatile

syntax AnnoFieldMod ::= Anno | FieldMod


//@ \subsection{MethodDeclarations.sdf}
syntax MethodDecHead ::=
    AnnoMethodModList OptionalTypeParams Type Id "(" Params ")" OptionalThrows
                                                                        [klabel('MethodDecHead)]
syntax MethodBody ::= Block | ";"                                       [klabel('NoMethodBody)]
syntax MethodDec ::= MethodDecHead MethodBody                           [klabel('MethodDec)]

syntax Param ::= AnnoVarModList Type VarDecId                           [strict(2), klabel('Param)]
syntax Param ::= AnnoVarModList Type "..." VarDecId                     [klabel('VarArityParam)]

syntax Throws ::= "throws" ExceptionTypeList                            [klabel('ThrowsDec)]

syntax ExceptionType ::= JavaClassType

syntax MethodMod ::= Public
                   | Private
                   | Protected
                   | Abstract
                   | Final
                   | Static
                   | Native
                   | Synchronized
                   | StrictFP

syntax AnnoMethodMod ::= Anno | MethodMod

syntax VarMod ::= Final

syntax AnnoVarMod ::= Anno | VarMod


//@ \subsection{InstanceInitializers.sdf}
syntax InstanceInit ::= Block                                           [klabel('InstanceInit)]


//@ \subsection{StaticInitializers.sdf}
syntax StaticInit ::= "static" Block                                    [klabel('StaticInit)]
syntax Block

endmodule