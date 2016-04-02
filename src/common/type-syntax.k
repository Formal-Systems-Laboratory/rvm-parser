require "domains.k"

module TYPE-SYNTAX
    imports DOMAINS-SYNTAX
    //syntax PackageName ::= IdList                           [klabel('PackageName)]
    //syntax PackageOrTypeName ::= Id                         [klabel('PackageOrTypeName)]
    //                       | PackageOrTypeName "." Id   [strict(1), klabel('PackageOrTypeName)]
    //syntax TypeName ::= Id                                  [klabel('TypeName), avoid] //TODO: added avoid to resolve amb with K internal syntax in rules
    //              | PackageOrTypeName "." Id            [strict(1), klabel('TypeName)]

    syntax PackageName ::= Id                            [klabel('PackageNameSingle), avoid]
                            | PackageName "." Id [strict(1), klabel('PackageNameMulti), avoid]
    syntax TypeName ::=  Id [klabel('TypeNameSingle), avoid]
				| TypeName "." Id [klabel('TypeNameMulti), avoid]

//PackageName  [klabel('TypeName)]



    syntax IdList                    ::= List{Id,"."}   [klabel('IdList)]


    syntax Dim ::= "[" "]"
    syntax Dims ::= List{Dim, ""}
    syntax ArrayType ::= Type "[" "]"
    syntax Type ::= TypeName | ArrayType

    syntax VarDecId ::= Id Dims

    syntax Param ::= Type VarDecId
    syntax Params                    ::= List{Param, ","}                [klabel('FormalParamList)]


    //context 'FormalParamList(HOLE,,_) [result(Param)]
    //context 'FormalParamList(_,,HOLE) [result(Params)]


endmodule
