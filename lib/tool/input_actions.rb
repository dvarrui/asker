#!/usr/bin/ruby
# encoding: utf-8

require 'haml'
require 'rexml/document'

module InputActions

  def load_input_files
    project=Project.instance
    project.verbose "\n[INFO] Loading input data..."

    inputdirs = project.inputdirs.split(',')
    inputdirs.each do |dirname|
      if !Dir.exists? dirname then
        msg "["+Rainbow(ERROR).color(:red)+"] <#{Rainbow(dirname).color(:red)}> directory dosn't exist!"
        project.verboseln msg
        raise msg
      end

      files=(Dir.new(dirname).entries-[".",".."]).sort
      accepted = files.select { |f| f[-4..-1]==".xml" || f[-5..-1]==".haml" } # accept only HAML or XML files
      project.verbose " * Input directory: #{Rainbow(dirname).bright}"

      flag = accepted.last
      accepted.each do |f|
        pFilename=dirname+'/'+f
        if pFilename[-5..-1]==".haml" then
          template = File.read(pFilename)
          haml_engine = Haml::Engine.new(template)
          lFileContent = haml_engine.render
        else
          lFileContent=open(pFilename) { |i| i.read }
        end

        begin
          if flag==f then
            project.verbose "   └── Input file : #{Rainbow(pFilename).bright}..."
          else
            project.verbose "   ├── Input file : #{Rainbow(pFilename).bright}..."
          end

          lXMLdata=REXML::Document.new(lFileContent)
          #system("echo '#{lFileContent}' > output/#{f}.xml")

          begin
            lLang=lXMLdata.root.attributes['lang'] # has lang attribute or not?
            lContext=lXMLdata.root.attributes['context']
		      rescue
		        lLang=project.lang
		        lContext="unknown"
		      end

          lXMLdata.root.elements.each do |xmldata|
            if xmldata.name=='concept' then
              c=Concept.new(xmldata,pFilename,lLang,lContext)
              if ( project.process_file==:default or project.process_file==f.to_s ) then
                c.process=true
              end
              @concepts[c.name]=c
            end
          end
        rescue REXML::ParseException
          msg = Rainbow("[ERROR] Format error in file ").red+Rainbow(pFilename).red.bright+Rainbow("! (Module InputActions#load_input_files)").red
          project.verbose msg
          system("echo '#{lFileContent}' > output/error.xml")
          raise msg
        end
      end
    end

    #find neighbors for every concept
    @concepts.each_value do |i|
      @concepts.each_value do |j|
        if (i.id!=j.id) then
          i.try_adding_neighbor j
        end
      end
    end
  end
end
