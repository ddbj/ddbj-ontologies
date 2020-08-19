
<!--

(C) 2014 UniProt consortium, http://www.uniprot.org
(C) 2008 by Andreas Radinger and Martin Hepp, Bundeswehr University Munich, http://www.unibw.de/ebusiness/

This file is part of owl2xhtml, a stylesheet for client-side rendering OWL ontologies in the form of XHTML documentation. For more information, see http://www.ebusiness-unibw.org/projects/owl2xhtml/.
It has been adapted for use on uniprot.org.    

Acknowledgements: The stylesheet re-uses, with kind permission, code-snippets from the RDFS/OWL presentation stylesheet (1) 

by Masahide Kanzaki, and from the OWL2HTML stylesheet (2), by Li Ding. We are very grateful for this kind support.

(1) http://www.kanzaki.com/ns/ns-schema.xsl
(2) available at http://daml.umbc.edu/ontologies/webofbelief/xslt/owl2html.xsl, 


     owl2xhtml is free software: you can redistribute it and/or modify
     it under the terms of the GNU Lesser General Public License (LPGL)
     as published by the Free Software Foundation, either version 3 of 
     the License, or (at your option) any later version.

     owl2xhtml is distributed in the hope that it will be useful, 
     but WITHOUT ANY WARRANTY; without even the implied warranty of 
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
     GNU General Public License for more details. 

     You should have received a copy of the GNU General Public License 
     along with owl2xhtml.  If not, see <http://www.gnu.org/licenses/>. 

-->



<!DOCTYPE xsl:stylesheet [
  <!ENTITY rdf		"http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <!ENTITY foaf "http://xmlns.com/foaf/0.1/" >
  <!ENTITY rdfs		"http://www.w3.org/2000/01/rdf-schema#">
  <!ENTITY dc		"http://purl.org/dc/elements/1.1/" >
  <!ENTITY skos		"http://www.w3.org/2004/02/skos/core#" >  
  <!ENTITY xsd		"http://www.w3.org/2001/XMLSchema#">
  <!ENTITY owl		"http://www.w3.org/2002/07/owl#">
  <!ENTITY core		"http://purl.uniprot.org/core/">
  <!ENTITY faldo	"http://biohackathon.org/resource/faldo#">
  <!ENTITY nucleotide	"http://ddbj.nig.ac.jp/ontologies/nucleotide/">
  <!ENTITY spin         "http://spinrdf.org/spin#">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
>
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- global variables and functions -->
	<xsl:variable name="nodeset-ontology"
		select=".//*[
		  rdf:type/@rdf:resource='&owl;Ontology'  or (local-name()='Ontology' and namespace-uri()='&owl;')
  ]" />
	<xsl:variable name="nodeset-class"
		select=".//*[     
		   (rdf:type/@rdf:resource='&owl;Class'  or (local-name()='Class' and namespace-uri()='&owl;' and @rdf:about) or (owl:Class and @rdf:about))
  ]" />
	<xsl:variable name="nodeset-property-object" select=".//*[  
		((local-name()='ObjectProperty' and namespace-uri()='&owl;') or (rdf:type/@rdf:resource='&owl;ObjectProperty')) 
  ]" />
	<xsl:variable name="nodeset-property-datatype" select=".//*[  
		((local-name()='DatatypeProperty' and namespace-uri()='&owl;') or (rdf:type/@rdf:resource='&owl;DatatypeProperty'))
  ]" />
	<xsl:variable name="nodeset-individual"
		select="(.//*[
			 (//rdf:type[@rdf:resource='&owl;NamedIndividual'] or (//rdf:type[@rdf:resource='&owl;Thing'] and (namespace-uri()='&core;')))
		  and not (namespace-uri()='&rdfs;')
		  and not (local-name()='RDF')
		  and @rdf:about
  ])" />
	<xsl:template match="/">
		<xsl:apply-templates />
	</xsl:template>

	<!-- Match RDF data -->
