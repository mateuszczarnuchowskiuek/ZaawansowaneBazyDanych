CREATE VIEW Student_9.v_IlosciWizytWSpecjalizacjach AS
SELECT 
    w.SpecjalizacjaWizyty,
    COUNT(w.IdWizyty) AS LiczbaWizyt
FROM Student_9.Wizyty AS w
GROUP BY w.SpecjalizacjaWizyty;