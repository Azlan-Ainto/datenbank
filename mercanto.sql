--
-- File generated with SQLiteStudio v3.4.20 on Sa Jan 10 23:26:32 2026
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

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