<xsl:template match="rdf:RDF">
          <xsl:if test="count($nodeset-ontology)>0">
		<xsl:apply-templates select="$nodeset-ontology" mode="details_ontology">
		</xsl:apply-templates>
	</xsl:if>
	<xsl:if test="count($nodeset-class)>0">
		<xsl:apply-templates select="$nodeset-class" mode="details">
			<xsl:sort select="@rdf:ID" />
		</xsl:apply-templates>
	</xsl:if>
	<xsl:if test="count($nodeset-property-object)>0">
		<xsl:apply-templates select="$nodeset-property-object" mode="details">
			<xsl:sort select="@rdf:ID" />
		</xsl:apply-templates>
	</xsl:if>
	<xsl:if test="count($nodeset-property-datatype)>0">
		<xsl:apply-templates select="$nodeset-property-datatype" mode="details">
			<xsl:sort select="@rdf:ID" />
		</xsl:apply-templates>
	</xsl:if>
	<xsl:if test="count($nodeset-individual)>0">
		<xsl:apply-templates select="$nodeset-individual" mode="details">
			<xsl:sort select="@rdf:ID" />
		</xsl:apply-templates>
	</xsl:if>
</xsl:template>
	<xsl:template match="*" mode="details_ontology">
		<h3>http://ddbj.nig.ac.jp/ontologies/nucleotide/<span style="padding-left: 30px"><u><a href="/ontologies/nucleotide.ttl">Turtle</a></u> <u><a href="/ontologies/nucleotide.rdf">RDF/XML</a></u></span></h3>
                <section class="section">
                  <div class="main_table format">
		    <table style="width:100%">
			<tbody>
			<xsl:if test="count(*)+count(@*)>0">
				<xsl:apply-templates select="." mode="attribute" />
				<xsl:apply-templates select="*" mode="child" />
			</xsl:if>
			</tbody>
		    </table>
                  </div>
                </section>
	</xsl:template>
	<xsl:template match="*" mode="details">
		<xsl:variable name="ref">
			<xsl:choose>
				<xsl:when test="@rdf:ID">
					<xsl:value-of select="@rdf:ID" />
				</xsl:when>
				<xsl:when test="@rdf:about">
					<xsl:value-of select="@rdf:about" />
				</xsl:when>
				<xsl:otherwise>
					BLANK
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length($ref)>0">
                  <h3><xsl:value-of select="@rdf:about" /></h3>
                  <section class="section">
                    <div class="main_table format">
                      <table style="width:100%">
				<tbody>
					<tr>
						<td>
						<xsl:call-template name="url">
							<xsl:with-param name="ns">
								<xsl:value-of select="'&rdf;'" />
                                                        </xsl:with-param>
							<xsl:with-param name="name">
								<xsl:value-of select="'type'" />
                                                        </xsl:with-param>
						</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="url">
								<xsl:with-param name="ns" select="namespace-uri()" />
								<xsl:with-param name="name" select="local-name()" />
							</xsl:call-template>
						</td>
					</tr>
					<xsl:if test="count(*)+count(@*)>0">
						<xsl:apply-templates select="." mode="attribute" />
						<xsl:apply-templates select="*" mode="child" />
					</xsl:if>
				</tbody>
			</table>
                     </div>
                  </section>
		</xsl:if>
	</xsl:template>
	<xsl:template name="url">
		<xsl:param name="ns" />
		<xsl:param name="name" />
		<xsl:choose>
			<xsl:when test="$ns='&rdf;'">
				<a href="{concat($ns,$name)}">
					rdf:<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:when test="$ns='&rdfs;'">
				<a href="{concat($ns,$name)}">
					rdfs:<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:when test="$ns='&owl;'">
				<a href="{concat($ns,$name)}">
					owl:<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:when test="$ns='&dc;'">
				<a href="{concat($ns,$name)}">
					dc:<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:when test="$ns='&skos;'">
				<a href="{concat($ns,$name)}">
					skos:<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:when test="$ns='&foaf;'">
				<a href="{concat($ns,$name)}">
					foaf:<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:when test="$ns='&core;'">
				<a href="{concat($ns,$name)}">
					core:<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:when test="$ns='&xsd;'">
				<a href="{concat($ns,$name)}">
					xsd:<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:when test="$ns='&nucleotide;'">
				<a href="{concat($ns,$name)}">
					:<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:when test="$ns='http://purl.org/dc/terms/'">
                                <a href="{concat($ns,$name)}">
                                        dcterms:<xsl:value-of select="$name" />
                                </a>
                        </xsl:when>
			<xsl:when test="$ns='&spin;'">
                                <a href="{concat($ns,$name)}">
                                        spin:<xsl:value-of select="$name" />
                                </a>
                        </xsl:when>
			<xsl:when test="$ns=/rdf:RDF/@xml:base">
				<a href="{concat('#',$name)}">
					<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:when test="(string-length($ns)>0) or starts-with($name,'http://')">
				<a href="{concat($ns,$name)}">
					<xsl:value-of select="$name" />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="prettyUrl">
		<xsl:param name="name" />
		<xsl:choose>
			<xsl:when test='starts-with($name, "&owl;")'>
				owl:<xsl:value-of select='substring-after($name, "&owl;")' />
			</xsl:when>
			<xsl:when test='starts-with($name, "&rdf;")'>
				rdf:<xsl:value-of select='substring-after($name, "&rdf;")' />
			</xsl:when>
			<xsl:when test='starts-with($name, "&rdfs;")'>
				rdfs:<xsl:value-of select='substring-after($name, "&rdfs;")' />
			</xsl:when>
			<xsl:when test='starts-with($name, "&xsd;")'>
				xsd:<xsl:value-of select='substring-after($name, "&xsd;")' />
			</xsl:when>
			<xsl:when test='starts-with($name, "&foaf;")'>
				foaf:<xsl:value-of select='substring-after($name, "&foaf;")' />
			</xsl:when>
			<xsl:when test='starts-with($name, "&skos;")'>
				skos:<xsl:value-of select='substring-after($name, "&skos;")' />
			</xsl:when>
			<xsl:when test='starts-with($name, "&core;")'>
				core:<xsl:value-of select='substring-after($name, "&core;")' />
			</xsl:when>
			<xsl:when test='starts-with($name, "&nucleotide;")'>
				:<xsl:value-of select='substring-after($name, "&nucleotide;")' />
			</xsl:when>
			<xsl:when test='starts-with($name,"http")'>
				<xsl:value-of select="$name" />
			</xsl:when>
			<xsl:when test="$name">
				<xsl:value-of select="$name" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" mode="resource">
		<a href="{@rdf:resource}">
			<xsl:call-template name="prettyUrl">
				<xsl:with-param name="name" select="@rdf:resource"/>
			</xsl:call-template>
		</a>
	</xsl:template>
	<xsl:template match="*" mode="attribute">
		<xsl:for-each select="@*[local-name()!=lang]">
			<sup>
				<xsl:call-template name="url">
						<xsl:with-param name="ns" select="namespace-uri()" />
						<xsl:with-param name="name" select="local-name()" />
					</xsl:call-template>
					<xsl:call-template name="url">
						<xsl:with-param name="ns" select="''" />
						<xsl:with-param name="name" select="." />
					</xsl:call-template>
                        </sup>
		</xsl:for-each>
                <xsl:if test="@rdf:datatype">
			<xsl:for-each select="@rdf:datatype">
        	        	<sup>
					<xsl:variable name="datatype" select="." />
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="." />
						</xsl:attribute>
                        			<xsl:call-template name="prettyUrl">
                          				<xsl:with-param name="name" select="."/>
                        			</xsl:call-template>
					</a>
                 		</sup>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="child">
		<tr>
			<td>
				<xsl:call-template name="url">
					<xsl:with-param name="ns" select="namespace-uri()" />
					<xsl:with-param name="name" select="local-name()" />
				</xsl:call-template>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="@rdf:resource">
						<xsl:apply-templates select="." mode="resource" />
					</xsl:when>
					<xsl:when test="local-name() = 'hasKey' and namespace-uri() = '&owl;'">
                                          <a href="{concat('&owl;', 'hasKey')}">owl:hasKey</a> consisting of (<br />
                                          <xsl:for-each select="descendant::*/rdf:first">
                                            <span class="indent">
                                              <xsl:apply-templates select="." mode="resource" />
                                            </span>
                                            <xsl:if test="position() != last()">
                                              <br /><em>and</em>
                                            </xsl:if>
                                            <br />
                                          </xsl:for-each>
                                          )
                                        </xsl:when>
					<xsl:when test="owl:Restriction">
						<xsl:apply-templates select="*" mode="restriction" />
					</xsl:when>
					<xsl:when test="@*">
						"<xsl:value-of select='text()' />"
						<xsl:if test="@xml:lang">@<xsl:apply-templates select="@xml:lang" mode="resource" />
						</xsl:if>
						<xsl:apply-templates select="." mode="attribute" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select='text()' />
						<xsl:if test="@xml:lang">^^<xsl:apply-templates select="@xml:lang" mode="resource" />
						</xsl:if>
						<xsl:if test="owl:hasKey">
                                                  hasKey
                                                </xsl:if>
						<xsl:if test="owl:Restriction">
							<xsl:apply-templates select="*" mode="restriction" />
						</xsl:if>
						<xsl:if test="rdfs:Datatype" >
							<xsl:if test="owl:Restriction" >
								<xsl:apply-templates select="*" mode="restriction" />
							</xsl:if>
                                                </xsl:if>
						<xsl:if test="owl:Class/owl:unionOf">
							<a href="http://www.w3.org/2002/07/owl#unionOf">owl:unionOf</a>
							<xsl:variable name="this">
								<xsl:value-of select="owl:Class/owl:unionOf/@rdf:nodeID" />
							</xsl:variable>
							(
							<xsl:choose>
								<xsl:when test="owl:Class/owl:unionOf[@rdf:parseType]/owl:Restriction">
									<xsl:for-each select="owl:Class/owl:unionOf[@rdf:parseType]">
                                                                                <xsl:if test="position() != last()">
                                                                                        <br />
                                                                                </xsl:if>
										<xsl:apply-templates select="*" mode="restriction" />
										<xsl:if test="position() != last()">
											<em>or</em><br />
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="owl:Class/owl:unionOf[@rdf:parseType]/owl:Class">
								<table>
									<xsl:for-each select="owl:Class/owl:unionOf[@rdf:parseType]">
										<xsl:for-each select='owl:Class'>
											<xsl:apply-templates select="*" mode="child" />
										</xsl:for-each>
									</xsl:for-each>
									</table>
								</xsl:when>
								<xsl:when test="owl:Class/owl:unionOf[@rdf:parseType]">
									<xsl:for-each select="owl:Class/owl:unionOf[@rdf:parseType]/child::*">
                                                                                <xsl:if test="position() = 1">
                                                                                        <br/>
                                                                                </xsl:if>
										<span class="indent"><a href="{@rdf:about}">
											<xsl:value-of select="@rdf:about" />
										</a></span>
										<xsl:if test="position() != 1">
											<br /><em>or</em>
										</xsl:if>
										<br />
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="owl:Class/owl:unionOf/rdf:Description">
                                                                        <xsl:for-each select="owl:Class/owl:unionOf/descendant::*/rdf:first">
                                                                                <xsl:if test="position() = 1">
                                                                                        <br/>
                                                                                </xsl:if>
                                                                                <span class="indent"><xsl:apply-templates select="." mode="resource" /></span>
                                                                                <xsl:if test="position() != last()">
                                                                                        <br /><em>or</em>
                                                                                </xsl:if>
                                                                                <br />
                                                                        </xsl:for-each>
                                                                </xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="owl:Class/owl:unionOf/child::*">
                                                                                <xsl:if test="position() = 1">
                                                                                        <br/>
                                                                                </xsl:if>
										<span class="indent"><a href="{@rdf:about}">
											<xsl:value-of select="@rdf:about" />
										</a></span>
										<xsl:if test="position() != last()">
											<br /><em>or</em>
										</xsl:if>
										<br />
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
							)
						</xsl:if>
						<xsl:if test="owl:Class/owl:intersectionOf">
							<a href="http://www.w3.org/2002/07/owl#intersectionOf">owl:intersectionOf</a>
							<xsl:variable name="this">
								<xsl:value-of select="owl:Class/owl:intersectionOf/@rdf:nodeID" />
							</xsl:variable>
							(
							<xsl:choose>
                                                                <xsl:when test="owl:Class/owl:intersectionOf/rdf:Description">
                                                                        <xsl:for-each select="owl:Class/owl:intersectionOf/descendant::*/rdf:first">
                                                                                <xsl:if test="position() != last()">
                                                                                        <br/>
                                                                                </xsl:if>
                                                                                <span class="indent"><xsl:apply-templates select="*" mode="restriction" /></span>
                                                                                <xsl:if test="position() != last()">
                                                                                        <em>and</em><br/>
                                                                                </xsl:if>
                                                                        </xsl:for-each>
                                                                </xsl:when>
								<xsl:when test="owl:Class/owl:intersectionOf[@rdf:parseType]">
									<xsl:for-each select="owl:Class/owl:intersectionOf[@rdf:parseType]">
                                                                                <xsl:if test="position() != last()">
                                                                                        <br/>
                                                                                </xsl:if>
										<span class="indent"><xsl:apply-templates select="*" mode="restriction" /></span>
										<xsl:if test="position() != last()">
                                                                                        <em>and</em><br/>
                                                                                </xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="owl:Class/owl:intersectionOf">
									<xsl:for-each select="owl:Class/owl:unionOf/child::*">
                                                                                <xsl:if test="position() != last()">
                                                                                        <br/>
                                                                                </xsl:if>
										<span class="indent"><a href="{@rdf:about}">
											<xsl:value-of select="@rdf:about" />
										</a></span>
										<xsl:if test="position() != last()">
                                                                                        <em>and</em><br/>
                                                                                </xsl:if>
									</xsl:for-each>
								</xsl:when>
							</xsl:choose>
							)
						</xsl:if>
						<xsl:if test="rdfs:Datatype/owl:unionOf">
							<a href="http://www.w3.org/2002/07/owl#unionOf">owl:unionOf</a>
							(
							<xsl:choose>
								<xsl:when test="rdfs:Datatype/owl:unionOf/rdf:Description">
                                                                        <xsl:for-each select="rdfs:Datatype/owl:unionOf/descendant::*/rdf:first">
                                                                                <xsl:if test="position() = 1">
                                                                                        <br/>
                                                                                </xsl:if>
										<xsl:choose>
											<xsl:when test="@rdf:resource">
                                                                                		<span class="indent"><xsl:apply-templates select="." mode="resource" /></span>
                                                                                		<xsl:if test="position() != last()">
                                                                                        		<br /><em>or</em>
                                                                                		</xsl:if>
                                                                                		<br />
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="rdfs:Datatype/owl:oneOf">
														<xsl:for-each select="rdfs:Datatype/owl:oneOf/descendant::*/rdf:first">
															<span class="indent"><a href="http://www.w3.org/2002/07/owl#oneOf">owl:oneOf</a></span>
															(
															<xsl:choose>
																<xsl:when test="@rdf:datatype">
																	<xsl:value-of select="."/>
                                                                				                			<xsl:apply-templates select="." mode="attribute"/>
																</xsl:when>
																<xsl:otherwise>
																	<span class="indent"><xsl:value-of select="."/></span>
																</xsl:otherwise>
															</xsl:choose>
                                                                                					<xsl:if test="position() != last()">
                                                                                        					<em>,</em>
                                                                                					</xsl:if>
															)
                                                                        					</xsl:for-each>
                                                                                				<br />
													</xsl:when>											
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
                                                                        </xsl:for-each>
                                                                </xsl:when>
							</xsl:choose>
							) 
						</xsl:if>
						<xsl:if test="rdfs:Datatype/owl:oneOf">
							<a href="http://www.w3.org/2002/07/owl#oneOf">owl:oneOf</a>
							(
							<xsl:choose>
								<xsl:when test="rdfs:Datatype/owl:oneOf/rdf:Description">
                                                                        <xsl:for-each select="rdfs:Datatype/owl:oneOf/descendant::*/rdf:first">
                                                                                <xsl:if test="position() = 1">
                                                                                        <br/>
                                                                                </xsl:if>
										<xsl:choose>
											<xsl:when test="@rdf:resource">
                                                                                		<span class="indent"><xsl:apply-templates select="." mode="resource" /></span>
											</xsl:when>
											<xsl:when test="@rdf:datatype">
												<span class="indent"><xsl:value-of select="."/></span>
                                                                                		<xsl:apply-templates select="." mode="attribute"/>
											</xsl:when>
											<xsl:otherwise>
												<span class="indent"><xsl:value-of select="."/></span>
											</xsl:otherwise>
										</xsl:choose>
                                                                                <xsl:if test="position() != last()">
                                                                                        <em>,</em>
                                                                                </xsl:if>
                                                                                <br />
                                                                        </xsl:for-each>
                                                                </xsl:when>
							</xsl:choose>
							) 
						</xsl:if>

						<xsl:if test="rdf:Description/owl:cardinality">
							<xsl:apply-templates select="*" mode="restriction" />
						</xsl:if>
						<xsl:if test="rdf:Description/owl:maxCardinality">
							<xsl:apply-templates select="*" mode="restriction" />
						</xsl:if>
						<xsl:if test="rdf:Description/owl:minCardinality">
							<xsl:apply-templates select="*" mode="restriction" />
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="*" mode="restriction">
		Restrict
		<a href="{owl:onProperty/@rdf:resource}">
                      <xsl:call-template name="prettyUrl">
                         <xsl:with-param name="name" select="owl:onProperty/@rdf:resource"/>
                      </xsl:call-template>
		</a> 
		<xsl:if test="owl:someValuesFrom/@rdf:resource">
			to <a href="{concat('&owl;', 'someValuesFrom')}">owl:someValuesFrom </a>
			<xsl:apply-templates select="owl:someValuesFrom" mode="resource"/>
		</xsl:if>
		<xsl:if test="owl:allValuesFrom/@rdf:resource">
			to <a href="{concat('&owl;', 'allValuesFrom')}">owl:allValuesFrom </a>
			<xsl:apply-templates select="owl:allValuesFrom" mode="resource"/>
		</xsl:if>
		<xsl:if test="owl:cardinality">
			to <a href="{concat('&owl;', 'cardinality')}">owl:cardinality </a>
				<a href="{owl:cardinality/@rdf:datatype}">
				<xsl:value-of select="owl:cardinality/text()" />
			</a>
		</xsl:if>
		<xsl:if test="owl:maxCardinality">
			to <a href="{concat('&owl;', 'maxCardinality')}">owl:maxCardinality </a>
			<a href="{owl:maxCardinality/@rdf:datatype}">
				<xsl:value-of select="owl:maxCardinality/text()" />
			</a>
		</xsl:if>
		<xsl:if test="owl:minCardinality">
			to <a href="{concat('&owl;', 'minCardinality')}">owl:minCardinality </a>
			<a href="{owl:minCardinality/@rdf:datatype}">
				<xsl:value-of select="owl:minCardinality/text()" />
			</a>
		</xsl:if>
		<xsl:if test="owl:onClass">
			<a href="{concat('&owl;', 'onClass')}"> owl:onClass </a>
			<xsl:apply-templates select="owl:onClass" mode="resource"/>
		</xsl:if>
		<xsl:if test="owl:onDataRange">
			<a href="{concat('&owl;', 'onDataRange')}"> owl:onDataRange </a>
			<xsl:apply-templates select="owl:onDataRange" mode="resource"/>
		</xsl:if>
		<xsl:if test="owl:onDatatype">
                        <a href="{concat('&owl;', 'onDataType')}"> owl:onDatatype </a> to 
                        <xsl:apply-templates select="owl:onDatatype" mode="resource"/> with a value of 
                        <xsl:for-each select="owl:onDatatype/../owl:withRestrictions/rdf:Description/descendant::*/rdf:Description/child::*">
                          <xsl:if test="local-name() = 'minInclusive'" >
                            at least <a href="{@rdf:datatype}" ><xsl:value-of select="text()" /> </a>
                          </xsl:if>
                          <xsl:if test="local-name() = 'maxInclusive'" >
                            at most <a href="{@rdf:datatype}" ><xsl:value-of select="text()" /> </a>
                          </xsl:if>
                        </xsl:for-each>
                </xsl:if>
		<xsl:if test="owl:maxQualifiedCardinality">
			to <a href="{concat('&owl;', 'maxQualifiedCardinality')}">owl:maxQualifiedCardinality </a>
			<a href="{owl:maxQualifiedCardinality/@rdf:datatype}">
                            <xsl:value-of select="owl:maxQualifiedCardinality/text()" />
			</a>
		</xsl:if>
		<xsl:if test="owl:minQualifiedCardinality">
			to <a href="{concat('&owl;', 'minQualifiedCardinality')}">owl:minQualifiedCardinality </a>
			<a href="{owl:minQualifiedCardinality/@rdf:datatype}">
				<xsl:value-of select="owl:minQualifiedCardinality/text()" />
			</a>
		</xsl:if>
		<xsl:if test="owl:hasValue">
			<a href="{concat('&owl;', 'hasValue')}"> owl:HasValue </a>
			<a href="{owl:hasValue/@rdf:datatype}">
				<xsl:value-of select="owl:hasValue/text()" />
			</a>
		</xsl:if>
		<br/>
	</xsl:template>
</xsl:stylesheet>
