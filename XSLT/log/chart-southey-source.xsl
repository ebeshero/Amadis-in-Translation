<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat"  encoding="utf-8"  omit-xml-declaration="yes"/>

    <!--    Command line from Amadis folder:
    java -jar ../../SaxonHE9-6-0-7J/saxon9he.jar -s:XML-and-Schematron/Southey XSLT/chart-southey-source.xsl -o:tables
    -->

    <xsl:variable name="montalvo" select="collection('../XML-and-Schematron/Montalvo')"/>
    <xsl:template match="/">
        <xsl:for-each select="collection('../XML-and-Schematron/Southey')[.//anchor]">
            <xsl:variable name="title">
                <xsl:value-of select="//body/div[@type = 'chapter']/@xml:id"/>
            </xsl:variable>
            <xsl:result-document href="{concat('../tables/', $title, '.html')}">
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
        <xsl:variable name="match" select="$montalvo//cl[@xml:id = current()/substring(@synch, 2)]"/>
        <xsl:element name="tr">
            <xsl:element name="td">
                <xsl:value-of select="$match/normalize-space()"/>
            </xsl:element>
            <xsl:element name="td">
                <xsl:if test="current()/@type = 'report'">
                    <xsl:attribute name="class">report</xsl:attribute>
                </xsl:if>
                <xsl:if test="current()/@type = 'direct'">
                    <xsl:attribute name="class">direct</xsl:attribute>
                </xsl:if>
                <xsl:if test="current()/@type = 'add'">
                    <xsl:attribute name="class">add</xsl:attribute>
                </xsl:if>
                <!--<xsl:if
                    test="
                        $montalvo//cl[@xml:id = current()/substring(@synch, 2)][following-sibling::cl[1]
                        [not(@xml:id = current()/(following::anchor | preceding::anchor)/substring(@synch, 2))]]">
                    <xsl:attribute name="class">omission</xsl:attribute>
                </xsl:if>-->
                <xsl:value-of
                    select="
                        current()/following::text()
                        except (current()/following::node()[@ana = 'end'][1]/following::node())"/>
            </xsl:element>
            <xsl:element name="td">
                <xsl:choose>
                    <xsl:when test="current()/@type = 'add'">
                        <xsl:text>Addition</xsl:text>
                    </xsl:when>
                    <xsl:when test="current()/@type = 'report'">
                        <xsl:text>Reported speech</xsl:text>
                    </xsl:when>
                    <xsl:when test="current()/@type = 'direct'">
                        <xsl:text>Directed speech</xsl:text>
                    </xsl:when>
<!--                    <xsl:when
                        test="
                            $montalvo//cl[@xml:id = current()/substring(@synch, 2)][following-sibling::cl[1]
                            [not(@xml:id = current()/(following::anchor | preceding::anchor)/substring(@synch, 2))]]">
                        <xsl:text>Omission</xsl:text>-->
                    <!--</xsl:when>-->
                    <xsl:otherwise>No tagged type</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <td>Comments</td>
        </xsl:element>
        <xsl:if
            test="
                $match[following-sibling::cl[1]
                [not(@xml:id = current()/(following::anchor | preceding::anchor)/substring(@synch, 2))]]">
            <tr>
                <td class="omission">
                    <xsl:for-each
                        select="
                            $match/following-sibling::cl[not(@xml:id = current()/
                            (following::anchor | preceding::anchor)/substring(@synch, 2))]
                            except $match/following-sibling::cl[not(@xml:id = current()/
                            (following::anchor | preceding::anchor)/substring(@synch, 2))]
                            [following-sibling::cl[1][@xml:id = current()/(following::anchor | preceding::anchor)/substring(@synch, 2)]]/
                            following-sibling::cl">
                        <xsl:value-of select="string-join(., ' ')"/>
                    </xsl:for-each>
                </td>
                <td/>
                <td>Omission</td>
                <td>Comments</td>
            </tr>

        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
