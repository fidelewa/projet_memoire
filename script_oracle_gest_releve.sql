-- Création du tablespace
CREATE TABLESPACE TBS
DATAFILE 'D:\PROJET_MEMOIRE\GEST_RELEVE_NOTES.DBF'
SIZE 2M
AUTOEXTEND ON
NEXT 1M
MAXSIZE 3M;

-- Création du profil
CREATE PROFILE PROF1 LIMIT
SESSIONS_PER_USER UNLIMITED
CONNECT_TIME 60
IDLE_TIME 1
PRIVATE_SGA 10M
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LIFE_TIME 3
PASSWORD_LOCK_TIME 1
PASSWORD_GRACE_TIME 1
PASSWORD_REUSE_TIME 1;

------------
-- USER
------------

create table users(
  id number(10),
  user_name VARCHAR2(32) NOT NULL,
  passw VARCHAR2(32) NOT NULL,
  type_user VARCHAR2(30) NOT NULL,
  CONSTRAINT USERS_PK PRIMARY KEY (id),
  CONSTRAINT USERS_CHK_TYPE_USER CHECK (type_user IN ('professeur','educateur','directeur des études')) 
);

------------
-- SESSION
------------

-- Sequence
CREATE SEQUENCE SESSION_ID_SEQ 
        MINVALUE 1 
        MAXVALUE 10000
        INCREMENT BY 1 
        START WITH 1;

-- Structure
CREATE TABLE sess (
        id NUMBER NOT NULL,
        nom VARCHAR2(20) NOT NULL,
        date_debut DATE NOT NULL,
        date_fin DATE NOT NULL,
        CONSTRAINT SESSION_PK PRIMARY KEY (id)
);

-- Index
CREATE INDEX IND_SESSION_NOM ON SESS (NOM);
CREATE INDEX IND_SESSION_DATE_DEBUT ON SESS (DATE_DEBUT);
CREATE INDEX IND_SESSION_DATE_FIN ON SESS (DATE_FIN);

------------
-- RELEVE
------------

-- Sequence
CREATE SEQUENCE RELEVE_ID_SEQ
        MINVALUE 1 
        MAXVALUE 10000
        INCREMENT BY 1 
        START WITH 1;

-- Structure
CREATE TABLE releve (
        id NUMBER NOT NULL,
        session_id NUMBER NOT NULL,
        CONSTRAINT RELEVE_PK PRIMARY KEY (id)
);

-- Index
CREATE INDEX IND_RELEVE_SESSION ON RELEVE (SESSION_ID);

--------------
-- PROFESSEUR
--------------

-- Sequence
CREATE SEQUENCE PROFESSEUR_ID_SEQ
        MINVALUE 1 
        MAXVALUE 10000
        INCREMENT BY 1 
        START WITH 1;

-- Structure
CREATE TABLE professeur (
        id NUMBER NOT NULL,
        nom VARCHAR2(20) NOT NULL,
        prenom VARCHAR2(20) NOT NULL,
        adresse VARCHAR2(60),
        typeprof VARCHAR2(15) NOT NULL,
        CONSTRAINT PROFESSEUR_PK PRIMARY KEY (id),
        CONSTRAINT PROFESSEUR_CHK_TYPEPROF CHECK (typeprof IN ('vacataire','permanent')) 
        -- Contrainte permettant de vérifier l'intégrité et la validité des données de la colonne typeprof
);

-- Index
CREATE INDEX IND_PROFESSEUR_ADRESSE ON PROFESSEUR (ADRESSE);
CREATE INDEX IND_PROFESSEUR_NOM ON PROFESSEUR (NOM);
CREATE INDEX IND_PROFESSEUR_PRENOM ON PROFESSEUR (PRENOM);
CREATE INDEX IND_PROFESSEUR_TYPEPROF ON PROFESSEUR (TYPEPROF);

--------------
-- MATIERE
--------------

-- Structure
CREATE TABLE matiere (
        code VARCHAR2(20) NOT NULL,
        libelle VARCHAR2(50) NOT NULL,
        CONSTRAINT MATIERE_PK PRIMARY KEY (code)
);

