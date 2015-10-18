<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xhtml" doctype-system="about:legacy-compat"/>

    <!--Command line from Amadis folder: 
        
java -jar ../../SaxonHE9-6-0-7J/saxon9he.jar -s:XML-and-Schematron/Southey XSLT/toc.xsl -o:tables

    -->

    <xsl:variable name="montalvo" select="collection('../XML-and-Schematron/Montalvo')"/>
    <xsl:template match="/">
        <xsl:result-document href="{'../tables/toc.xhtml'}">
            <html>
                <head>
                    <title>Table of contents</title>
                    <link type="text/css" rel="stylesheet" href="table.css"/>
                </head>
                <body>
                    <h1>Table of contents</h1>
                    <ul>
                        <xsl:for-each select="collection('../XML-and-Schematron/Southey')">
                            <xsl:sort select="current()//head"/>
                            <xsl:if test="current()//anchor">
                                <xsl:apply-templates select="//div[@type = 'chapter']"/>
                            </xsl:if>
                        </xsl:for-each>
                    </ul>
                    <ol>
                        <li>Proportion of Montalvo text that was omitted by Southey (which means
                            that 100% is equal to the total of Montalvo's clauses/words)</li>
                        <li>Proportion of Southey text that was not present in Montalvo (which means
                            that 100% is equal to the total of Southey's clauses/words)</li>
                        <li>Average word count per matching clause/anchor</li>
                    </ol>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="div[@type = 'chapter']">
        <xsl:variable name="montalvo-chapter"
            select=" $montalvo//div[@type[. = 'chapter']][number(substring(@xml:id, 2)) + 1 =
            number(substring(current()/@xml:id, 2))]"/>
        <xsl:variable name="clauses"
            select="
            $montalvo-chapter//cl[not(@xml:id = current()//anchor/substring(@synch, 2))]"/>
        <xsl:variable name="allCl" select="$montalvo-chapter//cl"/>
        <xsl:variable name="words" select="tokenize(string-join($clauses/replace(., '[.,/?:;]', ''), ' '), '\s+')"/>
        <xsl:variable name="totalW" select="tokenize(string-join($allCl, ' '), '\s+')"/>
        <xsl:variable name="width1" select="(count($clauses) * 100) div count($allCl) * 2"/>
        <xsl:variable name="width2" select="(count($words) * 100) div count($totalW) * 2"/>
        <li>
            <h2>
                <a>
                    <xsl:value-of select="$clauses/ancestor::div//head/text()[1]"/>
                </a>
                <xsl:text> --- </xsl:text>
                <a>
                    <xsl:value-of select="//head/text()[1]"/>
                </a>
            </h2>
            <div class="svg">
                <svg xmlns="http://www.w3.org/2000/svg" width="270" height="75">
                    <g>
                        <rect fill="#7E967E" stroke="#031B3F" stroke-width="2" height="20"
                            width="{$width1}" y="0" x="60"/>
                        <rect fill="none" stroke="#031B3F" stroke-width="2" height="20" width="200"
                            y="0" x="60"/>
                        <text y="16" fill="#031B3F">clauses</text>
                        <text y="16" fill="#031B3F" x="{$width1 + 70}" font-size="13"><xsl:value-of
                                select="round-half-to-even(($width1 div 2), 2)"/>%</text>
                    </g>
                    <g>
                        <rect fill="#7E967E" stroke="#031B3F" stroke-width="2" height="20"
                            width="{$width2}" y="20" x="60"/>
                        <rect fill="none" stroke="#031B3F" stroke-width="2" height="20" width="200"
                            y="20" x="60"/>
                        <text y="36" fill="#031B3F">words</text>
                        <text y="36" fill="#031B3F" x="{$width2 + 70}" font-size="13"><xsl:value-of
                                select="round-half-to-even(($width2 div 2), 2)"/>%</text>
                    </g>
                    <text fill="#031B3F" y="56" x="80" font-size="16">Omissions by Southey</text>
                </svg>
                <xsl:variable name="aditions" select="count(current()//anchor[@type='add'])"/>
                <xsl:variable name="total" select="$aditions + count(current()//anchor[@synch])"/>
                <xsl:variable name="width3" select="($aditions * 100) div $total * 2"/>
                <xsl:variable name="southey-text"
                    select="tokenize(string-join(//s/text()/replace(., '[.,/?:;]', ''), ' '), '\s+')"/>
                <xsl:variable name="aditionsW">
                    <xsl:for-each select="//anchor[@type='add']">
                        <xsl:value-of
                            select="current()/following::text()
                            except (current()/following::node()[@ana = 'end'][1]/following::node())"
                        />
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="wordsAdded"
                    select="tokenize(string-join($aditionsW/replace(., '[.,/?:;]', ''), ' '), '\s+')"/>
                <xsl:variable name="width4"
                    select="(count($wordsAdded) * 100) div count($southey-text) * 2"/>
                <svg xmlns="http://www.w3.org/2000/svg" width="270" height="75">
                    <g>
                        <rect fill="#7E967E" stroke="#031B3F" stroke-width="2" height="20"
                            width="{$width3}" y="0" x="60"/>
                        <rect fill="none" stroke="#031B3F" stroke-width="2" height="20" width="200"
                            y="0" x="60"/>
                        <text y="16" fill="#031B3F">clauses</text>
                        <text y="16" fill="#031B3F" x="{$width3 + 70}" font-size="13"><xsl:value-of
                                select="round-half-to-even(($width3 div 2), 2)"/>%</text>
                    </g>
                    <g>
                        <rect fill="#7E967E" stroke="#031B3F" stroke-width="2" height="20"
                            width="{$width4}" y="20" x="60"/>
                        <rect fill="none" stroke="#031B3F" stroke-width="2" height="20" width="200"
                            y="20" x="60"/>
                        <text y="36" fill="#031B3F">words</text>
                        <text y="36" fill="#031B3F" x="{$width4 + 70}" font-size="13"><xsl:value-of
                                select="round-half-to-even(($width4 div 2), 2)"/>%</text>
                    </g>
                    <text fill="#031B3F" y="56" x="80" font-size="16">Additions by Southey</text>
                </svg>
                <xsl:variable name="montalvo-match"
                    select="$montalvo-chapter//cl[@xml:id = current()//anchor/substring(@synch, 2)]"/>
                <xsl:variable name="text">
                    <xsl:for-each select="//anchor[@synch]">
                        <xsl:value-of
                            select="
                           current()/following::text()
                           except (current()/following::node()[@ana = 'end'][1]/following::node())"
                        />
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="correction"
                    select="string-join($text/replace(., '[.,/?:;]', ''))"/>
                <xsl:variable name="southey-words" select="count(tokenize($correction, '\s+'))"/>
                <xsl:variable name="montalvo-words"
                    select="count(tokenize(string-join($montalvo-match/replace(., '[.,/?:;]', ''), ' '), '\s+'))"/>
                <xsl:variable name="montalvo-clauses" select="count($montalvo-match)"/>
                <xsl:variable name="southey-clauses" select="count(//anchor[@synch])"/>
                <xsl:variable name="width5" select="$montalvo-words div $montalvo-clauses * 4"/>
                <xsl:variable name="width6" select="$southey-words div $southey-clauses * 4"/>
                <svg xmlns="http://www.w3.org/2000/svg" width="350" height="100">
                    <g>
                        <rect fill="#7E967E" stroke="#031B3F" stroke-width="2" height="20"
                            width="{$width5}" y="0" x="70"/>
                        <text y="16" fill="#031B3F">Montalvo</text>
                        <text y="16" fill="#031B3F" x="{$width5 + 75}" font-size="13"><xsl:value-of
                            select="round-half-to-even(($width5 div 4), 2)"/> words per
                            match</text>
                    </g>
                    <g>
                        <rect fill="#7E967E" stroke="#031B3F" stroke-width="2" height="20"
                            width="{$width6}" y="20" x="70"/>
                        <text y="36" fill="#031B3F">Southey</text>
                        <text y="36" fill="#031B3F" x="{$width6 + 75}" font-size="13"><xsl:value-of
                                select="round-half-to-even(($width6 div 4), 2)"/> words per
                            match</text>
                    </g>
                    <text fill="#031B3F" y="56" x="80" font-size="16">Word count comparison</text>
                </svg>
            </div>
        </li>
    </xsl:template>
</xsl:stylesheet>
