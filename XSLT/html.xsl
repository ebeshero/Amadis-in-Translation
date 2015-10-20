<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat"  encoding="utf-8"  omit-xml-declaration="yes"/>
    <xsl:variable name="montalvo"
        select="document('../XML-and-Schematron/Montalvo/Montalvo_Amadis_1547_0.xml')"/>
    <xsl:variable name="southey"
        select="document('../XML-and-Schematron/Southey/Southey_Amadis_1803_1.xml')"/>
    <xsl:variable name="SI" select="document('../XML-and-Schematron/SI-Amadis.xml')"/>
    <xsl:template match="/">
        <xsl:variable name="title">
            <xsl:value-of select="$montalvo//body/div[@type = 'chapter']/@xml:id"/>
        </xsl:variable>
        <xsl:result-document href="{concat('../html/', $title, '.html')}">
            <html>
                <head>
                    <title>Amadis in translation</title>
                    <link href="edition.css" rel="stylesheet" type="text/css"/>                    
                    <script src="highlight.js" type="text/javascript">/**/</script>                    
                    <script src="tooltip.js" type="text/javascript">/**/</script>
                </head>
                <body>
                    <div class="container">
                        <div class="montalvo">
                            <h1>
                                <xsl:value-of select="$montalvo//head"/>
                            </h1>
                            <xsl:apply-templates select="$montalvo//body//p"/>
                        </div>
                        <div class="southey">
                            <h1>
                                <xsl:value-of select="//head"/>
                            </h1>
                            <xsl:apply-templates select="//body//p"/>
                        </div>
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="p">
        <p>
            <xsl:apply-templates select="current()//anchor | current()//cl"/>
        </p>
    </xsl:template>
    <xsl:template match="cl">
        <xsl:if test="exists(index-of($southey//anchor/substring(@synch, 2), current()/@xml:id))">
            <xsl:element name="span">
                <xsl:attribute name="id">
                    <xsl:value-of select="current()/@xml:id"/>
                </xsl:attribute>
                <xsl:apply-templates/>
                <xsl:text> </xsl:text>
            </xsl:element>
        </xsl:if>
        <xsl:if
            test="not(exists(index-of($southey//anchor/substring(@synch, 2), current()/@xml:id)))">
            <xsl:element name="span">
                <xsl:attribute name="class">omission</xsl:attribute>
                <xsl:apply-templates/>
                <xsl:text> </xsl:text>
            </xsl:element>
        </xsl:if>

    </xsl:template>
    <xsl:template match="anchor[@ana = 'start']">
        <xsl:if test="current()/@synch">
            <xsl:element name="span">
                <xsl:attribute name="class">
                    <xsl:value-of select="current()/substring(@synch, 2)"/>
                    <xsl:if test="current()/@type"><xsl:value-of select="concat(' ', current()/@type)"/></xsl:if>
                </xsl:attribute>
                <xsl:apply-templates
                    select="current()/following::node() except current()/following::node()[@ana = 'end'][1]/following::node()"/>
                <xsl:text> </xsl:text>
            </xsl:element>
        </xsl:if>
        <xsl:if test="current()/@type[. = 'add']">
            <xsl:element name="span">
                <xsl:attribute name="class">add</xsl:attribute>
                <xsl:apply-templates
                    select="current()/following::node() except current()/following::node()[@ana = 'end'][1]/following::node()"
                />
                <xsl:text> </xsl:text>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="persName">
        <xsl:element name="span">
            <xsl:attribute name="class">character</xsl:attribute>
            <xsl:attribute name="data-content">
                <xsl:value-of select="$SI//person[@xml:id = current()/substring(@ref, 2)]/note"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="note">
        <xsl:element name="span">
            <xsl:attribute name="class">note</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="s"/>
    
</xsl:stylesheet>
