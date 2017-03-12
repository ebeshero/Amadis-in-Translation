<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>  
 
    <pattern>
        <rule context="tei:div[@type eq 'chapter']/@xml:id[contains(., 'M')][not(. eq'M0')]">
            <let name="M_C" value="substring-after(., 'M')"/>
            <let name="M_Cnum" value="number($M_C)"/>
            <xsl:variable name="Roman_Cnum">
                <xsl:number value="$M_Cnum" format="I"/>
            </xsl:variable>
            <!-- I think the following might be more concisely and clearly        -->
            <!-- specified as                                                     -->
            <!-- tokenize(parent::tei:div/tei:head/string(),' ')[2] eq $Roman_Cnum-->
            <!-- but I'm not sure, and would need to test; but I'd be inclined to -->
            <!-- add normalize-space(), too. -sb                                  -->
            <assert test="if (parent::tei:div/tei:head[tei:choice]) then tokenize(parent::tei:div/tei:head//tei:reg/string(),' ')[2] eq $Roman_Cnum else compare(tokenize(parent::tei:div/tei:head/string(), ' ')[2], $Roman_Cnum) eq 0">
                The @xml:id isn't matching the Roman numeral chapter number given in the head element on this Chapter div. One of these must be wrong: check what chapter you're actually working on!</assert>
            <assert test="contains(tokenize(base-uri(), '_')[last()], $M_C)">
                The chapter number in this file name doesn't match the @xml:id. One of these must be wrong: check what chapter you're actually working on!
            </assert>
        </rule>
    </pattern>
</schema>