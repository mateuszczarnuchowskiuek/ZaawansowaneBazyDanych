CREATE TABLE [Student_9].[Wizyty] (
    [IdWizyty]            INT            NOT NULL,
    [NumerKartyPacjenta]  INT            NULL,
    [IdLekarza]           INT            NULL,
    [SpecjalizacjaWizyty] NVARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([IdWizyty] ASC)
);

