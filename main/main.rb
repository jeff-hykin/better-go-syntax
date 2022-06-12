# frozen_string_literal: true
require 'ruby_grammar_builder'
require 'walk_up'
require_relative walk_up_until("paths.rb")
require_relative './tokens.rb'

# 
# 
# create grammar!
# 
# 
grammar = Grammar.fromTmLanguage(__dir__+"/modified.tmLanguage.json")

# 
#
# Setup Grammar
#
# 
    grammar[:$initial_context] = [
        :comments,
        :interpreted_string_literals,
        :raw_string_literals,
        :syntax_error_receiving_channels,
        :syntax_error_sending_channels,
        :syntax_error_using_slices,
        :syntax_error_numeric_literals,
        :built_in_functions,
        :function_declarations,
        :functions,
        :numeric_literals,
        :language_constants,
        :anonymous_pattern_1,
        :anonymous_pattern_2,
        :import_statement,
        :anonymous_pattern_4,
        :anonymous_pattern_5,
        :anonymous_pattern_6,
        :terminators,
        :brackets,
        :delimiters,
        :keywords,
        :operators,
        :runes,
        :storage_types,
    ]

# 
# Helpers
# 
    # @space
    # @spaces
    # @digit
    # @digits
    # @standard_character
    # @word
    # @word_boundary
    # @white_space_start_boundary
    # @white_space_end_boundary
    # @start_of_document
    # @end_of_document
    # @start_of_line
    # @end_of_line
    part_of_a_variable = /[a-zA-Z_][a-zA-Z_0-9]*/
    # this is really useful for keywords. eg: variableBounds[/new/] wont match "newThing" or "thingnew"
    variableBounds = ->(regex_pattern) do
        lookBehindToAvoid(@standard_character).then(regex_pattern).lookAheadToAvoid(@standard_character)
    end
    variable = variableBounds[part_of_a_variable]

# 
# imports
# 
    grammar.import(PathFor[:pattern]["numeric_literals"])
# 
# basic patterns
# 
    # 
    # comments
    # 
        grammar[:comments] = [
            # comments like this /* imma comment */
            PatternRange.new(
                tag_as: "comment.block",
                start_pattern: Pattern.new(
                    match: /\/\*/,
                    tag_as: 'punctuation.definition.comment'
                ),
                end_pattern: Pattern.new(
                    match: /\*\//,
                    tag_as: 'punctuation.definition.comment'
                ),
            ),
            # comments like this // imma comment
            PatternRange.new(
                tag_as: "comment.line.double-slash",
                start_pattern: Pattern.new(
                    match: /\/\//,
                    tag_as: "punctuation.definition.comment",
                ),
                end_pattern: @end_of_line,
            )
        ]
    # 
    # import_statement
    # 
        # "anonymous_pattern_3": {
        #     "begin": "\\b(import)\\s+",
        #     "beginCaptures": {
        #         "1": {
        #             "name": "keyword.import.go"
        #         }
        #     },
        #     "end": "(?!\\G)",
        #     "patterns": [
        #         {
        #             "include": "#imports"
        #         }
        #     ]
        # },
        grammar[:import_statement] = PatternRange.new(
            start_pattern: Pattern.new(
                Pattern.new(
                    match: /\bimport/,
                    tag_as: "keyword.import",
                    # unit tests
                    should_fully_match: [ "import" ],
                    should_not_partial_match: [ "_import" ],
                ).then(@spaces)
            ),
            end_pattern: lookAheadToAvoid(/\G/), # \G is the start of the start pattern... I'm not sure why/how this makes this PatternRange work -- Jeff
            includes: [
                :imports,
            ]
        )
        grammar[:imports] = [
            # {
            #     "begin": "\\(",
            #     "beginCaptures": {
            #         "0": {
            #             "name": "punctuation.definition.imports.begin.bracket.round.go"
            #         }
            #     },
            #     "end": "\\)",
            #     "endCaptures": {
            #         "0": {
            #             "name": "punctuation.definition.imports.end.bracket.round.go"
            #         }
            #     },
            #     "patterns": [
            #         {
            #             "include": "#comments"
            #         },
            #         {
            #             "include": "#imports"
            #         }
            #     ]
            # }
            PatternRange.new(
                start_pattern: Pattern.new(
                    match: /\(/,
                    tag_as: "punctuation.definition.imports.begin.bracket.round",
                ),
                end_pattern: Pattern.new(
                    match: /\)/,
                    tag_as: "punctuation.definition.imports.begin.bracket.round",
                ),
                includes: [
                    :comments,
                    :imports, # recursive? this seems weird -- Jeff
                ]
            ),
            
            # presumably an alias
            # {
            #     "match": "((?!\\s+\")[^\\s]*)?\\s*((\")([^\"]*)(\"))",
            #     "captures": {
            #         "1": {
            #             "name": "entity.alias.import.go"
            #         },
            #         "2": {
            #             "name": "string.quoted.double.go"
            #         },
            #         "3": {
            #             "name": "punctuation.definition.string.begin.go"
            #         },
            #         "4": {
            #             "name": "entity.name.import.go"
            #         },
            #         "5": {
            #             "name": "punctuation.definition.string.end.go"
            #         }
            #     }
            # },
            Pattern.new(
                # from: ((?!\\s+\")([^\\s]*))?
                maybe( # this maybe() doesn't make sense to me, idk whats being avoided
                    
                    # from: (?!\\s+\")
                    lookAheadToAvoid(
                        Pattern.new(@spaces).then(/"/)
                    # from: ([^\\s]*)
                    ).then(
                        match: zeroOrMoreOf(/[^\s]/), # this doesnt seem like a great pattern to me, should probably be more exclusive  -- Jeff
                        tag_as: "entity.alias.import",
                    )
                # from: \\s*
                ).maybe(
                    @spaces
                # from: ((\")([^\"]*)(\"))
                ).then(
                    tag_as: "string.quoted.double",
                    match: Pattern.new(
                        # from: (\")
                        Pattern.new(
                            match: /"/,
                            tag_as: "punctuation.definition.string.begin",
                        # from: ([^\"]*)
                        ).then(
                            match: zeroOrMoreOf(/[^"]/),  # this doesnt seem like a great pattern to me, should probably be more exclusive -- Jeff
                            tag_as: "entity.name.import",
                        # from: (\")
                        ).then(
                            match: /"/,
                            tag_as: "punctuation.definition.string.end",
                        ),
                    )
                )
            ),
        ]
    
#
# Save
#
grammar.save_to(
    syntax_name: "Go",
    syntax_dir: "./autogenerated",
    tag_dir: "./autogenerated",
)