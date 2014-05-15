# encoding: utf-8

require 'rexml/document'

class Table
	attr_reader :name, :data

	def initialize(pConcept, pXMLdata)
		@concept=pConcept
		@name=""

		@data={}
		@data[:fields]=[]
		@data[:title]=[]
		@data[:rows]=[]
		
		@data[:fields]=pXMLdata.attributes['fields'].to_s.strip.split(',')
		@data[:fields].each { |i| i.strip! }
		@data[:fields].each { |i| @name=@name+"$"+i.to_s.strip.downcase} 
		
		pXMLdata.elements.each do |i|
			if i.name=='title' then
				@data[:title] << i.text.strip
			elsif i.name=='row' then
				row=[]
				i.elements.each { |j| row << j.text.to_s}
				@data[:rows] << row
			else
				puts "[ERROR] XMLdata with #{i.name}"
			end
		end
	end
	
	def fields
		return @data[:fields]
	end
	
	def rows
		return @data[:rows]
	end
	
	def to_s
		@name.to_s
	end
	
end	
