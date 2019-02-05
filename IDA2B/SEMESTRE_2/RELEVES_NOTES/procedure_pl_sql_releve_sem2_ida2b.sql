
DECLARE
    v_nCount INTEGER;
    v_sql LONG;

BEGIN

    -- Requête
	SELECT count(tname) into v_nCount 
	FROM tab 
	WHERE tname = 'MOYENNE_SEM2_IDA2B';

    -- Si la table existe
    IF(v_nCount=1) THEN

        -- Purge
        v_sql:='DELETE FROM MOYENNE_SEM2_IDA2B';
        EXECUTE IMMEDIATE v_sql;


        -- INSERTION
        EXECUTE IMMEDIATE 'INSERT INTO MOYENNE_SEM2_IDA2B
        SELECT moyenne_session.releve_id AS numero_releve, Round(Sum(moyenne_pondere)/Sum(coefficient),2) AS "Moyenne semestrielle", 
        moyenne_session.classe_nom, moyenne_session.session_nom

        FROM matiere INNER JOIN ((matiere_classe INNER JOIN moyenne_session ON matiere_classe.matiere_code = moyenne_session.matiere_code) 
        INNER JOIN classe ON matiere_classe.classe_id = classe.id) ON matiere.code = matiere_classe.matiere_code

        GROUP BY moyenne_session.releve_id, moyenne_session.classe_nom, moyenne_session.session_nom

        HAVING ((moyenne_session.classe_nom=''IDA2/B'') AND (moyenne_session.session_nom=''2eme Semestre''))';

    END IF;

    IF(v_nCount=0) THEN -- Si la table n'existe pas
        
        -- Création dynamique de la table

        v_sql := 'CREATE TABLE MOYENNE_SEM2_IDA2B(
                releve_numero NUMBER,
                moyenne_session NUMBER(4,2),
                classe_nom VARCHAR2(30) NOT NULL,
                session_nom VARCHAR2(20)
        )';
        EXECUTE IMMEDIATE v_sql;

        -- INSERTION
        EXECUTE IMMEDIATE 'INSERT INTO MOYENNE_SEM2_IDA2B
        SELECT moyenne_session.releve_id AS numero_releve, Round(Sum(moyenne_pondere)/Sum(coefficient),2) AS "Moyenne semestrielle", 
        moyenne_session.classe_nom, moyenne_session.session_nom

        FROM matiere INNER JOIN ((matiere_classe INNER JOIN moyenne_session ON matiere_classe.matiere_code = moyenne_session.matiere_code) 
        INNER JOIN classe ON matiere_classe.classe_id = classe.id) ON matiere.code = matiere_classe.matiere_code

        GROUP BY moyenne_session.releve_id, moyenne_session.classe_nom, moyenne_session.session_nom

        HAVING ((moyenne_session.classe_nom=''IDA2/B'') AND (moyenne_session.session_nom=''2eme Semestre''))';
    
    END IF;

    -- ROLLBACK;
    COMMIT; -- validation des changements apportés par la transaction
END;
/
