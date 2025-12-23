CREATE XML SCHEMA COLLECTION [dbo].[ProductAttributesSchema]
    AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <xsd:element name="Attributes" type="ProductAttributes" />
  <xsd:complexType name="ProductAttributes">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="Waga" type="xsd:decimal" />
          <xsd:element name="Kolor" type="xsd:string" />
          <xsd:element name="Hipoalergiczny" type="xsd:boolean" />
          <xsd:element name="PoziomCertyfikacji" type="xsd:string" />
          <xsd:element name="ZawieraAI" type="xsd:boolean" />
        </xsd:sequence>
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
</xsd:schema>';

