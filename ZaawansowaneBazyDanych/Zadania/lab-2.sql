-- =============================================
-- Mateusz
-- Czarnuchowski
-- 234189
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

-- Sprawdziłem i baza danych już teraz zwraca dane na każde zapytanie z poprzedniego modułu (lab 1) (czyli jest dobrze? zadanie odhaczone?)

-- =============================================
-- Zadanie 2
-- =============================================

declare @Litera char(1) = 'M';
declare @Cyfra int = 9;

select CustomerID, FirstName, LastName
from SalesLT.Customer
where (LastName like @Litera+'%' and CustomerID % 10 = @Cyfra);

go

-- =============================================
-- Zadanie 3
-- =============================================

declare @Produkty table (
	ProductID int,
	Name nvarchar(50),
	ListPrice money
);

insert into @Produkty (ProductID, Name, ListPrice)
select Product.ProductID, Product.Name, Product.ListPrice
from SalesLT.Product
where Product.Name like '%m%';

select * from @Produkty;

go

-- =============================================
-- Zadanie 4
-- =============================================

select Customer.CustomerID, Customer.FirstName, Customer.LastName, Address.City 
into #KlienciMiasta
from SalesLT.Customer left join (SalesLT.CustomerAddress join SalesLT.Address on CustomerAddress.AddressID = Address.AddressID) on Customer.CustomerID = CustomerAddress.CustomerID
where Address.City like 'm%';

select * from #KlienciMiasta;
drop table #KlienciMiasta;

go

-- =============================================
-- Zadanie 5
-- =============================================

create schema Student_189 authorization dbo;

go

create table Student_189.ProduktyM (
	ProductID int,
	Name nvarchar(100),
	Category nvarchar(100),
	ListPrice money
);

insert into Student_189.ProduktyM (ProductID, Name, Category, ListPrice)
select Product.ProductID, Product.Name, ProductCategory.Name, Product.ListPrice
from (SalesLT.Product join SalesLT.ProductCategory on Product.ProductCategoryID = ProductCategory.ProductCategoryID)
where ProductCategory.Name like '%m%';

go

-- =============================================
-- Zadanie 6
-- =============================================

declare @Podsumowanie table (
	Category nvarchar(100),
	SredniaCena money
);

insert into @Podsumowanie (Category, SredniaCena)
select ProductCategory.Name, AVG(Product.ListPrice)
from SalesLT.ProductCategory join SalesLT.Product on ProductCategory.ProductCategoryID = Product.ProductCategoryID
where Product.ProductCategoryID % 10 = 9
group by ProductCategory.Name;

select * from @Podsumowanie;

go

-- =============================================
-- Zadanie 7
-- =============================================

create schema [234189] authorization dbo;

go

alter schema [234189] transfer SalesLT.Customer;
alter schema [234189] transfer SalesLT.CustomerAddress;

