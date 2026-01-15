--
-- File generated with SQLiteStudio v3.4.20 on Do Jan 15 22:19:50 2026
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Adresse
DROP TABLE IF EXISTS Adresse;

CREATE TABLE IF NOT EXISTS Adresse (
    AdressID   INTEGER    PRIMARY KEY AUTOINCREMENT
                          NOT NULL,
    KundeID    INTEGER    REFERENCES Kunden (KundenID) ON DELETE CASCADE
                                                       ON UPDATE CASCADE
                          NOT NULL,
    Strasse    TEXT (255) NOT NULL,
    Hausnummer TEXT       NOT NULL,
    PLZ        TEXT (5)   NOT NULL,
    Typ        TEXT (255) NOT NULL,
    Stadt      TEXT (255) NOT NULL,
    Land       TEXT (255) NOT NULL
);


-- Table: Bestellposition
DROP TABLE IF EXISTS Bestellposition;

CREATE TABLE IF NOT EXISTS Bestellposition (
    PositionID   INTEGER PRIMARY KEY AUTOINCREMENT
                         NOT NULL,
    BestellungID INTEGER REFERENCES Bestellung (BestellungID) ON DELETE CASCADE
                                                              ON UPDATE CASCADE
                         NOT NULL,
    ProduktID    INTEGER REFERENCES Produkt (ProduktID) ON DELETE CASCADE
                                                        ON UPDATE CASCADE
                         NOT NULL,
    Menge        INTEGER NOT NULL
                         CHECK (Menge > 0),
    Einzelpreis  REAL    NOT NULL,
    Gesamtpreis  REAL    NOT NULL
                         GENERATED ALWAYS AS (Menge * Einzelpreis) STORED,
    Rabatt       REAL    NOT NULL
                         DEFAULT (0.0),
    MwSt         REAL    NOT NULL
                         DEFAULT (19.0) 
);


-- Table: Bestellung
DROP TABLE IF EXISTS Bestellung;

CREATE TABLE IF NOT EXISTS Bestellung (
    BestellungID       INTEGER    PRIMARY KEY AUTOINCREMENT
                                  NOT NULL,
    Datum              TEXT (10)  NOT NULL,
    KundenID           INTEGER    REFERENCES Kunden (KundenID) ON DELETE CASCADE
                                                               ON UPDATE CASCADE
                                  NOT NULL,
    MitarbeiterID      INTEGER    REFERENCES Mitarbeiter (MitarbeiterID) ON DELETE CASCADE
                                                                         ON UPDATE CASCADE,
    Lieferdatum        TEXT (10)  NOT NULL,
    Status             TEXT (255) NOT NULL
                                  CHECK (Status IN ('Neu', 'Bearbeitung', 'Versendet', 'Storniert') ) 
                                  DEFAULT Neu,
    Gesamtbetrag       REAL,
    LieferadresseID    INTEGER    REFERENCES Adresse (AdressID) ON DELETE CASCADE
                                                                ON UPDATE CASCADE,
    RechnungsadresseID INTEGER    REFERENCES Adresse (AdressID) ON DELETE CASCADE
                                                                ON UPDATE CASCADE
);


-- Table: Kategorie
DROP TABLE IF EXISTS Kategorie;

CREATE TABLE IF NOT EXISTS Kategorie (
    kategorieID  INTEGER    PRIMARY KEY AUTOINCREMENT
                            NOT NULL,
    titel        TEXT (255),
    beschreibung TEXT (255) 
);


-- Table: Kunden
DROP TABLE IF EXISTS Kunden;

CREATE TABLE IF NOT EXISTS Kunden (
    KundenID      INTEGER    PRIMARY KEY AUTOINCREMENT
                             NOT NULL,
    Vorname       TEXT (155) NOT NULL,
    Nachname      TEXT (155) NOT NULL,
    Geburtsdatum  TEXT (10)  NOT NULL,
    Mobilenummer  TEXT (12),
    Telefonnummer TEXT (20) 
);


-- Table: Lieferant
DROP TABLE IF EXISTS Lieferant;

CREATE TABLE IF NOT EXISTS Lieferant (
    LieferantID INTEGER    PRIMARY KEY AUTOINCREMENT
                           NOT NULL,
    Name        TEXT (255) NOT NULL,
    Adresse     TEXT (255) NOT NULL
                           REFERENCES Adresse (AdressID) ON DELETE CASCADE
                                                         ON UPDATE CASCADE
);


-- Table: Mitarbeiter
DROP TABLE IF EXISTS Mitarbeiter;

CREATE TABLE IF NOT EXISTS Mitarbeiter (
    MitarbeiterID INTEGER    PRIMARY KEY AUTOINCREMENT
                             NOT NULL,
    Vorname       TEXT (155) NOT NULL,
    Nachname      TEXT (155) NOT NULL,
    Beruf         TEXT (155),
    Abteilung     TEXT (155) 
);


-- Table: Produkt
DROP TABLE IF EXISTS Produkt;

CREATE TABLE IF NOT EXISTS Produkt (
    ProduktID     INTEGER    PRIMARY KEY AUTOINCREMENT
                             NOT NULL,
    LieferantID   INTEGER    REFERENCES Lieferant (LieferantID) ON DELETE CASCADE
                                                                ON UPDATE CASCADE
                             NOT NULL,
    KategorieID   INTEGER    REFERENCES Kategorie (kategorieID) ON DELETE CASCADE
                                                                ON UPDATE CASCADE
                             NOT NULL,
    EAN           TEXT (255) UNIQUE,
    Preis         REAL       NOT NULL,
    Bezeichnug    TEXT (255) NOT NULL,
    Gewicht       REAL,
    Verfallsdatum TEXT (10),
    Lagerbestand  REAL       NOT NULL
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
