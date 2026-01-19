--
-- File generated with SQLiteStudio v3.4.20 on Mo Jan 19 12:44:34 2026
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


-- View: vw_Bestellposition_Detail
DROP VIEW IF EXISTS vw_Bestellposition_Detail;
CREATE VIEW IF NOT EXISTS vw_Bestellposition_Detail AS
    SELECT bp.PositionID,
           bp.BestellungID,
           bp.ProduktID,
           p.Bezeichnug AS Produktname,
           p.EAN,
           bp.Menge,
           bp.Einzelpreis,
           bp.Gesamtpreis,
           bp.Rabatt,
           bp.MwSt
      FROM Bestellposition bp
           LEFT JOIN
           Produkt p ON p.ProduktID = bp.ProduktID;


-- View: vw_Bestellung_Uebersicht
DROP VIEW IF EXISTS vw_Bestellung_Uebersicht;
CREATE VIEW IF NOT EXISTS vw_Bestellung_Uebersicht AS
    SELECT b.BestellungID,
           b.Datum,
           b.Lieferdatum,
           b.Status,
           b.Gesamtbetrag,
           k.KundenID,
           k.Vorname || ' ' || k.Nachname AS Kunde,
           m.MitarbeiterID,
           m.Vorname || ' ' || m.Nachname AS Mitarbeiter,
           (
               SELECT COUNT( * ) 
                 FROM Bestellposition bp
                WHERE bp.BestellungID = b.BestellungID
           )
           AS PositionenAnzahl
      FROM Bestellung b
           LEFT JOIN
           Kunden k ON k.KundenID = b.KundenID
           LEFT JOIN
           Mitarbeiter m ON m.MitarbeiterID = b.MitarbeiterID;


-- View: vw_Kunden_Adressen
DROP VIEW IF EXISTS vw_Kunden_Adressen;
CREATE VIEW IF NOT EXISTS vw_Kunden_Adressen AS
    SELECT a.AdressID,
           a.KundeID,
           k.Vorname || ' ' || k.Nachname AS Kunde,
           a.Strasse || ' ' || a.Hausnummer AS Strasse,
           a.PLZ,
           a.Stadt,
           a.Land,
           a.Typ
      FROM Adresse a
           LEFT JOIN
           Kunden k ON k.KundenID = a.KundeID;


-- View: vw_Kunden_Bestellhistorie
DROP VIEW IF EXISTS vw_Kunden_Bestellhistorie;
CREATE VIEW IF NOT EXISTS vw_Kunden_Bestellhistorie AS
    SELECT k.KundenID,
           k.Vorname || ' ' || k.Nachname AS Kunde,
           COUNT(b.BestellungID) AS AnzahlBestellungen,
           IFNULL(SUM(b.Gesamtbetrag), 0) AS SummeBestellungen,
           MAX(b.Datum) AS LetzteBestellung
      FROM Kunden k
           LEFT JOIN
           Bestellung b ON b.KundenID = k.KundenID
     GROUP BY k.KundenID;


-- View: vw_Produkt_Details
DROP VIEW IF EXISTS vw_Produkt_Details;
CREATE VIEW IF NOT EXISTS vw_Produkt_Details AS
    SELECT p.ProduktID,
           p.Bezeichnug,
           p.EAN,
           p.Preis,
           p.Gewicht,
           p.Verfallsdatum,
           p.Lagerbestand,
           l.LieferantID,
           l.Name AS Lieferant,
           c.kategorieID,
           c.titel AS Kategorie
      FROM Produkt p
           LEFT JOIN
           Lieferant l ON l.LieferantID = p.LieferantID
           LEFT JOIN
           Kategorie c ON c.kategorieID = p.KategorieID;


-- View: vw_Produkt_LowStock
DROP VIEW IF EXISTS vw_Produkt_LowStock;
CREATE VIEW IF NOT EXISTS vw_Produkt_LowStock AS
    SELECT ProduktID,
           Bezeichnug,
           Lagerbestand
      FROM Produkt
     WHERE Lagerbestand <= 5;


-- Trigger: trg_bestellung_after_status_versendet
DROP TRIGGER IF EXISTS trg_bestellung_after_status_versendet;
CREATE TRIGGER IF NOT EXISTS trg_bestellung_after_status_versendet
                       AFTER UPDATE OF Status
                          ON Bestellung
                        WHEN NEW.Status = 'Versendet' AND
                             (OLD.Status IS NULL OR
                              OLD.Status != 'Versendet') 
BEGIN-- Für jedes Produkt in der Bestellung die Summe der Menge abziehen
    UPDATE Produkt
       SET Lagerbestand = Lagerbestand - (
                                             SELECT IFNULL(SUM(bp.Menge), 0) 
                                               FROM Bestellposition bp
                                              WHERE bp.ProduktID = Produkt.ProduktID AND
                                                    bp.BestellungID = NEW.BestellungID
                                         )
     WHERE EXISTS (
        SELECT 1
          FROM Bestellposition bp
         WHERE bp.ProduktID = Produkt.ProduktID AND
               bp.BestellungID = NEW.BestellungID
    );
END;


-- Trigger: trg_bp_after_insert
DROP TRIGGER IF EXISTS trg_bp_after_insert;
CREATE TRIGGER IF NOT EXISTS trg_bp_after_insert
                       AFTER INSERT
                          ON Bestellposition
BEGIN
    UPDATE Bestellung
       SET Gesamtbetrag = (
               SELECT IFNULL(SUM(Gesamtpreis * (1.0 - Rabatt / 100.0) ), 0) 
                 FROM Bestellposition
                WHERE BestellungID = NEW.BestellungID
           )
     WHERE BestellungID = NEW.BestellungID;
END;


-- Trigger: trg_bp_after_insert_set_price
DROP TRIGGER IF EXISTS trg_bp_after_insert_set_price;
CREATE TRIGGER IF NOT EXISTS trg_bp_after_insert_set_price
                       AFTER INSERT
                          ON Bestellposition
                        WHEN NEW.Einzelpreis IS NULL OR
                             NEW.Einzelpreis = 0
BEGIN
    UPDATE Bestellposition
       SET Einzelpreis = (
               SELECT Preis
                 FROM Produkt
                WHERE ProduktID = NEW.ProduktID
           )
     WHERE PositionID = NEW.PositionID;
END;


-- Trigger: trg_bp_before_insert_validate_menge
DROP TRIGGER IF EXISTS trg_bp_before_insert_validate_menge;
CREATE TRIGGER IF NOT EXISTS trg_bp_before_insert_validate_menge
                      BEFORE INSERT
                          ON Bestellposition
                        WHEN NEW.Menge <= 0
BEGIN
    SELECT RAISE(ABORT, 'Menge muss grösser als 0 sein');
END;


-- Trigger: trg_check_negative_stock_after_versand
DROP TRIGGER IF EXISTS trg_check_negative_stock_after_versand;
CREATE TRIGGER IF NOT EXISTS trg_check_negative_stock_after_versand
                       AFTER UPDATE OF Status
                          ON Bestellung
                        WHEN NEW.Status = 'Versendet'
BEGIN-- Falls irgendein Produkt negativen Lagerbestand hat, Abbruch erzwingen
    SELECT CASE
               WHEN (
                        SELECT MIN(Lagerbestand) 
                          FROM Produkt
                    )
<              0 THEN RAISE(ABORT, 'Versand nicht möglich: Negativer Lagerbestand nach Anpassung') 
           END;
END;


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
