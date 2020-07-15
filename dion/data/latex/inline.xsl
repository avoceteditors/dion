<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:book="http://docbook.org/ns/docbook"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dion="http://avoceteditors.com/xml/dion">

<!-- Emphasis -->
<xsl:template match="book:emphasis">\textit{<xsl:apply-templates/>}</xsl:template>

<!-- Lettrine -->
<xsl:template match="dion:lett[@rubric]">\lettrine{<xsl:value-of select="@rubric"/>}{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="dion:lett">\lettrine[nindent=0pt]{}{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="book:quote">``<xsl:apply-templates/>''</xsl:template>

  
</xsl:stylesheet>


