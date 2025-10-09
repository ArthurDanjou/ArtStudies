DROP TABLE IF EXISTS Vu;
DROP TABLE IF EXISTS  Aime;
DROP TABLE IF EXISTS  Projection;
DROP TABLE IF EXISTS  Joue;
DROP TABLE IF EXISTS  Film;
DROP TABLE IF EXISTS  Spectateur;
DROP TABLE IF EXISTS  Salle;
DROP TABLE IF EXISTS  Participant;


CREATE TABLE Participant(
    IdP INTEGER not null,
    Nom VARCHAR(50) not null,
    Prenom VARCHAR(50) not null,
    CONSTRAINT Participant_pk
    PRIMARY KEY(IdP)
);
CREATE TABLE Salle(
    IdC INTEGER not null,
    Nom VARCHAR(50) not null,
    CONSTRAINT Salle_pk
    PRIMARY KEY(IdC)
);
CREATE TABLE Spectateur(
    IdS INTEGER not null,
    Prenom VARCHAR(50),
    CONSTRAINT Spectateur_pk
    PRIMARY KEY(IdS)
);
CREATE TABLE Film(
    IdF INTEGER AUTO_INCREMENT,
    Titre VARCHAR(50) not null,
    Annee INTEGER,
    Realisateur INTEGER not null,
    CONSTRAINT Film_pk
    PRIMARY KEY(IdF)
);
CREATE TABLE Joue(
    IdF INTEGER not null,
    IdP INTEGER not null
);
CREATE TABLE Projection(
    IdF INTEGER,
    IdC INTEGER not null,
    Debut TIMESTAMP
);
CREATE TABLE Aime(
    IdS INTEGER not null,
    IdF INTEGER not null
);
CREATE TABLE Vu(
    IdS INTEGER not null,
    IdF INTEGER not null
);
/* Participant */
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (1,'James','Cameron');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (2,'Leonardo','Di Caprio');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (3,'Kate','Winslet');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (4,'Charles','Chaplin');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (5,'Paulette','Goddard');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (6,'Woody','Allen');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (7,'Diane','Keaton');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (8,'Michael','Murphy');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (9,'Mariel','Hemingway');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (10,'Meryl','Streep');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (11,'Tony','Roberts');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (12,'Carol','Kane');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (13,'Sydney','Pollack');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (14,'Robert','Redford');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (15,'Patrice','Leconte');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (16,'Josiane','Balasko');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (17,'Christian','Clavier');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (18,'Gérard','Jugnot');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (19,'Thierry','Lhermitte');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (20,'Dominique','Lavanant');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (21,'Marie-Anne','Chazel');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (22,'Michel','Blanc');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (23,'Michel','Créton');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (24,'Alain','Chabat');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (25,'Jean-Pierre','Bacri');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (26,'Carole ','Bouquet');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (27,'Philippe','Noiret');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (28,'Jean-Luc','Godard');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (29,'Jean-Paul','Belmondo');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (30,'Philippe','De Broca');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (31,'Françoise','Dorléac');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (32,'Jean','Servais');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (33,'Gérard','Oury');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (34,'André','Bourvil');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (35,'Claude','Lelouch');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (36,'Christopher','Nolan');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (37,'Ellen','Page');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (38,'Cillian','Murphy');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (39,'Ken','Watanabe');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (40,'Joseph','Gordon-Levitt');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (41,'Marion','Cotillard');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (42,'Tom','Hardy');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (43,'Christian','Bale');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (44,'Anne','Hathaway');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (45,'Morgan','Freeman');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (46,'Vera','Farmiga');
INSERT INTO Participant(IdP, Prenom, Nom) VALUES (47,'Jackie','Coogan');
/* Film */
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (1,'Titanic',1997,1);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (2,'The Great Dictator',1940,4);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (3,'The Kid',1921,4);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (4,'Modern Times',1936,4);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (5,'Manhattan',1979,6);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (6,'Annie Hall',1977,6);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (7,'Out of Africa',1985,13);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (8,'Les Bronzés',1987,15);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (9,'Didier',1997,24);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (10,'Grosse fatigue',1994,22);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (11,'A bout de souffle',1960,28);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (12,'L''homme de Rio',1964,30);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (13,'Pierrot le fou',1965,28);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (14,'Le cerveau',1969,33);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (15,'Itinéraire d''un enfant gâté',1968,35);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (16,'Inception',2010,36);
INSERT INTO Film(IdF, Titre, Annee, Realisateur) VALUES (17,'The Dark Knight Rises',2012,36);
/* Joue */
INSERT INTO Joue(IdF, IdP) VALUES (1,2);
INSERT INTO Joue(IdF, IdP) VALUES (1,3);
INSERT INTO Joue(IdF, IdP) VALUES (2,4);
INSERT INTO Joue(IdF, IdP) VALUES (2,5);
INSERT INTO Joue(IdF, IdP) VALUES (3,4);
INSERT INTO Joue(IdF, IdP) VALUES (3,47);
INSERT INTO Joue(IdF, IdP) VALUES (4,4);
INSERT INTO Joue(IdF, IdP) VALUES (4,5);
INSERT INTO Joue(IdF, IdP) VALUES (5,6);
INSERT INTO Joue(IdF, IdP) VALUES (5,7);
INSERT INTO Joue(IdF, IdP) VALUES (5,8);
INSERT INTO Joue(IdF, IdP) VALUES (5,9);
INSERT INTO Joue(IdF, IdP) VALUES (5,10);
INSERT INTO Joue(IdF, IdP) VALUES (6,6);
INSERT INTO Joue(IdF, IdP) VALUES (6,7);
INSERT INTO Joue(IdF, IdP) VALUES (6,11);
INSERT INTO Joue(IdF, IdP) VALUES (6,12);
INSERT INTO Joue(IdF, IdP) VALUES (7,10);
INSERT INTO Joue(IdF, IdP) VALUES (7,14);
INSERT INTO Joue(IdF, IdP) VALUES (8,16);
INSERT INTO Joue(IdF, IdP) VALUES (8,17);
INSERT INTO Joue(IdF, IdP) VALUES (8,18);
INSERT INTO Joue(IdF, IdP) VALUES (8,19);
INSERT INTO Joue(IdF, IdP) VALUES (8,20);
INSERT INTO Joue(IdF, IdP) VALUES (8,21);
INSERT INTO Joue(IdF, IdP) VALUES (8,22);
INSERT INTO Joue(IdF, IdP) VALUES (8,23);
INSERT INTO Joue(IdF, IdP) VALUES (9,16);
INSERT INTO Joue(IdF, IdP) VALUES (9,24);
INSERT INTO Joue(IdF, IdP) VALUES (9,25);
INSERT INTO Joue(IdF, IdP) VALUES (10,16);
INSERT INTO Joue(IdF, IdP) VALUES (10,22);
INSERT INTO Joue(IdF, IdP) VALUES (10,26);
INSERT INTO Joue(IdF, IdP) VALUES (10,27);
INSERT INTO Joue(IdF, IdP) VALUES (10,17);
INSERT INTO Joue(IdF, IdP) VALUES (10,21);
INSERT INTO Joue(IdF, IdP) VALUES (11,29);
INSERT INTO Joue(IdF, IdP) VALUES (12,29);
INSERT INTO Joue(IdF, IdP) VALUES (12,31);
INSERT INTO Joue(IdF, IdP) VALUES (12,32);
INSERT INTO Joue(IdF, IdP) VALUES (13,29);
INSERT INTO Joue(IdF, IdP) VALUES (14,29);
INSERT INTO Joue(IdF, IdP) VALUES (14,34);
INSERT INTO Joue(IdF, IdP) VALUES (15,29);
INSERT INTO Joue(IdF, IdP) VALUES (16,2);
INSERT INTO Joue(IdF, IdP) VALUES (16,37);
INSERT INTO Joue(IdF, IdP) VALUES (16,38);
INSERT INTO Joue(IdF, IdP) VALUES (16,39);
INSERT INTO Joue(IdF, IdP) VALUES (16,40);
INSERT INTO Joue(IdF, IdP) VALUES (16,41);
INSERT INTO Joue(IdF, IdP) VALUES (16,42);
INSERT INTO Joue(IdF, IdP) VALUES (17,43);
INSERT INTO Joue(IdF, IdP) VALUES (17,44);
INSERT INTO Joue(IdF, IdP) VALUES (17,45);
INSERT INTO Joue(IdF, IdP) VALUES (17,42);
INSERT INTO Joue(IdF, IdP) VALUES (17,41);
/* Salle */
INSERT INTO Salle(IdC, Nom) VALUES (100,'Salle 1');
INSERT INTO Salle(IdC, Nom) VALUES (200,'Salle 2');
INSERT INTO Salle(IdC, Nom) VALUES (300,'Salle 3');
INSERT INTO Salle(IdC, Nom) VALUES (400,'Salle 4');
/* Projection */
INSERT INTO Projection(IdF, IdC, Debut) VALUES (11,100,'2025-12-15 10:15:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (8,100,'2025-12-15 14:30:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (17,100,'2025-12-15 17:05:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (1,100,'2025-12-15 20:05:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (3,200,'2025-12-15 10:00:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (14,200,'2025-12-15 12:00:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (10,200,'2025-12-15 13:35:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (9,200,'2025-12-15 16:05:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (1,200,'2025-12-15 19:10:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (4,300,'2025-12-15 09:50:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (13,300,'2025-12-15 11:30:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (16,300,'2025-12-15 14:00:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (5,300,'2025-12-15 17:05:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (10,300,'2025-12-15 20:10:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (5,400,'2025-12-15 10:10:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (4,400,'2025-12-15 12:30:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (16,400,'2025-12-15 14:30:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (6,400,'2025-12-15 16:45:00');
INSERT INTO Projection(IdF, IdC, Debut) VALUES (12,400,'2025-12-15 19:50:00');
/* Spectateur */
INSERT INTO Spectateur(IdS, Prenom) VALUES (1,'Alban');
INSERT INTO Spectateur(IdS, Prenom) VALUES (2,'Béatrice');
INSERT INTO Spectateur(IdS, Prenom) VALUES (3,'Charles');
INSERT INTO Spectateur(IdS, Prenom) VALUES (4,'Diane');
INSERT INTO Spectateur(IdS, Prenom) VALUES (5,'Etienne');
INSERT INTO Spectateur(IdS, Prenom) VALUES (6,'Florence');
INSERT INTO Spectateur(IdS, Prenom) VALUES (7,'Guillaume');
INSERT INTO Spectateur(IdS, Prenom) VALUES (8,'Hélène');
INSERT INTO Spectateur(IdS, Prenom) VALUES (9,'Igor');
/* Vu */
INSERT INTO Vu(IdS, IdF) VALUES (1,17);
INSERT INTO Vu(IdS, IdF) VALUES (2,17);
INSERT INTO Vu(IdS, IdF) VALUES (3,17);
INSERT INTO Vu(IdS, IdF) VALUES (4,17);
INSERT INTO Vu(IdS, IdF) VALUES (5,17);
INSERT INTO Vu(IdS, IdF) VALUES (6,17);
INSERT INTO Vu(IdS, IdF) VALUES (7,17);
INSERT INTO Vu(IdS, IdF) VALUES (8,17);
INSERT INTO Vu(IdS, IdF) VALUES (9,4);
INSERT INTO Vu(IdS, IdF) VALUES (9,11);
INSERT INTO Vu(IdS, IdF) VALUES (6,11);
INSERT INTO Vu(IdS, IdF) VALUES (6,6);
INSERT INTO Vu(IdS, IdF) VALUES (6,9);
INSERT INTO Vu(IdS, IdF) VALUES (6,10);
INSERT INTO Vu(IdS, IdF) VALUES (6,16);
INSERT INTO Vu(IdS, IdF) VALUES (6,15);
INSERT INTO Vu(IdS, IdF) VALUES (6,12);
INSERT INTO Vu(IdS, IdF) VALUES (6,8);
INSERT INTO Vu(IdS, IdF) VALUES (6,5);
INSERT INTO Vu(IdS, IdF) VALUES (6,4);
INSERT INTO Vu(IdS, IdF) VALUES (6,7);
INSERT INTO Vu(IdS, IdF) VALUES (6,13);
INSERT INTO Vu(IdS, IdF) VALUES (6,14);
INSERT INTO Vu(IdS, IdF) VALUES (6,2);
INSERT INTO Vu(IdS, IdF) VALUES (6,3);
INSERT INTO Vu(IdS, IdF) VALUES (6,1);
/* Aime */
INSERT INTO Aime(IdS, IdF) VALUES (1,17);
INSERT INTO Aime(IdS, IdF) VALUES (2,17);
INSERT INTO Aime(IdS, IdF) VALUES (3,17);
INSERT INTO Aime(IdS, IdF) VALUES (9,17);
INSERT INTO Aime(IdS, IdF) VALUES (9,4);
INSERT INTO Aime(IdS, IdF) VALUES (9,14);
INSERT INTO Aime(IdS, IdF) VALUES (6,8);
INSERT INTO Aime(IdS, IdF) VALUES (6,5);

-- Start of queries

-- Q3.1
INSERT INTO Film VALUES (
    18,
    'Esther',
    2009,
    (SELECT IdP FROM Participant WHERE Nom = 'Di Caprio' AND Prenom = 'Leonardo')
);

INSERT INTO Joue(IdF, IdP) VALUES (
    (SELECT IdF FROM Film WHERE Titre = 'Esther'),
    (SELECT IdP FROM Participant WHERE Nom = 'Di Caprio' AND Prenom = 'Leonardo')
);

INSERT INTO Vu(IdS, IdF) VALUES (
    (SELECT IdS FROM Spectateur WHERE Prenom = 'Florence'),
    (SELECT IdF FROM Film WHERE Titre = 'Esther')
);

-- Q3.2
UPDATE Film SET Annee = 1978 WHERE Titre = 'Les Bronzés' AND Annee = 1987;

-- Q3.3
SELECT * FROM Projection p
JOIN Film f ON f.IdF = p.IdF
JOIN Salle s ON p.IdC = s.IdC
WHERE f.Titre = 'Titanic';

-- Q3.4
SELECT Nom, Prenom FROM Joue j
JOIN Participant p ON j.IdP = p.IdP
JOIN Film f ON f.IdF = j.IdF
WHERE f.Titre = 'Manhattan';

-- Q3.5
SELECT s.Nom FROM Salle s
JOIN Projection p ON s.IdC = p.IdC
JOIN Film f ON f.IdF = p.IdF
JOIN Joue j ON j.IdF = f.IdF
JOIN Participant act ON act.IdP = j.IdP
WHERE act.Nom = 'Balasko' AND act.Prenom = 'Josiane';

-- Q3.6
SELECT f.Titre, real.Nom, real.Prenom FROM Film f
JOIN Participant real ON F.Realisateur = real.IdP
WHERE f.Annee BETWEEN 1975 AND 1990;

-- Q3.7
SELECT DISTINCT s.Nom FROM Salle s
JOIN Projection p on S.IdC = p.IdC
JOIN Film f ON f.IdF = p.IdF
JOIN Joue j ON f.IdF = j.IdF
JOIN Participant a ON a.IdP = j.IdP
WHERE a.Nom = 'Belmondo' AND a.Prenom = 'Jean-Paul' AND p.Debut >= '2025-12-15 18:00:00' AND p.Debut <= '2025-12-15 23:59:59';

-- Q3.8
SELECT Nom, Prenom FROM Participant p
WHERE p.IdP IN (
    SELECT j.IdP FROM Joue j
    JOIN Film f ON j.IdP = f.Realisateur
);

-- Q3.9
SELECT DISTINCT Nom, Prenom FROM Participant p
JOIN Joue j ON p.IdP = j.IdP
JOIN Film f ON j.IdF = f.IdF
WHERE p.IdP = f.Realisateur;

-- Q3.10
SELECT Titre FROM Film f
WHERE NOT EXISTS (
    SELECT * FROM Projection p WHERE p.IdF = f.IdF
);

-- Q3.11
SELECT DISTINCT s.IdS, s.Prenom, f.Titre
FROM Aime a
JOIN Spectateur s ON s.IdS = a.IdS
JOIN Film f ON f.IdF = a.IdF
WHERE NOT EXISTS (
    SELECT 1 FROM Vu v
    WHERE v.IdS = a.IdS AND v.IdF = a.IdF
);

-- Q3.12
SELECT s.Prenom FROM Spectateur s
JOIN Vu v ON s.IdS = v.IdS
AND NOT EXISTS (
    SELECT 1 FROM Aime a
    WHERE a.IdS = s.IdS
);

-- Q3.13
SELECT s.Prenom FROM Spectateur s
WHERE NOT EXISTS (
    SELECT 1 FROM Film f WHERE NOT EXISTS (
        SELECT 1 FROM Vu v WHERE v.IdS = s.IdS AND v.IdF = f.IdF
    )
);