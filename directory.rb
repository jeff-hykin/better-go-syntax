require 'json'
require 'yaml'
require 'fileutils'
require 'pathname'

PathFor = {
    root:                  Pathname.new(__dir__),
    package_json:          Pathname.new(File.join(__dir__, "package.json"                                                                    )),
    readme:                Pathname.new(File.join(__dir__, "README.md"                                                                       )),
    textmate_tools:        Pathname.new(File.join(__dir__, "library"            , "textmate_tools.rb"                                        )),
    jsonSyntax:            Pathname.new(File.join(__dir__, "export"             , "generated.tmLanguage.json"                                )),
    simplifiedJsonSyntax:  Pathname.new(File.join(__dir__, "export"             , "simplified.tmLanguage.json"                               )),
    languageTag:           Pathname.new(File.join(__dir__, "source"             , "language_tags.txt"                                        )),
    
    sharedPattern:    ->(pattern_name  ) { File.join(__dir__, "source"                  , "shared_patterns"                , pattern_name+".rb" ) },
}