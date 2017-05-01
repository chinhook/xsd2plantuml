<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ans="http://www.thalesgroup.com/afcdi"
    xmlns:tns="http://www.thalesgroup.com/afcdi"
	xmlns:fm2xx="http://www.thalesgroup.com/avionics/irs2xxattributes"
	exclude-result-prefixes="xs ans fm2xx tns">
	<xsl:output method="text" />
<xsl:template match="/">
!** Interface Requirement Specification
<xsl:apply-templates mode="#current"/></xsl:template>
<xsl:template match="xs:schema">!1 Interface Requirement Specification
!*> Primitive types
|'''Primitive type encoding definitions'''                                                                                               |
|!style_meta[Basic type]|!style_meta[XSD base type] |!style_meta[Size in bits]|!style_meta[Min]| !style_meta[Max]|!style_meta[Endianness]|
|Unsigned Byte |xs:unsignedByte | 8 bits |0 |255 |n/a |
|Unsigned Short |xs:unsignedShort| 16 bits |0 |65535 |Big Endian |
|Unsigned Integer|xs:unsignedByte | 8 bits |0 |4294967295|Big Endian |
|IEEE 754 Floating point simple precision|xs:float|32 bits|||Big Endian |
*!
!** Models
!startuml
class Demo {
+ hello : string
+ world : char *
}
!enduml
!*> Simple types overview
!startuml<xsl:for-each select="xs:simpleType[parent::xs:schema]">
<xsl:call-template name="simpleContentUML" /></xsl:for-each>
!enduml
*!
*!
!** Simple content details<xsl:call-template name="simpleContentTables"/>
*!
!*> Complex types overview
!startuml<xsl:for-each select="xs:complexType[parent::xs:schema]">
<xsl:choose>
<xsl:when test="@abstract='true'">
Abstract </xsl:when>
<xsl:otherwise>
Class </xsl:otherwise>
</xsl:choose>tns.<xsl:value-of select="@name"/></xsl:for-each>
!enduml
*!
!*> Complex content details
!startuml<xsl:for-each select="xs:complexType[parent::xs:schema]">
<xsl:call-template name="complexContentTemplate" /></xsl:for-each>
!enduml

!*> Code sippets
!listing cpp {
cout &lt;&lt; "hello world !";
}
*!
*!
*!</xsl:template>

