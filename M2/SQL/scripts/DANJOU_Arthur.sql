-- EXERCICE 1 --

-- Suppression des tables si elles existent
DROP TABLE IF EXISTS Inscription;
DROP TABLE IF EXISTS Orateur;
DROP TABLE IF EXISTS Conference;

-- Création des tables
CREATE TABLE Conference (
    IDConf INTEGER,
    Titre VARCHAR(100) NOT NULL,
    DateConf DATE,
    Prix DECIMAL(6,2),
    CONSTRAINT Conference_pk
    PRIMARY KEY(IDConf)
);

CREATE TABLE Orateur (
    IDOr INTEGER,
    NomOrateur VARCHAR(100) NOT NULL,
    CONSTRAINT Orateur_pk
    PRIMARY KEY(IDOr)
);

CREATE TABLE Inscription (
    IDIns INTEGER,
    IDConf INTEGER,
    IDOr INTEGER,
    DateIns DATE,
    CONSTRAINT Inscription_pk
    PRIMARY KEY(IDIns),
    CONSTRAINT Inscription_fk1
    FOREIGN KEY (IDConf) REFERENCES Conference(IDConf),
    CONSTRAINT Inscription_fk2
    FOREIGN KEY (IDOr) REFERENCES Orateur(IDOr)
);

-- Insertion des conférences
INSERT INTO Conference(IDConf, Titre, DateConf, Prix) VALUES (1, 'Data Science Fundamentals', '2025-03-15', 150.00);
INSERT INTO Conference(IDConf, Titre, DateConf, Prix) VALUES (2, 'Advanced Machine Learning', '2025-03-15', 200.00);
INSERT INTO Conference(IDConf, Titre, DateConf, Prix) VALUES (3, 'Introduction to AI', '2025-04-10', 120.00);
INSERT INTO Conference(IDConf, Titre, DateConf, Prix) VALUES (4, 'Big Data for Business', '2025-05-20', 180.00);
INSERT INTO Conference(IDConf, Titre, DateConf, Prix) VALUES (5, 'Data Visualization Techniques', '2025-05-20', 130.00);
INSERT INTO Conference(IDConf, Titre, DateConf, Prix) VALUES (6, 'Cloud Computing Basics', '2025-01-25', 100.00);
INSERT INTO Conference(IDConf, Titre, DateConf, Prix) VALUES (7, 'Cybersecurity Essentials', '2025-02-14', 160.00);
INSERT INTO Conference(IDConf, Titre, DateConf, Prix) VALUES (8, 'Neural Networks Deep Dive', '2025-03-15', 220.00);
INSERT INTO Conference(IDConf, Titre, DateConf, Prix) VALUES (9, 'Data Warehouses and Data Lakes', '2025-02-14', 150.00);

-- Insertion des orateurs
INSERT INTO Orateur(IDOr, NomOrateur) VALUES (1, 'Jean Dupont');
INSERT INTO Orateur(IDOr, NomOrateur) VALUES (2, 'Isabella Rihl');
INSERT INTO Orateur(IDOr, NomOrateur) VALUES (3, 'Marc Twilight');
INSERT INTO Orateur(IDOr, NomOrateur) VALUES (4, 'Houda Ben Ali');
INSERT INTO Orateur(IDOr, NomOrateur) VALUES (5, 'Yann Lequn');
INSERT INTO Orateur(IDOr, NomOrateur) VALUES (6, 'Sophie Marchand');

-- Insertion des inscriptions
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (1, 1, 1, '2025-01-10');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (2, 2, 1, '2025-01-11');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (3, 3, 1, '2025-01-15');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (4, 4, 2, '2025-02-01');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (5, 5, 2, '2025-02-20');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (6, 6, 3, '2025-03-10');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (7, 7, 3, '2025-02-28');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (8, 8, 1, '2025-03-01');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (9, 1, 4, '2025-01-12');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (10, 2, 4, '2025-01-15');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (11, 3, 4, '2025-02-01');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (12, 1, 5, '2025-01-25');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (13, 5, 5, '2025-01-30');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (14, 4, 6, '2024-12-10');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (15, 5, 6, '2025-01-05');
INSERT INTO Inscription(IDIns, IDConf, IDOr, DateIns) VALUES (16, 1, 6, '2025-01-10');

