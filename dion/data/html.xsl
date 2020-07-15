<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:book="http://docbook.org/ns/docbook"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dion="http://avoceteditors.com/xml/dion">

<xsl:output method="html" omit-xml-declaration="yes" indent="no"/>


<!-- ;;;;;;;;;;;;;;;;;;;;;;; Page ;;;;;;;;;;;;;;;;;;;;;;;;;;;; -->
<xsl:template match="dion:project|book:series|book:book|book:chapter">
<xsl:variable name="idref"><xsl:value-of select="@xml:id"/></xsl:variable>
<xsl:result-document href="{$idref}.html">
<html>

<!-- Add User-defined Links -->
<xsl:for-each select="/dion:project/book:info/dion:files/dion:file">
<xsl:variable name="rel"><xsl:value-of select="@rel"/></xsl:variable>
<xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
<xsl:variable name="path"><xsl:value-of select="@path"/></xsl:variable>
<link rel="{$rel}" type="{$type}" href="/static/{$path}"/>
</xsl:for-each>

<body>
<!-- ;;;;;;;;;;;;;;;;; Header Content ;;;;;;;;;;;;;;;;;;;-->
<section id="header">

<!-- ;:;;; MENU ;;;;; -->
<div id="main-menu">
<ul>
  <li><a href="/" title="home page"><xsl:value-of select="/dion:project/book:info/dion:short-title"/></a></li>

<xsl:for-each select="/dion:project/book:series">
<xsl:variable name="id"><xsl:value-of select="@xml:id"/></xsl:variable>
<xsl:variable name="abstract"><xsl:value-of select="./book:info/book:abstract"/></xsl:variable>
<li>
<a href="/{$id}.html" title="{$abstract}">
<xsl:value-of select="./book:title|./book:info/book:title"/>
</a>
</li>

</xsl:for-each>
</ul>
</div>

<!-- Title Block -->
<div id="site-title">
  <div id="name"><xsl:value-of select="/dion:project/book:info/book:title"/></div>
  <div id="subtitle"><xsl:value-of select="/dion:project/book:info/book:subtitle"/></div>
</div>

</section>

<!-- ;;;;;;;;;;;;;;;; Main Content ;;;;;;;;;;;;;;;;;;;; -->
<section id="main">
<xsl:choose>
<xsl:when test="@xml:id = 'index'"> 
  <h1>Welcome</h1>
</xsl:when>
<xsl:otherwise>
  <h1><xsl:value-of select="book:title|book:info/book:title"/></h1>
</xsl:otherwise>
</xsl:choose>
<xsl:copy>
  <xsl:apply-templates/>
</xsl:copy>

<xsl:if test="self::dion:project|self::book:series|self::book:book|self::book:part">
<table class="toc">
<xsl:for-each select="book:series|book:book|book:part|book:chapter">
<xsl:variable name="id"><xsl:value-of select="./[@xml:id]"/></xsl:variable>
<tr>
<td>
  <a href="/{$id}.html">
  <xsl:value-of select="./book:title|./book:info/book:title"/>
  </a>
</td>
<td>
  <xsl:copy-of select="./book:info/book:abstract"/>
</td>
</tr>
</xsl:for-each>
</table>
</xsl:if>

</section>

</body>
</html>
</xsl:result-document>

</xsl:template>


<xsl:include href="html/sections.xsl"/>
<xsl:include href="html/blocks.xsl"/>
<xsl:include href="html/inline.xsl"/>

</xsl:stylesheet>

