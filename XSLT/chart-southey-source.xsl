<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat"/>
    <xsl:variable name="montalvo"
        select="document('../XML-and-Schematron/Montalvo/Montalvo_Amadis_1547_1.xml')"/>    
    <xsl:variable name="southey" select="document('../XML-and-Schematron/Southey/Southey_Amadis_1803_1.xml')"/>    
    <xsl:template match="/">
        <xsl:for-each select="TEI">
            <xsl:variable name="title">
                <xsl:value-of select="//body/div[@type = 'chapter']/@xml:id"/>
            </xsl:variable>
            <xsl:result-document href="{concat('../tables/', $title, '.xhtml')}">
                <html>
                    <head>
                        <title>Tables for analysis</title>
                        <link type="text/css" rel="stylesheet" href="table.css"/>
                    </head>
                    <body>
                        <h1>
                            <xsl:value-of select="//body//head"/>
                        </h1>
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
                                <xsl:apply-templates select="//anchor"/>
                            </tbody>
                        </table>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="anchor[@ana = 'start']">
        <xsl:element name="tr">
            <xsl:element name="td">
                <xsl:value-of
                    select="$montalvo//cl[@xml:id = current()/substring(@synch, 2)]/normalize-space()"/>
<!--                <xsl:if
                    test="$montalvo//cl[@xml:id = current()/substring(@synch, 2)][following-sibling::cl[1][@xml:id != current()/following::anchor/substring(@synch,2)]]">
                    <xsl:value-of
                        select="$montalvo//cl[@xml:id = current()/substring(@synch, 2)]/following-sibling::cl[1][@xml:id != current()/following::anchor/substring(@synch,2)]"
                    />
                </xsl:if>-->
            </xsl:element>
            <xsl:element name="td">
                <xsl:if test="current()/@type = 'report'">
                    <xsl:attribute name="class">report</xsl:attribute>
                </xsl:if>
                <xsl:if test="current()/@type = 'add'">
                    <xsl:attribute name="class">add</xsl:attribute>
                </xsl:if><!--
                -->
                <xsl:value-of
                    select="
                        current()/following::node()
                        except (current()/following::node()[@ana = 'end'][1]/following::node())"/>
              <!--  <xsl:if
                    test="current()/substring(@synch, 2) = $montalvo//cl[following-sibling::cl[1][@xml:id != current()/following::anchor/substring(@synch,2)]]">
                    <xsl:text> -\-OMISSION</xsl:text>
                </xsl:if>-->
            </xsl:element>
            <xsl:element name="td">
                <xsl:choose>
                    <xsl:when test="current()/@type['add']">
                        <xsl:text>Addition</xsl:text>
                    </xsl:when>                    
                    <xsl:when test="current()/@type['report']">
                        <xsl:text>Reported speech</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>No tagged type</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="td">Comments</xsl:element>
        </xsl:element>
    </xsl:template>
   <!-- <xsl:template match="$montalvo/TEI">
        <h2>Omissions</h2>
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
        <xsl:if test="$southey//anchor[@ana = 'start'][@synch ne concat('#', current()/@xml:id)]">
            <tr>
                <td>
                    <xsl:value-of select="current()"/>
                </td>
                <td class="omission">-\-</td>
                <td>Omission</td>
                <td>Comments</td>
            </tr>
        </xsl:if>
    </xsl:template>-->
</xsl:stylesheet>
