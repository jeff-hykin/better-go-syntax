## How do I setup the project?

Note this guide might be somewhat out of date, don't be afraid to create an issue if something doesn't make sense or doesn't work.

1. Make sure you have `ruby`, `node` and `npm` installed.
2. Make sure you have the ruby bundler `gem install bundler`
3. Clone or fork the repo.
4. Run `npm install`
5. Run `npm test` to make sure everything is working
6. Then inside VS Code, open the `source/generate.rb` file and start the debugger (F5 for windows / Mac OS / Linux)
7. Then, in the new window created by the debugger, open up a Go file, and your changes to the project will show up in the syntax of that file.
8. Every time you make a change inside a `generate.rb`, just press the refresh button on the debugger pop-up to get the new changes.

## Adding a feature
If you believe you've successfully made a change. Create a `your_feature.go` file in the `source/examples`. Once it is created, add Go code to it that demonstrates your feature (more demonstration the better).

# How things work

You can probably look at the code `source/generate.rb` to get a general understanding of everything. The main features are `Pattern.new` and `PatternRange.new`.

General Flow:
*  `source/generate.rb` imports legacy grammer `source/original.tmLanguage.json`
*  `source/generate.rb` creates (using a beta-library) new patterns and sometimes overrides patterns in `source/original.tmLanguage.json`
*  `source/generate.rb` creates a new `export/generated.tmLanguage.json` using those patterns
*  `source/generate.rb` creates a new `export/simplified.tmLanguage.json` which has less problems but also less functionality than the  `generated.json` version

## If you already know about Textmate Grammars 
Here's a small conversion guide. You don't need capture groups anymore, for a single pattern rule:
- captures are replaced with tagging sub expressions (see readable regex tutorial further down)
- scope name `$0` becomes `$match` and `$N` becomes `$reference(name)` (search code for examples)
- `"captures": {"0": {"patterns": [...]}}` is just `includes:`

For begin/end rules:
- `contentName:` is renamed to `tag_content_as:`
- `begin:` is renamed to `start_pattern:`
- `end:` is renamed to `end_pattern:`
- `beginCaptures` and `endCaptures` are replaced with tagged sub-expressions on `start_pattern` and `end_pattern` respectively
- `patterns:` is renamed to `includes`

For both single pattern and begin/end rules:
- `name:` is renamed to `tag_as:`
- use ruby symbols `:repository_name:` instead of `"#repository_name` in `includes:`
- to add a rule to the repository use `go_grammar[:repository_name] = Pattern.new(...)`

## Readable Regex Guide
Regex is pretty hard to read, so this repo uses a library to help.
```ruby
# example 1
grammar[:semicolon] = Pattern.new(
    match: /;/,
    tag_as: "punctuation.terminator.statement",
)
# example 2
grammar[:single_line_statement] = Pattern.new(
    match: Pattern.new(
        Pattern.new(
            match: /.*/, # match anything other than newlines (uses regex for .*)
            tag_as: "meta.single-line",
        ).then(
            grammar[:semicolon]
        )
    ),
    tag_as: "punctuation.terminator.statement",
)
```

### Pattern API
- `Pattern.new(*attributes)` or `.then(*attributes)` creates a new "shy" group
  - example: `Pattern.new(/foo/)` => `/(?:foo)/
- `.or(*attributes)` adds an alternation (`|`)
  - example: `/foo/.or(/bar/)` => `/foo|(?:bar)/`
  - please note you may need more shy groups depending on order
    `/foo/.or(/bar/).maybe(@spaces)` becomes (simplified) `/foo|bar\s*/` not `/(?:foo|bar)\s*/` for that you need
    
    `Pattern.new(/foo/.or(/bar/)).maybe(@spaces)`
- `maybe(*attributes)` or `.maybe(*attributes)` causes the pattern to match zero or one times (`?`)
  - example `maybe(/foo/)` => `/(?:foo)?/`
- `zeroOrMoreTimes(*attributes)` or `.zeroOrMoreTimes(*attributes)` causes the pattern to be matched zero or more times (`*`)
  - example `zeroOrMoreTimes(/foo/)` => `/(?:foo)*/
