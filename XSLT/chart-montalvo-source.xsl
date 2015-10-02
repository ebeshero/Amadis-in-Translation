<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat"/>
    <xsl:variable name="southey" select="document('../Southey_Amadis_1803_1.xml')"/>
    <xsl:template match="/">
        <xsl:for-each select="TEI">
            <xsl:variable name="title">
                <xsl:value-of select="//body/div[@type = 'chapter']/@xml:id"/>
            </xsl:variable>
            <xsl:result-document href="{concat('../tables/', $title, '.xhtml')}">
                <html>
                    <head>
                        <title>Tables for analysis</title>
                        <style>
                            body{
                                background-color:#B4D6B4;
                                color:#031B3F;
                                font-family:arial, helvetica, sans-serif;
                                padding:15px;
                                line-height:1.3em;
                            }
                            
                            h1{
                                color:#AA0000;
                            }
                            table{
                                border-collapse:collapse;
                                width:100%;
                                border:2px solid #BF9E7D;
                            }
                            
                            tr{
                                border-collapse:collapse;
                                border:0
                            }
                            
                            th
                            {
                                border-collapse:collapse;
                                border:1px solid #000066;
                                background-color:#7E967E;
                                padding:1px;
                                color:#5F0000;
                                vertical-align:top;
                            }
                            
                            td
                            {
                                border-collapse:collapse;
                                border:1px solid #000066;
                                padding:7px;
                                vertical-align:top;
                            }
                            td.omission{
                                background-color:red;
                                color:white}
                            td.report{
                                background-color:yellow}
                            td.add{
                                background-color:green}</style>
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
                <!--
             How to retrieve Southey's additions-->
                    
                    <xsl:choose>
                        <!--We wrote this XPath over the Southey file and got 20 results:
                            
                            //anchor[@ana = 'start'][following::anchor[@ana = 'end'][1]/following::anchor[1][@type = 'add']]-->
                    <xsl:when
                        test="current()/@xml:id = $southey//anchor[@ana = 'start'][following::anchor[@ana = 'end'][1]/following::anchor[1][@type = 'add']]/substring(@synch, 2)">
                        <xsl:text>Modification</xsl:text>
                        <!-- 2015-01-01 ebb: Helena and I realized that this isn't really the output we want. 
                            1) We're not picking up every modification, if there are two instances of an xml:id from a Montalvo clause in a row, we're getting only a result for the first, not the second.
                            2) We actually want to output the text of Southey's modification, together with the last matching piece of Montalvo (or at least information on its location, its xml:id).
                           -->
                    </xsl:when>
                    <xsl:otherwise>
                   
                        <xsl:value-of select="current()"/>
                    </xsl:otherwise>
                </xsl:choose>
                <!--<xsl:value-of select="current()"/>-->
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
