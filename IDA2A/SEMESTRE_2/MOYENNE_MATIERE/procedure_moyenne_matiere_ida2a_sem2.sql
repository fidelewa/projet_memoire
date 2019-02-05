-- Moyennes matières IDA2A 2eme Semestre

DECLARE

    rty_user_tables PAQUET_CURSEUR.moyenne_sem2_ida2a_cur%ROWTYPE; -- variable de type enregistrement/ligne de curseur
BEGIN

OPEN PAQUET_CURSEUR.moyenne_sem2_ida2a_cur; -- Ouverture du curseur

    -- Extraction/chargement de la ou des colonnes de la ligne/enregistrement courante dans une ou plusieurs variables
	FETCH PAQUET_CURSEUR.moyenne_sem2_ida2a_cur into rty_user_tables;

	-- Tant qu'il y a des lignes dans le curseur, parcourir le curseur
	while (PAQUET_CURSEUR.moyenne_sem2_ida2a_cur%FOUND) loop

        -- ALGORITHME

        IF (rty_user_tables.table_name='MOYENNE_ALGO_SEM2_IDA2A') THEN
            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''ALGO'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P1;
        ELSIF (rty_user_tables.table_name='MOYENNE_ANALYSE_SEM2_IDA2A') THEN

        -- ANALYSE

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''ANA'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P2;
        ELSIF (rty_user_tables.table_name='MOYENNE_ANGLAIS_SEM2_IDA2A') THEN

        -- ANGLAIS

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''ANGLAIS'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P3;
        ELSIF (rty_user_tables.table_name='MOYENNE_ASSIDUTE_SEM2_IDA2A') THEN

        -- ASSIDUTE

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''ASSIDUTE'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P4;
        ELSIF (rty_user_tables.table_name='MOYENNE_BD_SEM2_IDA2A') THEN

        -- BASE DE DONNEES

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''BD'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P5;
        ELSIF (rty_user_tables.table_name='MOYENNE_C_SEM2_IDA2A') THEN

        -- LANGAGE C

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''C'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P6;
        ELSIF (rty_user_tables.table_name='MOYENNE_COMPTA_SEM2_IDA2A') THEN

        -- COMPTABILITE

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''COMPTA'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P7;

        ELSIF (rty_user_tables.table_name='MOYENNE_CONDUITE_SEM2_IDA2A') THEN

        -- CONDUITE

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''CONDUITE'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P8;

        ELSIF (rty_user_tables.table_name='MOYENNE_DROIT_SEM2_IDA2A') THEN

        -- DROIT

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''DROIT'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P9;

        ELSIF (rty_user_tables.table_name='MOYENNE_ECONOMIE_SEM2_IDA2A') THEN

        -- ECONOMIE

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''ECO'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P10;

        ELSIF (rty_user_tables.table_name='MOYENNE_FRANCAIS_SEM2_IDA2A') THEN

        -- FRANCAIS

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''FR'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P11;

        ELSIF (rty_user_tables.table_name='MOYENNE_MATH_FIN_SEM2_IDA2A') THEN

        -- MATHEMATIQUE FINANCIERE

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''MATH FIN'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P12;

        ELSIF (rty_user_tables.table_name='MOYENNE_MATH_GENE_SEM2_IDA2A') THEN

        -- MATHEMATIQUE GENERALE

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''MATH GENE'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P13;

        ELSIF (rty_user_tables.table_name='MOYENNE_NEGO_INFO_SEM2_IDA2A') THEN

        -- NEGOCIATION INFORMATIQUE

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''NEGO INFO'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P14;

        ELSIF (rty_user_tables.table_name='MOYENNE_PHP_SEM2_IDA2A') THEN

        -- LANGAGE PHP

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''PHP'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P15;

        ELSIF (rty_user_tables.table_name='MOYENNE_PROJET_SEM2_IDA2A') THEN

        -- PROJET

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''PROJET'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P16;

        ELSIF (rty_user_tables.table_name='MOYENNE_SE_SEM2_IDA2A') THEN

        -- SYSTEME D'EXPLOITATION

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''SE'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P17;

        ELSIF (rty_user_tables.table_name='MOYENNE_TELEINFO_SEM2_IDA2A') THEN

        -- TELEINFORMATIQUE

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''TELEINFO'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P18;

        ELSIF (rty_user_tables.table_name='MOYENNE_VB_SEM2_IDA2A') THEN

        -- VISUAL BASIC

            EXECUTE IMMEDIATE 'INSERT INTO '||rty_user_tables.table_name||'
            SELECT session_nom, releve_id, matricule, classe_nom, moyenne_matiere, matiere_code
            FROM MOYENNE_SESSION
            WHERE (classe_nom=''IDA2/A'') AND (matiere_code=''VB'') AND (session_nom=''2eme Semestre'')
        ';
        SAVEPOINT P19;

        ELSE
            DBMS_OUTPUT.PUT_LINE('La table d''insertion '||rty_user_tables.table_name||'n''exite pas.');
        END IF;
        
        -- On passe à l'enregistrement suivant
        FETCH PAQUET_CURSEUR.moyenne_sem2_ida2a_cur into rty_user_tables;

    end loop;

CLOSE PAQUET_CURSEUR.moyenne_sem2_ida2a_cur; -- Fermeture du curseur

-- ROLLBACK;
COMMIT; -- validation des changements apportés par la transaction
END;
/
