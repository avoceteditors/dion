<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:book="http://docbook.org/ns/docbook"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dion="http://avoceteditors.com/xml/dion">

<!-- Title Blocks -->
<xsl:template match="book:book[@role='novel']//book:chapter/book:info|book:book[@role='novel']//book:chapter/book:title">

\titleblock{<xsl:for-each select="ancestor::book:chapter|ancestor::book:chapter//book:section|ancestor::book:chapter//dion:scene">\hyperlink{<xsl:value-of select="./@xml:id"/>}{<xsl:value-of select="./book:title|./book:info/book:title"/>}<xsl:choose><xsl:when test="position() &lt; last()">, </xsl:when><xsl:otherwise>.</xsl:otherwise></xsl:choose></xsl:for-each>}

</xsl:template>

<!-- Suppress Info and Title -->
<xsl:template match="book:info|book:title"/>

<!-- Paragraph -->
<xsl:template match="book:para">

<xsl:apply-templates/>

</xsl:template>
<xsl:template match="dion:scene/dion:action/book:para[1]">

\noindent <xsl:apply-templates/>

</xsl:template>

<xsl:template match="dion:scene">


<xsl:if test="@role='draft'">
{\ttfamily

\noindent \emph{<xsl:value-of select="book:title"/>}

}
</xsl:if>

<xsl:apply-templates/>

<xsl:if test="@role='draft'">
\vspace{0.1in}
</xsl:if>
</xsl:template>

<xsl:template match="dion:action">

{ \ttfamily

<xsl:apply-templates/>

}
</xsl:template>

<xsl:template match="dion:cast"/>

<xsl:template match="dion:line">


\vspace{0.1in}
{ \ttfamily
\noindent\MakeUppercase{<xsl:value-of select="@role"/>}

\begin{quote}
<xsl:apply-templates/>

\end{quote}
}
</xsl:template>



</xsl:stylesheet>


