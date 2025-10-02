DROP TABLE IF EXISTS Departement;
DROP TABLE IF EXISTS Employe;


-- Q2.1
-- La clé 'Dep' ne fait pas référence à une clé primaire dans la table 'Departement' car les valeurs ne sont pas uniques.

CREATE TABLE IF NOT EXISTS Employe(
    Eno      INTEGER,
    Enom     VARCHAR(20),
    Prof     VARCHAR(30),
    Date_Emb Date,
    Salaire  INTEGER,
    Prime    INTEGER,
    Dep      INTEGER,

    CONSTRAINT Employe_PK PRIMARY KEY (Eno)
);

CREATE TABLE IF NOT EXISTS Departement(
    Dno       INTEGER,
    Dnom      VARCHAR(20),
    Directeur INTEGER,
    Ville     VARCHAR(20),

    CONSTRAINT Departement_PK PRIMARY KEY (Dno),
    CONSTRAINT Departement_FK FOREIGN KEY (Directeur) REFERENCES Employe(Eno)
);

INSERT INTO Employe VALUES
(10, 'Lucas', 'Ingénieur', '2023-10-01', 3100, NULL, 3),
(20, 'Jean', 'Technicien', '2018-05-01', 2510, 1500, 2),
(30, 'Claude', 'Vendeur', '2010-03-01', 4300, 2000, 1),
(40, 'Claire', 'Ingénieur', '2010-03-01', 4500, 2400, 3),
(50, 'Léon', 'Technicien', '2015-09-01', 2100, 1000, 2);

INSERT INTO Departement VALUES
(1, 'Ventes', 30, 'Passy'),
(2, 'Production', 20, 'Lyon'),
(3, 'Développement', 40, 'Grenoble'),
(4, 'Recherche', 40, 'Antibes');

-- Q2.2
SELECT 'Q2.2';

SELECT * FROM Employe;
SELECT * FROM Departement;

-- Q2.3
SELECT 'Q2.3';

SELECT Enom, Salaire FROM Employe;

-- Q2.4
SELECT 'Q2.4';

SELECT DISTINCT Prof FROM Employe;

-- Q2.5
SELECT 'Q2.5';

SELECT Enom, Salaire FROM Employe WHERE Salaire < 4000;

-- Q2.6
SELECT 'Q2.6';

SELECT e.Enom, e.Prof FROM Employe e
JOIN Departement d ON e.Dep = d.Dno
WHERE d.Ville = 'Lyon';

-- Q2.7
SELECT 'Q2.7';

SELECT Enom, Prof FROM Employe e
JOIN Departement d ON e.Dep = d.Dno
WHERE d.Dnom = 'Production';

-- Q2.8
SELECT 'Q2.8';

SELECT Enom, Date_Emb FROM Employe
WHERE Prof = 'Technicien';

-- Q2.9
SELECT 'Q2.9';

SELECT * FROM Employe, Departement;

-- Q.2.10
SELECT 'Q2.10';

SELECT e.Enom, d.Dnom FROM Employe e JOIN Departement d ON e.Dep = d.Dno;

-- Q2.11
SELECT 'Q2.11';

SELECT e.Enom, d.Dnom, dir.Enom AS Directeur FROM Employe e
JOIN Departement d ON e.Dep = d.Dno
JOIN Employe dir ON d.Directeur = dir.Eno;

-- Q2.12
SELECT 'Q2.12';

SELECT e.Enom, e.Date_Emb, d.Dnom, dir.Enom AS Directeur, dir.Date_Emb as 'Embauche Directeur'
FROM Employe e, Departement d, Employe dir
WHERE e.Dep = d.Dno AND d.Directeur = dir.Eno AND dir.Date_Emb > e.Date_Emb;

-- Q2.13
SELECT 'Q2.13';

SELECT e.Eno, e.Enom FROM Employe e, Departement d
WHERE e.Dep = d.Dno AND d.Ville = 'Lyon';

-- Q2.14
SELECT 'Q2.14';

