#!/bin/bash -l
#
# Generates html file for the site which publishes resource URI of ontologies
# 1. Replaces resourceURIs which are defined as <http://identifired.org/taxonomy/> to ddbj's domain
# 2. Generates html contents from rdfxml with create_ontologies_content.rb
#
#

TAX_DIR=$BASE_DIR/data/taxonomy
TAX_TTL_FILE=taxonomy.ttl
TAX_RDF_FILE=taxonomy.rdf
TAX_RDF_DDBJ_FILE=taxonomy_ddbj.rdf #this owl file which is replace from identifier.org domain to ddbj domain. This owl file is only used by converter to html.

INSDC_DIR=$BASE_DIR/data/nucleotide
INSDC_TTL_FILE=nucleotide.ttl
INSDC_RDF_FILE=nucleotide.rdf

LOG_FILE=$LOG_DIR/OwlConverter.log

LOG()
{
 echo `date +'%Y/%m/%d %H:%M:%S'` $1 >> $LOG_FILE
}

set -e

LOG "Start replaces resourceURIs to ddbj domain"

cp $TAX_DIR/$TAX_RDF_FILE $TAX_DIR/$TAX_RDF_DDBJ_FILE
perl -pi -e "s#<Taxon rdf:about=\"http://identifiers.org/taxonomy/#<Taxon rdf:about=\"http://ddbj.nig.ac.jp/ontologies/taxonomy/#" $TAX_DIR/$TAX_RDF_DDBJ_FILE
perl -pi -e "s#<merged rdf:resource=\"http://identifiers.org/taxonomy/#<merged rdf:resource=\"http://ddbj.nig.ac.jp/ontologies/taxonomy/#" $TAX_DIR/$TAX_RDF_DDBJ_FILE
perl -pi -e "s#<rdfs:subClassOf rdf:resource=\"http://identifiers.org/taxonomy/#<rdfs:subClassOf rdf:resource=\"http://ddbj.nig.ac.jp/ontologies/taxonomy/#" $TAX_DIR/$TAX_RDF_DDBJ_FILE

LOG "End replaces resourceURIs to ddbj domain"

LOG "Start generate html contents"

CONTENTS_DIR=$BASE_DIR/data/contents
if [ ! -e $CONTENTS_DIR ]; then
  mkdir -p $CONTENTS_DIR
fi
if [ -e $CONTENTS_DIR/ontologies ]; then
  rm -rf $CONTENTS_DIR/ontologies
fi
if [ -e $CONTENTS_DIR/nucleotide ]; then
  rm -rf $CONTENTS_DIR/nucleotide
fi
if [ -e $CONTENTS_DIR/taxonomy ]; then
  rm -rf $CONTENTS_DIR/taxonomy
fi

ruby bin/create_ontologies_content.rb "ontologies" $CONTENTS_DIR/ontologies $INSDC_DIR/$INSDC_RDF_FILE $TAX_DIR/$TAX_RDF_DDBJ_FILE
ruby bin/create_ontologies_content.rb "nucleotide" $CONTENTS_DIR/nucleotide $INSDC_DIR/$INSDC_RDF_FILE
ruby bin/create_ontologies_content.rb "taxonomy" $CONTENTS_DIR/taxonomy $TAX_DIR/$TAX_RDF_DDBJ_FILE
# copy ttl/rdf files
cp $INSDC_DIR/$INSDC_RDF_FILE $CONTENTS_DIR/$INSDC_RDF_FILE
cp $INSDC_DIR/$INSDC_TTL_FILE $CONTENTS_DIR/$INSDC_TTL_FILE
cp $TAX_DIR/$TAX_RDF_FILE $CONTENTS_DIR/$TAX_RDF_FILE
cp $TAX_DIR/$TAX_TTL_FILE $CONTENTS_DIR/$TAX_TTL_FILE

LOG "End generate html contents"
