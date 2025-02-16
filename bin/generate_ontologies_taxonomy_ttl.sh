#!/bin/bash -l
#
# Generater taxonomy ontology file(turtle)
# 1. Copy taxdump file
# 2. Gnerates turtle file from taxdump with taxdump2owl.rb
#

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
BASE_DIR=$(realpath "${SCRIPT_DIR}/../")
OWL_DIR=$BASE_DIR/data/taxonomy
TAX_DUMP_DIR=$OWL_DIR/taxdump
LOG_FILE=$BASE_DIR/logs/OwlConverter.log

LOG()
{
 echo `date +'%Y/%m/%d %H:%M:%S'` $1 >> $LOG_FILE
}

if [ ! -e $OWL_DIR ]; then
  mkdir -p $OWL_DIR
fi

LOG "Start convert taxonomy owl"
set -e

LOG "Start copy latest taxdump"
if [ -e $OWL_DIR/taxdump.tar.gz ]; then
  rm -f $OWL_DIR/taxdump.tar.gz
fi

cp $BASE_DIR/data/taxdump/taxdump.tar.gz $OWL_DIR/ 2>> $LOG_FILE

cd $OWL_DIR
if [ ! -e $TAX_DUMP_DIR ]; then
  mkdir -p $TAX_DUMP_DIR
fi

tar --directory=$TAX_DUMP_DIR -xf taxdump.tar.gz 2>> $LOG_FILE

LOG "End copy latest taxdump"

LOG "Start generate taxonomy.ttl from taxdump file"
ruby $BASE_DIR/bin/rdfsummit/taxdump2owl/taxdump2owl.rb $TAX_DUMP_DIR/nodes.dmp $TAX_DUMP_DIR/names.dmp $TAX_DUMP_DIR/merged.dmp $TAX_DUMP_DIR/citations.dmp > $OWL_DIR/taxonomy.ttl 2> $OWL_DIR/taxcite.ttl
LOG "End generate taxonomy.ttl from taxdump file"
