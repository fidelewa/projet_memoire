
DECLARE
	rty_user_tables PAQUET_CURSEUR.moyenne_sem2_ida2a_cur%ROWTYPE; -- variable de type enregistrement/ligne de curseur

BEGIN

	OPEN PAQUET_CURSEUR.moyenne_sem2_ida2a_cur; -- Ouverture du curseur

	-- Tant qu'il y a des lignes dans le curseur, parcourir le curseur
	loop

		-- Extraction des colonnes de la ligne/enregistrement courante du curseur dans une variable de type enregistrement
		FETCH PAQUET_CURSEUR.moyenne_sem2_ida2a_cur into rty_user_tables;
		-- On passe à l'enregistrement suivant

		-- Si la dernière extraction n'a pas renvoyée de lignes, et que le curseur n'a traité jusqu'à présent aucune ligne,
		-- cela signifie qu'aucune de ces tables n'existent en BDD et qu'ils faut les créer
		IF(PAQUET_CURSEUR.moyenne_sem2_ida2a_cur%NOTFOUND AND PAQUET_CURSEUR.moyenne_sem2_ida2a_cur%ROWCOUNT=0) THEN

			-- Voici le goulot d'étranglement à optimiser
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_ALGO_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_ANALYSE_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_ANGLAIS_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_ASSIDUTE_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_BD_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_C_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_COMPTA_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_CONDUITE_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_DROIT_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_ECONOMIE_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_FRANCAIS_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_MATH_FIN_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_MATH_GENE_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_NEGO_INFO_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_PHP_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_PROJET_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_SE_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_TELEINFO_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';
			EXECUTE IMMEDIATE 'CREATE TABLE MOYENNE_VB_SEM2_IDA2A AS SELECT * FROM MOYENNE_MATIERE';

		ELSE -- sinon si le dernier fetch a renvoyé des lignes, cela signifie que les tables des moyennes
		-- existent en BDD et qu'il faut supprimer les données qui s'y trouvent

			EXECUTE IMMEDIATE 'DELETE FROM '||rty_user_tables.table_name;
			DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' lignes supprimées dans la table '||rty_user_tables.table_name);

		END IF;

		-- On sortira de la boucle si effectivement aucune ligne n'a été extraite du curseur
		-- ou si toutes les lignes du curseur ont été parcourues
		-- ou si la première extraction FETCH n'a jamais eu lieu au niveau du curseur
		EXIT WHEN PAQUET_CURSEUR.moyenne_sem2_ida2a_cur%NOTFOUND OR PAQUET_CURSEUR.moyenne_sem2_ida2a_cur%NOTFOUND IS NULL;
	  
	end loop;

	close PAQUET_CURSEUR.moyenne_sem2_ida2a_cur; -- Fermeture du curseur

	-- Appel de la procédure cataloguée pl/sql moyenne_session
	PRC_MOYENNE_SESSION();
	-- Appel de la procédure cataloguée pl/sql points_généraux
	PRC_TOTAL_POINT();
	-- Appel de la procédure cataloguée moyenne_matiere_ida2a_sem2
	PRC_MOY_MATIERE_IDA2A_SEM2();
	-- GESTIONRELEVEIDA2A.PRC_MOY_MATIERE_IDA2A_SEM2();
    -- ROLLBACK;
	COMMIT; -- validation des changements apportés par la transaction

END;
/
