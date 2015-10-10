<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat"/>

    <!--Command line from Amadis folder: 
        
java -jar ../../SaxonHE9-6-0-7J/saxon9he.jar -s:XML-and-Schematron/Southey XSLT/statistics.xsl -o:tables

    -->

    <xsl:variable name="montalvo" select="collection('../XML-and-Schematron/Montalvo')"/>
    <xsl:template match="/">
        <xsl:result-document href="{'../tables/statistic-tables.xhtml'}">
            <html>
                <head>
                    <title>Charts and statistics</title>
                    <link type="text/css" rel="stylesheet" href="table.css"/>
                    <script type="text/javascript" src="sortable.js"/>
                </head>
                <body>
                    <h1>Number of omissions in Southey</h1>
                    <table class="sortable">
                        <thead>
                            <tr>
                                <th>Chapter </th>
                                <th>Number of clauses omitted </th>
                                <th>Number of words omitted </th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="collection('../XML-and-Schematron/Southey')">
                                <xsl:if test="current()//anchor">
                                    <xsl:apply-templates select="//div[@type = 'chapter']"/>
                                </xsl:if>
                            </xsl:for-each>
                        </tbody>
                    </table>                    
                    <h1>Word count by chapter</h1>
                    <xsl:for-each select="collection('../XML-and-Schematron/Southey')">
                        <xsl:sort select="//body//head"/>
                        <xsl:if test="//anchor">
                            <h2>
                                <xsl:value-of select="//body//head"/>
                            </h2>
                            <table class="sortable">
                                <thead>
                                    <tr>
                                        <th>ID </th>
                                        <th>Montalvo's word count </th>
                                        <th>Southey's word count </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:apply-templates select="//anchor"/>
                                </tbody>
                            </table>
                        </xsl:if>
                    </xsl:for-each>
                </body>
            </html>
        </xsl:result-document>

    </xsl:template>
    <xsl:template match="anchor[@ana = 'start'][@synch]">
        <xsl:variable name="match" select="$montalvo//cl[@xml:id = current()/substring(@synch, 2)]"/>
        <xsl:variable name="text"
            select="
                current()/following::text()
                except (current()/following::node()[@ana = 'end'][1]/following::node())"/>
        <xsl:variable name="correction" select="string-join($text/replace(., '[.,/?:;]', ''))"/>
        <xsl:variable name="southey-words" select="count(tokenize($correction,'\s+'))"/>
        <xsl:variable name="montalvo-words" select="count(tokenize($match, '\s+'))"/>
        <tr>
            <td>
                <xsl:value-of select="$match/@xml:id"/>
            </td>
            <xsl:element name="td">
                <xsl:value-of select="$montalvo-words"/>
            </xsl:element>
            <xsl:element name="td">
                <xsl:if test="($montalvo-words - $southey-words) div $southey-words >= 0.75">
                    <xsl:attribute name="class">red</xsl:attribute>
                </xsl:if>
                <xsl:if test="($southey-words - $montalvo-words) div $montalvo-words >= 0.75">
                    <xsl:attribute name="class">green</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$southey-words"/>
            </xsl:element>
        </tr>
    </xsl:template>
    <xsl:template match="div[@type = 'chapter']">
        <xsl:variable name="clauses"
            select="
                $montalvo//div[@type[. = 'chapter']][number(substring(@xml:id, 2)) + 1 =
                number(substring(current()/@xml:id, 2))]//cl[not(@xml:id = current()//anchor/substring(@synch, 2))]"/>
        <tr>
            <td>
                <xsl:value-of select="//head/text()"/>
            </td>
            <td>
                <xsl:value-of select="count($clauses)"/>
            </td>
            <td>
                <xsl:value-of select="count(tokenize(string-join($clauses, ' '), '\s+'))"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="persName"/>
    <xsl:template match="note"/>
</xsl:stylesheet>
