-- =============================================
-- Mateusz
-- Czarnuchowski
-- 234189
-- =============================================


-- =============================================
-- Zadanie 1
-- =============================================

CREATE SCHEMA M9_surname AUTHORIZATION dbo;

GO

CREATE TYPE M9_surname.Nazwisko FROM NVARCHAR(300);

GO

ALTER TABLE [234189].Customer
ALTER COLUMN LastName M9_surname.Nazwisko;
-- Z tego co widzę system chyba sam poradził sobie z aktualizacją
-- tego także w tabeli historycznej CustomerHistory

-- To chyba też wszystkie tabele, w których pojawia się nazwisko w jakiejś
-- formie więc mam nadzieję, że zadanie wykonane ^_^
GO

-- =============================================
-- Zadanie 2
-- =============================================

-- W Visual studio wykonuję taki kod:
BEGIN TRANSACTION;
SELECT * FROM Student_9.Wizyty WITH (HOLDLOCK);

GO
-- Nie zamykam w tym kodzie tej transakcji


-- Na boku w SSMS wykonuję (a przynajmniej próbuję) taki kod:
INSERT INTO Student_9.Wizyty (IdWizyty, NumerKartyPacjenta, IdLekarza, SpecjalizacjaWizyty)
VALUES (30, 112, 5, N'Alergologia');

GO
-- Ten kod się nie wykonuje. Tamta otwarta transakcja blokuje mi możliwość dodania
-- nowego wiersza, aż jej nie zamknę

-- Jest to niebezpieczne dla baz danych, bo baza danych przestanie wykonywać swoje zadania.
-- Byćmoże też jeśli funkcje czy inne takie rzeczy są źle zrobione to może potencjalnie dojść
-- zepsucia integralności danych, jeśli aplikacja ma dodawać wartości w dwóch tabelach,
-- a przez to uda się jej je dodać tylko w jednej (chociaż tutaj to raczej wina programisty,
-- bo w takim wypadku należałoby stosować transakcje, żeby się przed tym chronić)




-- DELETE FROM Student_9.Wizyty 
-- WHERE IdWizyty = 30;

-- SELECT * FROM Student_9.Wizyty;

-- ROLLBACK TRANSACTION;

-- =============================================
-- Zadanie 3
-- =============================================

-- Zauważyłem, że w tym zadaniu chyba omyłkowo dwa razy powtarza się to samo polecenie.
-- Postanowiłem je jak coś wykonać jak najdokładniej na podstawie wszystkich informacji
-- zawartych w obu powtórzeniach, bo jednak były troszeczkę inne od siebie (doprecyzowały
-- bardziej różne szczegóły, ale generalnie były takie same tylko opisane różnymi słowami).

BEGIN TRANSACTION;

INSERT INTO Student_9.Wizyty (IdWizyty, NumerKartyPacjenta, IdLekarza, SpecjalizacjaWizyty)
VALUES
(51, 112, 105, N'Alergologia'),
(52, 112, 102, N'Kardiologia'),
(53, 114, 101, N'Pediatria'),
(54, 115, 103, N'Dermatologia'),
(55, 115, 105, N'Alergologia'),
(56, 117, 104, N'Neurologia'),
(57, 112, 101, N'Pediatria'),
(58, 119, 101, N'Pediatria'),
(59, 120, 106, N'Ortopedia'),
(60, 114, 103, N'Dermatologia'),
(61, 122, 105, N'Alergologia'),
(62, 120, 107, N'Okulistyka'),
(63, 124, 104, N'Neurologia'),
(64, 125, 102, N'Kardiologia'),
(65, 112, 106, N'Ortopedia');

UPDATE Student_9.Wizyty
SET NumerKartyPacjenta = NumerKartyPacjenta + 100
WHERE IdWizyty BETWEEN 11 AND 20;

SELECT * FROM Student_9.Wizyty;




