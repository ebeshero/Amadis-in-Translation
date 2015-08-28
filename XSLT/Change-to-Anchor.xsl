<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>
    
<xsl:mode on-no-match="shallow-copy"/>
   <!--ebb 2015-08-27: This wonderful single line is now all you need to
       run an identity transformation in XSLT 3.0! 
       Streaming doesn't seem to be supported in oXygen, but
    to read more about it and the new built-in template for "shallow-copy" 
    see http://www.w3.org/TR/xslt-30/#built-in-templates-shallow-copy
    
    What happens here is that for anything you have NOT written a template
    rule to alter or remove, the stylesheet simply copies all the nodes, attributes,
    etc. You don't need the @streamable attribute at all; I'm just curious 
    about it and leaving it in for future reference, for perhaps one day 
    serving an XSLT like this over a web server or from eXist.
    -->

    <xsl:template match="milestone[@unit='transUnit']">
     <xsl:choose>  <xsl:when test="@synch"> 
           <anchor ana="{@ana}" synch="{@synch}"/>
       </xsl:when>
          <xsl:when test="@type">
              <anchor ana="{@ana}" type="{@type}"/>
          </xsl:when>
        <xsl:otherwise>
            <anchor ana="{@ana}"/>
        </xsl:otherwise>
     </xsl:choose>
       
        
    </xsl:template>
    
    
</xsl:stylesheet>
    
