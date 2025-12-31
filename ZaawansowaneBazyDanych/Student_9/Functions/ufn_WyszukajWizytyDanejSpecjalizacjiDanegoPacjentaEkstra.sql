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