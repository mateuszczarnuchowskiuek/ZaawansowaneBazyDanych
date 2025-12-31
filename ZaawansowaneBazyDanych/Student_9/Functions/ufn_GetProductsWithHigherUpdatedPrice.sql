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