-- index
CREATE INDEX IND_MATIERE_LIBELLE ON MATIERE (LIBELLE);

--------------
-- CYCLE
--------------

-- Séquence
CREATE SEQUENCE CYCLE_ID_SEQ
        MINVALUE 1 
        MAXVALUE 10000
        INCREMENT BY 1 
        START WITH 1;

-- Structure
CREATE TABLE cycle (
        id NUMBER NOT NULL,
        nom VARCHAR2(30) NOT NULL,
        CONSTRAINT CYCLE_PK PRIMARY KEY (id)
);

-- Index 
CREATE INDEX IND_CYCLE_NOM ON CYCLE (NOM);

--------------
-- NIVEAU
--------------

-- Séquence
CREATE SEQUENCE NIVEAU_ID_SEQ
        MINVALUE 1 
        MAXVALUE 10000
        INCREMENT BY 1 
        START WITH 1;

-- Structure
CREATE TABLE niveau (
        id NUMBER NOT NULL,
        nom VARCHAR2(80) NOT NULL,
        sigle VARCHAR2(10) NOT NULL,
        cycle_id NUMBER NOT NULL,
        CONSTRAINT NIVEAU_PK PRIMARY KEY (id)
);

-- Index
CREATE INDEX IND_NIVEAU_NOM ON NIVEAU (NOM);
CREATE INDEX IND_NIVEAU_SIGLE ON NIVEAU (SIGLE);
CREATE INDEX IND_NIVEAU_CYCLE ON NIVEAU (CYCLE_ID);

--------------
-- CLASSE
--------------

-- Séquence
CREATE SEQUENCE CLASSE_ID_SEQ
        MINVALUE 1 
        MAXVALUE 10000
        INCREMENT BY 1 
        START WITH 1;

-- Structure
CREATE TABLE classe (
        id NUMBER NOT NULL,
        nom VARCHAR2(15) NOT NULL,
        niveau_id NUMBER NOT NULL,
        CONSTRAINT CLASSE_PK PRIMARY KEY (id)
);

-- Index
CREATE INDEX IND_CLASSE_NOM ON CLASSE (NOM);
CREATE INDEX IND_CLASSE_NIVEAU ON CLASSE (NIVEAU_ID);

----------
-- ELEVE
----------

-- Structure
CREATE TABLE eleve (
        matricule VARCHAR2(15) NOT NULL,
        nom VARCHAR2(20) NOT NULL,
        prenom VARCHAR2(30) NOT NULL,
        sexe CHAR(10) NOT NULL,
        date_naissance DATE NOT NULL,
        lieu_naissance VARCHAR2(20) NOT NULL,
        nationalite VARCHAR2(25) NOT NULL,
        regime VARCHAR2(20),
        redoublant CHAR(1) NOT NULL,
        interne CHAR(1) NOT NULL,
        affecte CHAR(1) NOT NULL,
        inscription_annee_scolaire VARCHAR2(10) NOT NULL,
        classe_id NUMBER,
        CONSTRAINT ELEVE_PK PRIMARY KEY (matricule)
);

-- Index
CREATE INDEX IND_ELEVE_AFFECTE ON ELEVE (affecte);
CREATE INDEX IND_ELEVE_ANNEE_SCOLAIRE ON ELEVE (INSCRIPTION_ANNEE_SCOLAIRE);
CREATE INDEX IND_ELEVE_CLASSE ON ELEVE (CLASSE_ID);
CREATE INDEX IND_ELEVE_DATE_NAISSANCE ON ELEVE (DATE_NAISSANCE);
CREATE INDEX IND_ELEVE_LIEU_NAISSANCE ON ELEVE (LIEU_NAISSANCE);
CREATE INDEX IND_ELEVE_NATIONALITE ON ELEVE (NATIONALITE);
CREATE INDEX IND_ELEVE_NOM ON ELEVE (NOM);
CREATE INDEX IND_ELEVE_PRENOM ON ELEVE (PRENOM);
CREATE INDEX IND_ELEVE_REDOUBLANT ON ELEVE (redoublant);
CREATE INDEX IND_ELEVE_INTERNE ON ELEVE (interne);
CREATE INDEX IND_ELEVE_REGIME ON ELEVE (REGIME);
CREATE INDEX IND_ELEVE_SEXE ON ELEVE (SEXE);