-- Question 1.1
SELECT Titre, MIN(Prix) AS 'Prix Minimum' FROM Conference GROUP BY Titre;

-- Question 1.2
SELECT c.Titre FROM Conference c
WHERE EXISTS (SELECT * FROM Inscription i WHERE i.IDConf = c.IDConf) AND c.Titre LIKE '%Data%';

-- Question 1.4
SELECT o.NomOrateur FROM Orateur o
JOIN Inscription i ON o.IDOr = i.IDOr
WHERE i.DateIns < '2025-01-20'
GROUP BY o.NomOrateur
HAVING COUNT(i.IDConf) >= 3;

-- Question 1.4
SELECT c.Titre, c.DateConf, COUNT(i.IDOr) AS 'Nombre d''Orateurs inscrits' FROM Conference c
JOIN Inscription i ON i.IDConf = c.IdConf
GROUP BY c.Titre, c.DateConf
ORDER BY c.DateConf ASC;

-- Question 1.5
SELECT o.NomOrateur, SUM(c.Prix) AS 'Prix Total payé' FROM Orateur o
JOIN Inscription i ON o.IDOr = i.IDOr
JOIN Conference c ON c.IDConf = i.IDConf
GROUP BY o.NomOrateur
ORDER BY SUM(c.Prix) DESC;

-- Question 1.6
SELECT o.NomOrateur, MIN(c.Prix) AS 'Prix minimal payé' , MAX(c.Prix) AS 'Prix maximal payé' FROM Orateur o
JOIN Inscription i ON o.IDOr = i.IDOr
JOIN Conference c ON c.IDConf = i.IDConf
GROUP BY o.NomOrateur;

-- Question 1.7
SELECT c.Titre FROM Conference c
JOIN Inscription i ON i.IDConf = c.IDConf
JOIN Orateur o ON o.IDOr = i.IDOr
WHERE o.NomOrateur = 'Jean Dupont'
ORDER BY c.Titre ASC;

-- Question 1.8
SELECT o.NomOrateur FROM Orateur o
WHERE NOT EXISTS (
    SELECT * FROM Conference c WHERE NOT EXISTS (
        SELECT * FROM Inscription i WHERE i.IDConf = c.IDConf AND o.IDOr = i.IDOr
    ) AND c.DateConf = '2025-03-15'
);

-- EXERCICE 2 --

-- Suppression des tables si elles existent
DROP TABLE IF EXISTS Oeuvre;
DROP TABLE IF EXISTS Collection;
DROP TABLE IF EXISTS Musee;

-- Création des tables
CREATE TABLE Musee (
    idm INTEGER,
    nom VARCHAR(100) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    CONSTRAINT Musee_pk
    PRIMARY KEY(idm)
);

CREATE TABLE Collection (
    idc INTEGER,
    idm INTEGER NOT NULL,
    nom VARCHAR(100) NOT NULL,
    CONSTRAINT Collection_pk
    PRIMARY KEY(idc),
    CONSTRAINT Collection_fk
    FOREIGN KEY (idm) REFERENCES Musee(idm)
);

CREATE TABLE Oeuvre (
    ido INTEGER,
    idc INTEGER NOT NULL,
    titre VARCHAR(100) NOT NULL,
    artiste VARCHAR(100) NOT NULL,
    annee INTEGER,
    prix_estime DECIMAL(12,2),
    CONSTRAINT Oeuvre_pk
    PRIMARY KEY(ido),
    CONSTRAINT Oeuvre_fk
    FOREIGN KEY (idc) REFERENCES Collection(idc)
);

-- Insertion des musées
INSERT INTO Musee(idm, nom, ville) VALUES (1, 'Louvre', 'Paris');
INSERT INTO Musee(idm, nom, ville) VALUES (2, 'Musée d''Orsay', 'Paris');
INSERT INTO Musee(idm, nom, ville) VALUES (3, 'Metropolitan Museum of Art', 'New York');
INSERT INTO Musee(idm, nom, ville) VALUES (4, 'Galerie nationale', 'Berlin');

