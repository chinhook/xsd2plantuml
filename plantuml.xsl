<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:tns="http://www.thalesgroup.com/avionics/clusters"	
	exclude-result-prefixes="xs tns">
	<xsl:output method="text" />
<xsl:template match="/">
!** Interface Requirement Specification
<xsl:apply-templates mode="#current" />
</xsl:template>
<xsl:template match="xs:schema">
!1 Interface Requirement Specification
!*> Primitive types
|'''Primitive type encoding definitions'''                                                                                    |
|Basic type | XSD base type |Size in bits| Min | Max|Endianness |
|Unsigned Byte |xs:unsignedByte | 8 bits |0 |255 |n/a |
|Unsigned Short |xs:unsignedShort| 16 bits |0 |65535 |Big Endian |
|Unsigned Integer|xs:unsignedByte | 8 bits |0 |4294967295|Big Endian |
|IEEE 754 Floating point simple precision|xs:float|32 bits|||Big Endian |
*!
!** Models
!startuml
class Demo{
+ hello : string
+ world : char *
}
!enduml
!*> Simple type definitions
<xsl:for-each select="xs:simpleType[parent::xs:schema]">
<xsl:call-template name="simpleContentTemplate" />
</xsl:for-each>
*!
!*> Complex type definitions
!startuml
<xsl:for-each select="xs:complexType[parent::xs:schema]"><xsl:choose><xsl:when test="@abstract='true'">
Abstract</xsl:when>
<xsl:otherwise>
Class</xsl:otherwise>
</xsl:choose> tns.<xsl:value-of select="@name"/></xsl:for-each>
!enduml

!*> Complex content details
!startuml
<xsl:for-each select="xs:complexType[parent::xs:schema]">
<xsl:call-template name="complexContentTemplate" />
</xsl:for-each>
!enduml
*!
*!
*!
!*> Code sippets
!listing cpp {
cout &lt;&lt; "hello world !";
}
*!
*!
</xsl:template>

<xsl:template name="simpleContentTemplate">
TODO</xsl:template>

<xsl:template name="complexContentTemplate">
<xsl:choose>
<xsl:when test="@abstract='true'">
Abstract</xsl:when>
<xsl:otherwise>
Class</xsl:otherwise>
</xsl:choose> tns.<xsl:value-of select="@name"/>{<xsl:apply-templates select="descendant::xs:sequence" mode="classes"/>
}
<xsl:apply-templates select="descendant::xs:sequence" mode="associations"/>
<xsl:apply-templates mode="inheritance"/>
</xsl:template>

<xsl:template match="xs:sequence" mode="classes">
<xsl:for-each select="xs:element">
<xsl:choose>
<xsl:when test="@type">
+<xsl:value-of select="@name"/>:<xsl:value-of select="@type"/></xsl:when>
<xsl:when test="./xs:simpleType and not(@type)">
#<xsl:value-of select="@name"/>:<xsl:value-of select="./xs:simpleType/descendant-or-self::*/@base|./xs:simpleType/descendant-or-self::*/@name "/></xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:template>

<xsl:template match="xs:sequence" mode="associations">
<xsl:for-each select="xs:element[@type]">
tns.<xsl:value-of select="ancestor::xs:complexType/attribute::name"/> .down.> <xsl:value-of select="concat(substring-before(@type,':'),'.',substring-after(@type,':'))"/><xsl:text>&#xa;</xsl:text>
</xsl:for-each>
</xsl:template>

<xsl:template match="xs:restriction[not(ancestor::xs:element)]" mode="inheritance">
tns.<xsl:value-of select="ancestor::xs:complexType/attribute::name"/> -up-|> <xsl:value-of select="concat(substring-before(@base,':'),'.',substring-after(@base,':'))"/>
</xsl:template>

</xsl:stylesheet>