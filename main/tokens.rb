require "walk_up"
require_relative walk_up_until("paths.rb")
require_relative PathFor[:textmate_tools]

# 
# Create tokens
#
# (these are from C++)
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

# automatically add some adjectives (functional adjectives)
@tokens = TokenHelper.new tokens, for_each_token: ->(each) do 
    # isSymbol, isWordish
    if each[:representation] =~ /[a-zA-Z0-9_]/
        each[:isWordish] = true
    else
        each[:isSymbol] = true
    end
    # isWord
    if each[:representation] =~ /\A[a-zA-Z_][a-zA-Z0-9_]*\z/
        each[:isWord] = true
    end
    
    if each[:isTypeSpecifier] or each[:isStorageSpecifier]
        each[:isPossibleStorageSpecifier] = true
    end
end