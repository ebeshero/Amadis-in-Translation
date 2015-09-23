<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <!--ebb: 2015-08-26: See GitHub Issue#8 on our goals with numbering in 
        xml:ids: 
            https://github.com/ebeshero/Amadis-in-Translation/issues/8
            -->
    
    <xsl:template match="floatingText">
        <floatingText>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="./ancestor::div[@type='chapter']/@xml:id"/>
                <xsl:text>_ft</xsl:text>
                <xsl:if test="./ancestor::floatingText">
                    <xsl:text>-ft</xsl:text>
                </xsl:if>
                <!--ebb 2015-08-26: floatingText could be sitting at any level of
                    the XML document hierarchy, including inside another floatingText, and 
                    it's possible we will see multiple floatingText elements in a chapter.
                    If we do have any floatingTexts nested inside floatingTexts, we think it might be of use later to flag them in our
                    xml:ids, which is what we're doing with the <xsl:if> statement.--> 
                <xsl:number level="any"/>
            </xsl:attribute>
            
            <xsl:apply-templates/>
            
        </floatingText>
        
    </xsl:template>
    
    <xsl:template match="cl[not(ancestor::argument)]">
        <cl>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="./ancestor::div[@type='chapter']/@xml:id"/>
               
                <xsl:if test="./ancestor::floatingText">
                    <xsl:text>_ft</xsl:text>
                    <xsl:number select="./ancestor::floatingText[1]" level="any"/>
                </xsl:if>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="./parent::*/name()"/>
                
                <xsl:number select="./parent::*" level="any" count="//div[@type='chapter']//p[not(parent::argument)]"/>
                              
                <xsl:text>_c</xsl:text>
                <xsl:number level="any" count="//div[@type='chapter']//cl[not(ancestor::argument)]"/>
            </xsl:attribute>

            <xsl:apply-templates/>
        </cl>
    </xsl:template>
    
   <xsl:template match="l">
        <!--ebb 2015-08-26: This is for placing xml:ids on lines of poetry, which will most likely, 
            Stacey says, sit within floatingText elements. 
            Line-groups may or may not be positioned inside
            paragraphs, and since they're fundamentallly distinct from our <cl> units, it seems simplest just 
            to encode their relationship to their ancestor <floatingText>. 
          
            We don't care about getting stanza numbers or line positions inside stanzas, so 
            in this case, we just number lines of poetry consecutively within a whole chapter
            with <xsl:number level="any">. 
        -->
     
        <l>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="./ancestor::div[@type='chapter']/@xml:id"/>
                
                <xsl:if test="./ancestor::floatingText">
                    <xsl:text>_ft</xsl:text>
                    <xsl:number select="./ancestor::floatingText" level="any"/>
                </xsl:if>
  <!--ebb 2015-08-26: To keep this simple, I'm not bothering to locate the nearest paragraph for lines of poetry, since
      we are numbering all lines of poetry consecutively within the chapter.-->
               
                <xsl:text>_ln</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            
            <xsl:apply-templates/>
            
        </l>
        
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