SELECT * FROM Departement
WHERE Dno NOT IN (SELECT DISTINCT Dep FROM Employe);

-- Q2.15
SELECT 'Q2.15';

SELECT dir.Enom, d.Dnom, d.Ville FROM Employe dir, Departement d
WHERE dir.Eno = d.Directeur and (d.Dno = 1 OR d.Dno = 3);

-- Q2.16
SELECT 'Q2.16';

INSERT INTO Employe VALUES (60, 'Jérémy', 'Ingénieur', '2013-10-26', 2400, 1000, 2);

SELECT DISTINCT e.Enom
FROM Employe e
WHERE e.Dep IN (
    SELECT Dep FROM Employe WHERE Prof = 'Ingénieur'
);

-- Q2.17
SELECT 'Q2.17';

SELECT e.Enom, e.Salaire
FROM Employe e
WHERE e.Salaire >= (
    SELECT MIN(ing.Salaire) FROM Employe ing WHERE ing.Prof = 'Ingénieur'
) AND e.Prof <> 'Ingénieur';

-- Q2.18
SELECT 'Q2.18';

INSERT INTO Employe VALUES (70, 'Edmond', 'Président', '2010-02-04', 5800, 4000, 1);

SELECT e.Enom, e.Salaire FROM Employe e
WHERE e.Salaire >= (
    SELECT MAX(ing.Salaire) FROM Employe ing WHERE ing.Prof = 'Ingénieur'
) AND e.Prof <> 'Ingénieur';

-- Q2.19
SELECT 'Q2.19';

INSERT INTO Employe VALUES (80, 'Dominique', 'Technicien', '2010-03-01', 2900, 2000, 2);

SELECT e.Enom, e.Date_Emb FROM Employe e, Departement d
WHERE e.Dep = d.Dno 
    AND d.Dnom = 'Ventes'
    AND e.Date_Emb IN (
        SELECT e2.Date_Emb FROM Employe e2, Departement d2
        WHERE e2.Dep = d2.Dno AND d2.Dnom = 'Production'
    );

-- Q2.20
SELECT 'Q2.20';

SELECT e.Enom, e.Date_Emb FROM Employe e
WHERE e.Date_Emb < ALL (
    SELECT e2.Date_Emb FROM Employe e2
    WHERE e2.Dep = 2
);

-- As an alternative to ALL, we can use a subquery with MIN. ALL is not supported in SQLite.
SELECT e.Enom, e.Date_Emb FROM Employe e
WHERE e.Date_Emb < (
    SELECT MIN(e2.Date_Emb) FROM Employe e2
    WHERE e2.Dep = 2
);

-- Q2.21
SELECT 'Q2.21';

SELECT e.Enom, e.Prof, d.Directeur FROM Employe e, Departement d
WHERE e.Dep = d.Dno AND e.Prof = (
    SELECT Prof FROM Employe WHERE Enom = 'Claire'
) AND d.Directeur = (
    SELECT dep_claire.Directeur FROM Employe c, Departement dep_claire WHERE c.Enom = 'Claire' AND c.Dep = dep_claire.Dno
);

-- Q2.22
SELECT 'Q2.22';

SELECT e.Enom FROM Employe e WHERE e.Prime IS NOT NULL;

-- Q2.23
SELECT 'Q2.23';

SELECT e.Enom, e.Prof, e.Salaire FROM Employe e
ORDER BY e.Prof ASC, e.Salaire DESC;

-- Q2.24
SELECT 'Q2.24';

SELECT AVG(e.Salaire) AS Salaire_Moyen FROM Employe e;

-- Q2.25
SELECT 'Q2.25';

SELECT Count(*) as Nb_Employes FROM Employe e, Departement d
WHERE e.Dep = d.Dno AND d.Dnom = 'Production';

-- Q2.26
SELECT 'Q2.26';

SELECT e.Enom, d.Dnom FROM Employe e, Departement d
WHERE e.Dep = d.Dno AND e.Salaire >= (
    SELECT MAX(e2.Salaire) FROM Employe e2 WHERE e2.Dep = d.Dno
)