INSERT INTO Student_189.ProduktyM (ProductID, Name, Category, ListPrice)
VALUES
(1001, N'Extreme BMX - Red', N'Bikes', 1500.00),
(1002, N'Extreme BMX - Green', N'Bikes', 1500.00),
(1003, N'Extreme BMX - Blue', N'Bikes', 2100.00),
(1004, N'Panzerkopf Helmet, Pink', N'Helmets', 35.00),
(1005, N'Panzerkopf Helmet, Blue', N'Helmets', 35.00),
(1006, N'Indestructible bike chain', N'Accessories', 12.50),
(1007, N'Automatic premium bike pump', N'Accessories', 45.00),
(1008, N'Very Fancy Water Bottle', N'Accessories', 20.00),
(1009, N'Nuclear powered tail light', N'Accessories', 15.00),
(1010, N'Carbon Fibre Touring Frame - Black', N'Touring Frames', 600.00),
(1011, N'Carbon Fibre Touring Frame - Silver', N'Touring Frames', 600.00),
(1012, N'I am speed T-shirt - S', N'Clothing', 80.00),
(1013, N'I am speed T-shirt - M', N'Clothing', 80.00),
(1014, N'I am speed T-shirt - L', N'Clothing', 80.00),
(1015, N'Very cool and fancy leather jacket - M', N'Clothing', 195.00);

UPDATE Student_189.ProduktyM
SET ListPrice = ListPrice + 50
WHERE ProductID BETWEEN 718 AND 728;

SELECT * FROM Student_189.ProduktyM;



INSERT INTO SalesLT.Address (AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode)
VALUES
(N'ul. Marszałkowska 10/12', NULL, N'Warszawa', N'Mazowieckie', N'Poland', N'00-001'),
(N'ul. Floriańska 5', N'm. 3', N'Kraków', N'Małopolskie', N'Poland', N'31-019'),
(N'ul. Piotrkowska 100', NULL, N'Łódź', N'Łódzkie', N'Poland', N'90-001'),
(N'ul. Świdnicka 1', N'Piętro 2', N'Wrocław', N'Dolnośląskie', N'Poland', N'50-001'),
(N'ul. Półwiejska 14', NULL, N'Poznań', N'Wielkopolskie', N'Poland', N'61-001'),
(N'ul. Długa 45', NULL, N'Gdańsk', N'Pomorskie', N'Poland', N'80-827'),
(N'ul. Wojska Polskiego 20', NULL, N'Szczecin', N'Zachodniopomorskie', N'Poland', N'70-470'),
(N'ul. Gdańska 10', N'Lokal 4', N'Bydgoszcz', N'Kujawsko-Pomorskie', N'Poland', N'85-001'),
(N'ul. Krakowskie Przedmieście 2', NULL, N'Lublin', N'Lubelskie', N'Poland', N'20-002'),
(N'ul. Lipowa 12', NULL, N'Białystok', N'Podlaskie', N'Poland', N'15-001'),
(N'ul. Mariacka 1', NULL, N'Katowice', N'Śląskie', N'Poland', N'40-014'),
(N'ul. Świętojańska 10', NULL, N'Gdynia', N'Pomorskie', N'Poland', N'81-001'),
(N'ul. Najświętszej Maryi Panny 14', NULL, N'Częstochowa', N'Śląskie', N'Poland', N'42-200'),
(N'ul. Żeromskiego 5', NULL, N'Radom', N'Mazowieckie', N'Poland', N'26-600'),
(N'ul. Zwycięstwa 1', NULL, N'Gliwice', N'Śląskie', N'Poland', N'44-100');


UPDATE SalesLT.Address
SET CountryRegion = N'Equestria'
WHERE AddressID BETWEEN 1077 AND 1087;


SELECT * FROM SalesLT.Address;


TRUNCATE TABLE SalesLT.ProductAttribute;

SELECT * FROM SalesLT.ProductAttribute;


ROLLBACK TRANSACTION;

SELECT * FROM Student_9.Wizyty;
SELECT * FROM Student_189.ProduktyM;
SELECT * FROM SalesLT.Address;
SELECT * FROM SalesLT.ProductAttribute;

