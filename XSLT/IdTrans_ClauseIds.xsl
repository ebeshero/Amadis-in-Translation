<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
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
                <xsl:number level="any"/>
            </xsl:attribute>
            
            <xsl:apply-templates/>
            
        </floatingText>
        
    </xsl:template>
    
    <xsl:template match="cl">
        <cl>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="./ancestor::div[@type='chapter']/@xml:id"/>
               
                <xsl:if test="./ancestor::floatingText">
                    <xsl:text>ft</xsl:text>
                    <xsl:number select="./ancestor::floatingText[1]" level="any"/>
                </xsl:if>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="./parent::*/name()"/>
                
                 <xsl:number select="./parent::*" level="any"/>
                              
                <xsl:text>_c</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>

            <xsl:apply-templates/>
        </cl>
    </xsl:template>
    
   <xsl:template match="l">
        <!--ebb 2015-08-26: This is for placing xml:ids on lines of poetry, which will, 
            Stacey says, sit within floatingText. 
            With this template rule, we reach up to give the xsl:number of the paragraph that appears 
            before the floatingText begins. These floatingTexts *may or may not* be nested inside a body <p>. 
            (Sometimes poems are positioned inside paragraphs, but sometimes we may see signs that they appear in between
            two clearly distinct paragraphs.) So, we need to code this to locate the nearest preceding paragraph, whether
            it is an ancestor <p>, or whether it's the nearest <p> on the preceding:: axis.
            
            The goal is to help us locate the lines of poetry where they sits in relation to the body of the text.
            We don't care about getting stanza numbers or line positions inside stanzas, so 
            in this case, we just number lines of poetry consecutively 
            with <xsl:number level="any">. 
        -->
     
        <l>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="./ancestor::div[@type='chapter']/@xml:id"/>
                
                <xsl:if test="./ancestor::floatingText">
                    <xsl:text>_ft</xsl:text>
                    <xsl:number select="./ancestor::floatingText" level="any"/>
                </xsl:if>
                
                <xsl:text>_p</xsl:text>
                
                <xsl:choose>
                  <xsl:when test=".[not(ancestor::p)]">
                      
                    <xsl:number select="./ancestor::*[preceding-sibling::p][1]/preceding-sibling::p[1]" level="any"/>
                      
                  </xsl:when>
                    <xsl:otherwise>
                    <xsl:number select="./ancestor::p[1]" level="any"/>
                    </xsl:otherwise>
                
                </xsl:choose>
                
              <!--  <xsl:number select="./parent::*" level="multiple"/>-->
                
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
