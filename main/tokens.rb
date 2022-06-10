require_relative '../directory'
require_relative PathFor[:textmate_tools]

# 
# These are leftover from the Perl syntax, to give you an idea of how they're used
# 
tokens = [
    # arithmetic,
    { representation: "+",    areOperators: true, areArithmeticOperators: true },
    { representation: "-",    areOperators: true, areArithmeticOperators: true },
    { representation: "*",    areOperators: true, areArithmeticOperators: true },
    { representation: "/",    areOperators: true, areArithmeticOperators: true },
    { representation: "**",   areOperators: true, areArithmeticOperators: true },
    { representation: "%",    areOperators: true, areArithmeticOperators: true },
    # arithmetic assignment,
    { representation: "+=",   areOperators: true, areArithmeticOperators: true, areAssignmentOperators: true },
    { representation: "-=",   areOperators: true, areArithmeticOperators: true, areAssignmentOperators: true },
    { representation: "*=",   areOperators: true, areArithmeticOperators: true, areAssignmentOperators: true },
    { representation: "/=",   areOperators: true, areArithmeticOperators: true, areAssignmentOperators: true },
    { representation: "**=",  areOperators: true, areArithmeticOperators: true, areAssignmentOperators: true },
    { representation: "%=",   areOperators: true, areArithmeticOperators: true, areAssignmentOperators: true },
    { representation: "--",   areOperators: true, areArithmeticOperators: true, },
    { representation: "++",   areOperators: true, areArithmeticOperators: true, },
    # comparison,
    { representation: "==",   areOperators: true, areComparisonOperators: true },
    { representation: "!=",   areOperators: true, areComparisonOperators: true },
    { representation: ">",    areOperators: true, areComparisonOperators: true },
    { representation: "<",    areOperators: true, areComparisonOperators: true },
    { representation: ">=",   areOperators: true, areComparisonOperators: true },
    { representation: "<=",   areOperators: true, areComparisonOperators: true },
    { representation: "<=>",  areOperators: true, areComparisonOperators: true },
    { representation: "=~",   areOperators: true, areComparisonOperators: true },
    { representation: "!~",   areOperators: true, areComparisonOperators: true },
    # logical operators,
    { representation: "&&",   areOperators: true, areLogicalOperators: true },
    { representation: "and",  areOperators: true, areLogicalOperators: true, areOperatorAliases: true },
    { representation: "||",   areOperators: true, areLogicalOperators: true },
    { representation: "or",   areOperators: true, areLogicalOperators: true, areOperatorAliases: true },
    { representation: "//",   areOperators: true, areLogicalOperators: true },
    # bitwise,
    { representation: "<<",   areOperators: true, areBitwiseOperators: true },
    { representation: ">>",   areOperators: true, areBitwiseOperators: true },
    { representation: "&",    areOperators: true, areBitwiseOperators: true },
    { representation: "|",    areOperators: true, areBitwiseOperators: true },
    { representation: "^",    areOperators: true, areBitwiseOperators: true },
    { representation: "<<=",  areOperators: true, areBitwiseOperators: true, areAssignmentOperators: true },
    { representation: ">>=",  areOperators: true, areBitwiseOperators: true, areAssignmentOperators: true },
    { representation: "&=",   areOperators: true, areBitwiseOperators: true, areAssignmentOperators: true },
    { representation: "|=",   areOperators: true, areBitwiseOperators: true, areAssignmentOperators: true },
    { representation: "^=",   areOperators: true, areBitwiseOperators: true, areAssignmentOperators: true },
    # assignment,
    { representation: "=",    areOperators: true, areAssignmentOperators: true },
    # other
    { representation: ".",    areOperators: true },
    { representation: ".=",   areOperators: true, areAssignmentOperators: true },
]

@tokens = TokenHelper.new tokens, for_each_token: ->(each) do 
    # isSymbol, isWordish
    if each[:representation] =~ /[a-zA-Z0-9_]/
        each[:isWordish] = true
    else
        each[:isSymbol] = true
    end
end