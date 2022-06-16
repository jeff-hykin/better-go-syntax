# frozen_string_literal: true
require 'ruby_grammar_builder'
require 'walk_up'
require_relative walk_up_until("paths.rb")



grammar = Grammar.new_exportable_grammar
grammar.external_repos = [ # patterns that are imported
]
grammar.exports = [ # patterns that are exported
    :member_access,
    :method_access,
]


first_character              = Pattern.new(/[a-zA-Z_]/)
subsequent_character         = Pattern.new(/[a-zA-Z0-9_]/)
variable_name_without_bounds = first_character.then(zeroOrMoreOf(subsequent_character))

dot_operator = Pattern.new(
    match: /\./,
    tag_as: "punctuation.separator.dot-access"
)
subsequent_object_with_operator = Pattern.new(
    variable_name_without_bounds.maybe(@spaces).then(dot_operator.groupless).maybe(@spaces)
)


# pattern generator
generatePartialMemberFinder = ->(tag_name) do
    Pattern.new(
            match: variable_name_without_bounds.or(lookBehindFor(/\]|\)/)).maybe(@spaces),
            tag_as: tag_name,
    ).then(
        dot_operator
    )
end

partial_member = generatePartialMemberFinder["variable.other.object.access"]
member_start = Pattern.new(
    partial_member.then(
        match: zeroOrMoreOf(subsequent_object_with_operator.groupless),
        includes: [
            mid_member = Pattern.new(
                match: lookBehindFor(dot_operator).maybe(
                    @spaces
                ).then(
                    generatePartialMemberFinder["variable.other.object.property"]
                )
            ),
            partial_member,
            :method_access,
            :member_access,
        ],
    ).maybe(@spaces)
)
# access to attribute
grammar[:member_access] = Pattern.new(
    member_start.then(
        match: @word_boundary.then(variable_name_without_bounds).then(@word_boundary).lookAheadToAvoid(/\(/),
        tag_as: "variable.other.property"
    )
)
# access to method
grammar[:method_access] = PatternRange.new(
    start_pattern: member_start.then(
            # the ~ is for destructors
            match: variable_name_without_bounds,
            tag_as: "entity.name.function.member"
        ).maybe(@spaces).then(
            match: /\(/,
            tag_as: "punctuation.section.arguments.bracket.round.function.member"
        ),
    end_pattern: Pattern.new(
            match: /\)/,
            tag_as: "punctuation.section.arguments.bracket.round.function.member"
        ),
    includes: [
        :$initial_context
    ],
)