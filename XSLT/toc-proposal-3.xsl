<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat" encoding="utf-8"
        omit-xml-declaration="yes"/>

    <!--Command line from Amadis folder: 
        
java -jar ../../../SaxonHE9-6-0-7J/saxon9he.jar -s:XML-and-Schematron/Southey XSLT/toc-proposal-3.xsl -o:html

    -->

    <xsl:variable name="montalvo" select="collection('../XML-and-Schematron/Montalvo')"/>
    <xsl:template match="/">
        <xsl:result-document href="{'../html/toc-3.html'}">
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
                        <li>Overlapping bars.</li>
                        <li>Montalvo has a fixed width so the attention is focused on the omissions
                            and additions (because the chapter lenghts are not considered).</li>
                        <li>Calculations made attending to the number of clauses/anchors.</li>
                    </ul>
                    <xsl:for-each select="collection('../XML-and-Schematron/Southey')">
                        <xsl:sort select="//div[@type = 'chapter']/substring(@xml:id, 2)"
                            data-type="number"/>
                        <xsl:if test="current()//anchor">
                            <xsl:apply-templates select="//div[@type = 'chapter']"/>
                        </xsl:if>
                    </xsl:for-each>

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
                $montalvo-chapter//cl[not(seg)][not(@xml:id = current()//anchor/substring(@corresp, 2))]"/>
        <xsl:variable name="montalvo-clauses" select="$montalvo-chapter//cl"/>
        <xsl:variable name="southey-chapter" select="//head/substring-before(., '.')"/>
        <a href="{concat(replace($southey-chapter, '\s+', ''), '.html')}">
            <h2>
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
            </h2>
        </a>
        <xsl:variable name="variable" select="300 div count($montalvo-clauses)"/>
        <xsl:variable name="montalvo-match"
            select="
                $montalvo-chapter//cl[@xml:id = current()//anchor/substring(@corresp, 2)] |
                $montalvo-chapter//seg[@xml:id = current()//anchor/substring(@corresp, 2)]"/>
        <xsl:variable name="montalvo-matched-clauses" select="count($montalvo-match) * $variable"/>
        <xsl:variable name="southey-clauses"
            select="count(current()//anchor[@ana = 'start']) * $variable"/>
        <xsl:variable name="position" select="(300 - $montalvo-matched-clauses) + 80"/>
        <xsl:variable name="omissions"
            select="round-half-to-even((count($montalvo-clauses) - count($montalvo-match)) * 100 div count($montalvo-clauses), 1)"/>
        <xsl:variable name="common-text-m"
            select="round-half-to-even((count($montalvo-match) * 100) div count($montalvo-clauses), 1)"/>
        <xsl:variable name="common-text-s"
            select="
                round-half-to-even(count(current()//anchor[@corresp]) * 100
                div count(current()//anchor[@ana eq 'start']), 1)"/>
        <xsl:variable name="additions"
            select="round-half-to-even(count(current()//anchor[@type eq 'add']) * 100 div count(current()//anchor[@ana = 'start']), 1)"/>
        <div class="svg">
            <svg xmlns="http://www.w3.org/2000/svg" width="510" height="125">
                <g>
                    <rect y="12" fill="#d61d08" stroke="#550b03" stroke-width="2" height="20"
                        opacity="0.7" stroke-opacity="1" x="{$position}" width="{$southey-clauses}"/>
                    <text y="29" fill="#220a00" x="{$position + $southey-clauses + 7}"
                        >Southey</text>
                </g>
                <g>
                    <rect fill="#fdd221" stroke="#550b03" stroke-width="2" height="20" opacity="0.7"
                        stroke-opacity="1" width="300" y="12" x="80"/>
                    <text y="29" fill="#220a00">Montalvo</text>
                </g>
                <text fill="#461801" y="65" x="84" font-size="18">Omissions and additions by
                    Southey</text>
            </svg>
        </div>
    </xsl:template>
</xsl:stylesheet>