<xsl:template name="range"><xsl:if test="@tns:range_min_authorized='yes'">[</xsl:if><xsl:if test="@tns:range_min_authorized!='yes'">]</xsl:if><xsl:value-of select="@tns:range_min"/> .. <xsl:value-of select="@tns:range_max"/><xsl:if test="@tns:range_max_authorized='yes'">]</xsl:if><xsl:if test="@tns:range_max_authorized!='yes'">[</xsl:if></xsl:template>

<xsl:template name="simpleContentTables">
!**> Enumerations<xsl:for-each select="xs:simpleType[parent::xs:schema and ./xs:restriction/xs:enumeration]">
!*> <xsl:value-of select="@name"/> ( <xsl:value-of  select="./xs:restriction/@base"/> )
|'''<xsl:value-of select="@name"/>'''|
|!style_meta[Value]|!style_meta[Meaning]|<xsl:for-each select="./xs:restriction/xs:enumeration">
|<xsl:value-of select="@value"/>|<xsl:value-of select="@ans:meaning | @fm2xx:literal | @id"/>|</xsl:for-each>
*!
</xsl:for-each>
*!
!**> Numerics<xsl:for-each select="xs:simpleType[parent::xs:schema and ./xs:restriction/@base!='xs:string' and ./xs:restriction/@base!='tns:CharArray' and not(./xs:restriction/xs:enumeration)]">
!*> <xsl:value-of select="@name"/> ( <xsl:value-of  select="./xs:restriction/@base"/> )
|'''<xsl:value-of select="@name"/>'''|
|!style_meta[description]|!style_meta[range]|!style_meta[unit]|
|<xsl:value-of select="@tns:description"/>|<xsl:call-template name="range"/>|<xsl:value-of select="@tns:unit_Aero"/>|
*!
</xsl:for-each>
*!
!**> Strings<xsl:for-each select="xs:simpleType[(parent::xs:schema and ./xs:restriction/@base='xs:string')]">
!*> <xsl:value-of select="@name"/> ( <xsl:value-of  select="./xs:restriction/@base"/> )
|'''<xsl:value-of select="@name"/>'''|
|!style_meta[length]|!style_meta[pattern]|
|<xsl:choose><xsl:when test="xs:restriction/xs:length/@value"><xsl:value-of select="xs:restriction/xs:length/@value"/></xsl:when><xsl:otherwise>"n/a"</xsl:otherwise></xsl:choose>|<xsl:choose><xsl:when test="xs:restriction/xs:pattern/@value"><xsl:value-of select="xs:restriction/xs:pattern/@value"/></xsl:when><xsl:otherwise>!style_ignore(nothing)</xsl:otherwise></xsl:choose>|
*!
</xsl:for-each><xsl:for-each select="xs:simpleType[(parent::xs:schema and ./xs:restriction/@base='tns:CharArray')]">
!*> <xsl:value-of select="@name"/> ( <xsl:value-of  select="./xs:restriction/@base"/> )
|'''<xsl:value-of select="@name"/>'''|
|!style_meta[length]|!style_meta[pattern]|
|<xsl:choose><xsl:when test="xs:restriction/xs:length/@value"><xsl:value-of select="xs:restriction/xs:length/@value"/></xsl:when><xsl:otherwise>"n/a"</xsl:otherwise></xsl:choose>|<xsl:choose><xsl:when test="xs:restriction/xs:pattern/@value"><xsl:value-of select="xs:restriction/xs:pattern/@value"/></xsl:when><xsl:otherwise>!style_ignore(nothing)</xsl:otherwise></xsl:choose>|
*!
</xsl:for-each>
*!</xsl:template>

<xsl:template name="simpleContentUML"><xsl:choose><xsl:when test="descendant-or-self::xs:enumeration">
Enum <xsl:value-of select="@name"/> &lt;&lt;<xsl:value-of select="./xs:restriction/@base"/>&gt;&gt; {<xsl:for-each select="descendant::xs:enumeration">
+<xsl:value-of select="@ans:meaning | @fm2xx:literal | @id"/>:<xsl:value-of select="@value"/></xsl:for-each>
}</xsl:when>
<xsl:otherwise>
Class <xsl:value-of select="@name"/> &lt;&lt;<xsl:value-of select="./xs:restriction/@base"/>&gt;&gt;</xsl:otherwise></xsl:choose></xsl:template>

<xsl:template name="complexContentTemplate"><xsl:choose><xsl:when test="@abstract='true'">
Abstract </xsl:when>
<xsl:otherwise>
Class </xsl:otherwise>
</xsl:choose>tns.<xsl:value-of select="@name"/>{<xsl:apply-templates select="descendant::xs:sequence" mode="classes"/>
}
<xsl:apply-templates select="descendant::xs:sequence" mode="associations"/><xsl:apply-templates mode="inheritance"/></xsl:template>

<xsl:template match="xs:sequence" mode="classes">
<xsl:for-each select="xs:element">
<xsl:choose>
<xsl:when test="@type">
+<xsl:value-of select="@name"/>:<xsl:value-of select="@type"/></xsl:when>
<xsl:when test="not(@type) and ./xs:simpleType">
#<xsl:value-of select="@name"/>:<xsl:value-of select="./xs:simpleType/descendant-or-self::*/@base|./xs:simpleType/descendant-or-self::*/@name"/></xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:template>

<xsl:template match="xs:sequence" mode="associations"><xsl:for-each select="xs:element[@type]">
tns.<xsl:value-of select="ancestor::xs:complexType/attribute::name"/> .down.> <xsl:value-of select="concat(substring-before(@type,':'),'.',substring-after(@type,':'))"/><xsl:text>&#xa;</xsl:text>
</xsl:for-each><xsl:for-each select="xs:element[not(@type) and ./xs:simpleType]">
tns.<xsl:value-of select="ancestor::xs:complexType/attribute::name"/> *-down.> <xsl:value-of select="concat(substring-before(./xs:simpleType/descendant-or-self::*/@base|./xs:simpleType/descendant-or-self::*/@name,':'),'.',substring-after(./xs:simpleType/descendant-or-self::*/@base|./xs:simpleType/descendant-or-self::*/@name,':'))"/><xsl:text>&#xa;</xsl:text>
</xsl:for-each></xsl:template>

<xsl:template match="xs:restriction[not(ancestor::xs:element)]" mode="inheritance">
tns.<xsl:value-of select="ancestor::xs:complexType/attribute::name"/> -up-|> <xsl:value-of select="concat(substring-before(@base,':'),'.',substring-after(@base,':'))"/>
</xsl:template>

</xsl:stylesheet>