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