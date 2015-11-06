<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat" encoding="utf-8"
        omit-xml-declaration="yes"/>

    <!--Command line from Amadis folder: 
        
java -jar ../../SaxonHE9-6-0-7J/saxon9he.jar -s:XML-and-Schematron/Southey XSLT/toc-overlapped-bars.xsl -o:html

    -->

    <xsl:variable name="montalvo" select="collection('../XML-and-Schematron/Montalvo')"/>
    <xsl:template match="/">
        <xsl:result-document href="{'../html/toc.html'}">
            <html>
                <head>
                    <title>Table of contents</title>
                    <meta name="keywords"
                        content="Amadis of Gaule, Amadís de Gaula, Garci Rodríguez de Montalvo, 
                        Robert Southey, TEI, Text Encoding Initiative, romance of chivalry, libro de caballerías, 
                        libro de caballería, digital humanities, dh, textual scholarship, digital scholarship, 
                        translation studies, studies in translation"/>
                    <link rel="stylesheet" type="text/css" href="amadis.css"/>
                </head>
                <body>
                    <h1>Table of contents</h1>
                    <hr/>
                    <ul>
                        <xsl:for-each select="collection('../XML-and-Schematron/Southey')">
                            <xsl:sort select="//div[@type = 'chapter']/substring(@xml:id, 2)"
                                data-type="number"/>
                            <xsl:if test="current()//anchor">
                                <xsl:apply-templates select="//div[@type = 'chapter']"/>
                            </xsl:if>
                        </xsl:for-each>
                    </ul>
                    <p class="boilerplate">
                        <span><strong>Maintained by: </strong> Elisa E. Beshero-Bondar (ebb8 at +
                            pitt.edu) <a rel="license"
                                href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img
                                    alt="Creative Commons License" style="border-width:0"
                                    src="https://licensebuttons.net/l/by-nc-sa/4.0/80x15.png"
                                /></a><a rel="license"
                                href="http://creativecommons.org/licenses/by-nc-sa/4.0/"
                                /><strong>Last modified:</strong>
                            <!--#echo var="LAST_MODIFIED" -->. <a
                                href="http://newtfire.org/firebellies.html">Powered by +
                                firebellies</a>.</span>
                    </p>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="div[@type eq 'chapter']">
        <xsl:variable name="montalvo-chapter"
            select="
                $montalvo//div[@type[. eq 'chapter']][number(substring(@xml:id, 2)) + 1 =
                number(substring(current()/@xml:id, 2))]"/>
        <xsl:variable name="clauses"
            select="
                $montalvo-chapter//cl[not(@xml:id = current()//anchor/substring(@synch, 2))]"/>
        <xsl:variable name="montalvo-clauses" select="$montalvo-chapter//cl"/>
        <xsl:variable name="southey-chapter"  select="//head/substring-before(., '.')"/>
        <li>
            <h2>
                <a href="{concat(replace($southey-chapter, '\s+', ''), '.html')}">
                    <xsl:choose>
                        <xsl:when test="$clauses/ancestor::div/head[choice]">
                            <xsl:value-of select="$clauses/ancestor::div/head//reg"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$clauses/ancestor::div//head/text()[1]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> --- </xsl:text>
                    <xsl:value-of select="$southey-chapter"/>
                </a>
            </h2>
            <xsl:variable name="width1" select="count($montalvo-clauses)"/>
            <xsl:variable name="montalvo-match"
                select="$montalvo-chapter//cl[@xml:id = current()//anchor/substring(@synch, 2)]"/>
            <xsl:variable name="montalvo-matched-clauses" select="count($montalvo-match)"/>
            <xsl:variable name="southey-clauses" select="count(current()//anchor[@ana = 'start'])"/>
            <xsl:variable name="width2" select="($width1 - $montalvo-matched-clauses) + 80"/>
            <div class="svg">
                <svg xmlns="http://www.w3.org/2000/svg" width="490" height="75">
                    <g>
                        <rect y="12" fill="#d61d08" stroke="#550b03" stroke-width="2" height="20"
                            opacity="0.7" stroke-opacity="1" x="{$width2}"
                            width="{$southey-clauses}"/>
                        <text y="29" fill="#220a00" x="{$width2 + $southey-clauses + 7}"
                            >Southey</text>
                    </g>
                    <g>
                        <rect fill="#fdd221" stroke="#550b03" stroke-width="2" height="20"
                            opacity="0.7" stroke-opacity="1" width="{$width1}" y="12" x="80"/>
                        <text y="29" fill="#220a00">Montalvo</text>
                    </g>
                    <text fill="#461801" y="65" x="52" font-size="18">Omissions and additions by
                        Southey</text>
                </svg>

                <xsl:variable name="text">
                    <xsl:for-each select="//anchor[@synch]">
                        <xsl:value-of
                            select="
                                current()/following::text()
                                except (current()/following::node()[@ana = 'end'][1]/following::node()) except current()//following::note//text()"
                        />
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="correction"
                    select="string-join($text/replace(., '[.,/?:;]', ''))"/>
                <xsl:variable name="southey-words" select="count(tokenize($correction, '\s+'))"/>
                <xsl:variable name="southey-matched-clauses" select="count(//anchor[@synch])"/>
                <xsl:variable name="montalvo-words"
                    select="count(tokenize(string-join($montalvo-match/replace(., '[.,/?:;]', ''), ' '), '\s+'))"/>

                <xsl:variable name="width3" select="$montalvo-words div $montalvo-matched-clauses * 4"/>
                <xsl:variable name="width4" select="$southey-words div $southey-matched-clauses * 4"/>
                <svg xmlns="http://www.w3.org/2000/svg" width="350" height="100">
                    <g>
                        <rect fill="#adc2bb" stroke="#220a00" stroke-width="2" height="20"
                            width="{$width3}" y="1" x="80"/>
                        <text y="16" fill="#220a00">Montalvo</text>
                        <text y="16" fill="#220a00" x="{$width3 + 85}" font-size="13"><xsl:value-of
                                select="round-half-to-even(($width3 div 4), 2)"/> words per
                            match</text>
                    </g>
                    <g>
                        <rect fill="#adc2bb" stroke="#220a00" stroke-width="2" height="20"
                            width="{$width4}" y="21" x="80"/>
                        <text y="36" fill="#220a00">Southey</text>
                        <text y="36" fill="#220a00" x="{$width4 + 85}" font-size="13"><xsl:value-of
                                select="round-half-to-even(($width4 div 4), 2)"/> words per
                            match</text>
                    </g>
                    <text fill="#461801" y="65" x="81" font-size="18">Word count comparison</text>
                </svg>
            </div>
        </li>
    </xsl:template>
</xsl:stylesheet>
