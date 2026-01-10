--
-- File generated with SQLiteStudio v3.4.20 on Sa Jan 10 20:48:29 2026
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

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


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
