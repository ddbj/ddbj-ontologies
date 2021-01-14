require 'yaml'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'
require 'fileutils'
require File.expand_path('../owl_convertor/taxonomy.rb', __FILE__)

module DDBJOntologies
  class Application < Sinatra::Base

    configure do
      APP_PATH = ENV.fetch("APP_ROOT_PATH") { "/usr/src/app" }
      DATA_PATH = ENV.fetch("DATA_ROOT_PATH") { "/usr/src/app/data" }
      set :public_folder  , File.expand_path("#{DATA_PATH}/contents/", __FILE__)
      set :views          , File.expand_path("#{APP_PATH}/views", __FILE__)
      set :root           , File.dirname(__FILE__)
      set :show_exceptions, development?
    end

    configure :development do
      register Sinatra::Reloader
    end

    # top page
    ['', '/', '/ontologies', '/ontologies/'].each do |route|
      get route do
        content_type 'text/html; charset=utf-8'
        file_path = File.join(settings.public_folder, 'ontologies/html_content/index.html')
        @contents = File.read(file_path)
        erb :layout
      end
    end

    # virtuoso db files
    get '/ontologies/virtuoso.db' do ||
      send_file File.join(settings.public_folder, "virtuoso.db")
    end

    # resource uri
    get '/ontologies/:ontology/:resource' do |ontology, resource|
      ontology.downcase!
      if ontology == "taxonomy"
        ontology_name = "taxonomy"
        file_base = OwlConvertor::Taxonomy.get_resource_dir(resource) + "/#{resource}"
      elsif ontology == "nucleotide"
        ontology_name = "nucleotide"
        file_base = "#{resource}"
      else
        status 404
      end
      file_path =  File.join(settings.public_folder, "#{ontology_name}/html_content/#{file_base}.html")
      if File.exist?(file_path)
        @contents = File.read(file_path)
        erb :layout
      else
        status 404
      end
    end

    # ontology files
    get '/ontologies/:ontology' do |ontology|
      if ontology.start_with?("taxonomy")
        ontology_name = "taxonomy"
      elsif ontology.start_with?("nucleotide")
        ontology_name = "nucleotide"
      else
        status 404
      end
      exp = File.extname(ontology)
      if exp == ".rdf"
        content_type 'application/rdf+xml; charset=utf-8'
      else
        content_type 'text/turtle; charset=utf-8'
        exp = ".ttl"
      end
      send_file File.join(settings.public_folder, "#{ontology_name}#{exp}")
    end

    #error response
    error 400..599 do
      if status == 404
        send_file(File.join(settings.public_folder, '404-e.html'), {status: 404})
      elsif status == 500
        send_file(File.join(settings.public_folder, '503-e.html'), {status: 500})
      end
    end
  end
end
