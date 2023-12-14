
;FONCTIONS DE SERVICE
(defun getCriteresPourAppliquerRegle (regle)
    (second regle)
)

(defun getCriteresPourAppliquerMaRegle (regle)
    (third regle)
)

(defun getActionsSuiteARegle (regle)
    (fourth regle)
)

;Syteme expert Clash Royale
;Idéal pour gagner des championnats.
;Il suffit de voir contre qui on joue, voir quel est le deck qu'il utilise en général et déterminer le meilleur deck pour le contrer
;C'est donc un chainage arrière

;Il y a énormément de cartes, nous allons donc nous limiter au cartes de l'arène 1 : 
; Archere, Fleches, Chevalier, Gargouille, BouleFeu, MiniPK, Mousquetaire, Geant, Gobelin, GobelinFleche, HutteGobelin

;Au vu du faible nombre de cartes en jeu, nous allons réduire les decks de 8 à 4 cartes

;On ne mets pas les accents pour éviter tout problème avec l'interpréteur Lisp d'Allegro et pour ne jamais confondre

;Je sais que normalement on est sensé déclarer les fonctions avec ma-fonction au lieu de maFonction mais l'autocomplétion de vs code ne fonctionne pas avec "-"

;BASE D'EXEMPLES
(setq *enquetes* '())
(setq Ex1 '(Ex1 "exemple_moteur_arrière" (Archère Chevalier MiniPK Géant)))
(push 'Ex1 *enquetes*)

;VARIABLES GLOBALES

;LISTE DE RÈGLES
;((ce qu'il a )(ce que j'ai deja)=>(Ce que je dois prendre))
;Dans ce que je dois prendre, si il y a plusieurs trucs qu'on peut prendre ca fait ((Card1) OU (Card2) OU (Card3 AND Card4))
;Le premier choix (ici Card1) est pris sauf si une règle l'empeche auquel cas on prendra la suite (Card2) et ainsi de suite

(setq *regles* '(
        (R1 ((Chevalier) (Geant))()((MiniPK) (Mousquetaire) (HutteGobelin)))
        (R2 ((Chevalier))()((Mousquetaire)))
        (R3 ((Geant))()((MiniPK)))
        (R4 ((Gargouille))()((Archere) (Mousquetaire)))
        (R5 ((Archere)(Chevalier))()((MiniPK Fleches)(Mousquetaire Fleche)))
    )
)

(defun creerDeck()
    (dolist (r *regles*)
        (write (getCeQueJeDoitAvoirPourAppliquerLaRegle r))
    )
)

(creerDeck)

#|














;MOTEUR AVANT
(defun ajouter_conclu (base_conflits)
; pour chaque regle en conflit, on ajouter tous les buts qui ne sont pas déja dans la base de faits à la base de faits
; SOUS ENTEND QUE LES CONCLUSIONS NE SONT QUE DES "ET"
	(dolist (regle base_conflits)
		(push regle *regles_deja_appliquees*)
		(dolist (x (buts_regle regle))
			(pushnew x *base_faits*)
		)
	)
)

(defun obtenir_conflits ()
;pour chaque regle, si une règle est applicable alors elle appartient à la liste des conflits
	(let (liste_conflits)
		(dolist (r *regles*)
			(if (AND (not (member r *regles_deja_appliquees* :test #'equal)) (regle_applicable r)) (push r liste_conflits))	
		)
	liste_conflits
	)
)

(defun regle_applicable (regle)
;si une premisse n'est pas dans la base de fait alors la règle n'est pas applicable
	(let ((ok T))
		(dolist (p (premisses_regle regle))
			(if (not (member p *base_faits* :test #'equal)) (setq ok NIL))
		)
	ok
	)	
)

(defun suspects_trouves ()
	(let (suspects)
		(dolist (f *base_faits*)
			(if (eq (car f) 'suspect) (push (cadr f) suspects))			
		)
		suspects
	)
)

(defun moteur_avant ()
	(let ((copie_bf *base_faits*))
		(if (not (null (obtenir_conflits)))
			(let ()
				(ajouter_conclu (obtenir_conflits))
				(moteur_avant)
			)
			(let ()
				(write-line "IL N'Y A PLUS DE CONFLITS - TERMINÉ")
				(if		(> (length (suspects_trouves)) 0) 
						(let ()
							(write-line "Suspect(s) trouvé(s) : ")
							(dolist (s (suspects_trouves))
								(write-line (symbol-name s))
							)
						)
						(write-line "Désolé, aucun suspect potentiel ne ressort.")
				)
				(write-line "==APPUYEZ SUR UNE TOUCHE POUR CONTINUER==")
				(read-line)
			)
		)
		;restauration de la base de fait initiale afin de ne pas interferer avec un test du second moteur
		(setq *base_faits* copie_bf)
	)
)

; MOTEUR D'INFÉRENCES EN CHAINAGE ARRIÈRE EN PROFONDEUR D'ABORD
(defun regles_ayant_pour_but (but)
    (let (regles '())
	    (dolist (x *regles*) (if (member but (buts_regle  x) :test #'equal) (push x regles)))
		regles
	)
)

(defun verifier (but)
    (setq ok (member but *base_faits* :test #'equal))
    (if (eq ok nil)
                (dolist (x (regles_ayant_pour_but but)) 
					(cond 
						((eq ok nil) (verifier_ET x) (print but))
					)
				)
	;			(setq ok T)
    )
    ok
)

(defun verifier_ET (regle)
    (setq ok T)
    (dolist (x (premisses_regle regle)) 
		(if (eq ok T) (setq ok (verifier x)))
	)
    (if (eq ok T) (print (symbol-name regle)))
    ok
)

;INTERFACE	
(defun ihm ()
	(let (saisie_utilisateur)
		(loop
			(write-line "")
			(write-line "### BIENVENUE DANS UN SE D'AIDE À LA RÉSOLUTION D'ENQUETES###")
			(write-line "=============================================================")
			(write-line (concatenate 'string "Nom de l'enquete courante : " (nom_enquete *enquete_courante*)))
			(write-line (concatenate 'string "Nombre de faits présents en base : " (write-to-string (length *base_faits*))))
			(write-line "Pour créer une nouvelle enquète tapez N")
			(write-line "Pour sauvegarder l'enquète courante tapez R")
			(write-line "Pour sélectionner une enquète précédement saisie tapez S")
			(write-line "Pour ajouter un fait dans l'enquete en cours tapez F")
			(write-line "Pour lister les  faits dans l'enquete en cours tapez L")
			(write-line "Pour tenter d'élucider l'enquete sélectionnée avec le premier moteur d'inférence (chaînage avant) tapez 1")
			(write-line "Pour tenter d'élucider l'enquete sélectionnée avec le second moteur d'inférence (chaînage arrière) tapez 2")
			(write-line "Pour quitter tapez Q")
			(write-line "=============================================================")
			(setq saisie_utilisateur (read-line))
			(cond 
				((OR (equal saisie_utilisateur "N") (equal saisie_utilisateur "n")) (nouvelle_enquete))
				((OR (equal saisie_utilisateur "R") (equal saisie_utilisateur "r")) (sauvegarder_enquete))
				((OR (equal saisie_utilisateur "S") (equal saisie_utilisateur "s")) (selection_enquete))
				((OR (equal saisie_utilisateur "F") (equal saisie_utilisateur "f")) (ajouter_fait))
				((OR (equal saisie_utilisateur "L") (equal saisie_utilisateur "l")) (lister_faits))
				((equal saisie_utilisateur "1") (moteur_avant))
				((equal saisie_utilisateur "2") (moteur_arriere))
				((OR (equal saisie_utilisateur "Q") (equal saisie_utilisateur "q")) (quit))
				(T (print "ERREUR : Recommencez") (ihm))
			)
		)
	)
)

(defun nouvelle_enquete ()
	(let (id)
		(setq id (gentemp "E"))
		(write-line "Quel nom porte l'enquete ?")
		(set id (list id (read-line)))
		(push id *enquetes*)
		(setq *enquete_courante* (eval id))
		(setq *base_faits* '())
		(setq *regles_deja_appliquees* '())
		(write-line "Il vous faut maintenant ajouter des faits à la base ! - Appuyez sur ENTRER")
		(read-line)
	)
)

(defun sauvegarder_enquete ()
	(set (id_enquete *enquete_courante*) (append *enquete_courante* *base_faits*))
	(write-line "Les modificatiosn apportées à l'enquete courante ont été sauvegardées.")
	(write-line "==APPUYEZ SUR UNE TOUCHE POUR CONTINUER==")
	(read-line)
)

(defun selection_enquete ()
	(let ((saisie NIL))
		(write-line "*****LISTE DES ENQUETES EN BASE*****")
		(dotimes (x (length *enquetes*))
			(write-line  (concatenate 'string (write-to-string x) " - " (nom_enquete (eval (nth x *enquetes*)))))
		)
		
		(loop 
			(write-line "PENSEZ À SAUVEGARDER AVANT AVANT DE SÉLECTIONNER UNE AUTRE ENQUETE !")
			(write-line "Choissez en tapant le numéro d'ordre de l'enquete")
			(setq saisie (read-line))
			(cond 
				((< (parse-integer saisie) (length *enquetes*))
				;ATTENTION : parse-integer est capricieuse
					(setq *enquete_courante* (eval (nth (parse-integer saisie) *enquetes*)))
					(setq *base_faits* (faits_enquete *enquete_courante*))
					(setq *enquete_courante* (list (car *enquete_courante*) (cadr *enquete_courante*))) ;evite d'avoir la BF courante en double
					(setq *regles_deja_appliquees* '())
					(return-from NIL)
				)
				(T (print "ERREUR : Recommencez"))
			)
		)
	)
)

(defun ajouter_fait ()
		(let (id (saisie NIL) type_fait valeur)
			(write-line "")
			(write-line "*****AJOUT D'UN FAIT DANS L'ENQUETE COURRANTE****")
			(write-line "***ÉTATPE 1 : CHOIX DU TYPE DE FAIT***")
			(dotimes (x (length *type_faits*))
				(write-line (concatenate 'string (write-to-string x) " - " (symbol-name (nth x *type_faits*))))
			)
			(loop 
				(print "Choisissez le numéro d'ordre de l'un des types de faits")
				(setq saisie (read-line))
				(cond 
					((< (parse-integer saisie) (length *type_faits*)) 
						(setq type_fait (nth (parse-integer saisie) *type_faits*))
						(return-from NIL)
					)
					(T (print "ERREUR : Recommencez"))
				)
			)
			(write-line "***ÉTATPE 2 : CHOIX DE LA VALEUR DU FAIT***")
			(dotimes  (x (length (eval type_fait)))
				(write-line (concatenate 'string (write-to-string x) " - " (symbol-name (nth x (eval type_fait)))))
			)
			(loop 
				(print "Choisissez le numéro d'ordre de l'une des valeurs possible pour le type de fait sélectionné")
				(setq saisie (read-line))
				(cond 
					((< (parse-integer saisie) (length (eval type_fait))) 
						(setq valeur (nth (parse-integer saisie) (eval type_fait)))
						(return-from NIL)
					)
					(T "ERREUR : Recommencez")
				)
			)
			(push (list type_fait valeur) *base_faits*)
		)
)

(defun lister_faits ()
	(write-line "")
	(write-line "*****LISTE DES FAITS DE L'ENQUETE COURANTE****")
	(dolist (f *base_faits*)
		(write-line (concatenate 'string (symbol-name (car f)) " : " (symbol-name (cadr f))))
	)
	(write-line "==APPUYEZ SUR UNE TOUCHE POUR CONTINUER==")
	(read-line)
)

(defun moteur_arriere ()
	(let ((saisie NIL))
		(write-line "*****UTILISATION DU MOTEUR ARRIERE*****")
		(write-line "Vous avez un doute sur un suspect ? Vérifier si les éléments de l'enquete permettent de coroborer ce doute !")
		(write-line "**LISTE DES SUSPECTS POSSIBLES DANS LES ENQUTES EXPERTISÉES**")
		(dotimes (x (length *type_suspects*))
			(write-line  (concatenate 'string (write-to-string x) " - " (symbol-name (cadr (nth x *type_suspects*)))))
		)
		
		(loop 
			(write-line "Choissez en tapant le numéro d'ordre du type de suspect à vérifier.")
			(setq saisie (read-line))
			(cond 
;				((< (parse-integer saisie) (length *type_suspects*))
				(t
				;ATTENTION : parse-integer est capricieuse
					(if 
						(verifier (nth (parse-integer saisie) *type_suspects*)) 
						(write-line "Le système corobore. Certains indice vont dans le sens de votre hypothèse. Il est possible que ce soit le coupable") 
						(write-line "Le système de corobore pas. Vous suspectez peut-être le bon coupable mais aucun indice ne l'indique.")
					)
					(write-line "==APPUYEZ SUR UNE TOUCHE POUR CONTINUER==")
					(read-line)
					(return-from NIL)
				)
				(T (write-line "ERREUR : Recommencez"))
			)
		)
	)
)

(format t   "~& ~& ~& ~& ~& ~
            Bonsoir commandant, ~& ~&
            Vous arrivez malheureusement trop tard. Un homicide a été commis
            ce soir... Je suis là pour vous aider à trouver celui ou celle qui a 
            fait ça, et le mettre derrière les barreaux ! Pour cela, je vais vous
            demander d'entrer toutes les informations que vous trouverez sur le lieu
            du crime et je pourrais alors vous donner un suspect...~& 
			~& ~& ~& 
")
(ihm)
 |#