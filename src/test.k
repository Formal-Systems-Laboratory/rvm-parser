require "domains.k"


module TEST
	imports DOMAINS-SYNTAX

	syntax LTLFormula ::=
		  "empty"
         | "o" LTLFormula 	[klabel('LTLO)]
	syntax Param ::= Id Id [klabel('Param)]

endmodule


