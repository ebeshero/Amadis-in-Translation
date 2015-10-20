<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>

    <!--    Command line from Amadis folder:
    java -jar ../../SaxonHE9-6-0-7J/saxon9he.jar -s:XML-and-Schematron/Southey XSLT/fs-chart.xsl -o:tables
    -->
    <xsl:variable name="montalvo" select="collection('../XML-and-Schematron/Montalvo')"/>
    <xsl:template match="/">
        <xsl:for-each select="collection('../XML-and-Schematron/Southey')[.//anchor]">
            <xsl:variable name="title">
                <xsl:value-of select="//body/div[@type = 'chapter']/@xml:id"/>
            </xsl:variable>
            <xsl:result-document href="{concat('../tables/fs-', $title, '.xml')}">
                <TEI>
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>Charts for <xsl:value-of select="$title"/></title>
                            </titleStmt>
                            <publicationStmt>
                                <p>Publication Information</p>
                            </publicationStmt>
                            <sourceDesc>
                                <p>To copy</p>
                            </sourceDesc>
                        </fileDesc>
                        <encodingDesc>
                            <editorialDecl>
                                <p>To copy</p>
                            </editorialDecl>
                        </encodingDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <div type="table">
                                <head>
                                    <xsl:value-of select="//body//head/text()[1]"/>
                                </head>
                                <xsl:apply-templates select="//anchor"/>
                            </div>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="anchor[@ana = 'start']">
        <xsl:variable name="match" select="$montalvo//cl[@xml:id = current()/substring(@synch, 2)]"/>
        <xsl:variable name="text"
            select="
                current()/following::text()
                except (current()/following::node()[@ana = 'end'][1]/following::node())"/>
        <xsl:variable name="correction" select="string-join($text/replace(., '[.,/?:;]', ''))"/>
        <xsl:variable name="southey-words" select="count(tokenize($correction, '\s+'))"/>
        <xsl:variable name="montalvo-words" select="count(tokenize($match, '\s+'))"/>
        <xsl:element name="fs">
            <xsl:if test="current()/@synch">
                <xsl:attribute name="corresp">
                    <xsl:value-of select="@synch"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:element name="f">
                <xsl:attribute name="name">southey</xsl:attribute>
                <xsl:attribute name="n">
                    <xsl:value-of select="$southey-words"/>
                </xsl:attribute>
                <xsl:if test="@synch">
                    <xsl:attribute name="ana">
                        <xsl:value-of
                            select="round-half-to-even(($montalvo-words - $southey-words) div $southey-words, 2)"
                        />
                    </xsl:attribute>
                </xsl:if>
                <string>
                    <xsl:value-of
                        select="
                            current()/following::text()
                            except (current()/following::node()[@ana = 'end'][1]/following::node())"
                    />
                </string>
            </xsl:element>
            <xsl:if test="@synch">
                <xsl:element name="f">
                    <xsl:variable name="match"
                        select="$montalvo//cl[@xml:id = current()/substring(@synch, 2)]"/>
                    <xsl:attribute name="name">montalvo</xsl:attribute>
                    <xsl:attribute name="n">
                        <xsl:value-of select="$montalvo-words"/>
                    </xsl:attribute>
                    <string>
                        <xsl:value-of select="$match/normalize-space()"/>
                    </string>
                </xsl:element>
            </xsl:if>
            <xsl:element name="f">
                <xsl:attribute name="name">type</xsl:attribute>
                <xsl:attribute name="select">
                    <xsl:if test="@type">
                        <xsl:value-of select="@type"/>
                    </xsl:if>
                    <xsl:if test="not(@type)">indefinite</xsl:if>
                </xsl:attribute>
                <string>Comments</string>
            </xsl:element>
        </xsl:element>
        <xsl:if
            test="
                $match[following-sibling::cl[1]
                [not(@xml:id = current()/(following::anchor | preceding::anchor)/substring(@synch, 2))]]">
            <xsl:variable name="omission">
                <xsl:for-each
                    select="
                    $match/following-sibling::cl[not(@xml:id = current()/
                    (following::anchor | preceding::anchor)/substring(@synch, 2))]
                    except $match/following-sibling::cl[not(@xml:id = current()/
                    (following::anchor | preceding::anchor)/substring(@synch, 2))]
                    [following-sibling::cl[1][@xml:id = current()/(following::anchor | preceding::anchor)/substring(@synch, 2)]]/
                    following-sibling::cl">
                    <xsl:value-of select="."/>
                   <!-- heb: I add this space to separate the clauses. I intended to use string-join(., ' ') but it 
                   didn't work. To compensate for the last extra space, I was forced to add a ' -1 ' to the count() 
                   function -->
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:element name="fs">
                    <xsl:variable name="corresp">
                        <xsl:for-each
                        select="
                            $match/following-sibling::cl[not(@xml:id = current()/
                            (following::anchor | preceding::anchor)/substring(@synch, 2))]
                            except $match/following-sibling::cl[not(@xml:id = current()/
                            (following::anchor | preceding::anchor)/substring(@synch, 2))]
                            [following-sibling::cl[1][@xml:id = current()/(following::anchor | preceding::anchor)/substring(@synch, 2)]]/
                            following-sibling::cl">
                            <xsl:value-of select="./@xml:id"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:attribute name="corresp"><xsl:value-of select="replace($corresp,'(\d)M', '$1 #M' )"/></xsl:attribute>
                <xsl:element name="f">
                    <xsl:variable name="correction" select="$omission/replace(., '[.,/?:;]', '')"/>
                    <xsl:attribute name="name">montalvo</xsl:attribute>                    
                    <xsl:attribute name="n"><xsl:value-of select="count(tokenize($correction, '\s+')) - 1"/></xsl:attribute>
                    <string><xsl:value-of select="$omission"/></string>
                </xsl:element>
                <f name="type" select="omission"><string>Comments</string></f>
            </xsl:element>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
