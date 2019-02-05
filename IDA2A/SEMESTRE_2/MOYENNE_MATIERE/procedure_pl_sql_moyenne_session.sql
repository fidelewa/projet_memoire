
DECLARE
    v_nCount INTEGER;
    v_sql LONG;

BEGIN

    -- Requête
	SELECT count(tname) into v_nCount 
	FROM tab 
	WHERE tname = 'MOYENNE_SESSION';

    -- Si la table existe
    IF(v_nCount=1) THEN

        -- On vide la table
        v_sql:='DELETE FROM MOYENNE_SESSION';
        EXECUTE IMMEDIATE v_sql;

        -- INSERTION
        INSERT INTO MOYENNE_SESSION (matricule, moyenne_matiere, moyenne_pondere, somme_notes, nombre_notes, releve_id, matiere_code, 
        session_nom, classe_nom)
        SELECT eleves_avec_ou_sans_notes.matricule, 
        (CASE WHEN NB_NOTES=0 OR SOM_NOTES=0 THEN null ELSE Round((SOM_NOTES/NB_NOTES),2) END) AS moyenne_matiere,
        coefficient*(CASE WHEN NB_NOTES=0 OR SOM_NOTES=0 THEN null ELSE Round((SOM_NOTES/NB_NOTES),2) END) AS moyenne_pondere,
        SOM_NOTES, NB_NOTES, eleves_avec_ou_sans_notes.releve_id AS numero_releve, rqt_prof_matiere.matiere_code,
        eleves_avec_ou_sans_notes.session_nom, eleves_avec_ou_sans_notes.classe_nom

        FROM (
                -- requête ELEVES AVEC OU SANS NOTES

                SELECT rqt_note_session.releve_id, rqt_eleve_classe.matricule, rqt_note_session.session_nom, 
                rqt_eleve_classe.nom, rqt_eleve_classe.prenom, rqt_eleve_classe.sexe, 
                rqt_note_session.eleve_matricule, rqt_eleve_classe.classe_nom, rqt_note_session.matiere_code, rqt_note_session.valeur_1, 
                rqt_note_session.valeur_2, rqt_note_session.valeur_3, rqt_note_session.valeur_4, rqt_note_session.valeur_5, 
                rqt_eleve_classe.classe_id,
                (
                CASE WHEN rqt_note_session.valeur_1 is null THEN 0 ELSE rqt_note_session.valeur_1 END +
                CASE WHEN rqt_note_session.valeur_2 is null THEN 0 ELSE rqt_note_session.valeur_2 END +
                CASE WHEN rqt_note_session.valeur_3 is null THEN 0 ELSE rqt_note_session.valeur_3 END +
                CASE WHEN rqt_note_session.valeur_4 is null THEN 0 ELSE rqt_note_session.valeur_4 END +
                CASE WHEN rqt_note_session.valeur_5 is null THEN 0 ELSE rqt_note_session.valeur_5 END 
                ) AS SOM_NOTES,
                (
                CASE WHEN rqt_note_session.valeur_1 is null THEN 0 ELSE 1 END +
                CASE WHEN rqt_note_session.valeur_2 is null THEN 0 ELSE 1 END +
                CASE WHEN rqt_note_session.valeur_3 is null THEN 0 ELSE 1 END +
                CASE WHEN rqt_note_session.valeur_4 is null THEN 0 ELSE 1 END +
                CASE WHEN rqt_note_session.valeur_5 is null THEN 0 ELSE 1 END 
                ) AS NB_NOTES
                FROM (
                        SELECT CLASSE.nom AS classe_nom, eleve.matricule, ELEVE.classe_id, ELEVE.nom, ELEVE.prenom, ELEVE.sexe
                        FROM CLASSE 
                        INNER JOIN ELEVE 
                        ON CLASSE.id = ELEVE.classe_id
                    ) rqt_eleve_classe 
                LEFT JOIN 
                    (
                        SELECT SESS.nom AS session_nom, note.eleve_matricule, note.releve_id, note.matiere_code,
                        note.valeur_1, note.valeur_2, note.valeur_3, note.valeur_4, note.valeur_5
                        FROM SESS 
                        INNER JOIN (releve INNER JOIN note ON releve.id = note.releve_id) 
                        ON SESS.id = releve.session_id
                    ) rqt_note_session 
                ON rqt_eleve_classe.matricule = rqt_note_session.eleve_matricule

        ) eleves_avec_ou_sans_notes
        LEFT JOIN
        (
            -- requête PROFESSEUR_MATIERE

            SELECT matiere.code AS matiere_code, matiere.libelle AS matiere_libelle, matiere_classe.coefficient, 
            professeur.nom, professeur.prenom, classe.id AS classe_id, classe.nom AS classe_nom
            FROM professeur 
            INNER JOIN  ((matiere INNER JOIN (classe INNER JOIN matiere_classe ON classe.id = matiere_classe.classe_id) 
            ON matiere.code = matiere_classe.matiere_code) 
            INNER JOIN PROFESSEUR_MATIERE ON matiere.code = PROFESSEUR_MATIERE.matiere_code) ON professeur.id = PROFESSEUR_MATIERE.professeur_id
            MINUS 
            SELECT matiere.code AS matiere_code, matiere.libelle, matiere_classe.coefficient, 
            professeur.nom, professeur.prenom, classe.id AS classe_id, classe.nom AS classe
            FROM professeur 
            INNER JOIN  ((matiere INNER JOIN (classe INNER JOIN matiere_classe ON classe.id = matiere_classe.classe_id) 
            ON matiere.code = matiere_classe.matiere_code) 
            INNER JOIN PROFESSEUR_MATIERE ON matiere.code = PROFESSEUR_MATIERE.matiere_code) ON professeur.id = PROFESSEUR_MATIERE.professeur_id
            WHERE ((professeur.nom='VANIE') And (professeur.prenom='Henri') And (classe.nom='IDA2/B')) 
            OR ((professeur.nom='ADOPO') And (professeur.prenom='Frederique') And (classe.nom='IDA2/A'))
        ) rqt_prof_matiere
        ON (eleves_avec_ou_sans_notes.matiere_code = rqt_prof_matiere.matiere_code) 
        AND (eleves_avec_ou_sans_notes.classe_id = rqt_prof_matiere.classe_id)
        ORDER BY eleves_avec_ou_sans_notes.releve_id, eleves_avec_ou_sans_notes.session_nom, 
        rqt_prof_matiere.matiere_code, eleves_avec_ou_sans_notes.classe_nom;

    END IF;
    
    IF(v_nCount=0) THEN -- Si la table n'existe pas
        
        -- Création dynamique de la table

        v_sql := 'CREATE TABLE moyenne_session (
            matricule VARCHAR2(15) NOT NULL,
            moyenne_matiere NUMBER(4,2),
            moyenne_pondere NUMBER(4,2),
            somme_notes NUMBER(4,2) NOT NULL,
            nombre_notes NUMBER(1) NOT NULL,
            releve_id NUMBER,
            matiere_code VARCHAR2(20),
            session_nom VARCHAR2(20),
            classe_nom VARCHAR2(30) NOT NULL
        )';
        EXECUTE IMMEDIATE v_sql;

        -- INSERTION
        INSERT INTO MOYENNE_SESSION (matricule, moyenne_matiere, moyenne_pondere, somme_notes, nombre_notes, releve_id, matiere_code, 
        session_nom, classe_nom)
        SELECT eleves_avec_ou_sans_notes.matricule, 
        (CASE WHEN NB_NOTES=0 OR SOM_NOTES=0 THEN null ELSE Round((SOM_NOTES/NB_NOTES),2) END) AS moyenne_matiere,
        coefficient*(CASE WHEN NB_NOTES=0 OR SOM_NOTES=0 THEN null ELSE Round((SOM_NOTES/NB_NOTES),2) END) AS moyenne_pondere,
        SOM_NOTES, NB_NOTES, eleves_avec_ou_sans_notes.releve_id AS numero_releve, rqt_prof_matiere.matiere_code,
        eleves_avec_ou_sans_notes.session_nom, eleves_avec_ou_sans_notes.classe_nom

        FROM (
                -- requête ELEVES AVEC OU SANS NOTES

                SELECT rqt_note_session.releve_id, rqt_eleve_classe.matricule, rqt_note_session.session_nom, 
                rqt_eleve_classe.nom, rqt_eleve_classe.prenom, rqt_eleve_classe.sexe, 
                rqt_note_session.eleve_matricule, rqt_eleve_classe.classe_nom, rqt_note_session.matiere_code, rqt_note_session.valeur_1, 
                rqt_note_session.valeur_2, rqt_note_session.valeur_3, rqt_note_session.valeur_4, rqt_note_session.valeur_5, 
                rqt_eleve_classe.classe_id,
                (
            CASE WHEN rqt_note_session.valeur_1 is null THEN 0 ELSE rqt_note_session.valeur_1 END +
            CASE WHEN rqt_note_session.valeur_2 is null THEN 0 ELSE rqt_note_session.valeur_2 END +
            CASE WHEN rqt_note_session.valeur_3 is null THEN 0 ELSE rqt_note_session.valeur_3 END +
            CASE WHEN rqt_note_session.valeur_4 is null THEN 0 ELSE rqt_note_session.valeur_4 END +
            CASE WHEN rqt_note_session.valeur_5 is null THEN 0 ELSE rqt_note_session.valeur_5 END 
        ) AS SOM_NOTES,
        (
            CASE WHEN rqt_note_session.valeur_1 is null THEN 0 ELSE 1 END +
            CASE WHEN rqt_note_session.valeur_2 is null THEN 0 ELSE 1 END +
            CASE WHEN rqt_note_session.valeur_3 is null THEN 0 ELSE 1 END +
            CASE WHEN rqt_note_session.valeur_4 is null THEN 0 ELSE 1 END +
            CASE WHEN rqt_note_session.valeur_5 is null THEN 0 ELSE 1 END 
        ) AS NB_NOTES
                FROM (
                        SELECT CLASSE.nom AS classe_nom, eleve.matricule, ELEVE.classe_id, ELEVE.nom, ELEVE.prenom, ELEVE.sexe
                        FROM CLASSE 
                        INNER JOIN ELEVE 
                        ON CLASSE.id = ELEVE.classe_id
                    ) rqt_eleve_classe 
                LEFT JOIN 
                    (
                        SELECT SESS.nom AS session_nom, note.eleve_matricule, note.releve_id, note.matiere_code,
                        note.valeur_1, note.valeur_2, note.valeur_3, note.valeur_4, note.valeur_5
                        FROM SESS 
                        INNER JOIN (releve INNER JOIN note ON releve.id = note.releve_id) 
                        ON SESS.id = releve.session_id
                    ) rqt_note_session 
                ON rqt_eleve_classe.matricule = rqt_note_session.eleve_matricule

        ) eleves_avec_ou_sans_notes
        LEFT JOIN
        (
            -- requête PROFESSEUR_MATIERE

            SELECT matiere.code AS matiere_code, matiere.libelle AS matiere_libelle, matiere_classe.coefficient, 
            professeur.nom, professeur.prenom, classe.id AS classe_id, classe.nom AS classe_nom
            FROM professeur 
            INNER JOIN  ((matiere INNER JOIN (classe INNER JOIN matiere_classe ON classe.id = matiere_classe.classe_id) 
            ON matiere.code = matiere_classe.matiere_code) 
            INNER JOIN PROFESSEUR_MATIERE ON matiere.code = PROFESSEUR_MATIERE.matiere_code) ON professeur.id = PROFESSEUR_MATIERE.professeur_id
            MINUS 
            SELECT matiere.code AS matiere_code, matiere.libelle, matiere_classe.coefficient, 
            professeur.nom, professeur.prenom, classe.id AS classe_id, classe.nom AS classe
            FROM professeur 
            INNER JOIN  ((matiere INNER JOIN (classe INNER JOIN matiere_classe ON classe.id = matiere_classe.classe_id) 
            ON matiere.code = matiere_classe.matiere_code) 
            INNER JOIN PROFESSEUR_MATIERE ON matiere.code = PROFESSEUR_MATIERE.matiere_code) ON professeur.id = PROFESSEUR_MATIERE.professeur_id
            WHERE ((professeur.nom='VANIE') And (professeur.prenom='Henri') And (classe.nom='IDA2/B')) 
            OR ((professeur.nom='ADOPO') And (professeur.prenom='Frederique') And (classe.nom='IDA2/A'))
        ) rqt_prof_matiere
        ON (eleves_avec_ou_sans_notes.matiere_code = rqt_prof_matiere.matiere_code) 
        AND (eleves_avec_ou_sans_notes.classe_id = rqt_prof_matiere.classe_id)
        ORDER BY eleves_avec_ou_sans_notes.releve_id, eleves_avec_ou_sans_notes.session_nom, 
        rqt_prof_matiere.matiere_code, eleves_avec_ou_sans_notes.classe_nom;

    END IF;

    -- ROLLBACK;
    COMMIT; -- validation des changements apportés par la transaction

END;
/
