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