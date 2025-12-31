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