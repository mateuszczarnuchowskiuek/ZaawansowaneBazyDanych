-- =============================================
-- Mateusz
-- Czarnuchowski
-- 234189
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

-- Link do repozytorium: https://github.com/mateuszczarnuchowskiuek/ZaawansowaneBazyDanych

-- =============================================
-- Zadanie 2
-- =============================================

ALTER TABLE [234189].[Customer]
ADD
	SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL DEFAULT GETUTCDATE(),
	SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL DEFAULT '9999-12-31 23:59:59.9999999',
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime);
GO

ALTER TABLE [234189].[Customer]
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [234189].[CustomerHistory]));

GO

-- =============================================
-- Zadanie 3
-- =============================================

-- 10 zmian rekordow

UPDATE [234189].[Customer]
SET FirstName = N'Marek'
WHERE CustomerID = 1;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Adam'
WHERE CustomerID = 2;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Bartosz'
WHERE CustomerID = 3;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Jan'
WHERE CustomerID = 4;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Henryk'
WHERE CustomerID = 5;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Jakub'
WHERE CustomerID = 6;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Robert'
WHERE CustomerID = 7;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Roman'
WHERE CustomerID = 11;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Ksawery'
WHERE CustomerID = 12;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Andrzej'
WHERE CustomerID = 10;
GO

-- 3 zmiany w tym samym rekordzie

UPDATE [234189].[Customer]
SET FirstName = N'Krzysztof'
WHERE CustomerID = 16;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Jeremiasz'
WHERE CustomerID = 16;
GO

UPDATE [234189].[Customer]
SET FirstName = N'Chris'
WHERE CustomerID = 16;
GO

-- dodanie 5 nowych rekordow

INSERT INTO [234189].[Customer] (FirstName, LastName, PasswordHash, PasswordSalt)
VALUES (N'Marek', N'Maureliusz', 'gfdf23h4kh23h5jk23h46', 'l42j34h');

INSERT INTO [234189].[Customer] (FirstName, LastName, PasswordHash, PasswordSalt)
VALUES (N'Adam', N'Mith', 'gfdf23g4kh23h5jk23h46', 'l42j64h');

INSERT INTO [234189].[Customer] (FirstName, LastName, PasswordHash, PasswordSalt)
VALUES (N'Ludwig', N'Mieses', 'fdf23hd4kh23h5jk23h46', 'l4da34h');

INSERT INTO [234189].[Customer] (FirstName, LastName, PasswordHash, PasswordSalt)
VALUES (N'Juliusz', N'Maesar', 'kshrb23h4kh23h5jk23h46', 'l42ge4h');

INSERT INTO [234189].[Customer] (FirstName, LastName, PasswordHash, PasswordSalt)
VALUES (N'Albert', N'Mebra', 'gfdf23h4kh23hgfds3h46', 'l43464h');

GO

-- =============================================
-- Zadanie 4
-- =============================================

SELECT * FROM [234189].[Customer]
FOR SYSTEM_TIME ALL
WHERE CustomerID = 16
ORDER BY SysStartTime ASC;

GO

-- =============================================
-- Zadanie 5
-- =============================================

SELECT * FROM [234189].[Customer]
FOR SYSTEM_TIME AS OF '2025-12-23 00:51:03.98';

GO

-- =============================================
-- Zadanie 6
-- =============================================

CREATE XML SCHEMA COLLECTION ProductAttributesSchema AS N'
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Attributes" type="ProductAttributes"/>
  <xs:complexType name="ProductAttributes">
    <xs:sequence>
      <xs:element name="Waga" type="xs:decimal"/>
      <xs:element name="Kolor" type="xs:string"/>
      <xs:element name="Hipoalergiczny" type="xs:boolean"/>
      <xs:element name="PoziomCertyfikacji" type="xs:string"/>
      <xs:element name="ZawieraAI" type="xs:boolean"/>
    </xs:sequence>
  </xs:complexType>
</xs:schema>';

GO

CREATE TABLE [SalesLT].[ProductAttribute] (
	ProductID INT NOT NULL,
	Attributes XML(ProductAttributesSchema) NULL,
    CONSTRAINT FK_ProductAttributes
        FOREIGN KEY ([ProductID])
        REFERENCES [SalesLT].[Product] ([ProductID])
);

GO

-- =============================================
-- Zadanie 7
-- =============================================

INSERT INTO [SalesLT].[ProductAttribute] (ProductID, Attributes)
VALUES
(680, '<Attributes>
<Waga>20.42</Waga>
<Kolor>Niebieski</Kolor>
<Hipoalergiczny>false</Hipoalergiczny>
<PoziomCertyfikacji>silver</PoziomCertyfikacji>
<ZawieraAI>true</ZawieraAI>
</Attributes>'),
(707, '<Attributes>
<Waga>3.14</Waga>
<Kolor>Czerwony</Kolor>
<Hipoalergiczny>false</Hipoalergiczny>
<PoziomCertyfikacji>bronze</PoziomCertyfikacji>
<ZawieraAI>false</ZawieraAI>
</Attributes>'),
(709, '<Attributes>
<Waga>5.03</Waga>
<Kolor>Zielony</Kolor>
<Hipoalergiczny>true</Hipoalergiczny>
<PoziomCertyfikacji>bronze</PoziomCertyfikacji>
<ZawieraAI>true</ZawieraAI>
</Attributes>'),
(712, '<Attributes>
<Waga>8.3</Waga>
<Kolor>Czarny</Kolor>
<Hipoalergiczny>false</Hipoalergiczny>
<PoziomCertyfikacji>silver</PoziomCertyfikacji>
<ZawieraAI>false</ZawieraAI>
</Attributes>'),
(714, '<Attributes>
<Waga>5.45</Waga>
<Kolor>Fioletowy</Kolor>
<Hipoalergiczny>true</Hipoalergiczny>
<PoziomCertyfikacji>gold</PoziomCertyfikacji>
<ZawieraAI>true</ZawieraAI>
</Attributes>')

GO

-- =============================================
-- Zadanie 8
-- =============================================

UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/Kolor)[1] with "Mniebieski"')
WHERE ProductID = 680;
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/Kolor)[1] with "Mczerwony"')
WHERE ProductID = 707;
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/Kolor)[1] with "Mzielony"')
WHERE ProductID = 709;
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/Kolor)[1] with "Mczarny"')
WHERE ProductID = 712;
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/Kolor)[1] with "Mfioletowy"')
WHERE ProductID = 714;

GO


UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/PoziomCertyfikacji)[1] with "Msilver"')
WHERE ProductID = 680;
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/PoziomCertyfikacji)[1] with "Mbronze"')
WHERE ProductID = 707;
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/PoziomCertyfikacji)[1] with "Mbronze"')
WHERE ProductID = 709;
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/PoziomCertyfikacji)[1] with "Msilver"')
WHERE ProductID = 712;
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/PoziomCertyfikacji)[1] with "Mgold"')
WHERE ProductID = 714;

GO

-- =============================================
-- Zadanie 9
-- =============================================

DECLARE @zmienna NVARCHAR(MAX) = N'{
  "lista_zakupow": [
    {
      "nazwa": "jab?ka",
      "ilosc": 1
    },
    {
      "nazwa": "mleko",
      "ilosc": 2
    },
    {
      "nazwa": "chleb",
      "ilosc": 1
    },
    {
      "nazwa": "jajka",
      "ilosc": 12
    },
    {
      "nazwa": "makaron",
      "ilosc": 500
    }
  ]
}';

SET @zmienna = JSON_MODIFY(@zmienna, '$.lista_zakupow[1].ilosc', 234189);

GO


-- =============================================
