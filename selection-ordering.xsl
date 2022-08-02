<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- relative ordering of title, interlinear text, and notes -->
  <xsl:template match="interlinear-text">
    <interlinear-text>
      <xsl:apply-templates select="item[@type='title']"/> 
      <xsl:apply-templates select="phrases"/> 
      <xsl:apply-templates select="item[@type!='title']"/> 
    </interlinear-text>
  </xsl:template> 

  <!-- grouping - concatenate all free translations at the end 
  <xsl:template match="phrases">
    <phrases>
      <phrase>
        <xsl:apply-templates select="phrase/words"/>
      </phrase>
    </phrases>
    <phrases>
      <phrase>
        <xsl:apply-templates select="phrase/item"/>
      </phrase>
    </phrases>
  </xsl:template> -->

  <!-- ordering - free translation after interlinear -->
  <xsl:template match="phrase">
    <phrase>
<!--  <xsl:apply-templates select="item[@type='txt']"/> -->
      <xsl:apply-templates select="words"/>
      <xsl:apply-templates select="item[@type='gls']"/>
    </phrase>
  </xsl:template> 

  <!-- ordering - morphemes after word -->
  <!-- ordering - word after morphemes -->
  <xsl:template match="word">
    <word>
      <xsl:apply-templates select="item[@type='txt']"/> 
      <xsl:apply-templates select="morphemes"/>
      <xsl:apply-templates select="item[@type='gls']"/>
    </word>
  </xsl:template> 

  <!-- ordering and selection of aligned rows
       The order here will be the order displayed
       Comment out any row that isn't to be displayed -->
  <xsl:template match="morph">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="item[@type='txt']"/>
      <xsl:apply-templates select="item[@type='POS']"/>
<!--  <xsl:apply-templates select="morphemes"/> -->
      <xsl:apply-templates select="item[@type='gls']"/>
      <xsl:apply-templates select="item[@type='gls1']"/>
      <xsl:apply-templates select="item[@type='gls2']"/>
    </xsl:copy>
  </xsl:template> 

  <!-- process morpheme types.
       Added <xsl:copy-of select="@*"/> in order to
       keep the item type for later processing; 
       to apply styles to particular item types -->

  <xsl:template match="morph[@type='prefix']/item">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/><xsl:text>-</xsl:text>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="morph[@type='suffix']/item">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:text>-</xsl:text><xsl:apply-templates/>
    </xsl:copy>
  </xsl:template> 
  <xsl:template match="morph[@type='infix']/item">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:text>-</xsl:text><xsl:apply-templates/><xsl:text>-</xsl:text>
    </xsl:copy>
  </xsl:template> 
  <xsl:template match="morph[@type='proclitic']/item">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/><xsl:text>+</xsl:text>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="morph[@type='enclitic']/item">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:text>+</xsl:text><xsl:apply-templates/>
    </xsl:copy>
  </xsl:template> 

<!-- Alternate morpheme processing to avoid multiple matches on
     "morph/item" when trying to also apply styles to items.
     This alternate approach did away with the error messages,
     but it still didn't succeed in applying a style to an item
     while it was also being marked as a particular morpheme type.

  <xsl:template match="morph[@type='prefix']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="item">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/><xsl:text>-</xsl:text>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template> 
  <xsl:template match="morph[@type='suffix']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="item">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:text>-</xsl:text><xsl:apply-templates/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template> 
  <xsl:template match="morph[@type='proclitic']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="item">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/><xsl:text>+</xsl:text>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template> 
  <xsl:template match="morph[@type='enclitic']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="item">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:text>+</xsl:text><xsl:apply-templates/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template> -->

  <!-- to delete unwanted attributes 
  <xsl:template match="item">
    <item>
      <xsl:apply-templates/>
    </item>
  </xsl:template> -->

  <!-- identity template (original - but both gave identical results in initial testing) -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template> 

  <!-- identity template (from http://www.dpawson.co.uk/xsl/sect2/identity.html) 
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template> -->

</xsl:stylesheet>
