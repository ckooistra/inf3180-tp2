PROMPT Creation des tables

SET ECHO ON
DROP TABLE Inscription
/
DROP TABLE GroupeCours
/
DROP TABLE Prealable
/
DROP TABLE Cours
/
DROP TABLE SessionUQAM
/
DROP TABLE Etudiant
/
DROP TABLE Professeur
/

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY'
/

CREATE TABLE Cours
(sigle 		CHAR(7) 	NOT NULL,
 titre 		VARCHAR(50) 	NOT NULL,
 nbCredits 	INTEGER 	NOT NULL,
 CONSTRAINT ClePrimaireCours PRIMARY KEY 	(sigle)
)
/

CREATE TABLE Prealable
(sigle 		CHAR(7) 	NOT NULL,
 siglePrealable CHAR(7) 	NOT NULL,
 CONSTRAINT ClePrimairePrealable PRIMARY KEY 	(sigle,siglePrealable),
 CONSTRAINT CEsigleRefCours FOREIGN KEY 	(sigle) REFERENCES Cours,
 CONSTRAINT CEsiglePrealableRefCours FOREIGN KEY 	(siglePrealable) REFERENCES Cours(sigle)
)
/

CREATE TABLE SessionUQAM
(codeSession 	INTEGER		NOT NULL,
 dateDebut 	DATE		NOT NULL,
 dateFin 	DATE		NOT NULL,
 CONSTRAINT ClePrimaireSessionUQAM PRIMARY KEY 	(codeSession)
 --C.2 Date de la fin de session doit être exactement 120 jours après le début de la session
 --CONSTRAINT semester_verif CHECK (dateFin = dateDebut + 120)
)
/

CREATE TABLE Professeur
(codeProfesseur		CHAR(5)	NOT NULL,
 nom			VARCHAR(10)	NOT NULL,
 prenom		VARCHAR(10)	NOT NULL,
 -- C.1 Ajout de la colonne minCours et ajout de la contrainte qui s'assure d'un minimum de 4 cours
 minCours INTEGER NOT NULL,
 CONSTRAINT ClePrimaireProfesseur PRIMARY KEY 	(codeProfesseur),
 CONSTRAINT minCoursContrainte CHECK ( minCours >= 4 )
)
/

CREATE TABLE GroupeCours
(sigle 		CHAR(7) 	NOT NULL,
 noGroupe	INTEGER		NOT NULL,
 codeSession	INTEGER		NOT NULL,
 maxInscriptions	INTEGER		NOT NULL,
 codeProfesseur		CHAR(5)	NOT NULL,
CONSTRAINT ClePrimaireGroupeCours PRIMARY KEY 	(sigle,noGroupe,codeSession),
CONSTRAINT CESigleGroupeRefCours FOREIGN KEY 	(sigle) REFERENCES Cours,
CONSTRAINT CECodeSessionRefSessionUQAM FOREIGN KEY 	(codeSession) REFERENCES SessionUQAM,
CONSTRAINT CEcodeProfRefProfesseur FOREIGN KEY(codeProfesseur) REFERENCES Professeur 
)
/

CREATE TABLE Etudiant
(codePermanent 	CHAR(12) 	NOT NULL,
 nom		VARCHAR(10)	NOT NULL,
 prenom		VARCHAR(10)	NOT NULL,
 codeProgramme	INTEGER,
CONSTRAINT ClePrimaireEtudiant PRIMARY KEY 	(codePermanent)
)
/

CREATE TABLE Inscription
(codePermanent 	CHAR(12) 	NOT NULL,
 sigle 		CHAR(7) 	NOT NULL,
 noGroupe	INTEGER		NOT NULL,
 codeSession	INTEGER		NOT NULL,
 dateInscription DATE		NOT NULL,
 dateAbandon	DATE,
 note		INTEGER,
CONSTRAINT ClePrimaireInscription PRIMARY KEY 	(codePermanent,sigle,noGroupe,codeSession),
CONSTRAINT CERefGroupeCours FOREIGN KEY 	(sigle,noGroupe,codeSession) REFERENCES GroupeCours,
CONSTRAINT CECodePermamentRefEtudiant FOREIGN KEY (codePermanent) REFERENCES Etudiant
)
/
--C2
CREATE TRIGGER c2


BEFORE INSERT OR UPDATE ON SessionUQAM

