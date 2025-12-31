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