- `oneOrMoreTimes(*attributes)` or `.oneOrMoreTimes(*attributes)` causes the pattern to be matched one or more times (`+`)
  - example `oneOrMoreTimes(/foo/)` => `/(?:foo)+/
- `lookBehindFor(regex)` or `.lookBehindFor(regex)` add a positive lookbehind
  - example `lookBehindFor(/foo/)` => `/(?<=foo)/
- `lookBehindToAvoid(regex)` or `.lookBehindToAvoid(regex)` add a negative lookbehind
  - example `lookBehindToAvoid(/foo/)` => `/(?<!foo)/
- `lookAheadFor(regex)` or `.lookAheadFor(regex)` add a positive lookahead
  - example `lookAheadFor(/foo/)` => `/(?=foo)/
- `lookAheadToAvoid(regex)` or `.lookAheadToAvoid(regex)` add a negative lookahead
  - example `lookAheadToAvoid(/foo/)` => `/(?!foo)/
- `backreference(reference)` or `.backreference(reference)` adds a backreference
  - example `Pattern.new(match: /foo|bar/, reference: "foobar").backreference("foobar")` => `/(foo|bar)\1/`

helpers that are marked as accepting `*attributes` can accept either a regular expression, a hash that provide more info, or a variable that is either of those.

the hash provided to the helper patterns can have the following keys:
  - `match:` the regular expression that should be matched
  - `tag_as:` the scope-name to give this sub-expression
  - `reference:` a name used to refer to this sub-expression in a `tag_as` or `back_reference`
  - `comment:` unused, use regular ruby comments
  - `should_partial_match`, `should_not_partial_match`, `should_fully_match`, and `should_not_fully_match` see unit testing

look{Ahead,Behind}{ToAvoid,For} helpers only accept regular expressions use `.without_numbered_capture_groups` to convert a pattern to a regular expression

### PatternRange
Things like strings and matching `()`'s need pattern ranges

```ruby
NAME_OF_YOUR_RANGE = PatternRange.new(
    tag_content_as: "meta.NAME_OF_YOUR_RANGE",
    start_pattern: Pattern.new(),
    end_pattern: Pattern.new(),
    includes: [
        # whatever patterns are allowed inbetween the start and end
        Pattern.new(),
        PatternRange.new(),
        # a context
        [
            Pattern.new(),
            PatternRange.new(),
        ]
    ]
)
```

## Testing
### Unit Testing
By supplying one of the unit testing keys to the pattern, you can ensure that pattern only matches what you want it to.

- `should_partial_match` asserts that the pattern matches anywhere in the test strings
- `should_not_partial_match` asserts that the pattern does not match at all in the test strings.
- `should_fully_match` asserts that the pattern matches all the characters in the test strings.
- `should_not_fully_match` asserts that the pattern does not match all the characters in the test strings.
  - note: `should_not_fully_match` does not imply `should_partial_match`, that is a failure to match satisfies `should_not_fully_match` 

## Other Resources
- https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide Visual Studio Code's guide to language grammar
- https://macromates.com/manual/en/language_grammars Textmate's guide to language grammars.
- https://www.sublimetext.com/docs/3/scope_naming.html Sublime Text's guide to textmate scope selection.
- https://www.apeth.com/nonblog/stories/textmatebundle.html More explanation on how grammars are structured.
- https://rubular.com/ Ruby compatible regular expression tester
- https://github.com/stedolan/jq/wiki/Docs-for-Oniguruma-Regular-Expressions-(RE.txt) Documentation for Oniguruma flavored (textmate) regular expressions
- https://github.com/Microsoft/vscode-textmate the Textmate grammar parser for Visual Studio Code
`