FOR EACH ROW
--WHEN (:NEW.dateFin < :NEW.dateDebut)
BEGIN
	IF :NEW.dateFin != :NEW.dateDebut + 120 THEN
		--RAISE_APPLICATION_ERROR(-20001, 'You cannot do that');
		DBMS_OUTPUT.PUT_LINE('Days in semester is not equal to 120!');
	END IF;
END;
/
--C3
CREATE TRIGGER c3
BEFORE INSERT OR UPDATE OF dateAbandon ON Inscription

REFERENCING
	OLD as lb
	NEW AS la
FOR EACH ROW

DECLARE
	la_date_deb	DATE;
	la_date_fin	DATE;
BEGIN

	SELECT dateDebut, dateFin INTO la_date_deb, la_date_fin FROM SessionUQAM WHERE codeSession = :la.codeSession;
	IF :la.dateAbandon <  la_date_deb OR :la.dateAbandon > la_date_fin THEN
		RAISE_APPLICATION_ERROR(-20001, 'Date abandon doit tomber entre les dates de la session');
		--DBMS_OUTPUT.PUT('This is the message');
	END IF;
END;
/
COMMIT
/
--C4
CREATE TRIGGER c4

BEFORE INSERT OR UPDATE OF dateInscription ON Inscription
REFERENCING
	NEW AS la
FOR EACH ROW
DECLARE
	la_date_deb	DATE;
	la_date_fin	DATE;

BEGIN
	SELECT dateDebut, dateFin INTO la_date_deb, la_date_fin FROM SessionUQAM WHERE codeSession = :la.codeSession;
	IF :la.dateInscription > la_date_deb THEN
		DBMS_OUTPUT.PUT_LINE('Date doit être inférieure à la date de début'); 
		DBMS_OUTPUT.PUT_LINE(la_date_deb); 
		RAISE_APPLICATION_ERROR(-20001, 'illegal date');
		
	END IF;
END;
/
--C5
CREATE TRIGGER c5
BEFORE UPDATE OF codePermanent,sigle,noGroupe,codeSession,dateInscription,dateAbandon ON Inscription

BEGIN
	RAISE_APPLICATION_ERROR(-20001, 'You cannot do that');
END;
/
--C6
CREATE TRIGGER c6
BEFORE UPDATE OF note ON Inscription
REFERENCING
	NEW AS lap
	OLD AS lav
FOR EACH ROW
BEGIN
	IF :lav.note IS NULL THEN
		DBMS_OUTPUT.PUT_LINE('Absence lors de l’épreuve'); 

	ELSIF :lap.note > :lav.note*1.3 THEN
		DBMS_OUTPUT.PUT_LINE('Valeur changé pour être <= 1.3*valeur de mise à jour'); 
		:lap.note := :lav.note*1.3;
	END IF;	
END;
/
COMMIT
/

INSERT INTO SessionUQAM VALUES(1,'01/01/2017','01/05/2017');
INSERT INTO SessionUQAM VALUES(2,'01/09/2017','30/12/2017');

--Professeurs
INSERT INTO Professeur VALUES('1', 'Picard', 'Jean-Luc', 4);
INSERT INTO Professeur VALUES('2', 'Riker', 'Will', 4);
INSERT INTO Professeur VALUES('3', 'LaForge', 'Geordi', 4);
INSERT INTO Professeur VALUES('4', 'Troy', 'Deanna', 4);

--Cours
INSERT INTO Cours VALUES('1','Structure de Données', 3);
INSERT INTO Cours VALUES('2','Math Discrètes', 3);
INSERT INTO Cours VALUES('3','Calcul 1', 4);
INSERT INTO Cours VALUES('4','Chimie Organique', 3);
INSERT INTO Cours VALUES('5','Génétique 1', 3);
INSERT INTO Cours VALUES('6','Psychologie', 3);
INSERT INTO Cours VALUES('7','Réseaux', 3);
INSERT INTO Cours VALUES('8','Evolution Moléculaire', 3);
--Prealable
INSERT INTO Prealable VALUES('2','1');
INSERT INTO Prealable VALUES('8','3');
INSERT INTO Prealable VALUES('7','2');

--Etudiants
INSERT INTO Etudiant VALUES('1','Olivier','Andrew', 1);
INSERT INTO Etudiant VALUES('2','Turcotte','Caroline', 1);
INSERT INTO Etudiant VALUES('3','Murphy','Frank', 2);
INSERT INTO Etudiant VALUES('4','Murphy','Robin', 3);