-- Przed wykonaniem ROLLBACK'u selecty zwróciły zmodyfikowane tabele.
-- Tabela SalesLT.ProductAttribute została wyczyszczona.
-- Po wykonaniu ROLLBACK'u tabele wróciły do pierwotnych stanów. Wróciła też
-- tabela SalesLT.ProductAttribute. Wniosek: Wszystkie zmiany zostały cofnięte.
-- Baza danych się tak zachowała, ponieważ transakcja została odrzucona,
-- a tak działa odrzucanie transakcji (wszystkie zmiany dokonane podczas
-- trwania transakcji mają zostać cofnięte).


-- =============================================
-- Zadanie 4
-- =============================================

BEGIN TRANSACTION;

INSERT INTO Student_9.Wizyty (IdWizyty, NumerKartyPacjenta, IdLekarza, SpecjalizacjaWizyty)
VALUES
(51, 112, 105, N'Alergologia'),
(52, 112, 102, N'Kardiologia'),
(53, 114, 101, N'Pediatria'),
(54, 115, 103, N'Dermatologia'),
(55, 115, 105, N'Alergologia'),
(56, 117, 104, N'Neurologia'),
(57, 112, 101, N'Pediatria'),
(58, 119, 101, N'Pediatria'),
(59, 120, 106, N'Ortopedia'),
(60, 114, 103, N'Dermatologia'),
(61, 122, 105, N'Alergologia'),
(62, 120, 107, N'Okulistyka'),
(63, 124, 104, N'Neurologia'),
(64, 125, 102, N'Kardiologia'),
(65, 112, 106, N'Ortopedia');

UPDATE Student_9.Wizyty
SET NumerKartyPacjenta = NumerKartyPacjenta + 100
WHERE IdWizyty BETWEEN 11 AND 20;

SELECT * FROM Student_9.Wizyty;




INSERT INTO Student_189.ProduktyM (ProductID, Name, Category, ListPrice)
VALUES
(1001, N'Extreme BMX - Red', N'Bikes', 1500.00),
(1002, N'Extreme BMX - Green', N'Bikes', 1500.00),
(1003, N'Extreme BMX - Blue', N'Bikes', 2100.00),
(1004, N'Panzerkopf Helmet, Pink', N'Helmets', 35.00),
(1005, N'Panzerkopf Helmet, Blue', N'Helmets', 35.00),
(1006, N'Indestructible bike chain', N'Accessories', 12.50),
(1007, N'Automatic premium bike pump', N'Accessories', 45.00),
(1008, N'Very Fancy Water Bottle', N'Accessories', 20.00),
(1009, N'Nuclear powered tail light', N'Accessories', 15.00),
(1010, N'Carbon Fibre Touring Frame - Black', N'Touring Frames', 600.00),
(1011, N'Carbon Fibre Touring Frame - Silver', N'Touring Frames', 600.00),
(1012, N'I am speed T-shirt - S', N'Clothing', 80.00),
(1013, N'I am speed T-shirt - M', N'Clothing', 80.00),
(1014, N'I am speed T-shirt - L', N'Clothing', 80.00),
(1015, N'Very cool and fancy leather jacket - M', N'Clothing', 195.00);

UPDATE Student_189.ProduktyM
SET ListPrice = ListPrice + 50
WHERE ProductID BETWEEN 718 AND 728;

SELECT * FROM Student_189.ProduktyM;



INSERT INTO SalesLT.Address (AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode)
VALUES
(N'ul. Marszałkowska 10/12', NULL, N'Warszawa', N'Mazowieckie', N'Poland', N'00-001'),
(N'ul. Floriańska 5', N'm. 3', N'Kraków', N'Małopolskie', N'Poland', N'31-019'),
(N'ul. Piotrkowska 100', NULL, N'Łódź', N'Łódzkie', N'Poland', N'90-001'),
(N'ul. Świdnicka 1', N'Piętro 2', N'Wrocław', N'Dolnośląskie', N'Poland', N'50-001'),
(N'ul. Półwiejska 14', NULL, N'Poznań', N'Wielkopolskie', N'Poland', N'61-001'),
(N'ul. Długa 45', NULL, N'Gdańsk', N'Pomorskie', N'Poland', N'80-827'),
(N'ul. Wojska Polskiego 20', NULL, N'Szczecin', N'Zachodniopomorskie', N'Poland', N'70-470'),
(N'ul. Gdańska 10', N'Lokal 4', N'Bydgoszcz', N'Kujawsko-Pomorskie', N'Poland', N'85-001'),
(N'ul. Krakowskie Przedmieście 2', NULL, N'Lublin', N'Lubelskie', N'Poland', N'20-002'),
(N'ul. Lipowa 12', NULL, N'Białystok', N'Podlaskie', N'Poland', N'15-001'),
(N'ul. Mariacka 1', NULL, N'Katowice', N'Śląskie', N'Poland', N'40-014'),
(N'ul. Świętojańska 10', NULL, N'Gdynia', N'Pomorskie', N'Poland', N'81-001'),
(N'ul. Najświętszej Maryi Panny 14', NULL, N'Częstochowa', N'Śląskie', N'Poland', N'42-200'),
(N'ul. Żeromskiego 5', NULL, N'Radom', N'Mazowieckie', N'Poland', N'26-600'),
(N'ul. Zwycięstwa 1', NULL, N'Gliwice', N'Śląskie', N'Poland', N'44-100');


