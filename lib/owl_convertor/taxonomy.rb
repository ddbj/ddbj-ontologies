require 'rubygems'
require 'yaml'
require 'nokogiri'
require 'xml/xslt'
require 'fileutils'
require File.expand_path('../base.rb', __FILE__)

module OwlConvertor
  class Taxonomy < Base
    # create root node for each resource uri
    @@head = <<-HEAD
<?xml version='1.0' encoding='UTF-8'?>
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:pubmed="http://identifiers.org/pubmed/" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:taxid="http://identifiers.org/taxonomy/" xmlns:taxncbi="http://www.ncbi.nlm.nih.gov/taxonomy/" xmlns:taxobo0="http://purl.obolibrary.org/obo/NCBITaxon_" xmlns:taxobo1="http://purl.org/obo/owl/NCBITaxon#" xmlns:taxobo2="http://www.berkeleybop.org/ontologies/owl/NCBITaxon#" xmlns:taxup="http://purl.uniprot.org/taxonomy/" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns="http://ddbj.nig.ac.jp/ontologies/taxonomy/">
    HEAD
    @@tail = <<-TAIL
</rdf:RDF>
    TAIL

    def initialize(output_dir)
      super
      @setting = YAML.load(File.read(File.expand_path("../../../config/taxonomy.yml", __FILE__)))
      #XSLT
      @xslt = XML::XSLT.new()
      @xslt.xsl = File.expand_path("../../../templates/#{@setting['xslfile_name']}", __FILE__)
    end

    def get_output_filepath(resource_name, base_dir)
      output_dir = base_dir + "/" + OwlConvertor::Taxonomy.get_resource_dir(resource_name)
      FileUtils.mkdir_p(output_dir) unless File.exist?(output_dir)
      "#{output_dir}/#{resource_name}.html"
    end

    def self.get_resource_dir(resource_name)
      ret = ""
      if resource_name =~ /^\d+$/
        tax_id = format('%09d', resource_name)
        ret = "#{tax_id[0..2]}/#{tax_id[3..5]}"
      end
      ret
    end

    def output_entry(rdf_entry)
      return if rdf_entry.chomp.strip == ""
      rdf_entry.slice!("\n</rdf:RDF>") # exclude footer if include
      xml_data = @@head + rdf_entry + @@tail
      root_node = Nokogiri::XML(xml_data)
      owl2html_content(root_node)
    end

    def convert(owl_file)
      header_flag = true
      current_entry = ""
      current_block = []
      File.foreach(owl_file).slice_before(/rdf:about="http:\/\/ddbj.nig.ac.jp\/ontologies\/taxonomy\/\w+"/).each do |block|
        if !header_flag # exclude header
          if !current_entry.start_with?("<?xml") && current_entry != block.first
            output_entry(current_block.join)
            current_block = block
            current_entry = block.first
          else
            current_block.concat(block)
            current_entry = block.first
          end
        end
        header_flag = false
      end
      output_entry(current_block.join) # last one
    end
  end
end
