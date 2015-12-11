require "type-syntax.k"

module PACKAGE-CCOMMON
    imports TYPE-CCOMMON
    syntax OptionalPackageDec
    syntax ImportDecList
endmodule

module PACKAGE-SYNTAX
    imports PACKAGE-CCOMMON
	imports TYPE-SYNTAX


syntax ImportDec ::= "import" TypeName                  ";"  [klabel('TypeImportDec)]
                   | "import" PackageName       "." "*" ";"  [klabel('TypeImportOnDemandDec)]
                   | "import" "static" TypeName "." Id  ";"  [klabel('StaticImportDec)]
                   | "import" "static" TypeName "." "*" ";"  [klabel('StaticImportOnDemandDec)]

syntax PackageDec ::=  "package" PackageName ";"     [klabel('PackageDec)]
syntax OptionalPackageDec ::= PackageDec | None
syntax None

syntax ImportDecList             ::= List{ImportDec,""} [klabel('ImportDecList)]

endmodule