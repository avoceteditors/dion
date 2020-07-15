<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:book="http://docbook.org/ns/docbook"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dion="http://avoceteditors.com/xml/dion">

<xsl:template match="book:para"><p>
<xsl:apply-templates/>
</p></xsl:template>

<xsl:template match="book:image"><xsl:variable name="source"><xsl:value-of select="@src"/></xsl:variable><xsl:variable name="class"><xsl:value-of select="@role"/></xsl:variable><img src="/images/{$source}" class="user {$class}"/></xsl:template>

</xsl:stylesheet>
