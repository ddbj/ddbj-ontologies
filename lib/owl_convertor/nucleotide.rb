require 'rubygems'
require 'yaml'
require 'nokogiri'
require 'xml/xslt'
require 'fileutils'
require File.expand_path('../base.rb', __FILE__)

module OwlConvertor
  class Nucleotide < Base
    def initialize(output_dir)
      super
      @setting = YAML.load(File.read(File.expand_path("../../../config/nucleotide.yml", __FILE__)))
      #XSLT
      @xslt = XML::XSLT.new()
      @xslt.xsl = File.expand_path("../../../templates/#{@setting['xslfile_name']}", __FILE__)
    end

    def get_output_filepath(resource_name, base_dir)
      output_dir =  base_dir
      FileUtils.mkdir_p(output_dir) unless File.exist?(output_dir)
      "#{output_dir}/#{resource_name}.html"
    end

    def convert(owl_file)
      doc = Nokogiri::XML(File.read(owl_file))
      owl2html_content(doc)
    end
  end
end
