require 'json'
require 'yaml'
require 'fileutils'
require 'pathname'

PathFor = {
    root:           __dir__,
    package_json:    File.join(__dir__, "package.json"                                                                    ),
    temp_readme:     File.join(__dir__, "temp_readme.md"                                                                  ),
    generic_readme:  File.join(__dir__, "generic_readme.md"                                                               ),
    readme:          File.join(__dir__, "README.md"                                                                       ),
    textmate_tools:  File.join(__dir__, "library"            , "textmate_tools.rb"                                        ),
    jsonSyntax:      File.join(__dir__, "source"             , "generated.tmLanguage.json"                                ),
    languages:       File.join(__dir__, "source"             , "languages"                                                ),
    svg_helper:      File.join(__dir__, "scripts"            , "helpers"              , "convert_svgs.js"                 ),
    fixtures:        File.join(__dir__, "test"               , "fixtures"                                                 ),
    report:          File.join(__dir__, "test"               , "source"               , "commands"          , "report.js" ),
    linter:          File.join(__dir__, "lint"               , "index.js"                                                 ),
    languageTag:     File.join(__dir__, "source"             , "language_tags.txt"                                        ),
    
    sharedPattern:    ->(pattern_name  ) { File.join(__dir__, "source"                  , "shared_patterns"                , pattern_name+".rb" ) },
}