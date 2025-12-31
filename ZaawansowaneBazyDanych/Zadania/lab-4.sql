-- =============================================
-- Mateusz
-- Czarnuchowski
-- 234189
-- =============================================


-- =============================================
-- Zadanie 1
-- =============================================

-- Jeśli zmienna ma nie być definiowana w ramach tworzonego widoku,
-- to chyba nie będzie się dało zrobić tego zadania, bo jak próbuję
-- utworzyć zmienną przed widokiem to dostaję następujący błąd:
-- SQL80001: Incorrect syntax: 'CREATE VIEW' must be the only statement in the batch
--
-- Sprawdziłem o co chodzi z tym błędem i wychodzi na to, że widok musi być jedyną instrukcją
-- w batch'u. Z racji, że zmienne zachowują się tylko wewnątrz pojedynczego batch'a,
-- nie ma więc chyba jak użyć tej zmiennej.
--
-- Można by było może zastosować funkcję tabelaryczną z parametrem (tamtą iTVF), ale w tym
-- zadaniu Pan prosi o stworzenie konkretnie widoku, więc zgaduję, że tutaj
-- chodzi o to, że nie da się tego zadania zrobić z przyczyn technicznych.

-- =============================================
-- Zadanie 2
-- =============================================

CREATE SCHEMA Student_9;

GO

CREATE VIEW Student_9.TheBestCustomers AS
SELECT TOP 10
	c.CustomerID,
	c.FirstName,
	c.LastName,
	c.CompanyName,
	SUM(s.TotalDue) as CustomerLifetimeValue
FROM [234189].Customer AS c
INNER JOIN SalesLT.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID
GROUP BY
	c.CustomerID,
	c.FirstName,
	c.LastName,
	c.CompanyName
ORDER BY CustomerLifetimeValue DESC;

-- Uzasadniam wybór algorytmu: Aby wybrać najlepszych klientów postanowiłem wybrać
-- 10 klientów, którzy wydali u nas najwięcej pieniędzy łącznie na wszystkie zamówienia.
-- Uważam, że to dobra metryka, bo to właśnie ci klienci przynieśli nam największe przychody.

GO

-- SELECT * from Student_9.TheBestCustomers

-- =============================================
-- Zadanie 3
-- =============================================

