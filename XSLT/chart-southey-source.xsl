<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat"/>
    <xsl:variable name="montalvo" select="document('../Montalvo_Amadis_1547_0.xml')"/>
    <xsl:template match="/">
        <xsl:for-each select="TEI">
            <xsl:variable name="title">
                <xsl:value-of select="//body/div[@type = 'chapter']/@xml:id"/>
            </xsl:variable>
            <xsl:result-document href="{concat('../tables/', $title, '.xhtml')}">
                <html>
                    <head>
                        <title>Tables for analysis</title>
                        <style>
                            body{
                                background-color:#B4D6B4;
                                color:#031B3F;
                                font-family:arial, helvetica, sans-serif;
                                padding:15px;
                                line-height:1.3em;
                            }
                            
                            h1{
                                color:#AA0000;
                            }
                            table{
                                border-collapse:collapse;
                                width:100%;
                                border:2px solid #BF9E7D;
                            }
                            
                            tr{
                                border-collapse:collapse;
                                border:0
                            }
                            
                            th
                            {
                                border-collapse:collapse;
                                border:1px solid #000066;
                                background-color:#7E967E;
                                padding:1px;
                                color:#5F0000;
                                vertical-align:top;
                            }
                            
                            td
                            {
                                border-collapse:collapse;
                                border:1px solid #000066;
                                padding:7px;
                                vertical-align:top;
                            }</style>
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
                    select="$montalvo//cl[@xml:id = current()/substring(@synch, 2)]/normalize-space()"
                />
            </xsl:element>
            <xsl:element name="td">
                <xsl:variable name="sequence"
                    select="
                        current()/following::node()
                        except (current()/following::node()[@ana = 'end'][1]/following::node())"
                />
                <xsl:value-of select="$sequence/text()"/>
            </xsl:element>
            <xsl:element name="td">
                <xsl:choose>
                    <xsl:when test="current()/@type">
                        <xsl:value-of select="current()/@type"/>
                    </xsl:when>
                    <xsl:otherwise>No tagged type</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="td">Comments</xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