--Courses in first session
--JLP Structures
INSERT INTO GroupeCours VALUES('1',1,1,25,1); 
--Riker Structures
INSERT INTO GroupeCours VALUES('1',2,1,25,2); 
-- Laforge Discretes
INSERT INTO GroupeCours VALUES('2',1,1,25,3); 
--Troy
INSERT INTO GroupeCours VALUES('3',1,1,25,4); 
--Laforge Chimie
INSERT INTO GroupeCours VALUES('4',1,1,25,3); 
--Troy Génétique
INSERT INTO GroupeCours VALUES('5',1,1,25,4); 
--Riker Génétique
INSERT INTO GroupeCours VALUES('5',2,1,25,2); 

--Inscriptions
INSERT INTO Inscription VALUES('1','1',1,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('2','1',1,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('3','1',1,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('4','1',1,1,'12/12/2016',null,null);

INSERT INTO Inscription VALUES('1','2',1,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('2','2',1,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('3','2',1,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('4','2',1,1,'12/12/2016',null,null);

INSERT INTO Inscription VALUES('1','3',1,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('2','3',1,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('3','3',1,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('4','3',1,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('3','5',2,1,'12/12/2016',null,null);
INSERT INTO Inscription VALUES('3','1',2,2,'12/12/2016',null,null);
/
PROMPT Contenu des tables
SELECT * FROM Cours
/
SELECT * FROM Prealable
/
SELECT * FROM SessionUQAM
/
SELECT * FROM Professeur
/
SELECT * FROM GroupeCours
/
SELECT * FROM Etudiant
/
SELECT * FROM Inscription
/
ALTER TRIGGER c5 DISABLE;
--Démonstration de la contrainte 1
INSERT INTO Professeur VALUES('5', 'Janeway', 'Kathryn', 1);

UPDATE Professeur SET minCours = 2 WHERE codeProfesseur = '1';

--Démonstration de la Contrainte 2
INSERT INTO SessionUQAM VALUES(3,'30/04/2017','01/01/2017');

--Démonstration de la Contrainte 3
SELECT sigle,noGroupe, codePermanent, codeSession, dateDebut, dateFin, dateAbandon FROM Inscription NATURAL JOIN SessionUQAM;

--On utilise une valeur trop grande
UPDATE Inscription SET dateAbandon = '05/06/2017' WHERE codePermanent = '1' AND sigle = '2' AND noGroupe = 1 AND codeSession = 1;

--On utilise une valeur trop petite
UPDATE Inscription SET dateAbandon = '11/12/2016' WHERE codePermanent = '1' AND sigle = '2' AND noGroupe = 1 AND codeSession = 1;

--On Démontre une valeur qui est bonne
UPDATE Inscription SET dateAbandon = '05/04/2017' WHERE codePermanent = '1' AND sigle = '2' AND noGroupe = 1 AND codeSession = 1;


--Démonstration de la Contrainte 4

UPDATE Inscription SET dateInscription = '02/05/2017' WHERE codePermanent = '4' AND sigle ='3' AND noGroupe = 1 AND codeSession = 1;


--Démonstration de la Contrainte 5
ALTER TRIGGER c5 ENABLE;
UPDATE Inscription SET sigle = '3' WHERE codePermanent = '4' AND sigle ='3' AND noGroupe = 1 AND codeSession = 1;

ALTER TRIGGER c5 DISABLE;

--Démonstration de la Contrainte 5
--Inserer valeurs initiales dans le bdd
UPDATE Inscription SET note = 99 WHERE codePermanent = '1' AND sigle = '2' AND noGroupe = 1;
UPDATE Inscription SET note = 80 WHERE codePermanent = '2' AND sigle = '2' AND noGroupe = 1;
UPDATE Inscription SET note = 80 WHERE codePermanent = '3' AND sigle = '2' AND noGroupe = 1;
UPDATE Inscription SET note = 95 WHERE codePermanent = '1' AND sigle = '1' AND noGroupe = 1;

SELECT * FROM Inscription;
UPDATE Inscription SET note = 140 WHERE codePermanent = '1' AND sigle = '2' AND noGroupe = 1;
SELECT * FROM Inscription;
