<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <!--2016-06-14 ebb: Note: This should be part of the master schema; 
        it's not easy to locate for anyone attempting to survey the rules of this project. 
        WARNING: The error-reporting text values in this file have not been carefully updated; there appear to
        be many inconsistencies though I have made some corrections and updates today.
    We will incorporate this in a simpler and better-documented way in ODD, with the other project rules.
    -->
    
    <pattern>
        <rule context="tei:fs[not(tei:f[@name eq 'note'])]">
            <assert test="tei:f[@name eq 'type']">There must be a &lt;f&gt; element with a @name =
                'type' attribute declaring the type of match.</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:f[@name eq 'type']">
            <assert
                test="@select = ('literal', 'approximate', 'omission', 'addition', 'mistranslation', 'quotation')"
                >Valid values for "type of translation" are: literal, approximate, omission,
                addition, quotation.</assert>
            <!--2017-05-27 ebb and set: set thinks we should REDUCE translation typing to the following:
                omission, addition, compression, mistranslation
                
                We should take word for word translation as Southey's default, and not bother to mark it. Thus, we only mark what's WARPED in translation.
            -->
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:f[@name eq 'subtype']">
            <let name="approxValues"
                value="('compressed', 'cultural', 'syntax', 'reported', 'aesthetic', 'new', 'voice', 'direct', 'antecedent', 'annotated', 'archaism')"/>
        <!--2017-05-27 ebb and set: set indicates that after all, every translation is "cultural" so that doesn't tell us much. compressed should be a main type, not a subtype, b/c this is quantifiable and easy to mark. 
        Change in clause order is MORE significant to us than small rearrangements of subject-object-verb to subject-verb-object in English. These micro-shifts are so common they aren't worth commenting on.  Transpositions of clauses don't need to be marked here b/c these show up in the clause numbers, and we should maybe flag them in the HTML tables.
        Shifts in voice, similarly, are marked elsewhere via milestone elements (so we don't need to repeat that markup here). 
        -->
            <let name="addValues" value="('cultural', 'aesthetic', 'voice', 'antecedent', 'archaism')"/>
            <let name="misValues" value="('cultural', 'voice', 'archaism')"/>
            <let name="litValues" value="('unnatural', 'archaism', 'close')"/>
            <let name="subtypes"
                value="
                    for $i in tokenize(current()/@select, '\s+')
                    return
                        $i"/>
            <assert
                test="
                if (preceding-sibling::tei:f[@select eq 'literal']) then
                every $subtype
                in $subtypes
                satisfies $subtype = $litValues
                else
                true()"
                >The only valid subtypes of a literal translation are 'close', 'archaism', and 'unnatural'.</assert>
            <assert
                test="
                    if (preceding-sibling::tei:f[@select eq 'approximate']) then
                        every $subtype
                        in $subtypes
                            satisfies $subtype = $approxValues
                    else
                        true()"
                >Valid values for a subtype of an approximate translation are: 'compressed',
                'cultural', 'syntax', 'reported', 'antecedent', 'new', 'annotated' and 'aesthetic'. </assert>
            <assert
                test="
                    if (preceding-sibling::tei:f[@select eq 'mistranslation']) then
                        every $subtype
                        in $subtypes
                            satisfies $subtype = $misValues
                    else
                        true()"
                >Valid values for a subtype of a mistranslation are: 'cultural', 'archaism', and
                'voice'.</assert>
            <assert
                test="
                    if (preceding-sibling::tei:f[@select eq 'addition']) then
                        every $subtype
                        in $subtypes
                            satisfies $subtype = $addValues
                    else
                        true()"
                >Valid values for a subtype of an addition are: 'cultural', 'antecedent', 'voice',
                and 'aesthetic'. </assert>
        </rule>
    </pattern>
    
</schema>
