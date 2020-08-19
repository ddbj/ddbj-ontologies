# DDBJ Ontologies

DDBJ Ontologies is designed for the conversion of DDBJ-related ontologies and publishing them on the web site.
http://ddbj.nig.ac.jp/ontologies/

## Generate taxonomy ontology
### 1. Clone the source code
```
$ git clone --recursive https://github.com/ddbj/ddbj-ontologies.git
```

### 2. Set environment variables(if necessary)
```
$ cp template.env .env
```
##### DDBJ_ONTOLOGIES_CONVERTOR_CONTAINER_NAME
If the container name conflicts with another container, change it. The default value is 'ddbj_ontologies_convertor'
##### DDBJ_ONTOLOGIES_CONVERTOR_IMAGE_NAME
If the image name conflicts with another image, change it. The default value is 'ddbj_ontologies_convertor'

### 3. Build a image
```
$ docker-compose build
```

### 4. Download (or copy) the 'taxdump.tar.gz'
```
$ curl -o data/taxdump/taxdump.tar.gz ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
```
If you have a specific version of 'taxdump.tar.gz', coyp it in 'data/taxdump' directory. File names other than 'taxdump.tar.gz' will be ignored.

### 5. Generate taxonomy ontology via this image
```
$ docker-compose run --rm convertor /usr/src/app/bin/generate_ontologies_taxonomy_ttl.sh
```
A turtle file 'taxonomy.ttl' will be generated in the directory 'data/taxonomy/'.

## Generate contents file for web site
### 1. Convert taxonomy turtle file to RDF/XML format
```
$ docker run --rm -v `pwd`/data/taxonomy:/data ddbj_ontologies_raptor -i turtle -o rdfxml-abbrev /data/taxonomy.ttl > ./data/taxonomy/taxonomy.rdf 2>> ./logs/OwlConverter.log
```
### 2. Output static html file
```
$ docker-compose run --rm convertor /usr/src/app/bin/generate_ontologies_contents.sh
```
HTML static files will be generated in the directory 'data/contents/'.

## Start the web server
### 1. Set environment variables(if necessary)
```
$ cp template.env .env
```
##### DDBJ_ONTOLOGIES_APP_CONTAINER_NAME
If the container name conflicts with another container, change it. The default value is  'ddbj_ontologies_app'
##### DDBJ_ONTOLOGIES_APP_IMAGE_NAME
If the image name conflicts with another image, change it. The default value is 'ddbj_ontologies_app'
##### DDBJ_ONTOLOGIES_APP_ROOT_DIR
The application root directory. If you want to run the application without a container, change it.
##### DDBJ_ONTOLOGIES_APP_DATA_DIR
The html contents root directory. If you want to run the application without a container, change it.
##### DDBJ_ONTOLOGIES_APP_PORT
web server port on host

### 2. Start this container
start with 'docker-compose_web.yml' compose file.
```
$ docker-compose -f docker-compose_web.yml up -d
```