-- Insertion des collections
INSERT INTO Collection(idc, idm, nom) VALUES (1, 1, 'Toile classique');
INSERT INTO Collection(idc, idm, nom) VALUES (2, 1, 'Sculpture');
INSERT INTO Collection(idc, idm, nom) VALUES (3, 2, 'Impressionnisme');
INSERT INTO Collection(idc, idm, nom) VALUES (4, 3, 'Art moderne');
INSERT INTO Collection(idc, idm, nom) VALUES (5, 4, 'Art contemporain');
INSERT INTO Collection(idc, idm, nom) VALUES (6, 2, 'Photographie');

-- Insertion des œuvres (ido, idc, titre, artiste, annee, prix_estime)
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (1, 1, 'Mona Lisa', 'Léonard de Vinci', 1503, 700000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (2, 1, 'La Vénus de Milo', 'Alexandros d''Antioche', -100, 20000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (3, 2, 'Le Penseur', 'Auguste Rodin', 1902, 15000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (4, 3, 'Impression, Soleil Levant', 'Claude Monet', 1872, 5000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (5, 3, 'La Nuit étoilée', 'Vincent van Gogh', 1889, 100000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (6, 4, 'Les Demoiselles d''Avignon', 'Pablo Picasso', 1907, 140000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (7, 4, 'Guernica', 'Pablo Picasso', 1937, 200000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (8, 5, 'Balloon Dog', 'Jeff Koons', 1994, 56000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (9, 5, 'Untitled', 'Banksy', 2005, 15000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (10, 6, 'Migrant Mother', 'Dorothea Lange', 1936, 800000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (11, 6, 'Moonrise, Hernandez, New Mexico', 'Ansel Adams', 1941, 600000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (12, 1, 'La Liberté guidant le peuple', 'Eugène Delacroix', 1830, 120000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (13, 3, 'Le Déjeuner sur l''herbe', 'Edouard Manet', 1863, 60000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (14, 4, 'Composition VIII', 'Wassily Kandinsky', 1923, 40000000.00);
INSERT INTO Oeuvre(ido, idc, titre, artiste, annee, prix_estime) VALUES (15, 5, 'For the Love of God', 'Damien Hirst', 2007, 100000000.00);

-- Question 2.1
SELECT COUNT(*) AS 'NombreMusees' FROM Musee;

-- Question 2.2
SELECT m.nom, m.ville, COUNT(o.ido) AS 'NombreOeuvres' FROM Musee m
JOIN Collection c ON m.idm = c.idm
JOIN Oeuvre o ON o.idc = c.idc
GROUP BY m.nom, m.ville
HAVING COUNT(o.ido) >= 4;

-- Question 2.3
SELECT o.titre, o.artiste, o.annee FROM Oeuvre o
JOIN Collection c ON o.idc = c.idc
JOIN Musee m ON c.idm = m.idm
WHERE m.ville = 'Paris'
ORDER BY o.annee ASC;

-- Question 2.4
SELECT AVG(o.prix_estime) AS 'Prix moyen des oeuvres de Pablo Picasso' FROM Oeuvre o
WHERE o.artiste = 'Pablo Picasso';

-- Question 2.5
SELECT m.nom, COUNT(o.ido) AS 'Nombre d''oeuvres dont le prix est estimé à plus d''1 million d''euros' FROM Musee m
JOIN Collection c ON m.idm = c.idm
JOIN Oeuvre o ON c.idc = o.idc
WHERE o.prix_estime > 1000000
GROUP BY m.nom;

-- Question 2.6
SELECT m.nom, MIN(o.prix_estime) AS 'Prix estimé minimal', MAX(o.prix_estime) AS 'Prix estimé maximal' FROM Musee m
JOIN Collection c ON m.idm = c.idm
JOIN Oeuvre o ON c.idc = o.idc
GROUP BY m.nom;

-- Question 2.7
-- SELECT AVG(prix_estime) AS 'Moyenne des prix estimés de toutes les oeuvres' FROM Oeuvre;

SELECT o.titre, o.prix_estime FROM Oeuvre o
WHERE o.prix_estime >= (SELECT AVG(prix_estime) FROM Oeuvre)
ORDER BY o.titre ASC;

-- Question 2.8
SELECT m.nom FROM Musee m
WHERE NOT EXISTS (
    SELECT * FROM Oeuvre o WHERE NOT EXISTS (
        SELECT * FROM Collection c
        WHERE c.idc = o.idc AND c.idm = m.idm
    ) AND o.annee > 1950
)