----------
-- NOTE
----------

-- Séquence
CREATE SEQUENCE NOTE_ID_SEQ
        MINVALUE 1 
        MAXVALUE 10000
        INCREMENT BY 1 
        START WITH 1;

-- Struture
CREATE TABLE note (
        id NUMBER NOT NULL,
        valeur_1 NUMBER(4,2),
        valeur_2 NUMBER(4,2),
        valeur_3 NUMBER(4,2),
        valeur_4 NUMBER(4,2),
        valeur_5 NUMBER(4,2),
        eleve_matricule VARCHAR2(15) NOT NULL,
        matiere_code VARCHAR2(20) NOT NULL,
        releve_id NUMBER NOT NULL,
        CONSTRAINT NOTE_PK PRIMARY KEY (id)
);

-- Index
CREATE INDEX IND_NOTE_1 ON NOTE (VALEUR_1);
CREATE INDEX IND_NOTE_2 ON NOTE (VALEUR_2);
CREATE INDEX IND_NOTE_3 ON NOTE (VALEUR_3);
CREATE INDEX IND_NOTE_4 ON NOTE (VALEUR_4);
CREATE INDEX IND_NOTE_5 ON NOTE (VALEUR_5);
CREATE INDEX IND_NOTE_ELEVE ON NOTE (ELEVE_MATRICULE);
CREATE INDEX IND_NOTE_MATIERE ON NOTE (MATIERE_CODE);
CREATE INDEX IND_NOTE_RELEVE ON NOTE (RELEVE_ID);

------------------
-- ETABLISSEMENT
------------------

-- Structure
CREATE TABLE etablissement (
        code VARCHAR2(10) NOT NULL,
        nom VARCHAR2(100) NOT NULL,
        adresse_postale VARCHAR2(30) NOT NULL,
        telephone VARCHAR2(20) NOT NULL,
        statut VARCHAR2(15) NOT NULL,
        email VARCHAR2(30),
        CONSTRAINT ETABLISSEMENT_PK PRIMARY KEY (code)
);

------------------------
-- PROFESSEUR_MATIERE
------------------------

-- Structure
CREATE TABLE PROFESSEUR_MATIERE (
        professeur_id NUMBER NOT NULL,
        matiere_code VARCHAR2(20) NOT NULL,
        volume_horaire NUMBER,
        CONSTRAINT PROFESSEUR_MATIERE_PK PRIMARY KEY (professeur_id, matiere_code)
);

-- Index
CREATE INDEX IND_PROFESSEUR_MATIERE_HEURES ON PROFESSEUR_MATIERE (VOLUME_HORAIRE);

--------------------
-- MATIERE_CLASSE
--------------------

-- Structure
CREATE TABLE MATIERE_CLASSE (
        matiere_code VARCHAR2(20) NOT NULL,
        classe_id NUMBER,
        coefficient NUMBER,
        CONSTRAINT MATIERE_CLASSE_PK PRIMARY KEY (matiere_code, classe_id)
);

-- Index
CREATE INDEX IND_MATIERE_CLASSE_COEF ON MATIERE_CLASSE (COEFFICIENT);

---------------------
-- MOYENNE_MATIERE
---------------------
-- Structure
CREATE TABLE MOYENNE_MATIERE (
        session_nom VARCHAR2(20),
        releve_numero NUMBER,
        eleve_matricule VARCHAR2(15) NOT NULL,
        classe_nom VARCHAR2(30) NOT NULL,
        moyenne_matiere NUMBER(4,2),
        matiere_code VARCHAR2(20)
);

/*CREATE TABLE MOYENNE_SESSION (
        matricule VARCHAR2(15) NOT NULL,
        moyenne_matiere NUMBER(4,2),
        moyenne_pondere NUMBER(4,2),
        somme_notes NUMBER(4,2) NOT NULL,
        nombre_notes NUMBER(1) NOT NULL,
        releve_id NUMBER,
        matiere_code VARCHAR2(20),
        session_nom VARCHAR2(20),
        classe_nom VARCHAR2(30) NOT NULL
);*/

