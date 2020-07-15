<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:book="http://docbook.org/ns/docbook"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dion="http://avoceteditors.com/xml/dion">

<xsl:template match="book:chapter/book:section|book:series/book:section">
<xsl:variable name="idref"><xsl:value-of select="@xml:id"/></xsl:variable>
<div id="{$idref}">
<h2><xsl:value-of select="book:title|book:info/book:title"/></h2>

<xsl:copy>
<xsl:apply-templates/>
</xsl:copy>
</div>
</xsl:template>


</xsl:stylesheet>
