--Les Sessions
INSERT INTO SessionUQAM VALUES(3,'30/04/2017','01/01/2017');
INSERT INTO SessionUQAM VALUES(1,'01/01/2017','01/05/2017');
INSERT INTO SessionUQAM VALUES(2,'01/09/2017','30/12/2017');
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

INSERT INTO GroupeCours VALUES('1',1,2,25,1); 
--Riker Structures
INSERT INTO GroupeCours VALUES('1',2,2,25,2); 
-- Laforge Discretes
INSERT INTO GroupeCours VALUES('2',1,2,25,3); 
--Troy
INSERT INTO GroupeCours VALUES('3',1,2,25,4); 
--Laforge Chimie
INSERT INTO GroupeCours VALUES('4',1,2,25,3); 
--Troy Génétique
INSERT INTO GroupeCours VALUES('5',1,2,25,4); 
--Riker Génétique
INSERT INTO GroupeCours VALUES('5',2,1,25,2); 

INSERT INTO Inscription VALUES('1','1',1,1,'30/08/2017',null,95);
INSERT INTO Inscription VALUES('2','1',1,1,'30/08/2017',null,80);
INSERT INTO Inscription VALUES('3','1',1,1,'30/08/2017',null,100);
INSERT INTO Inscription VALUES('4','1',1,1,'30/08/2017',null,97);

INSERT INTO Inscription VALUES('1','2',1,1,'30/08/2017',null,100);
INSERT INTO Inscription VALUES('2','2',1,1,'30/08/2017',null,82);
INSERT INTO Inscription VALUES('3','2',1,1,'30/08/2017',null,100);
INSERT INTO Inscription VALUES('4','2',1,1,'30/08/2017',null,96);

INSERT INTO Inscription VALUES('1','3',1,1,'30/08/2017',null,95);
INSERT INTO Inscription VALUES('2','3',1,1,'30/08/2017',null,75);
INSERT INTO Inscription VALUES('3','3',1,1,'30/08/2017',null,100);
INSERT INTO Inscription VALUES('4','3',1,1,'30/08/2017',null,62);
INSERT INTO Inscription VALUES('3','5',2,1,'30/08/2017',null,97);
INSERT INTO Inscription VALUES('3','1',2,1,'30/08/2017',null,95);

INSERT INTO Inscription VALUES('1','1',1,2,'30/08/2017',null,57);
INSERT INTO Inscription VALUES('2','1',1,2,'30/08/2017',null,80);
INSERT INTO Inscription VALUES('3','1',1,2,'30/08/2017',null,10);
INSERT INTO Inscription VALUES('4','1',1,2,'30/08/2017',null,9);

INSERT INTO Inscription VALUES('1','2',1,2,'30/08/2017',null,10);
INSERT INTO Inscription VALUES('2','2',1,2,'30/08/2017',null,82);
INSERT INTO Inscription VALUES('3','2',1,2,'30/08/2017',null,85);
INSERT INTO Inscription VALUES('4','2',1,2,'30/08/2017',null,90);
