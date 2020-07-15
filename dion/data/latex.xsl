<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:book="http://docbook.org/ns/docbook"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dion="http://avoceteditors.com/xml/dion">

<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

<xsl:template match="//book:book">
<xsl:variable name="idref"><xsl:value-of select="@xml:id"/></xsl:variable>
<xsl:result-document href="{$idref}.tex">
\documentclass[<xsl:value-of select="@dion:font|ancestor::*/@dion:font"/>, <xsl:value-of select="@dion:paper|ancestor::*/@dion:paper"/>, twoside]{book}
\usepackage[book, hidetitles, gothrubric]{dion}
\usepackage{etoolbox}

% Title
\setTitle{<xsl:value-of select="book:title|book:info/book:title"/>}

% Configure Author
\setAuthor{<xsl:value-of select="book:info/book:author/book:personname|ancestor::*/book:info/book:author/book:personname"/>}
\setSurname{<xsl:value-of select="book:info/book:author/book:personname/book:surname|ancestor::*/book:info/book:author/book:personname/book:surname"/>}

% Set Publisher
\setPublisher{<xsl:value-of select="book:info/book:publisher/book:publishername|../book:info/book:publisher/book:publishername"/>}
\setPubcities{<xsl:for-each select="book:info/book:publisher/book:address/book:city|ancestor::*/book:info/book:publisher/book:address/book:city"><xsl:choose><xsl:when test="position() &lt; last()"><xsl:value-of select="."/>, </xsl:when><xsl:otherwise><xsl:value-of select="."/>.</xsl:otherwise></xsl:choose></xsl:for-each>}
\begin{document}

\diontitlepage

\tableofcontents

<xsl:apply-templates/>

\end{document}
</xsl:result-document>
</xsl:template>


<xsl:template match="book:chapter|book:article">
<xsl:variable name="idref"><xsl:value-of select="@xml:id"/></xsl:variable>
<xsl:result-document href="{$idref}.tex">
\documentclass[10pt, letterhead, oneside]{book}
\usepackage[book, hidetitles, gothrubric]{dion}

% Title
\setTitle{<xsl:value-of select="ancestor::book:book/book:title|ancestor::book:book/book:info/book:title"/>}

% Configure Author
\setAuthor{<xsl:value-of select="book:info/book:author/book:personname|ancestor::*/book:info/book:author/book:personname"/>}
\setSurname{<xsl:value-of select="book:info/book:author/book:personname/book:surname|ancestor::*/book:info/book:author/book:personname/book:surname"/>}

% Set Publisher
\setPublisher{<xsl:value-of select="book:info/book:publisher/book:publishername|ancestor::book:series/book:info/book:publisher/book:publishername" />}
\setPubcities{<xsl:for-each select="book:info/book:publisher/book:address/book:city|ancestor::*/book:info/book:publisher/book:address/book:city"><xsl:choose><xsl:when test="position() &lt; last()"><xsl:value-of select="."/> + </xsl:when><xsl:otherwise><xsl:value-of select="."/>.</xsl:otherwise></xsl:choose></xsl:for-each>}

\renewcommand{\cleardoublepage}{\clearpage}
%\renewcommand{\clearpage}{}

\pgfplotsset{compat=1.16}

\begin{document}
<xsl:if test="@dion:status='draft'">
\begin{flushright}
\Large\bfseries <xsl:value-of select="ancestor::book:book/book:info/book:title"/> - \textit{<xsl:value-of select="book:info/book:title|book:title"/>}


<xsl:value-of select="ancestor::*/book:info/book:author"/>
\end{flushright}

<xsl:if test="book:info/book:abstract">
\begin{center}
  \textbf{ABSTRACT}
\end{center}

\begin{quote}
<xsl:apply-templates select="book:info/book:abstract"/>
\end{quote}

\begin{tikzpicture}
\begin{axis}[ xbar, enlargelimits=0.2, xlabel=Word Count, ytick=data,
  symbolic y coords={<xsl:for-each select="ancestor::book:book//book:chapter"><xsl:value-of select="@xml:id"/><xsl:if test="position() != last()">, </xsl:if></xsl:for-each>},
  nodes near coords align={horizontal}]
  \addplot coordinates {
<xsl:for-each select="ancestor::book:book//book:chapter">
(<xsl:value-of select="@dion:words"/>,<xsl:value-of select="@xml:id"/>)
</xsl:for-each>
};
\end{axis}
\end{tikzpicture}

\begin{flushright}

\textbf{Document Records:}

Created: <xsl:value-of select="@dion:hctime"/>

Updated: <xsl:value-of select="@dion:hmtime"/>

\textbf{Document Statistics:}

Lines: <xsl:value-of select="@dion:plines"/>

Words: <xsl:value-of select="@dion:pwords"/> \\

Chars: <xsl:value-of select="@dion:pchars"/> \\

\end{flushright}


</xsl:if>

</xsl:if>
\chapter*{<xsl:value-of select="book:info/book:title|book:title"/> }
\hypertarget{<xsl:value-of select="$idref"/>}{}

<xsl:copy>
<xsl:apply-templates/>
</xsl:copy>

\end{document}
</xsl:result-document>

\chapter*{<xsl:value-of select="book:info/book:title|book:title"/>}
\hypertarget{<xsl:value-of select="$idref"/>}{}

<xsl:apply-templates/>

</xsl:template>

<!-- Section Configuration -->
<xsl:include href="latex/sections.xsl"/>


<!-- Block Configuration -->
<xsl:include href="latex/blocks.xsl"/>

<!-- Inline Elements -->
<xsl:include href="latex/inline.xsl"/>


</xsl:stylesheet>
