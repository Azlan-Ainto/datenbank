--
-- File generated with SQLiteStudio v3.4.20 on So Jan 11 20:15:45 2026
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Adresse
DROP TABLE IF EXISTS Adresse;

CREATE TABLE IF NOT EXISTS Adresse (
    AdressID   INTEGER PRIMARY KEY AUTOINCREMENT
                       NOT NULL,
    KundeID    INTEGER REFERENCES Kunden (KundenID) ON DELETE CASCADE
                                                    ON UPDATE CASCADE
                       NOT NULL,
    Strasse    TEXT    NOT NULL,
    Hausnummer TEXT    NOT NULL,
    PLZ        TEXT    NOT NULL,
    Typ        TEXT    NOT NULL,
    Stadt      TEXT,
    Land       TEXT
);


-- Table: Bestellposition
DROP TABLE IF EXISTS Bestellposition;

CREATE TABLE IF NOT EXISTS Bestellposition (
    PositionsID  INTEGER PRIMARY KEY AUTOINCREMENT
                         NOT NULL,
    BestellungID INTEGER REFERENCES Bestellung (BestellungID) ON DELETE CASCADE
                                                              ON UPDATE CASCADE
                         NOT NULL,
    ProduktID    INTEGER REFERENCES Produkt (ProduktID) ON DELETE CASCADE
                                                        ON UPDATE CASCADE
                         NOT NULL,
    Menge        INTEGER NOT NULL,
    Einzelpreis  REAL    NOT NULL,
    Gesamtpreis  REAL    NOT NULL
                         GENERATED ALWAYS AS (Menge * Einzelpreis) STORED,
    Rabatt       REAL,
    MwStSatz     INTEGER NOT NULL
);


-- Table: Bestellung
DROP TABLE IF EXISTS Bestellung;

CREATE TABLE IF NOT EXISTS Bestellung (
    BestellungID     INTEGER PRIMARY KEY AUTOINCREMENT
                             NOT NULL,
    Datum            TEXT    NOT NULL,
    KundenID         INTEGER REFERENCES Kunden (KundenID) ON DELETE CASCADE
                                                          ON UPDATE CASCADE
                             NOT NULL,
    ProduktID        INTEGER REFERENCES Produkt (ProduktID) ON DELETE CASCADE
                                                            ON UPDATE CASCADE
                             NOT NULL,
    MitarbeiterID    INTEGER REFERENCES Mitarbeiter (MitarbeiterID) ON DELETE CASCADE
                                                                    ON UPDATE CASCADE,
    Lieferdatum      TEXT    NOT NULL,
    Status           TEXT,
    Gesamtbetrag     REAL,
    Lieferadresse    TEXT,
    Rechnungsadresse TEXT
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
    KundenID      INTEGER PRIMARY KEY AUTOINCREMENT
                          NOT NULL,
    vorname       TEXT    NOT NULL,
    nachname      TEXT    NOT NULL,
    geburtsdatum  TEXT    NOT NULL,
    strasse       TEXT,
    hausnummer    INTEGER,
    plz           TEXT,
    stadt         TEXT,
    Mobilenummer  TEXT,
    Telefonnummer TEXT
);


-- Table: Lieferant
DROP TABLE IF EXISTS Lieferant;

CREATE TABLE IF NOT EXISTS Lieferant (
    LieferantID INTEGER    PRIMARY KEY AUTOINCREMENT
                           NOT NULL,
    Name        TEXT (255) NOT NULL,
    Kontakt     TEXT (255),
    Adresse     TEXT (255) NOT NULL
);


-- Table: Mitarbeiter
DROP TABLE IF EXISTS Mitarbeiter;

CREATE TABLE IF NOT EXISTS Mitarbeiter (
    MitarbeiterID INTEGER PRIMARY KEY AUTOINCREMENT
                          NOT NULL,
    Vorname       TEXT    NOT NULL,
    Nachname      TEXT    NOT NULL,
    Beruf         TEXT,
    Abteilung     TEXT
);


-- Table: Produkt
DROP TABLE IF EXISTS Produkt;

CREATE TABLE IF NOT EXISTS Produkt (
    ProduktID     INTEGER    PRIMARY KEY AUTOINCREMENT
                             NOT NULL,
    ean           TEXT (255) UNIQUE,
    preis         REAL,
    bezeichnug    TEXT (255),
    gewicht       REAL,
    verfallsdatum TEXT
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
