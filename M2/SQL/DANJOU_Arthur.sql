--- EXERCICE 1 ---

-- Question 1.1
SELECT Titre, MIN(Prix) AS 'Prix Minimum' FROM Conference;

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
    ) AND C.DateConf = '2025-03-15'
);

--- EXERCICE 2 ---

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