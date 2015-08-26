<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
    <ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>   

    <pattern>
        <rule context="tei:milestone">
            <assert test=".[@unit='p'] | .[@unit='said'] | .[@unit='transUnit']">
               "p," "said," or "transUnit" are the only permitted values of @unit on the milestone element. 
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="tei:milestone[@unit='said'] | tei:milestone[@unit='transUnit']">
            <report test=".[not(@ana)]">
                An @ana must be present to designate the start or end (or interruption) of a speech or unit of translation.
            </report>     
        </rule> 
    </pattern>
    
    <pattern>
        <rule context="tei:milestone[@unit='said'] | tei:milestone[@unit='transUnit']">
            <assert test=".[@ana='start'] | .[@ana='end'] | .[@ana= 'intStart'] | .[@ana='intEnd']">
                Legitimate values for @ana are "start," "end," "intStart," and "intEnd."
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="tei:milestone[@unit='said'][@ana='start']">
            <assert test=".[@resp]">
                A milestone marking the start of a speech must always contain an @resp attribute pointing to the #xml:id for the speaker.
            </assert>
        </rule>
    </pattern>
    
    <pattern> 
        <rule context="tei:milestone[@ana][preceding::tei:milestone[@ana]]/@ana">
            <report test="matches(., preceding::tei:milestone[@ana][1]/@ana)">
                The @ana must NOT be the same on two subsequent milestones for speech!
            </report>   
        </rule>
    </pattern>
    
    <pattern>
        <rule context="tei:milestone[@ana='start']">
            <report test="./following::tei:milestone[@ana][1][@ana='intEnd']">
                The value of @ana for the next speech milestone after "start" must never be "intEnd"!
            </report>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="tei:milestone[@ana='intStart']">
            <assert test="./following::tei:milestone[@ana][1][@ana='intEnd']">
                After an @ana="intStart" (interruption start) the next @ana must be "intEnd" (interruption end)!
            </assert>
            
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:cl">
            <report test=".//tei:cl">Nested clauses!</report>
        </rule>
    </pattern>
    
    <!--ebb 2015-08-06 CHECK THESE!!! Rules for Pointing to Other Files and xml:ids-->
    
    <let name="si" value="doc('SI-Amadis.xml')//@xml:id"/>
    <let name="siFile" value="doc('SI-Amadis.xml')"/>
    
    <let name="M_ids" value="doc('Montalvo_Amadis_1547_20.xml')//@xml:id"/>
    <let name="M_file" value="doc('Montalvo_Amadis_1547_20.xml')"/>
    
    
    <pattern>
        <rule context="@ref | @resp | @corresp">
            <let name="tokens" value="for $i in tokenize(., '\s+') return substring-after($i,'#')"/>
            <assert test="every $token in $tokens satisfies $token = $si">The attribute (after the hashtag, #) must match a defined @xml:id in the Site Index file!</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="@synch">
            <let name="tokens" value="for $i in tokenize(., '\s+') return substring-after($i,'#')"/>
            <assert test="every $token in $tokens satisfies $token = $M_ids">The attribute (after the hashtag, #) must match a defined @xml:id in the corresponding Montalvo 1547 edition file!</assert>
            
        </rule>
        
        
    </pattern>
    
  

</schema>