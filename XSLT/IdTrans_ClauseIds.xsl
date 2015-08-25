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
                <xsl:number level="multiple"/>
            </xsl:attribute>
            
            <!--ebb: 2015-08-20: Solved the problem of flagging nested clauses if they ever appear!
               This just uses a single template match with an attribute builder and <xsl:number>.
                Here's how <xsl:number> works: 
                
                <cl n="1">.....</cl>
                <cl n="2">......</cl>
                <cl n="3"> ....
                    <cl n="3.1">.....</cl>
                    <cl n="3.2">.....</cl>
                    <cl n="3.3">.....</cl>
                </cl>
                <cl n="4">>.........</cl>
                
                Try level= "any" or level="single" We want level="multiple" for numbering
            consecutively through a nested hierarchy (as with numbering an outline).
            
            -->
            <xsl:apply-templates/>
        </cl>
    </xsl:template>
    
   <!--ebb 2015-08-15: Uncomment this and run the transformation if you need to scrub out unwanted attributes from a problematic transformation:
       
    <xsl:template match="div[@type='chapter']">
        <div type="chapter" xml:id="{@xml:id}"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="sourceDesc">
        <sourceDesc><xsl:apply-templates/></sourceDesc>
    </xsl:template>
    <xsl:template match="editorialDecl">
        <editorialDecl><xsl:apply-templates/></editorialDecl>
    </xsl:template>
    <xsl:template match="bibl">
        <bibl><xsl:apply-templates/></bibl>
    </xsl:template>
    <xsl:template match="persName">
        <persName><xsl:apply-templates/></persName>
    </xsl:template>
    <xsl:template match="placeName">
        <placeName><xsl:apply-templates/></placeName>
    </xsl:template>
    <xsl:template match="corr">
        <corr><xsl:apply-templates/></corr> 
    </xsl:template>
    -->

</xsl:stylesheet>
