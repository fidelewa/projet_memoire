SELECT header_releve.releve_numero, header_releve.Année_scolaire, header_releve.session_nom, 
header_releve.etab_nom, header_releve.etab_code, header_releve.etab_adresse_postale, header_releve.etab_telephone, 
header_releve.etab_statut, header_releve.etab_adresse_mail, header_releve.etudiant, header_releve.matricule, 
header_releve.classe, header_releve.eleve_sexe, header_releve.eleve_date_naissance, header_releve.eleve_lieu_naissance, 
header_releve.eleve_nationalite, header_releve.redoublant, header_releve.eleve_regime, header_releve.eleve_interne, 
header_releve.affecte, body_releve_sem1_ida2a.discipline, body_releve_sem1_ida2a.valeur_1, body_releve_sem1_ida2a.valeur_2, 
body_releve_sem1_ida2a.valeur_3, body_releve_sem1_ida2a.valeur_4, body_releve_sem1_ida2a.valeur_5, 
body_releve_sem1_ida2a.moyenne_matiere, body_releve_sem1_ida2a.coefficient, body_releve_sem1_ida2a.moyenne_ponderee, 
body_releve_sem1_ida2a.appreciation_matiere, body_releve_sem1_ida2a.rang_matiere, body_releve_sem1_ida2a.professeur, 
rqt_rang_sem1_ida2a.rang_classe_ida2a, rqt_points_generaux_sem1.moyenne_min_classe, rqt_points_generaux_sem1.moyenne_max_classe, 
rqt_points_generaux_sem1.moyenne_gene_classe, footer_releve_sem1.*

