SPOOL TP2-2.out
--INF 3180 TP2
--Partie 1
--Réalisé par Chris Kooistra
--KOOC08098307
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
COMMIT
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
--Partie C2 Procédure PL/SQL
CREATE OR REPLACE PROCEDURE TacheEnseignement
(cp GroupeCours.codeProfesseur % TYPE) AS

CURSOR c_C2 IS
SELECT p.nom,p.prenom,gc.sigle,gc.codeSession,gc.noGroupe,su.dateDebut,su.dateFin FROM Professeur p, GroupeCours gc, SessionUQAM su WHERE p.codeProfesseur = cp AND p.codeProfesseur=gc.codeProfesseur AND gc.codeSession = su.codeSession;
BEGIN
FOR line IN c_C2
	LOOP
		DBMS_OUTPUT.PUT_LINE('Code Professeur: '||cp);
		DBMS_OUTPUT.PUT_LINE('Nom: '||line.nom);
		DBMS_OUTPUT.PUT_LINE('Prenom: '||line.prenom);
		DBMS_OUTPUT.PUT_LINE('Sigle Cours: '||line.sigle);
		DBMS_OUTPUT.PUT_LINE('Code Session: '||line.codeSession);
		DBMS_OUTPUT.PUT_LINE('No Groupe: '||line.codeSession);
		DBMS_OUTPUT.PUT_LINE('Date Début Session: '||line.dateDebut);
		DBMS_OUTPUT.PUT_LINE('Date Fin Session: '||line.dateFin);
		DBMS_OUTPUT.PUT_LINE('----------------------------------------------');

	END LOOP;
END;
/

CREATE OR REPLACE FUNCTION EXCELLENCE
(cp Etudiant.codePermanent % TYPE, sesh SessionUQAM.codeSession % TYPE)
RETURN BOOLEAN AS

CURSOR c3 IS
SELECT note FROM Inscription WHERE codePermanent = cp AND codeSession = sesh; 
BEGIN
FOR line IN c3

	LOOP
		--DBMS_OUTPUT.PUT_LINE('Inscription note: '||line.note);
		IF line.note < 95 OR line.note IS NULL THEN 
			--DBMS_OUTPUT.PUT_LINE('Inside false condition');
			RETURN FALSE;
		END IF;
	END LOOP;
	RETURN TRUE;
END;
/
CREATE OR REPLACE PROCEDURE EtudiantsExcellence
(cs SessionUQAM.codeSession % TYPE) AS
--DECLARE
noOne BOOLEAN := TRUE;
CURSOR c_C2 IS
SELECT DISTINCT codePermanent FROM Inscription WHERE codeSession = cs; 

BEGIN

FOR line IN c_C2
	LOOP
		IF EXCELLENCE(line.codePermanent, cs) THEN
			DBMS_OUTPUT.PUT_LINE(line.codePermanent);
			noOne := FALSE;
		END IF;

	END LOOP;
	IF noOne = TRUE THEN
		RAISE_APPLICATION_ERROR(-20001, 'pas d’étudiants excellents pendant la session');
	END IF;
END;
/
--Execution de script TP2-2R.sql pour populer la BDD
-- SPOOL arreté pour l'execution
SPOOL OFF;
@TP2-2R.sql
SPOOL TP2-2.out append;
-----------------------------------------------------------------------------------
--C.2 Procédure PL/SQL Execution de la procédure TacheExcellence
EXECUTE TacheEnseignement(1);

SELECT * FROM Inscription;
-----------------------------------------------------------------------------------
--C.3Procédure et Fonction PL/SQL
EXECUTE EtudiantsExcellence(1);
-----------------------------------------------------------------------------------
EXECUTE EtudiantsExcellence(2);
-----------------------------------------------------------------------------------

SPOOL OFF