UPDATE SalesLT.Address
SET CountryRegion = N'Equestria'
WHERE AddressID BETWEEN 1077 AND 1087;


SELECT * FROM SalesLT.Address;



TRUNCATE TABLE SalesLT.ProductAttribute;

SELECT * FROM SalesLT.ProductAttribute;


WAITFOR DELAY '00:05:00';
ROLLBACK TRANSACTION;

SELECT * FROM Student_9.Wizyty;
SELECT * FROM Student_189.ProduktyM;
SELECT * FROM SalesLT.Address;
SELECT * FROM SalesLT.ProductAttribute;

-- Zapytanie zwracające dane mimo trwającej transakcji (tutaj zadziała):
SELECT * FROM Student_9.Wizyty WITH (NOLOCK);
SELECT * FROM Student_189.ProduktyM WITH (NOLOCK);
SELECT * FROM SalesLT.Address WITH (NOLOCK);
-- Nie uda się jednak zwrócić danych mimo trwającej transakcji dla truncate'owanej
-- tabeli (wynika to z ograniczenia SQL Servera - blokada w przypadku truncate jest inna):
SELECT * FROM SalesLT.ProductAttribute WITH (NOLOCK); -- nie uda się


-- =============================================
-- Zadanie 5
-- =============================================

BEGIN TRY
	BEGIN TRANSACTION;
	TRUNCATE TABLE SalesLT.Product

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
	SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- =============================================
-- Zadanie 6
-- =============================================

-- Pracownik sklepu ma mieć możliwość usunięcia z bazy danych jakiegoś adresu
-- (z tabeli SalesLT.Addresses), który został przykładowo błędnie lub bez potrzeby
-- wprowadzony do bazy danych. Wykonywana jest operacja DELETE na tabeli SalesLT.Addresses.
-- Możliwe błędy są takie, że przesłano ID adresu, które nie istnieje. Możliwe jest
-- też, że zostanie przesłane ID adresu, który nie może zostać usunięty, bo jest
-- on wykorzystywany w innych tabelach.

-- SELECT * FROM SalesLT.Address
-- WHERE AddressID = 450

DECLARE @parametr INT = 450; -- <-- Może Pan stestować podając inne

BEGIN TRY
	IF EXISTS (SELECT 1 FROM SalesLT.Address WHERE AddressID = @parametr)
	BEGIN
		DELETE FROM SalesLT.Address WHERE AddressID = @parametr;
	END
	ELSE
	BEGIN
		;THROW 50001, N'Nie ma takiego rekordu w bazie.', 1;
	END
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- =============================================
-- Zadanie 7
-- =============================================

DECLARE @parametr INT = 450; -- <-- Może Pan stestować podając inne

BEGIN TRY
	BEGIN TRANSACTION;
		IF EXISTS (SELECT 1 FROM SalesLT.Address WHERE AddressID = @parametr)
		BEGIN
			DELETE FROM SalesLT.Address WHERE AddressID = @parametr;
			COMMIT TRANSACTION;
		END
		ELSE
		BEGIN
			;THROW 50001, N'Nie ma takiego rekordu w bazie.', 1;
		END
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH


