<?xml version="1.0" encoding="UTF-8"?>
<!-- LinguaLinks PText interlinear XML reader, version 3                -->
<!-- Transform from PText XML to 4-level XML                            -->
<!-- Works with both word-gloss oriented and word-sense oriented PTEXT. -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- ENTIRE TEXT LEVEL-->
  <xsl:template match="/PTEXT">
    <document>
      <interlinear-text>
        <item type="title">
          <xsl:choose>
<!-- If /PTEXT/TEXT has a title markup, and it's followed by a text node, output that as the title -->
            <xsl:when test="TEXT/MARKUP[text()='Title']/following-sibling::text()[position()=1]">
              <xsl:value-of select="TEXT/MARKUP[text()='Title']/following-sibling::text()[position()=1]"/>
            </xsl:when>
<!-- Otherwise, just use whatever is in the header as the title -->
            <xsl:otherwise>
              <xsl:value-of select="HEADER"/>
            </xsl:otherwise>
          </xsl:choose>
        </item>
        <phrases>
          <xsl:apply-templates select="TEXT"/>
        </phrases>
      </interlinear-text>
    </document>
  </xsl:template>

<!-- Remove the title markup since it's already been output elsewhere -->
  <xsl:template match="/PTEXT/TEXT/MARKUP[text()='Title']">
  </xsl:template> 

  <xsl:template match="/PTEXT/TEXT/text()">
  </xsl:template> 

<!-- The "Paragraph" markup from PText is followed by any number of <S> elements     -->
<!-- which apparently are all to be taken as part of that paragraph until another    -->
<!-- Paragraph markup is encountered.                                                -->
<!--                                                                                 -->
<!-- I'd like to restructure this if I can, putting everything after the "Paragraph" -->
<!-- markup, up until the next one is encountered, between the start and end tags of -->
<!-- a paragraph element.  This would be an added level of hierarchy though, which   -->
<!-- doesn't fit the 4-level model.  For now, just delete the paragraph markups.     -->
<!-- But some way of marking paragraphs will need to be developed.                   -->

<!-- For now, delete any paragraph markups -->
  <xsl:template match="/PTEXT/TEXT/MARKUP[text()='Paragraph']">
  </xsl:template> 

<!-- ...the beginning of a template for processing the paragraph markups 
  <xsl:template match="/PTEXT/TEXT/MARKUP">
    <xsl:if test=".='Paragraph'">
      <p>
       This is where the first interlinear paragraph should be.
      </p>
    </xsl:if>
  </xsl:template> -->

<!-- SENTENCE LEVEL -->
  <xsl:template match="TEXT/S">
    <phrase>
      <item type="txt">
        <xsl:value-of select="ORTH"/>
      </item>
      <item type="gls">
        <xsl:value-of select="PS/ANNO"/>
      </item>
      <words>
        <xsl:apply-templates select="PS/W"/>
      </words>
    </phrase>
  </xsl:template>

<!-- WORD LEVEL -->
  <xsl:template match="W">
    <word>
      <item type="txt">
        <xsl:variable name="WORDFORM" select="@FORM"/>
        <xsl:apply-templates select="key('WFORM',$WORDFORM)"/>
      </item>
      <item type="gls">
        <xsl:variable name="WORDGLOSS" select="@ANA"/>
        <xsl:apply-templates select="key('WGLOSS',$WORDGLOSS)"/>
      </item>
      <morphemes>
        <xsl:call-template name="Locate-WordSense-Entry"/>
      </morphemes>
    </word>
  </xsl:template>

  <xsl:key name="WFORM" match="/PTEXT/WORDFORMS/WF" use="@ID"/>

  <xsl:template match="/PTEXT/WORDFORMS/WF">
    <xsl:value-of select="FORM"/>
  </xsl:template>

  <xsl:key name="WGLOSS" match="/PTEXT/WORDFORMS/WF//WS/GLOSS" use="@ID"/>

  <xsl:template match="/PTEXT/WORDFORMS/WF//WS/GLOSS">
    <xsl:value-of select="."/>
  </xsl:template>

<!-- WORD LEVEL - locate the specified WS (WordSense) entry -->
  <xsl:template name="Locate-WordSense-Entry">
    <xsl:variable name="WORDFORM" select="@FORM"/>
    <xsl:variable name="WORDGLOSS" select="@ANA"/>
    <xsl:variable name="WORDSENSE" select="@ANA"/>
    <xsl:for-each select="key('WFORM',$WORDFORM)">
      <xsl:choose>
        <xsl:when test="starts-with($WORDSENSE,'WG')">
          <xsl:for-each select="key('WGLOSS',$WORDGLOSS)/..">
            <xsl:call-template name="Locate-LEX-Entry"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="key('WSENSE',$WORDSENSE)">
            <xsl:call-template name="Locate-LEX-Entry"/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:key name="WSENSE" match="/PTEXT/WORDFORMS/WF//WS" use="@ID"/>

<!-- MORPHEME LEVEL - locate the LEX entry for each morpheme -->
  <xsl:template name="Locate-LEX-Entry">
    <xsl:for-each select="M">
      <xsl:variable name="LEXEME" select="@LEX"/>
      <xsl:for-each select="key('LEX',$LEXEME)">
        <xsl:choose>
          <xsl:when test="@TYPE='PREFIX'">
            <morph type="prefix">
              <xsl:call-template name="get-morpheme"/>
            </morph>
          </xsl:when>
          <xsl:when test="@TYPE='SUFFIX'">
            <morph type="suffix">
              <xsl:call-template name="get-morpheme"/>
            </morph>
          </xsl:when>
          <xsl:when test="@TYPE='INFIX'">
            <morph type="infix">
              <xsl:call-template name="get-morpheme"/>
            </morph>
          </xsl:when>
          <xsl:otherwise>
            <morph type="root">
              <xsl:call-template name="get-morpheme"/>
            </morph>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:key name="LEX" match="/PTEXT/LEXICON/LEX" use="@ID"/>

<!-- MORPHEME LEVEL - get the morpheme info from the LEX entry -->
  <xsl:template name="get-morpheme">
    <item type="txt">
      <xsl:value-of select="FORM"/>
    </item>
    <item type="gls">
      <xsl:value-of select="GLOSS"/>
    </item>
  </xsl:template>

</xsl:stylesheet>