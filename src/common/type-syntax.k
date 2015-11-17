require "domains.k"

module TYPE-SYNTAX
    imports DOMAINS-SYNTAX
    syntax PackageName ::= IdList                           [klabel('PackageName)]
    syntax PackageOrTypeName ::= Id                         [klabel('PackageOrTypeName)]
                           | PackageOrTypeName "." Id   [strict(1), klabel('PackageOrTypeName)]
    syntax TypeName ::= Id                                  [klabel('TypeName)]
                  | PackageOrTypeName "." Id            [strict(1), klabel('TypeName)]
    syntax IdList                    ::= List{Id,"."}


    syntax Dim ::= "[" "]"
    syntax Dims ::= List{Dim, ""}
    syntax ArrayType ::= Type "[" "]"
    syntax Type ::= TypeName | ArrayType

    syntax VarDecId ::= Id Dims

    syntax Param ::= Type VarDecId
    syntax Params                    ::= List{Param, ","}                [klabel('FormalParamList)]

    syntax None ::= ""

    //context 'FormalParamList(HOLE,,_) [result(Param)]
    //context 'FormalParamList(_,,HOLE) [result(Params)]


endmodule