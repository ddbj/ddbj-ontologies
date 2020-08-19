require File.expand_path('../../lib/owl_convertor/taxonomy.rb', __FILE__)
require File.expand_path('../../lib/owl_convertor/nucleotide.rb', __FILE__)
require File.expand_path('../../lib/owl_convertor/ontologies.rb', __FILE__)

unless ARGV.size >= 2
  exit 1
end
if ARGV[0] == "nucleotide"
  conv = OwlConvertor::Nucleotide.new(ARGV[1])
elsif ARGV[0] == "taxonomy"
  conv = OwlConvertor::Taxonomy.new(ARGV[1])
elsif ARGV[0] == "ontologies"
  conv = OwlConvertor::Ontologies.new(ARGV[1])
else
  STDERR.puts "not exist ontology name: #{ARGV[0]}"
  exit 1
end

# convert
if ARGV[0] == "ontologies"
  for index in 2..(ARGV.size-1) do
    conv.convert(ARGV[index])
  end
else
  conv.convert(ARGV[2])
end
