# encoding: utf-8
require 'singleton'

class Project
  include Singleton
  attr_accessor :param

  def initialize
    @param={}
    @param[:inputbasedir]    = "input"
    @param[:outputdir]       = "output"
    @param[:category]        = :none
    @param[:formula_weights] = [1,1,1]
    @param[:lang]            = 'en'
    @param[:show_mode]       = :default
    @param[:verbose]         = true
  end

  def fill_param_with_values
    #We need at least process_file and inputdirs params
    ext = ".haml"

    @param[:process_file] = @param[:process_file] || @param[:projectdir].split(File::SEPARATOR).last + ext
    @param[:projectname]  = @param[:projectname]  || File.basename( @param[:process_file], ext)
    @param[:inputdirs]    = @param[:inputdirs]    || File.join( @param[:inputbasedir], @param[:projectdir] )

    @param[:logname]      = @param[:logname]      || "#{@param[:projectname]}-log.txt"
    @param[:outputname]   = @param[:outputname]   || "#{@param[:projectname]}-gift.txt"
    @param[:lessonname]   = @param[:lessonname]   || "#{@param[:projectname]}-doc.txt"

    @param[:logpath]      = @param[:logpath]      || File.join( @param[:outputdir], @param[:logname] )
    @param[:outputpath]   = @param[:outputpath]   || File.join( @param[:outputdir], @param[:outputname] )
    @param[:lessonpath]   = @param[:lessonpath]   || File.join( @param[:outputdir], @param[:lessonname] )

    create_log_file
  end

  def method_missing(m, *args, &block)
    return @param[m]
  end

  def verbose(lsText)
    puts lsText
    @logfile.write(lsText.to_s+"\n") if @logfile
  end

  def verboseln(lsText)
    verbose(lsText+"\n")
  end

  def create_log_file
    #create or reset logfile
    Dir.mkdir(@param[:outputdir]) if !Dir.exists? @param[:outputdir]

    @param[:logfile] = File.open(@param[:logpath],'w')
    @param[:logfile].write("="*50+"\n")
    @param[:logfile].write("Generated by #{Application::name} (version #{Application::version})\n")
    @param[:logfile].write("File : #{@param[:logname]}\n")
    @param[:logfile].write("Time : "+Time.new.to_s+"\n")
    @param[:logfile].write("="*50+"\n")
  end

  def close
    @param[:logfile].close
  end
end
