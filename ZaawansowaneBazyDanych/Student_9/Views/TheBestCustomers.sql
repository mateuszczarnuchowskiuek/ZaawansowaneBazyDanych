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