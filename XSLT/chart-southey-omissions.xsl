<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml"/>
    <xsl:variable name="southey"
        select="document('../XML-and-Schematron/Southey/Southey_Amadis_1803_1.xml')"/>
    <xsl:template match="/">
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
    </xsl:template>
    <xsl:template match="cl">
        <xsl:if test="not(current()/@xml:id = //$southey//anchor/substring(@synch, 2))">
            <tr>
                <td>
                    <xsl:value-of select="current()"/>
                </td>
                <td class="omission">--</td>
                <td>Omission</td>
                <td>Comments</td>
            </tr>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
