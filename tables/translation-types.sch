<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <pattern>
        <rule context="tei:fs">
            <assert test="tei:f[@name eq 'type']">There must be a &lt;f&gt; element with a @name = 'type' attribute declaring the type of match.</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:f[@name eq 'type']">
            <assert test="@select = ('literal', 'approximate', 'omission', 'addition', 'mistranslation')">Valid values for "type of translation" are: literal, approximate, omission, addition.</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:f[@name eq 'subtype']">
            <let name="values" value="('compressed', 'cultural', 'omission', 'syntax', 'reported', 'liberal', 'addition', 'antecedent')"/>
            <let name="subtypes" value="for $i in tokenize(current()/@select, '\s+') return $i"/>
            <assert test="if (preceding-sibling::tei:f[@select eq 'literal']) then current()/@select eq 'close' else true()">The only valid subtype of a literal translation is 'close'.</assert>
            <assert test="if (preceding-sibling::tei:f[@select eq 'approximate']) then every $subtype 
                in $subtypes satisfies $subtype = $values else true()">Valid values for a subtype of an approximate translation are: 'compressed', 'omission' 'cultural', 'syntax', 'reported', 'antecedent', 'addition', and 'liberal'.
            </assert>
        </rule>
    </pattern>
</schema>