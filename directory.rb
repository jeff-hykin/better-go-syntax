require 'json'
require 'yaml'
require 'fileutils'
require 'pathname'

PathFor = {
    root:                  Pathname.new(__dir__),
    package_json:          Pathname.new(File.join(__dir__, "package.json"                                                                    )),
    temp_readme:           Pathname.new(File.join(__dir__, "temp_readme.md"                                                                  )),
    generic_readme:        Pathname.new(File.join(__dir__, "generic_readme.md"                                                               )),
    readme:                Pathname.new(File.join(__dir__, "README.md"                                                                       )),
    textmate_tools:        Pathname.new(File.join(__dir__, "library"            , "textmate_tools.rb"                                        )),
    jsonSyntax:            Pathname.new(File.join(__dir__, "source"             , "generated.tmLanguage.json"                                )),
    simplifiedJsonSyntax:  Pathname.new(File.join(__dir__, "source"             , "simplified.tmLanguage.json"                               )),
    languages:             Pathname.new(File.join(__dir__, "source"             , "languages"                                                )),
    svg_helper:            Pathname.new(File.join(__dir__, "scripts"            , "helpers"              , "convert_svgs.js"                 )),
    fixtures:              Pathname.new(File.join(__dir__, "test"               , "fixtures"                                                 )),
    report:                Pathname.new(File.join(__dir__, "test"               , "source"               , "commands"          , "report.js" )),
    linter:                Pathname.new(File.join(__dir__, "lint"               , "index.js"                                                 )),
    languageTag:           Pathname.new(File.join(__dir__, "source"             , "language_tags.txt"                                        )),
    
    sharedPattern:    ->(pattern_name  ) { File.join(__dir__, "source"                  , "shared_patterns"                , pattern_name+".rb" ) },
}