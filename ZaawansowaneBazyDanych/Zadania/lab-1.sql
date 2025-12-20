-- =============================================
-- Mateusz
-- Czarnuchowski
-- 234189
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

select *
from SalesLT.Customer
where LastName like 'M%';

go

-- =============================================
-- Zadanie 2
-- =============================================

select FirstName, LastName, EmailAddress--, CustomerID
from SalesLT.Customer
where CustomerID like '%9';

go

-- =============================================
-- Zadanie 3
-- =============================================

select Name, ListPrice, ProductNumber
from SalesLT.Product
where Name like '%m%'
order by ListPrice desc;

go

-- =============================================
-- Zadanie 4
-- =============================================

select avg(ListPrice) as AveragePrice
from SalesLT.Product
where ProductCategoryID % 10 = 9;

go

-- =============================================
-- Zadanie 5
-- =============================================

select distinct City
from SalesLT.CustomerAddress
join SalesLT.Address on CustomerAddress.AddressID = Address.AddressID
where City like 'm%';

go

-- =============================================
-- Zadanie 6
-- =============================================

insert into SalesLT.Customer (FirstName, LastName, CompanyName, EmailAddress, PasswordHash, PasswordSalt)
values
('Mateusz', 'Czarnuchowski', 'Lab9', 'mateusz.czarnuchowski@lab9.com', 'MGQ5YTc3YTZhNTYzMzkyOTA5OTliYzM1ODBjOTkyMDk1MzUyZjQxMDQ0ZDY2M2E2NTY3Yzk3NThkMDdhZWE4NQ==', 'kDNy9Tas=');

select *
from SalesLT.Customer
where (FirstName='Mateusz' and LastName='Czarnuchowski' and CompanyName='Lab9' and EmailAddress='mateusz.czarnuchowski@lab9.com');

go

-- =============================================
-- Zadanie 7
-- =============================================

insert into SalesLT.ProductCategory (Name)
values
('Special-M'),
('Extra-9');

go

-- =============================================
-- Zadanie 8
-- =============================================

select Product.Name, Product.ProductNumber, ProductCategory.Name as Category, 234189 as OwnerId
into ProductCategories234189
from SalesLT.Product join SalesLT.ProductCategory on Product.ProductCategoryID = ProductCategory.ProductCategoryID
where Product.Name like 'm%m' or ProductCategory.Name like '%m%';

go

-- =============================================
-- Zadanie 9
-- =============================================

select Category, COUNT(*) as Quantity
from ProductCategories234189
group by Category;