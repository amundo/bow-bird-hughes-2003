<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- styles - Apply italics to any item of the 'txt' type -->
  <xsl:template match="item[@type='txt']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <i>
        <xsl:apply-templates/>
      </i>
    </xsl:copy>
  </xsl:template> 

  <!-- styles - Apply bold to any item of the 'gls' type 
  <xsl:template match="item[@type='gls']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <b>
        <xsl:apply-templates/>
      </b>
    </xsl:copy>
  </xsl:template> -->

  <!-- styles - Apply bold to any item of the 'title' type -->
  <xsl:template match="item[@type='title']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <b>
        <xsl:apply-templates/>
      </b>
    </xsl:copy>
  </xsl:template> 

  <!-- to delete unwanted attributes 
  <xsl:template match="item">
    <item>
      <xsl:apply-templates/>
    </item>
  </xsl:template> -->

  <!-- identity template -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template> 

</xsl:stylesheet>