CREATE FUNCTION Student_9.ufn_ProductsJsonByCategory
(
	@CategoryName NVARCHAR(50)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Result NVARCHAR(MAX);

	SET @Result = (
		SELECT
			p.ProductID,
			p.Name,
			p.Size,
			p.Color,
			p.ListPrice,
			pd.Description
		FROM
		SalesLT.ProductCategory AS pc
		INNER JOIN SalesLT.Product AS p ON pc.ProductCategoryID = p.ProductCategoryID
		LEFT JOIN SalesLT.ProductModelProductDescription AS pmd
			ON pmd.ProductModelID = p.ProductModelID
			AND pmd.Culture= N'en'
		LEFT JOIN SalesLT.ProductDescription AS pd
			ON pd.ProductDescriptionID = pmd.ProductDescriptionID
		WHERE pc.Name = @CategoryName
		FOR JSON PATH, ROOT('Products')
	);

	RETURN @Result;
END

GO

-- select Student_9.ufn_ProductsJsonByCategory(N'Brakes')

-- =============================================
-- Zadanie 4
-- =============================================

CREATE FUNCTION Student_9.ufn_IsPriceHigherThanCurrent
(
	@JsonDocument NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    DECLARE @ProductID INT;
    DECLARE @NewPrice MONEY;
    DECLARE @CurrentPrice MONEY;

    SELECT
        @ProductID = ProductID,
        @NewPrice = ListPrice
    FROM OPENJSON(@JsonDocument)
    WITH 
    (
        ProductID INT '$.ProductID',
        ListPrice MONEY '$.ListPrice'
    );

    SELECT @CurrentPrice = ListPrice
    FROM SalesLT.Product
    WHERE ProductID = @ProductID;


    IF @NewPrice > @CurrentPrice
    BEGIN
        RETURN 1;
    END
    RETURN 0;
END

GO

-- Gdy cena będzie równa, system zwróci fałsz, ponieważ warunkiem jest silna nierówność,
-- więc logicznie wszystko się zgadza w sumie. Pytamy, czy cena jest większa od obecnej,
-- a skoro jest równa, to znaczy, że nie. Wszystko się zgadza.

-- =============================================
-- Zadanie 5
-- =============================================

CREATE FUNCTION Student_9.ufn_GetProductsWithHigherUpdatedPrice
(
    @Data NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        d.ProductID,
        p.Name,
        p.ListPrice as CurrentPrice,
        d.ListPrice as UpdatedPrice
    FROM OPENJSON(@Data)
    WITH 
    (
        ProductID INT '$.ProductID',
        ListPrice MONEY '$.ListPrice'
    ) as d
    INNER JOIN SalesLT.Product AS p ON p.ProductID = d.ProductID
    WHERE Student_9.ufn_IsPriceHigherThanCurrent
    (
        (
        SELECT
            d.ProductID AS ProductID,
            d.ListPrice AS ListPrice
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )
    ) = 1
);

GO

-- =============================================
-- Zadanie 6
-- =============================================

CREATE TABLE #TopProducts
(
    ProductID INT,
    Name NAME,
    ListPrice MONEY
);

GO

SELECT TOP 25
    sod.ProductID,
    p.Name,
    SUM(sod.OrderQty) AS QtySold,
    SUM(sod.LineTotal) AS TotalRevenue
INTO #TopProducts
FROM SalesLT.SalesOrderDetail AS sod
INNER JOIN SalesLT.Product AS p ON p.ProductID = sod.ProductID
GROUP BY sod.ProductID, p.Name
ORDER BY TotalRevenue DESC;

GO

-- Za 25 najlepszych produktów przyjąłem 25 produktów, które
-- wygenerowały największy przychód

-- SELECT * FROM #TopProducts

-- Doszedłem do tego punktu i stwierdzam, że to zadanie
-- jest według mnie niemożliwe do wykonania z powodu błędu:
-- Cannot access temporary tables from within a function
-- Jeśli funkcja MUSI korzystać z tabeli tymczasowej, to nie da się tego zrobić.

-- =============================================
-- Zadanie 7
-- =============================================

-- SCENARIUSZ DLA iTVF:
-- Mamy tabele zawierajaca dane wszystkich wizyt wszystkich pacjentow prywatnej kliniki.
-- Chcemy zwrocic liste wszystkich wizyt danego pacjenta w charakterze danej
-- specjalizacji, poniewaz pacjent ma w panelu pacjenta na naszej stronie internetowej
-- wyszukiwarke swoich wizyt i moze je wyszukiwac po specjalizacji lekarskiej wizyty.

-- Przygotowanie tabeli do scenariusza:
CREATE TABLE Student_9.Wizyty
(
    IdWizyty INT PRIMARY KEY,
    NumerKartyPacjenta INT,
    IdLekarza INT,
    SpecjalizacjaWizyty NVARCHAR(200)
);

GO

-- Wprowadzenie przykladowych danych do tabeli ze scenariusza:
INSERT INTO Student_9.Wizyty (IdWizyty, NumerKartyPacjenta, IdLekarza, SpecjalizacjaWizyty)
VALUES
(1, 101, 201, N'alergologia'),
(2, 101, 201, N'alergologia'),
(3, 101, 202, N'alergologia'),
(4, 101, 202, N'alergologia'),
(5, 102, 203, N'kardiologia'),
(6, 103, 204, N'gastrologia'),
(7, 104, 205, N'neurologia'),
(8, 105, 206, N'chirurgia'),
(9, 102, 203, N'kardiologia'),
(10, 106, 201, N'alergologia'),
(11, 107, 204, N'gastrologia'),
(12, 103, 205, N'neurologia'),
(13, 108, 206, N'chirurgia'),
(14, 101, 203, N'kardiologia'),
(15, 109, 204, N'gastrologia'),
(16, 110, 205, N'neurologia'),
(17, 104, 206, N'chirurgia'),
(18, 105, 201, N'alergologia'),
(19, 102, 204, N'gastrologia'),
(20, 107, 205, N'neurologia');

GO

-- Rozwiazanie dla scenariusza:

CREATE FUNCTION Student_9.ufn_WyszukajWizytyDanejSpecjalizacjiDanegoPacjenta
(
    @IdPacjenta INT,
    @Specjalizacja NVARCHAR(200)
)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM Student_9.Wizyty as w
    WHERE @IdPacjenta = w.NumerKartyPacjenta AND @Specjalizacja = w.SpecjalizacjaWizyty
);

GO

-- Wywolanie rozwiazania:

SELECT * FROM Student_9.ufn_WyszukajWizytyDanejSpecjalizacjiDanegoPacjenta(101,N'alergologia');

GO

-- SCENARIUSZ DLA mTVF:
-- Podobnie jak wyzej mamy tabele zawierajaca dane wszystkich wizyt wszystkich
-- pacjentow prywatnej kliniki i chcemy zwrocic liste wszystkich wizyt danego
-- pacjenta w charakterze danej specjalizacji lekarskiej na potrzeby wyszukiwarki
-- w panelu pacjenta na naszej stronie internetowej, ale tym razem chcemy umozliwic wybranie
-- specjalizacji 'dowolna' w przypadku, kiedy specjalizacja nie ma znaczenia.

-- Tabele z przykladowymi danymi mamy juz gotowa

-- Rozwiazanie dla scenariusza:

CREATE FUNCTION Student_9.ufn_WyszukajWizytyDanejSpecjalizacjiDanegoPacjentaEkstra
(
    @IdPacjenta INT,
    @Specjalizacja NVARCHAR(200)
)
RETURNS @Result TABLE
(
    IdWizyty INT,
    NumerKartyPacjenta INT,
    IdLekarza INT,
    SpecjalizacjaWizyty NVARCHAR(200)
)
AS
BEGIN
    IF @Specjalizacja = N'dowolna'
    BEGIN
        INSERT INTO @Result
        SELECT * FROM Student_9.Wizyty as w
        WHERE @IdPacjenta = w.NumerKartyPacjenta;
    END
    ELSE
    BEGIN
        INSERT INTO @Result
        SELECT * FROM Student_9.Wizyty as w
        WHERE @IdPacjenta = w.NumerKartyPacjenta AND @Specjalizacja = w.SpecjalizacjaWizyty
    END
    RETURN;
END

GO

-- Wywolanie rozwiazania:

SELECT * FROM Student_9.ufn_WyszukajWizytyDanejSpecjalizacjiDanegoPacjentaEkstra(101,N'dowolna');

GO

-- SCENARIUSZ DLA WIDOKU:
-- Dalej zajmujemy sie obsluga prywatnej kliniki. Jako zarzadzajacy klinika chcemy
-- poznac ilosci wizyt u lekarzy roznych specjalizacji aby dowiedziec sie jakich
-- lekarzy jakich specjalizacji potrzebujemy potencjalnie wiecej zatrudnic, zeby
-- zaspokoic popyt. W zwiazku z tym chcemy zwracac liste zawierajaca specjalizacje
-- lekarska i liczbe wizyt w tej specjalizacji. Dalej korzystamy z poprzedniej tabeli.

-- Tabele z przykladowymi danymi mamy juz gotowa

-- Rozwiazanie dla scenariusza:

CREATE VIEW Student_9.v_IlosciWizytWSpecjalizacjach AS
SELECT 
    w.SpecjalizacjaWizyty,
    COUNT(w.IdWizyty) AS LiczbaWizyt
FROM Student_9.Wizyty AS w
GROUP BY w.SpecjalizacjaWizyty;

GO

-- Wywolanie rozwiazania:

SELECT * FROM Student_9.v_IlosciWizytWSpecjalizacjach;

GO

-- SCENARIUSZ DLA FUNKCJI SKALARNEJ:
-- Dalej zajmujemy sie obsluga prywatnej kliniki, ale tym razem od strony recepcjonisty.
-- W zaleznosci od ilosci odbytych wizyt recepcjonista powinien naliczyc pacjentowi
-- rabat w roznej wysokosci. W swoim panelu recepcjonista zobaczy informacje jak duzy rabat
-- nalezy sie klientowi w danej chwili przy naliczaniu platnosci. Dalej korzystamy
-- z poprzedniej tabeli.

-- Tabele z przykladowymi danymi mamy juz gotowa

-- Rozwiazanie dla scenariusza:

CREATE FUNCTION Student_9.ufn_ObliczRabat
(
    @NumerKartyKlienta INT
)
RETURNS INT
AS
BEGIN
    DECLARE @LiczbaWizyt INT;
    DECLARE @Result INT

    SET @LiczbaWizyt = 
    (
        SELECT COUNT(*)
        FROM Student_9.Wizyty
        WHERE NumerKartyPacjenta = @NumerKartyKlienta
    )

    IF @LiczbaWizyt >= 30
        SET @Result = 15;
    ELSE IF @LiczbaWizyt >= 10
        SET @Result = 10;
    ELSE IF @LiczbaWizyt >= 5
        SET @Result = 5;
    ELSE
        SET @Result = 0;

    RETURN @Result;
END;

GO

-- Wywolanie rozwiazania:

SELECT Student_9.ufn_ObliczRabat(101);



