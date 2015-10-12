<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat"/>

    <!--Command line from Amadis folder: 
        
java -jar ../../SaxonHE9-6-0-7J/saxon9he.jar -s:XML-and-Schematron/Southey XSLT/graphs.xsl -o:tables

    -->

    <xsl:variable name="montalvo" select="collection('../XML-and-Schematron/Montalvo')"/>
    <xsl:template match="/">
        <xsl:result-document href="{'../tables/graphs.xhtml'}">
            <html>
                <head>
                    <title>Graphs</title>
                    <link type="text/css" rel="stylesheet" href="table.css"/>
                </head>
                <body>
                    <h1>Omissions in Southey</h1>         
                    <svg xmlns="http://www.w3.org/2000/svg" width="350" height="120">
                        <xsl:for-each select="collection('../XML-and-Schematron/Southey')">
                            <xsl:sort select="current()//head"/>
                            <xsl:if test="current()//anchor">
                                <xsl:apply-templates select="//div[@type = 'chapter']" mode="clauses"/>
                            </xsl:if>
                        </xsl:for-each>                        
                        <!--<line stroke="#BF9E7D" x1="95" y1="82" x2="300" y2="82" stroke-width="2"/>-->
                        <text fill="#031B3F" x="100" y="100">Number of clauses omitted</text>
                    </svg>
                    <svg xmlns="http://www.w3.org/2000/svg" width="350" height="120">
                        <xsl:for-each select="collection('../XML-and-Schematron/Southey')">
                            <xsl:sort select="current()//head"/>
                            <xsl:if test="current()//anchor">
                                <xsl:apply-templates select="//div[@type = 'chapter']" mode="words"/>
                            </xsl:if>
                        </xsl:for-each>                        
                        <text fill="#031B3F" x="100" y="100">Number of words omitted</text>
                    </svg>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="div[@type = 'chapter']" mode="clauses">
        <xsl:variable name="position">
            <xsl:choose>
                <xsl:when test="substring(@xml:id, 2) = '21'">
                    <xsl:value-of select="3"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="number(substring(@xml:id, 2))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="clauses"
            select="
            $montalvo//div[@type[. = 'chapter']][number(substring(@xml:id, 2)) + 1 =
            number(substring(current()/@xml:id, 2))]//cl[not(@xml:id = current()//anchor/substring(@synch, 2))]"/>
        <g xmlns="http://www.w3.org/2000/svg">
            <rect fill="#7E967E" stroke="#031B3F" stroke-width="2" height="20"
                width="{count($clauses) * 2}" y="{$position * 20}" x="95"/>
            <text y="{$position * 20 + 16}" fill="#031B3F">
                <xsl:value-of select="//head/text()[1]"/>
            </text>
        </g>
    </xsl:template>
    <xsl:template match="div[@type = 'chapter']" mode="words">
        <xsl:variable name="position">
            <xsl:choose>
                <xsl:when test="substring(@xml:id, 2) = '21'">
                    <xsl:value-of select="3"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="number(substring(@xml:id, 2))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="clauses"
            select="
            $montalvo//div[@type[. = 'chapter']][number(substring(@xml:id, 2)) + 1 =
            number(substring(current()/@xml:id, 2))]//cl[not(@xml:id = current()//anchor/substring(@synch, 2))]"/>
        <xsl:variable name="words" select="tokenize(string-join($clauses, ' '), '\s+')"/>
        <g xmlns="http://www.w3.org/2000/svg">
            <rect fill="#7E967E" stroke="#031B3F" stroke-width="2" height="20"
                width="{count($words) div 5}" y="{$position * 20}" x="95"/>
            <text y="{$position * 20 + 16}" fill="#031B3F">
                <xsl:value-of select="//head/text()[1]"/>
            </text>
        </g>
    </xsl:template>
    <xsl:template match="persName"/>
    <xsl:template match="note"/>
</xsl:stylesheet>
