<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="cl">
        <cl>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="./ancestor::div[@type='chapter']/@xml:id"/>                
                <xsl:text>_c</xsl:text>
                <xsl:value-of select="count(preceding::cl)+1"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </cl>        
    </xsl:template>
    
</xsl:stylesheet>