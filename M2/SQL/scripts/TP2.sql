DROP TABLE IF EXISTS Employe;
DROP TABLE IF EXISTS Departement;

-- Q2.1
-- La clé 'Dep' ne fait pas référence à une clé primaire dans la table 'Departement' car les valeurs ne sont pas uniques.

CREATE TABLE IF NOT EXISTS Employe(
    Eno      INTEGER PRIMARY KEY,
    Enom     VARCHAR(20),
    Prof     VARCHAR(30),
    Date_Emb Date,
    Salaire  INTEGER,
    Prime    INTEGER,
    Dep      INTEGER
);

CREATE TABLE IF NOT EXISTS Departement(
    Dno       INTEGER PRIMARY KEY,
    Dnom      VARCHAR(20),
    Directeur INTEGER,
    Ville     VARCHAR(20)
);

INSERT INTO Employe VALUES
(10, 'Lucas', 'Ingénieur', '2023-10-01', 3100, NULL, 3),
(20, 'Jean', 'Technicien', '2018-05-01', 2510, 1500, 2),
(30, 'Claude', 'Vendeur', '2010-03-01', 4300, 2000, 1),
(40, 'Claire', 'Ingénieur', '2010-03-01', 4500, 2400, 3),
(50, 'Léon', 'Technicien', '2015-09-01', 2100, 1000, 2);

INSERT INTO Departement VALUES
(1, 'Vente', 30, 'Passy'),
(2, 'Production', 20, 'Lyon'),
(3, 'Développement', 40, 'Grenoble'),
(4, 'Recherche', 40, 'Antibes');

-- Q2.2
SELECT * FROM Employe;
SELECT * FROM Departement;

-- Q2.3
SELECT Enom, Salaire FROM Employe;

-- Q2.4
SELECT DISTINCT Prof FROM Employe;

-- Q2.5
SELECT Enom, Salaire FROM Employe WHERE Salaire < 4000;

-- Q2.6
SELECT Enom, Prof FROM Employe e
JOIN Departement d ON e.Dep = d.Dno 
WHERE d.Ville = 'Lyon';

-- Q2.7
SELECT Enom, Prof FROM Employe e
JOIN Departement d ON d.Directeur = e.Eno
WHERE d.Dnom = 'Production';

-- Q2.8
SELECT Enom, Date_Emb FROM Employe
WHERE Prof = 'Technicien';

-- Q2.9
SELECT * FROM Employe, Departement;

-- Q.2.10
SELECT e.Enom, d.Dnom FROM Employe e, Departement d
WHERE e.Dep = d.Dno;

-- Q2.11
SELECT e.Enom, d.Dnom, dir.Enom AS Directeur FROM Employe e, Departement d, Employe dir
WHERE e.Dep = d.Dno AND d.Directeur = dir.Eno;

-- Q2.12
SELECT e.Enom, e.Date_Emb, d.Dnom, dir.Enom AS Directeur, dir.Date_Emb as 'Embauche Directeur'
FROM Employe e, Departement d, Employe dir
WHERE e.Dep = d.Dno AND d.Directeur = dir.Eno AND dir.Date_Emb > e.Date_Emb;

-- Q2.13
SELECT e.Eno, e.Enom FROM Employe e, Departement d
WHERE e.Dep = d.Dno AND d.Ville = 'Lyon';

-- Q2.14
SELECT * FROM Departement
WHERE Dno NOT IN (SELECT DISTINCT Dep FROM Employe);

-- Q2.15
SELECT dir.Enom, d.Dnom, d.Ville FROM Employe dir, Departement d
WHERE dir.Eno = d.Directeur and (d.Dno = 1 OR d.Dno = 3);

-- Q2.16
INSERT INTO Employe VALUES (60, 'Jérémy', 'Ingénieur', '2013-10-26', 2400, 1000, 2);

SELECT e.Enom, d.Dnom, d.Dnom FROM Employe e, Departement d, Employe inge
WHERE e.Dep = d.Dno AND inge.Prof = 'Ingénieur' and inge.Dep = e.Eno;