<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat" encoding="utf-8"
        omit-xml-declaration="yes"/>

    <!--Command line from Amadis folder: 
        
java -jar ../../SaxonHE9-6-0-7J/saxon9he.jar -s:XML-and-Schematron/Southey XSLT/chart-pages.xsl -o:html

    -->
    <xsl:template match="/">
        <xsl:for-each select="collection('../tables')//TEI">
            <xsl:variable name="chapter" select="current()//head/substring-before(., '.')"/>
            <xsl:result-document href="{concat('../html/', replace($chapter, '\s+', ''), '.html')}">
                <html>
                    <head>
                        <title>Charts and stats</title>
                        <meta name="keywords"
                            content="Amadis of Gaule, Amadís de Gaula, Garci Rodríguez de Montalvo, Robert Southey, TEI, 
                        Text Encoding Initiative, romance of chivalry, libro de caballerías, libro de caballería, digital humanities, 
                        dh, textual scholarship, digital scholarship, translation studies, studies in translation"/>
                        <link rel="stylesheet" type="text/css" href="amadis.css"/>
                    </head>
                    <body>
                        <h1>Alignment charts</h1>
                        <hr/>
                        <div class="container">
                            <div class="toc">
                                <h3>Table of contents</h3>
                                <ul>
                                    <xsl:for-each select="collection('../tables')//TEI">
                                        <xsl:sort
                                            select="//div[@type = 'table']/number(substring(@xml:id, 2))"
                                            data-type="number"/>
                                        <xsl:variable name="chapter"
                                            select="current()//head/substring-before(., '.')"/>
                                        <li>
                                            <a
                                                href="{concat(replace($chapter, '\s+', ''), '.html')}">
                                                <xsl:value-of select="$chapter"/>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </div>
                            <main>
                                <h2>
                                    <xsl:value-of select="$chapter"/>
                                </h2>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Southey</th>
                                            <th>Montalvo</th>
                                            <th>Word count rate</th>
                                            <th>Analysis</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:apply-templates select="//fs"/>
                                    </tbody>
                                </table>
                            </main>

                        </div>
                        <footer>
                            <p class="boilerplate">
                                <span><strong>Maintained by: </strong> Elisa E. Beshero-Bondar (ebb8
                                    at + pitt.edu) <a rel="license"
                                        href="http://creativecommons.org/licenses/by-nc-sa/4.0/"
                                            ><img alt="Creative Commons License"
                                            style="border-width:0"
                                            src="https://licensebuttons.net/l/by-nc-sa/4.0/80x15.png"
                                        /></a><a rel="license"
                                        href="http://creativecommons.org/licenses/by-nc-sa/4.0/"
                                        /><strong>Last modified:</strong>
                                    <!--#echo var="LAST_MODIFIED" -->. <a
                                        href="http://newtfire.org/firebellies.html">Powered by +
                                        firebellies</a>.</span>
                            </p>
                        </footer>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>

    </xsl:template>
    <xsl:template match="fs">
        <tr>
            <xsl:element name="td">
                <xsl:if test="current()/not(f[@name = 'montalvo'])">
                    <xsl:attribute name="class">add</xsl:attribute>
                </xsl:if>
                <xsl:if test="current()/f[@select = 'report']">
                    <xsl:attribute name="class">report</xsl:attribute>
                </xsl:if>
                <xsl:if test="current()/f[@select = 'direct']">
                    <xsl:attribute name="class">direct</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="f[@name = 'southey']/string"/>
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
                <xsl:if test="f[@select = 'indefinite']">Match</xsl:if>
                <xsl:if test="f[@select = 'omission']">Omission</xsl:if>
                <xsl:if test="f[@select = 'add']">Addition</xsl:if>
                <xsl:if test="f[@select = 'report']">Reported speech</xsl:if>
                <xsl:if test="f[@select = 'direct']">Direct speech</xsl:if>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
