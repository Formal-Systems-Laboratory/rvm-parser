require "type-syntax.k"

module PACKAGE-SYNTAX
	imports TYPE-SYNTAX

syntax ImportDec ::= "import" TypeName                  ";"  [klabel('TypeImportDec)]
                   | "import" PackageName       "." "*" ";"  [klabel('TypeImportOnDemandDec)]
                   | "import" "static" TypeName "." Id  ";"  [klabel('StaticImportDec)]
                   | "import" "static" TypeName "." "*" ";"  [klabel('StaticImportOnDemandDec)]

//                   //for c code
                   | "#include" "<" Id ".h" ">" [klabel('CInclude1)]
                   | "#include" "\"" Id ".h" "\"" [klabel('CInclude2)]


syntax PackageDec ::=  "package" PackageName ";"     [klabel('PackageDec)]
syntax OptionalPackageDec ::= PackageDec | None
syntax None

syntax ImportDecList             ::= List{ImportDec,""} [klabel('ImportDecList)]

endmodule