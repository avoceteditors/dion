<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:book="http://docbook.org/ns/docbook"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dion="http://avoceteditors.com/xml/dion">

<!-- Part -->
<xsl:template match="book:part">
\part*{<xsl:value-of select="book:title|book:info/book:title"/>}
\hypertarget{<xsl:value-of select="@xml:id"/>}{}

<xsl:apply-templates/>

</xsl:template>

<!-- Section -->
<xsl:template match="book:chapter/book:section">
\section*{<xsl:value-of select="book:title|book:info/book:title"/>}
\hypertarget{<xsl:value-of select="@xml:id"/>}{}

<xsl:apply-templates/>

</xsl:template>

<!-- Subsection -->
<xsl:template match="book:chapter/book:section/book:section">
\subsection*{<xsl:value-of select="book:title|book:info/book:title"/>}
\hypertarget{<xsl:value-of select="@xml:id"/>}{}

<xsl:apply-templates/>

</xsl:template>

<!-- Subsubsection -->
<xsl:template match="book:chapter/book:section/book:section/book:section">
\subsubsection*{<xsl:value-of select="book:title|book:info/book:title"/>}
\hypertarget{<xsl:value-of select="@xml:id"/>}{}

<xsl:apply-templates/>

</xsl:template>


<!-- Paragraph -->
<xsl:template match="book:chapter/book:section/book:section/book:section/book:section">
\paragraph*{<xsl:value-of select="book:title|book:info/book:title"/>}
\hypertarget{<xsl:value-of select="@xml:id"/>}{}

<xsl:apply-templates/>

</xsl:template>


<!-- Subparagraph -->
<xsl:template match="book:chapter/book:section/book:section/book:section/book:section/book:section">
\subparagraph*{<xsl:value-of select="book:title|book:info/book:title"/>}
\hypertarget{<xsl:value-of select="@xml:id"/>}{}

<xsl:apply-templates/>

</xsl:template>

<!-- Below Subparagraph -->
<xsl:template match="book:section">
\section*{<xsl:value-of select="book:title|book:info/book:title"/>}
\hypertarget{<xsl:value-of select="@xml:id"/>}{}

<xsl:apply-templates/>

</xsl:template>





</xsl:stylesheet>
