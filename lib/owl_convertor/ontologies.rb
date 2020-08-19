require 'rubygems'
require 'yaml'
require 'nokogiri'
require 'xml/xslt'
require 'fileutils'
require File.expand_path('../base.rb', __FILE__)

module OwlConvertor
  class Ontologies < Base
    def initialize(output_dir)
      super
    end

    def get_output_filepath(resource_name, base_dir)
      output_dir =  base_dir
      FileUtils.mkdir_p(output_dir) unless File.exist?(output_dir)
      "#{output_dir}/#{resource_name}.html"
    end

    def minimalize_owl(input_owl_file, output_owl_file)
      system("grep -n '</owl:Ontology>' #{input_owl_file} | cut -d':' -f1 | xargs -Ixxx head -n xxx #{input_owl_file} > #{output_owl_file}")
      system("echo '</rdf:RDF>' >> #{output_owl_file}")
    end

    def owl2html_top_contents(owl_file)
      @xslt.xml = owl_file
      # Multiple resources may be included in one page, so write in additional mode. ex. "Sequnce", "sequence"(Can't save separate files)
      File.open(get_output_filepath("index", @output_html_content_dir), "a") do |file|
        file.puts @xslt.serve()
      end
    end

    def convert(owl_file)
      if (owl_file.include?("taxonomy"))
        @setting = YAML.load(File.read(File.expand_path("../../../config/taxonomy.yml", __FILE__)))
      else
        @setting = YAML.load(File.read(File.expand_path("../../../config/nucleotide.yml", __FILE__)))
      end
      @xslt = XML::XSLT.new()
      @xslt.xsl = File.expand_path("../../../templates/#{@setting['xslfile_name']}", __FILE__)

      file_name = File.basename(owl_file)
      minimalize_owl(owl_file, @output_dir + "/" + file_name)
      owl2html_top_contents(@output_dir + "/" + file_name)
    end
  end
end
