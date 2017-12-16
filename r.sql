INSERT INTO SessionUQAM VALUES(3,'30/04/2017','01/01/2017');
INSERT INTO SessionUQAM VALUES(1,'01/01/2017','01/05/2017');
INSERT INTO SessionUQAM VALUES(2,'01/09/2017','30/12/2017');

UPDATE SessionUQAM SET dateFin ='02/05/2017' WHERE codeSession = '1';
UPDATE PROFESSEUR SET minCours = 3 WHERE codeProfesseur = '1';
UPDATE PROFESSEUR SET minCours = 3 WHERE codeProfesseur = '1';
UPDATE PROFESSEUR SET minCours = 2 WHERE codeProfesseur = '4';
--Professeurs
INSERT INTO Professeur VALUES('1', 'Picard', 'Jean-Luc', 4);
INSERT INTO Professeur VALUES('2', 'Riker', 'Will', 4);
INSERT INTO Professeur VALUES('3', 'LaForge', 'Geordi', 4);
INSERT INTO Professeur VALUES('4', 'Troy', 'Deanna', 4);

INSERT INTO Cours VALUES('1','Structure de Données', 3);
INSERT INTO Cours VALUES('2','Math Discrètes', 3);
INSERT INTO Cours VALUES('3','Calcul 1', 4);
INSERT INTO Cours VALUES('4','Chimie Organique', 3);
INSERT INTO Cours VALUES('5','Génétique 1', 3);
INSERT INTO Cours VALUES('6','Psychologie', 3);
INSERT INTO Cours VALUES('7','Réseaux', 3);
INSERT INTO Cours VALUES('8','Evolution Moléculaire', 3);

INSERT INTO Prealable VALUES('2','1');
INSERT INTO Prealable VALUES('8','3');
INSERT INTO Prealable VALUES('7','2');


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


INSERT INTO Inscription VALUES('1','1',1,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('2','1',1,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('3','1',1,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('4','1',1,1,'30/08/2017',null,null);

INSERT INTO Inscription VALUES('1','2',1,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('2','2',1,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('3','2',1,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('4','2',1,1,'30/08/2017',null,null);

INSERT INTO Inscription VALUES('1','3',1,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('2','3',1,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('3','3',1,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('4','3',1,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('3','5',2,1,'30/08/2017',null,null);
INSERT INTO Inscription VALUES('3','1',2,2,'30/08/2017',null,null);

UPDATE Inscription SET dateAbandon = '05/06/2017' WHERE codePermanent = '1' AND sigle = '2' AND noGroupe = 1;
UPDATE Inscription SET dateInscription = '05/06/2017' WHERE codePermanent = '1' AND sigle = '2' AND noGroupe = 1;
UPDATE Inscription SET note = 99 WHERE codePermanent = '1' AND sigle = '2' AND noGroupe = 1;
UPDATE Inscription SET note = 80 WHERE codePermanent = '2' AND sigle = '2' AND noGroupe = 1;
UPDATE Inscription SET note = 80 WHERE codePermanent = '3' AND sigle = '2' AND noGroupe = 1;
UPDATE Inscription SET note = 95 WHERE codePermanent = '1' AND sigle = '1' AND noGroupe = 1;
UPDATE Inscription SET note = 190 WHERE codePermanent = '1' AND sigle = '1' AND noGroupe = 1;
UPDATE Inscription SET note = 90 WHERE codePermanent = '1' AND sigle = '1' AND noGroupe = 1;
SELECT * FROM Inscription where codeSession = 1;
select * from SYS.USER_ERRORS where NAME = 'EtudiantsExcellence' and type = 'PROCEDURE';
--SELECT note FROM Inscription WHERE codePermanent = 1 AND codeSession = 1;
--SELECT note FROM Inscription WHERE codePermanent = 2 AND codeSession = 1;
--SELECT note FROM Inscription WHERE codePermanent = 1 AND codeSession = 1;
--EXECUTE EtudiantsExcellence(1);
--EXEC DBMS_OUTPUT.PUT_LINE(sys.diutil.bool_to_int(EXCELLENCE('1','1')));
--EXEC DBMS_OUTPUT.PUT_LINE(sys.diutil.bool_to_int(EXCELLENCE('2','1')));
EXEC DBMS_OUTPUT.PUT_LINE('sadfasdfasdf');
SELECT * FROM Etudiant;
SELECT * FROM Professeur;
SELECT * FROM Inscription;
SELECT * FROM GroupeCours;
SELECT * FROM Cours;
SELECT p.nom,p.prenom,gc.sigle,gc.codeSession,gc.noGroupe,su.dateDebut,su.dateFin FROM Professeur p, GroupeCours gc, SessionUQAM su WHERE p.codeProfesseur = '3' AND p.codeProfesseur=gc.codeProfesseur AND gc.codeSession = su.codeSession;

SELECT codeSession, dateAbandon, dateDebut, dateFin, dateInscription FROM Inscription NATURAL JOIN SessionUQAM;


--Removed
select * from SYS.USER_ERRORS where NAME = 'EXCELLENCE' and type = 'FUNCTION';
-- C.1 Ajout de la colonne minCours et ajout de la contrainte qui s'assure d'un minimum de 4 cours
--ALTER TABLE Professeur ADD minCours INTEGER NOT NULL;
--/
--ALTER TABLE Professeur ADD CONSTRAINT minCoursContrainte CHECK ( minCours >= 4 );
--COMMIT
--/
--C.2 Date de la fin de session doit être exactement 120 jours après le début de la session
--ALTER TABLE SessionUQAM ADD CONSTRAINT semester_verif CHECK (dateFin = dateDebut + 120);
