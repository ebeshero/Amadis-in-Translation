<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat"/>
    
    <!--We wrote this XPath over the Southey file and got 20 results:
                            
                            //anchor[@ana = 'start'][following::anchor[@ana = 'end'][1]/following::anchor[1][@type = 'add']]-->
    
    
    <!-- 2015-01-01 ebb: Helena and I realized that this isn't really the output we want. 
                            1) We're not picking up every modification, if there are two instances of an xml:id from a Montalvo clause in a row, we're getting only a result for the first, not the second.
                            2) We actually want to output the text of Southey's modification, together with the last matching piece of Montalvo (or at least information on its location, its xml:id).
                           -->
    
    <xsl:variable name="southey" select="document('../XML-and-Schematron/Southey/Southey_Amadis_1803_2.xml')"/>    
    <xsl:template match="/">
        <xsl:for-each select="TEI">
            <xsl:variable name="title">
                <xsl:value-of select="//body/div[@type = 'chapter']/@xml:id"/>
            </xsl:variable>
            <xsl:result-document href="{concat('../tables/', $title, '.xhtml')}">
                <html>
                    <head>
                        <title>Tables for analysis</title>
                        <link type="text/css" rel="stylesheet" href="table.css" />
                    </head>
                    <body>
                        <h1>
                            <xsl:value-of select="//body//head"/>
                        </h1>
                        <table>
                            <thead>
                                <tr>
                                    <th>Montalvo</th>
                                    <th>Southey</th>
                                    <th>Type of change</th>
                                    <th>Commentary</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:apply-templates select="//cl"/>
                            </tbody>
                        </table>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="cl">
        <xsl:element name="tr">
            <xsl:element name="td">
                <!--<xsl:choose>
                    We might need to add a <xsl:for-each/> to get the instances where a montalvo clause is quoted by more than one Southey <anchor/>
                    <xsl:when test="current()/@xml:id = //$southey//anchor/substring(@synch, 2)">-->
                        <xsl:value-of select="current()"/>
                    <!-- </xsl:when>
                   <xsl:when
                        test="current()/@xml:id = $southey//anchor[@ana = 'start'][following::anchor[@ana = 'end'][1]/following::anchor[1][@type = 'add']]/substring(@synch, 2)">
                        <xsl:value-of select="current()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="current()"/>
                        <xsl:text>- - Modification</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>-->
            </xsl:element>
            <xsl:element name="td">
                <xsl:choose>
                    <xsl:when
                        test="$southey//anchor[@ana = 'start'][@synch = concat('#', current()/@xml:id)]">
                        <xsl:value-of
                            select="
                                $southey//anchor[@ana = 'start'][@synch = concat('#', current()/@xml:id)]/following::node()
                                except ($southey//anchor[@ana = 'start'][@synch = concat('#', current()/@xml:id)]/following::node()[@ana = 'end'][1]/following::node())"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="class">omission</xsl:attribute>
                        <xsl:text>Omission</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="td">
                <xsl:choose>
                    <xsl:when
                        test="$southey//anchor[@ana = 'start'][@synch = concat('#', current()/@xml:id)]/@type[. = 'report']">
                        <xsl:attribute name="class">report</xsl:attribute>
                        <xsl:text>Reported speech</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>No tagged type</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="td">Comments</xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
