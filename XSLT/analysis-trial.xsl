<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat" encoding="utf-8"
        omit-xml-declaration="yes"/>
    <xsl:function name="functx:capitalize-first" as="xs:string?">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="
            concat(upper-case(substring($arg,1,1)),
            substring($arg,2))
            "/>
        
    </xsl:function>

    <xsl:template match="/">
        <xsl:result-document href="../html/analysis-1.html">
            <html>
                <head>
                    <title>Charts and stats</title>
                    <meta name="keywords"
                        content="Amadis of Gaule, Amadís de Gaula, Garci Rodríguez de Montalvo, Robert Southey, TEI, 
                            Text Encoding Initiative, romance of chivalry, libro de caballerías, libro de caballería, digital humanities, 
                            dh, textual scholarship, digital scholarship, translation studies, studies in translation"/>
                    <link rel="stylesheet" type="text/css" href="amadis.css"/>
                    <script type="text/javascript" src="notes.js">/**/</script>
                </head>
                <body>
                    <h1>Alignment charts</h1>
                    <hr/>
                    <h2>Chapter 1</h2>
                    <table>
                        <thead>
                            <tr>
                                <th>Southey</th>
                                <th>Montalvo</th>
                                <th>Word count rate</th>
                                <th>Type</th>
                                <th>Subtype</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:apply-templates select="//fs[not(f[@name = 'note'])]"/>
                        </tbody>
                    </table>


                    <footer>
                        <p class="boilerplate">
                            <span><strong>Maintained by: </strong> Elisa E. Beshero-Bondar (ebb8 at
                                pitt.edu) <a rel="license"
                                    href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img
                                        alt="Creative Commons License" style="border-width:0"
                                        src="https://licensebuttons.net/l/by-nc-sa/4.0/80x15.png"
                                    /></a><a rel="license"
                                    href="http://creativecommons.org/licenses/by-nc-sa/4.0/"
                                    /><xsl:text> </xsl:text><strong>Last modified:</strong>
                                <xsl:comment>#echo var="LAST_MODIFIED" </xsl:comment>. <a
                                    href="http://newtfire.org/firebellies.html">Powered by
                                    firebellies</a>.</span>
                        </p>
                    </footer>
                </body>
            </html>
        </xsl:result-document>

    </xsl:template>
    <xsl:template match="fs">
        <tr>
            <xsl:element name="td">
                <xsl:if test="current()/not(f[@name = 'montalvo'])">
                    <xsl:attribute name="class">add</xsl:attribute>
                </xsl:if>
                <xsl:if test="current()/f[@name eq 'subtype'][contains(@select, 'addition')]">
                    <xsl:attribute name="class">add</xsl:attribute>
                </xsl:if>
                <xsl:if test="current()/f[@name eq 'subtype'][contains(@select, 'liberal')]">
                    <xsl:attribute name="class">liberal</xsl:attribute>
                </xsl:if>
                <xsl:if test="parent::f">
                    <xsl:attribute name="title">note</xsl:attribute>
                </xsl:if>
                <xsl:if test="current()/f[string[@ana = 'note']]">
                    <xsl:attribute name="class">embNote</xsl:attribute>
                </xsl:if>
                <xsl:for-each select="f[@name = 'southey']/string">
                    <xsl:value-of select="current() except current()[@ana = 'note']"/>
                    <xsl:if test="@ana = 'note'">
                        <span class="noteContents">
                            <xsl:value-of select="current()"/>
                        </span>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="td">
                <xsl:if test="current()/not(f[@name = 'southey'])">
                    <xsl:attribute name="class">omission</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="f[@name = 'montalvo']/string"/>
            </xsl:element>
            <xsl:element name="td">
                <xsl:if test="f[@name = 'southey']/number(@ana) gt 0.7">
                    <xsl:attribute name="class">compression</xsl:attribute>
                </xsl:if>
                <xsl:if test="f[@name = 'southey']/number(@ana) lt 0">
                    <xsl:attribute name="class">expansion</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="f[@name = 'southey']/@ana"/>
            </xsl:element>
            <td>
                <xsl:value-of select="functx:capitalize-first(f[@name eq 'type']/@select)"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="count(tokenize(f[@name eq 'subtype']/@select, '\s')) eq 1">
                        <xsl:if
                            test="not(f[@name eq 'subtype']/@select eq 'addition') and not(f[@name eq 'subtype']/@select eq 'omission') and not(f[@name eq 'subtype']/@select eq 'syntax')">
                            <xsl:value-of select="functx:capitalize-first(f[@name eq 'subtype']/@select)"/>
                        </xsl:if>
                        <xsl:if test="f[@name eq 'subtype']/@select eq 'addition'">
                            <xsl:text>Liberal with added contents</xsl:text>
                        </xsl:if>
                        <xsl:if test="f[@name eq 'subtype']/@select eq 'omission'">
                            <xsl:text>Compressed by omission</xsl:text>
                        </xsl:if>                        
                        <xsl:if test="f[@name eq 'subtype']/@select eq 'syntax'">
                            <xsl:text>Altered syntax</xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="functx:capitalize-first(replace(replace(string-join(tokenize(f[@name eq 'subtype']/@select, '\s'), ', '), 'omission', 'compressed by omission'),
                            'syntax', 'altered syntax'))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