FROM 
(
    (
        (
            SELECT Min(moyenne_session) AS moyenne_min_classe, Max(moyenne_session) AS moyenne_max_classe, 
            Round(Avg(moyenne_session),2) AS moyenne_gene_classe, classe_nom
            FROM total_point
            WHERE session_nom='1er Semestre'
            GROUP BY classe_nom
            HAVING classe_nom='IDA2/A'

        ) rqt_points_generaux_sem1 INNER JOIN 
        (
            (
                SELECT releve.id AS releve_numero, Sum(matiere_classe.coefficient) AS "Somme des coefficients", 
                Round((Sum(moyenne_pondere)),2) AS "Total des points", 
                Round(Sum(moyenne_pondere)/Sum(coefficient),2) AS "Moyenne semestrielle",
                CASE 
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<20 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>=16 THEN 'Félicitation'
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<16 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>=12 THEN 'Tableau d''honneur'
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<12 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>=8 THEN 'Encouragement'
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<8 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>=4 THEN 'Avertissement'
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<4 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>=0 THEN 'Blame'
                    ELSE ''
                END AS mention,
                CASE 
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<=20 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>18 THEN 'Excellent'
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<=18 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>16 THEN 'Très-Bien'
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<=16 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>14 THEN 'Bien'
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<=14 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>12 THEN 'Assez Bien'
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<=12 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>10 THEN 'Passable'
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<=10 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>8 THEN 'Insuffisant'
                    WHEN Round(Sum(moyenne_pondere)/Sum(coefficient),2)<=8 And Round(Sum(moyenne_pondere)/Sum(coefficient),2)>6 THEN 'Faible'
                    ELSE ''
                END AS appreciation,
                "Elèves au-dessus de 12", "Elèves entre 10 et 12", "Elèves entre 09 et 10", "Elèves en dessous de 09", 
                "Elèves non classé", "Effectif total de la classe"

                FROM releve INNER JOIN 
                (
                    (
                        (
                            SELECT effectif_total_par_classe.classe, nb_eleve_sup_12_sem1_classe."Elèves au-dessus de 12", 
                            nb_eleve_10_12_sem1_classe."Elèves entre 10 et 12", 
                            nb_eleve_09_10_sem1_classe."Elèves entre 09 et 10", 
                            nb_eleve_inf_09_sem1_classe."Elèves en dessous de 09", 
                            nb_eleve_non_classe."Elèves non classé", effectif_total_par_classe.effectif AS "Effectif total de la classe"

                            FROM 
                            (
                                SELECT classe.nom AS classe, Count(*) AS effectif
                                FROM classe INNER JOIN eleve ON classe.id = eleve.classe_id
                                GROUP BY classe.nom

                            ) effectif_total_par_classe INNER JOIN 
                            (
                                (
                                    (
                                        (
                                            (
                                                SELECT classe_nom, Count(*) AS "Elèves entre 10 et 12", session_nom
                                                FROM total_point
                                                WHERE moyenne_session>=10 And moyenne_session<=12
                                                GROUP BY classe_nom, session_nom
                                                HAVING session_nom='1er Semestre'
                                            ) nb_eleve_10_12_sem1_classe LEFT JOIN 
                                            (
                                                SELECT classe_nom, Count(*) AS "Elèves au-dessus de 12", session_nom
                                                FROM total_point
                                                WHERE moyenne_session>12
                                                GROUP BY classe_nom, session_nom
                                                HAVING session_nom='1er Semestre'
                                            ) nb_eleve_sup_12_sem1_classe ON nb_eleve_10_12_sem1_classe.classe_nom = nb_eleve_sup_12_sem1_classe.classe_nom
                                        ) LEFT JOIN 
                                        (
                                            SELECT classe_nom, Count(*) AS "Elèves entre 09 et 10", session_nom
                                            FROM total_point
                                            WHERE moyenne_session>=9 And moyenne_session<=10
                                            GROUP BY classe_nom, session_nom
                                            HAVING session_nom='1er Semestre'
                                        ) nb_eleve_09_10_sem1_classe ON nb_eleve_10_12_sem1_classe.classe_nom = nb_eleve_09_10_sem1_classe.classe_nom
                                    ) LEFT JOIN 
                                    (
                                        SELECT classe_nom, Count(*) AS "Elèves en dessous de 09", session_nom
                                        FROM total_point
                                        WHERE moyenne_session<9
                                        GROUP BY classe_nom, session_nom
                                        HAVING session_nom='1er Semestre'
                                    ) nb_eleve_inf_09_sem1_classe ON nb_eleve_10_12_sem1_classe.classe_nom = nb_eleve_inf_09_sem1_classe.classe_nom
                                ) LEFT JOIN 
                                (
                                    SELECT classe_nom, count(*) AS "Elèves non classé"
                                    FROM total_point
                                    WHERE moyenne_session IS NULL
                                    GROUP BY classe_nom
                                ) nb_eleve_non_classe ON nb_eleve_10_12_sem1_classe.classe_nom = nb_eleve_non_classe.classe_nom
                            ) ON effectif_total_par_classe.classe = nb_eleve_10_12_sem1_classe.classe_nom
                        ) repartition_eleve_moy_sem1 INNER JOIN
                        (
                            classe INNER JOIN
                            (
                                matiere_classe INNER JOIN moyenne_session ON matiere_classe.matiere_code = moyenne_session.matiere_code
                            ) ON classe.id = matiere_classe.classe_id
                        ) ON repartition_eleve_moy_sem1.classe = classe.nom
                    ) INNER JOIN eleve ON (classe.id = eleve.classe_id) AND (moyenne_session.matricule = eleve.matricule)
                ) ON releve.id = moyenne_session.releve_id
                GROUP BY releve.id, "Elèves au-dessus de 12", "Elèves entre 10 et 12", "Elèves entre 09 et 10", 
                "Elèves en dessous de 09", "Elèves non classé", "Effectif total de la classe", eleve.matricule, classe.nom 
                
            ) footer_releve_sem1 INNER JOIN 
            (
                SELECT releve_numero, session_nom, moyenne_session, classe_nom, 
                CASE WHEN RANK() OVER (ORDER BY MOYENNE_SESSION DESC)=1 
                        THEN RANK() OVER (ORDER BY MOYENNE_SESSION DESC)||' '||'er'
                        ELSE RANK() OVER (ORDER BY MOYENNE_SESSION DESC)||' '||'ème'
                    END AS rang_classe_ida2a
                FROM moyenne_sem1_ida2a
                ORDER BY moyenne_sem1_ida2a.moyenne_session DESC
            ) rqt_rang_sem1_ida2a ON footer_releve_sem1.releve_numero = rqt_rang_sem1_ida2a.releve_numero
        ) ON rqt_points_generaux_sem1.classe_nom = rqt_rang_sem1_ida2a.classe_nom
    ) INNER JOIN 
    (
        SELECT releve.id AS releve_numero, eleve.inscription_annee_scolaire AS Année_scolaire, 
        niveau.sigle || ' ' || classe.nom AS classe, eleve.nom || ' ' || eleve.prenom AS etudiant,
        CASE 
            WHEN eleve.redoublant='O' THEN 'Oui' ELSE 'Non'
        END AS redoublant,
        CASE 
            WHEN eleve.affecte='O' THEN 'Oui' ELSE 'Non'
        END AS affecte,
        CASE 
            WHEN eleve.sexe='M' THEN 'Masculin'
            WHEN eleve.sexe='F' THEN 'Feminin'
            ELSE ''
        END AS eleve_sexe,
        sess.nom AS session_nom, etablissement.nom AS etab_nom, etablissement.code AS etab_code,
        etablissement.adresse_postale AS etab_adresse_postale, etablissement.telephone AS etab_telephone,
        etablissement.statut AS etab_statut, etablissement.email AS etab_adresse_mail, 
        eleve.matricule, eleve.date_naissance AS eleve_date_naissance, 
        eleve.lieu_naissance AS eleve_lieu_naissance, eleve.nationalite AS eleve_nationalite,
        eleve.regime AS eleve_regime, 
        CASE 
            WHEN eleve.interne='O' THEN 'OUI' ELSE 'NON'
        END AS eleve_interne

        FROM etablissement, 
        sess INNER JOIN 
        (
            niveau INNER JOIN 
            (
                classe INNER JOIN 
                (
                    (
                        (
                            SELECT DISTINCT eleve.matricule AS eleve_matricule, releve.id AS releve_id
                            FROM releve INNER JOIN (eleve INNER JOIN note ON eleve.matricule = note.eleve_matricule) ON releve.id = note.releve_id

                        ) rqt_eleve_releve INNER JOIN 
                        eleve ON rqt_eleve_releve.eleve_matricule = eleve.matricule
                    ) 
                    INNER JOIN releve ON rqt_eleve_releve.releve_id = releve.id
                ) ON classe.id = eleve.classe_id
            ) 
            ON niveau.id = classe.niveau_id
        ) ON sess.id = releve.session_id
    ) header_releve ON footer_releve_sem1.releve_numero = header_releve.releve_numero
) INNER JOIN 
(
    SELECT classement_ida2a.releve_numero, libelle AS discipline, 
    note.valeur_1, note.valeur_2, note.valeur_3, note.valeur_4, note.valeur_5, 
    SOM_NOTES, NB_NOTES,
    Round((SOM_NOTES/NB_NOTES),2) AS moyenne_matiere, coefficient, 
    coefficient*Round((SOM_NOTES/NB_NOTES),2) AS moyenne_ponderee, rang_matiere,
    CASE WHEN Round((SOM_NOTES/NB_NOTES),2)<=20.00 AND Round((SOM_NOTES/NB_NOTES),2)>18.00 THEN 'Excellent'
        WHEN Round((SOM_NOTES/NB_NOTES),2)<=18.00 AND Round((SOM_NOTES/NB_NOTES),2)>=16.00 THEN 'Très Bien'
        WHEN Round((SOM_NOTES/NB_NOTES),2)<16.00 AND Round((SOM_NOTES/NB_NOTES),2)>=14.00 THEN 'Bien'
        WHEN Round((SOM_NOTES/NB_NOTES),2)<14.00 AND Round((SOM_NOTES/NB_NOTES),2)>=12.00 THEN 'Assez Bien'
        WHEN Round((SOM_NOTES/NB_NOTES),2)<12.00 AND Round((SOM_NOTES/NB_NOTES),2)>=10.00 THEN 'Passable'
        WHEN Round((SOM_NOTES/NB_NOTES),2)<10.00 AND Round((SOM_NOTES/NB_NOTES),2)>=08.00 THEN 'Insuffisant'
        WHEN Round((SOM_NOTES/NB_NOTES),2)<08.00 AND Round((SOM_NOTES/NB_NOTES),2)>=06.00 THEN 'Faible'
    END AS appreciation_matiere,
    professeur.nom ||' '|| professeur.prenom AS professeur

    FROM sess INNER JOIN 
    (releve INNER JOIN 
        (professeur INNER JOIN 
            (
                (matiere INNER JOIN 
                    (
                        ((classe INNER JOIN matiere_classe ON classe.id = matiere_classe.classe_id) INNER JOIN 
                        eleve ON classe.id = eleve.classe_id) INNER JOIN 
                        (
                            (
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_algo_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_analyse_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_anglais_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_assidute_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_bd_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_c_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_compta_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_conduite_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_droit_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_economie_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_francais_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_math_fin_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_math_gene_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_nego_info_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_php_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_projet_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_se_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_teleinfo_sem1_ida2a
                                UNION
                                SELECT 
                                    CASE WHEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)=1 
                                        THEN RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'er'
                                        ELSE RANK() OVER (ORDER BY MOYENNE_MATIERE DESC)||' '||'ème'
                                    END AS rang_matiere, matiere_code, releve_numero
                                FROM moyenne_vb_sem1_ida2a
                                
                            )
                            classement_ida2a INNER JOIN 
                            (
                                SELECT (CASE WHEN note.valeur_1 is null THEN 0 ELSE note.valeur_1 END +
                                CASE WHEN note.valeur_2 is null THEN 0 ELSE note.valeur_2 END +
                                CASE WHEN note.valeur_3 is null THEN 0 ELSE note.valeur_3 END +
                                CASE WHEN note.valeur_4 is null THEN 0 ELSE note.valeur_4 END +
                                CASE WHEN note.valeur_5 is null THEN 0 ELSE note.valeur_5 END 
                                ) AS SOM_NOTES,
                                (
                                CASE WHEN note.valeur_1 is null THEN 0 ELSE 1 END +
                                CASE WHEN note.valeur_2 is null THEN 0 ELSE 1 END +
                                CASE WHEN note.valeur_3 is null THEN 0 ELSE 1 END +
                                CASE WHEN note.valeur_4 is null THEN 0 ELSE 1 END +
                                CASE WHEN note.valeur_5 is null THEN 0 ELSE 1 END 
                                ) AS NB_NOTES, matiere_code, releve_id, eleve_matricule, valeur_1, valeur_2, valeur_3, valeur_4, valeur_5
                                FROM note
                            ) note ON (classement_ida2a.releve_numero = note.releve_id) AND (classement_ida2a.matiere_code = note.matiere_code)
                        ) ON eleve.matricule = note.eleve_matricule
                    ) ON (matiere.code = note.matiere_code) AND (matiere.code = matiere_classe.matiere_code)
                ) INNER JOIN 
                (
                    SELECT PROFESSEUR_MATIERE.matiere_code, PROFESSEUR_MATIERE.professeur_id
                    FROM professeur 
                    INNER JOIN  ((matiere INNER JOIN (classe INNER JOIN matiere_classe ON classe.id = matiere_classe.classe_id) 
                    ON matiere.code = matiere_classe.matiere_code) 
                    INNER JOIN PROFESSEUR_MATIERE ON matiere.code = PROFESSEUR_MATIERE.matiere_code) ON professeur.id = PROFESSEUR_MATIERE.professeur_id
                    MINUS 
                    SELECT PROFESSEUR_MATIERE.matiere_code, PROFESSEUR_MATIERE.professeur_id
                    FROM professeur 
                    INNER JOIN  ((matiere INNER JOIN (classe INNER JOIN matiere_classe ON classe.id = matiere_classe.classe_id) 
                    ON matiere.code = matiere_classe.matiere_code) 
                    INNER JOIN PROFESSEUR_MATIERE ON matiere.code = PROFESSEUR_MATIERE.matiere_code) ON professeur.id = PROFESSEUR_MATIERE.professeur_id
                    WHERE ((professeur.nom='VANIE') And (professeur.prenom='Henri') And (classe.nom='IDA2/B')) 
                )
                professeur_matiere ON (matiere.code = professeur_matiere.matiere_code)
            ) ON professeur.id = professeur_matiere.professeur_id
        ) ON releve.id = note.releve_id
    ) ON sess.id = releve.session_id
    WHERE (classe.nom='IDA2/A')
    ORDER BY classement_ida2a.releve_numero, matiere.code

) body_releve_sem1_ida2a ON header_releve.releve_numero = body_releve_sem1_ida2a.releve_numero

ORDER BY footer_releve_sem1."Moyenne semestrielle" DESC , header_releve.releve_numero, body_releve_sem1_ida2a.discipline;