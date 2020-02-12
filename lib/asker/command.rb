#!/usr/bin/ruby

require 'rainbow'
require 'thor'
require_relative 'application'
require_relative 'tool'

module Asker
  ##
  # Command Line User Interface
  class Command < Thor
    map ['h', '-h', '--help'] => 'help'

    map ['f', '-f', '--file'] => 'file'
    desc 'file NAME', 'Build output files, from HAML/XML input file.'
    option :color, type: :boolean
    long_desc <<-LONGDESC
    Create output files, from input file (HAML/XML format).

    Build questions about contents defined into input file specified.

    Examples:

    1) #{Rainbow('asker input/foo/foo.haml').yellow}, Build questions from HAML file.\n
    2) #{Rainbow('asker input/foo/foo.xml').yellow}, Build questions from XML file.\n
    3) #{Rainbow('asker file --no-color input/foo/foo.haml').yellow}, Same as (1) but without colors.\n
    4) #{Rainbow('asker projects/foo/foo.yaml').yellow}, Build questions from YAML project file.\n

    LONGDESC
    def file(filename)
      Rainbow.enabled = false if options['color'] == false
      Tool.new.start(filename)
    end

    def method_missing(method, *_args, &_block)
      file(method.to_s)
    end

    map ['v', '-v', '--version'] => 'version'
    desc 'version', 'show the program version'
    def version
      print Rainbow(Application::NAME).bright.blue
      puts  " (version #{Rainbow(Application::VERSION).green})"
    end
  end
end