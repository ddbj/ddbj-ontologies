require 'rubygems'
require 'yaml'
require 'nokogiri'
require 'xml/xslt'
require 'fileutils'

module OwlConvertor
  class Base
    def initialize(output_dir)
      # clear output directory
      @output_dir = output_dir
      @output_html_content_dir = "#{@output_dir}/html_content" # without header/footer content
      if File.exist?("#{@output_html_content_dir}")
        FileUtils.rm_rf(Dir.glob("#{@output_html_content_dir}/*"))
      else
        FileUtils.mkdir_p(@output_html_content_dir)
      end
    end

    def owl2html_content(owl_doc)
      # create root node for each resource uri
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.RDF(owl_doc.root.namespaces)
      }
      new_root = builder.doc.root
      new_root.namespace = new_root.namespace_definitions.find{ |ns| ns.href==owl_doc.root.namespaces["xmlns:rdf"] } # add prefix for root node

      resource_url = owl_doc.xpath(@setting["resource_xpath"])
      resource_url.each do |resource|
        new_resource = resource.dup
        val = resource.attribute("about").value
        if val.start_with?(@setting["resource_prefix"])
          local_part = val.sub(@setting["resource_prefix"],"")
          root_node = new_root.dup
          root_node.add_child(new_resource)
          tmp_xml_file = "#{@output_dir}/resouce.xml"
          File.open(tmp_xml_file, "w") do |xmlfile|
            xmlfile.puts Nokogiri::XML(root_node.to_xml, nil, 'utf-8').to_xml
          end
          @xslt.xml = tmp_xml_file
          output_file = get_output_filepath(local_part, @output_html_content_dir)
          # Multiple resources may be included in one page, so write in additional mode. ex. "Sequnce", "sequence"(Can't save separate files)
          File.open(output_file, "a") do |file|
            file.puts @xslt.serve()
          end
        end
        FileUtils.rm(tmp_xml_file)
      end
    end
  end
end