/*CREATE TABLE TOTAL_POINT(
        releve_id NUMBER,
        moyenne_session NUMBER(4,2),
        session_nom VARCHAR2(20),
        classe_nom VARCHAR2(30) NOT NULL
);*/

/*CREATE TABLE MOYENNE_SEM1_IDA2A(
                releve_numero NUMBER,
                moyenne_session NUMBER(4,2),
                classe_nom VARCHAR2(30) NOT NULL,
                session_nom VARCHAR2(20)
);

CREATE TABLE MOYENNE_SEM2_IDA2A(
                releve_numero NUMBER,
                moyenne_session NUMBER(4,2),
                classe_nom VARCHAR2(30) NOT NULL,
                session_nom VARCHAR2(20)
);

CREATE TABLE MOYENNE_SEM1_IDA2B(
                releve_numero NUMBER,
                moyenne_session NUMBER(4,2),
                classe_nom VARCHAR2(30) NOT NULL,
                session_nom VARCHAR2(20)
);

CREATE TABLE MOYENNE_SEM2_IDA2B(
                releve_numero NUMBER,
                moyenne_session NUMBER(4,2),
                classe_nom VARCHAR2(30) NOT NULL,
                session_nom VARCHAR2(20)
);*/

/*
Warning: Oracle 9i/10g does not support this relationship's update action (CASCADE).
*/
ALTER TABLE MATIERE_CLASSE ADD CONSTRAINT MATIERE_CLASSE_MATIERE_FK
FOREIGN KEY (matiere_code)
REFERENCES matiere (code)
ON DELETE SET NULL
NOT DEFERRABLE;

/*
Warning: Oracle 9i/10g does not support this relationship's update action (CASCADE).
*/
ALTER TABLE MATIERE_CLASSE ADD CONSTRAINT MATIERE_CLASSE_CLASSE_FK
FOREIGN KEY (classe_id)
REFERENCES classe (id)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE releve ADD CONSTRAINT PERIODE_ACADEMIQUE_RELEVE_FK
FOREIGN KEY (session_id)
REFERENCES sess (id)
NOT DEFERRABLE;

ALTER TABLE note ADD CONSTRAINT RELEVE_NOTE_FK
FOREIGN KEY (releve_id)
REFERENCES releve (id)
NOT DEFERRABLE;

ALTER TABLE PROFESSEUR_MATIERE ADD CONSTRAINT PROFESSEUR_MATIERE_PROF_FK
FOREIGN KEY (professeur_id)
REFERENCES professeur (id)
ON DELETE CASCADE
NOT DEFERRABLE;

/*
Warning: Oracle 9i/10g does not support this relationship's update action (CASCADE).
*/
ALTER TABLE PROFESSEUR_MATIERE ADD CONSTRAINT PROFESSEUR_MATIERE_MATIERE_FK
FOREIGN KEY (matiere_code)
REFERENCES matiere (code)
ON DELETE SET NULL
NOT DEFERRABLE;

/*
Warning: Oracle 9i/10g does not support this relationship's update action (CASCADE).
*/
ALTER TABLE note ADD CONSTRAINT MATIERE_NOTE_PERSO_FK
FOREIGN KEY (matiere_code)
REFERENCES matiere (code)
NOT DEFERRABLE;

ALTER TABLE niveau ADD CONSTRAINT CYCLE_NIVEAU_FK
FOREIGN KEY (cycle_id)
REFERENCES cycle (id)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE classe ADD CONSTRAINT NIVEAU_CLASSE_FK
FOREIGN KEY (niveau_id)
REFERENCES niveau (id)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE eleve ADD CONSTRAINT CLASSE_ELEVE_FK
FOREIGN KEY (classe_id)
REFERENCES classe (id)
ON DELETE SET NULL
NOT DEFERRABLE;

/*
Warning: Oracle 9i/10g does not support this relationship's update action (CASCADE).
*/
ALTER TABLE note ADD CONSTRAINT ELEVE_NOTE_PERSO_FK
FOREIGN KEY (eleve_matricule)
REFERENCES eleve (matricule)
ON DELETE CASCADE
NOT DEFERRABLE;
