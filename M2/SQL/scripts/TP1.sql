DROP TABLE IF EXISTS Magasin;
DROP TABLE IF EXISTS Localite;

-- Q1.1
CREATE TABLE IF NOT EXISTS Localite(
    Ville      VARCHAR(255) NOT NULL,
    Population INTEGER NOT NULL,

    CONSTRAINT Localite_PK PRIMARY KEY (Ville)
);

CREATE TABLE IF NOT EXISTS Magasin(
    Id       VARCHAR(3),
    Enseigne VARCHAR(100) NOT NULL,
    Ville    VARCHAR(255) NOT NULL,
    Chiffre  DECIMAL(10,2) NOT NULL,

    CONSTRAINT Magasin_FK FOREIGN KEY (VILLE) REFERENCES Localite(Ville),
    CONSTRAINT Magasin_PK PRIMARY KEY (Id)
);

INSERT INTO Localite (Ville, Population) VALUES
('Créteil', 92984),
('Pantin', 60597),
('Colombes', 87328);

INSERT INTO Magasin (Id, Enseigne, Ville, Chiffre) VALUES
('D10', 'Super Discount', 'Créteil', 2800000),
('I10', 'Inter Prix', 'Créteil', 1230000), 
('T01', 'Leader Trade', 'Créteil', 830000),
('M01', 'Discount Market', 'Créteil', 1010000),
('T08', 'Leader Trade', 'Pantin', 3230000),
('D20', 'Super Discount', 'Pantin', 556000),
('D22', 'Super Discount', 'Colombes', 4032000),
('T05', 'Leader Trade', 'Colombes', 2780000),
('I17', 'Inter Prix', 'Colombes', 3912000),
('M87', 'Discount Market', 'Colombes', 1471000),
('M89', 'Discount Market', 'Colombes', 845000);

SELECT * FROM Magasin;
SELECT * FROM Localite;

-- Q1.2
SELECT 'Q1.2';

SELECT Ville, COUNT(*) AS NombreMagasins 
FROM Magasin 
GROUP BY Ville 
ORDER BY Ville ASC;

-- Q1.3
SELECT 'Q1.3';

SELECT Ville, Enseigne, COUNT(*) as NombreMagasins 
FROM Magasin 
GROUP BY Ville, Enseigne
HAVING NombreMagasins >= 2;

-- Q1.4
SELECT 'Q1.4';

SELECT Enseigne, AVG(Chiffre) AS ChiffreMoyen
FROM Magasin
GROUP BY Enseigne;

-- Q1.5
SELECT 'Q1.5';

SELECT Enseigne, AVG(Chiffre) AS ChiffreMoyen
FROM Magasin m, Localite l
WHERE m.Ville = l.Ville AND l.Population >= 80000
GROUP BY Enseigne;

-- Q1.6
SELECT 'Q1.6';

SELECT Ville, SUM(Chiffre) as ChiffreAffaire
FROM Magasin
GROUP BY Ville;

-- Q1.7
SELECT 'Q1.7';

SELECT Ville, SUM(Chiffre) as ChiffreAffaire
FROM Magasin
WHERE Chiffre > 1000000
GROUP BY Ville;