<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<!--      page-height="216mm" page-width="140mm" -->

  <xsl:template match="document">
    <root xmlns="http://www.w3.org/1999/XSL/Format">
      <layout-master-set>
        <simple-page-master master-name="page"
          page-height="279mm" page-width="216mm"
          margin-top="40mm" margin-bottom="10mm"
          margin-left="25mm" margin-right="25mm">
          <region-body margin-top="0mm" margin-bottom="15mm"
            margin-left="0mm" margin-right="0mm"/>
          <region-after extent="10mm"/>
        </simple-page-master>
      </layout-master-set>
      <page-sequence master-reference="page">
        <static-content flow-name="xsl-region-after">
          <block>Page <page-number/></block>
        </static-content>
        <flow flow-name="xsl-region-body">
          <xsl:apply-templates/>
        </flow>
      </page-sequence>
    </root>
  </xsl:template>

  <!-- INTERLINEAR-TEXT LEVEL -->

  <xsl:template match="interlinear-text">
    <!-- <block border="thin solid black" background="white"> -->
    <block>
      <xsl:apply-templates/>
    </block>
  </xsl:template>

  <xsl:template match="interlinear-text/item">
    <block>
      <xsl:apply-templates/>
    </block>
  </xsl:template>

  <!-- PHRASE LEVEL -->

  <xsl:template match="phrases">
    <list-block>
      <xsl:apply-templates/>
    </list-block>
  </xsl:template>

  <xsl:template match="phrase">
    <!-- <list-item border="thin solid black"> -->
    <list-item>
      <list-item-label end-indent="label-end()">
        <block>
          <xsl:number format="1."/>
        </block>
      </list-item-label>
      <list-item-body start-indent="body-start()">
        <xsl:apply-templates/>
        <block><xsl:text>&#160;</xsl:text></block>
      </list-item-body>
    </list-item>
  </xsl:template>

  <xsl:template match="phrase/item">
    <block>
      <xsl:apply-templates/>
    </block>
  </xsl:template>

  <!-- WORD LEVEL -->

  <xsl:template match="words">
    <block>
      <xsl:apply-templates/>
    </block>
  </xsl:template>

  <xsl:template match="word">
    <inline-container alignment-baseline="before-edge">
      <!-- <block start-indent="0mm" background="silver"> -->
      <!-- <block start-indent="0mm" padding-after="5mm" border="thin solid black"> -->
      <block start-indent="0mm" padding-after="4mm">
        <table>
          <table-column/>
          <table-body>
            <xsl:apply-templates/>
          </table-body>
        </table>
      </block>
    </inline-container>
  </xsl:template>

  <xsl:template match="word/item[@type='txt']">
    <table-row>
      <table-cell>
        <block>
          <xsl:apply-templates/>
          <xsl:text>&#160;&#160;</xsl:text> 
        </block>
      </table-cell>
    </table-row>
  </xsl:template>

  <xsl:template match="word/item[@type='gls']">
    <table-row>
      <table-cell>
        <block>
          <xsl:if test="string(.)">
            <xsl:apply-templates/>
            <xsl:text>&#160;&#160;</xsl:text>
          </xsl:if>
        </block>
      </table-cell>
    </table-row>
  </xsl:template>

  <!-- MORPHEME LEVEL -->

  <xsl:template match="morphemes">
    <table-row>
      <table-cell start-indent="0mm">
        <block>
          <xsl:apply-templates/>
        </block>
      </table-cell>
    </table-row>
  </xsl:template>

  <xsl:template match="morph">
    <inline-container>
      <!-- <block border="thin solid black"> -->
      <!-- <block border="thin dotted white"> -->
      <block start-indent="0mm"> 
        <table>
          <table-column/>
          <table-body>
            <xsl:apply-templates/>
          </table-body>
        </table>
      </block>
    </inline-container>
  </xsl:template>

  <xsl:template match="morph/item">
    <table-row>
      <table-cell>
        <block>
          <xsl:apply-templates/>
          <xsl:text>&#160;&#160;</xsl:text> 
        </block>
      </table-cell>
    </table-row>
  </xsl:template>

  <!-- MISCELLANEOUS -->

  <xsl:template match="i">
    <inline font-style="italic">
      <xsl:apply-templates/>
    </inline>
  </xsl:template>

  <xsl:template match="b">
    <inline font-style="bold">
      <xsl:apply-templates/>
    </inline>
  </xsl:template>

  <xsl:template match="title">
    <block font-style="bold">
      <xsl:apply-templates/>
    </block>
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
