<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="processing-instruction('xml-model')">
      <xsl:choose>
          <xsl:when test="contains(., 'Amadis.sch')">
              <xsl:processing-instruction name="xml-model">href="../Amadis.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>  
          
          
      </xsl:when>
        <xsl:otherwise>
            <xsl:copy/>
        </xsl:otherwise></xsl:choose>
      
  </xsl:template>

</xsl:stylesheet>
