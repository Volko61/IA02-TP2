(defun cclRegle (regle) (car regle))
(defun premisseRegle (regle) (cadr regle))
(defun numRegle (regle) (caddr regle))

(defun regles_candidates (but bdR)
  (if bdR
      (if (EQUAL (cclRegle (car bdR)) but)
          (cons (car bdR) (regles_candidates but (cdr bdR)))
        (regles_candidates but (cdr bdR)))))

(defun chainage-arriere (but bdF bdR &optional (i 0))
  (if (member but bdF) 
      (progn 
        (format t "~V@t   But : ~A proof ~%" i but)
        T)
    (progn
      ;; (let ((regles (regles_candidates but bdR)) (ok nil))
      (let* ((regles (reverse (regles_candidates but bdR))) (ok nil))
        (while (and regles (not ok))
          (format t "~%~V@t VERIFIE_OU ~A Regles ~s :  ~A ~%" i but (numRegle (car regles)) (car regles))
          (let ((premisses (premisseRegle (pop regles))))
            (setq ok t)
            ;;(format t "premisses ~s~%" premisses)
            (while (and premisses ok)
              (format t "~V@t  ~t VERIFIE_ET premisse ~A~%" (+ 1 i) (car premisses))
              (setq ok (chainage-arriere (pop premisses) bdF bdR (+ 9 i))))))
     ok))
    ))

(defun check-compatibilite (premisse1 premisse2)
  (let ((operator1 (cadr premisse1))
        (value1 (caddr premisse1))
        (operator2 (cadr premisse2))
        (value2 (caddr premisse2))
        (vmin most-negative-fixnum)
        (vmax most-positive-fixnum))

    (cond
      ((equal operator1 '=)
        (setq vmin value1)
        (setq vmax value1))
      ((equal operator1 '>=)
        (setq vmin value1))
      ((equal operator1 '<=)
        (setq vmax value1))
      ((equal operator1 '<)
        (setq vmax (- value1 1)))
      ((equal operator1 '>)
        (setq vmin (+ value1 1)))
    )
;; c'est pas fini il faut maintenant faire du côté de premisse2
;; après ça ça devrait le faire
    (and (>= value2 vmin) (<= value2 vmax))
  )
)

(defun verif-premisse (premisse bdF)
  (if (listp premisse)
    (dolist (basePrem bdF)
        (when (listp basePrem)
          (return-from verif-premisse (check-compatibilite basePrem premisse))
          ;; TODO est-ce que c'est vraiment bien de faire des return-from ?
        )
    )
    (member premisse bdF :test #'equal) ;; TODO faire ça plus proprement
  )
)

(defun verifier_ou (but bdF bdR &optional (i 0))
  (if (verif-premisse but bdF) 
      (progn 
        (format t "~V@t But : ~A proof ~%" i but)
        T)
  
    ;;(let ((regles (regles_candidates but bdR)) (sol nil))
    (let ((regles (reverse (regles_candidates but bdR))) (sol nil))

     (while (and regles (not sol))
       (format t "~% ~V@t VERIFIE_OU ~A Regles ~s :  ~A ~%" i but (numRegle (car regles)) (car regles))
       (setq sol (verifier_et (car regles) bdF bdR i))
       (if sol 
           (push (numRegle (car regles)) sol))
       (pop regles))
     sol)
    ))

(defun verifier_et (regle bdF bdR i)
  (let ((ok t) (premisses (premisseRegle regle)))
    (while (and premisses ok)
      (format t "~V@t  ~t VERIFIE_ET ~s premisse ~A~%" (+ 1 i) (numRegle regle) (car premisses))
      (setq ok (verifier_ou (pop premisses) bdF bdR (+ 6 i))))
    ok))

;;(setq *bdf* '(cote_droit cote_gauche corps_mou coquille))
(setq *bdf* '(athropode (antennes = 2) (pattes >= 5)))
(verif-premisse '(pattes >= 4) *bdf*)
(verif-premisse 'athropode *bdf*)
(print (verifPremisse '!athropode *bdf*))

(setq *bdr* 
  '(
    (crustacé (athropode (antennes = 2) (pattes >= 5)) R1)
    (insecte (athropode (antennes = 1) (pattes = 3)) R2)
    (myriapode (athropode (antennes = 1) (pattes > 3)) R3)
    (arachnide (athropode (antennes = 0) (pattes = 4)) R4)

    (A (invertebre cote_droit cote_gauche) R5)
    (B (A corps_mou) R6)
    (arthropode (A carapace pates_articulees) R7)
    (mollusque (B coquille) R8)
    (ver (B corps_allonge !coquille) R9)

    (C (invertebtre !cote_droit !cote_gauche) R10)
    (echinoderme (C calcaire) R11)
    (D (C corps_mou) R12)
    (cnidaire (D tentacules) R13)
    (spongiaire (D !tentacules) R14)
  )
)

(chainage-arriere 'C *baseDeFaits* *baseDeRegles*)
(verifier_ou 'h *baseDefaits* *baseDeRegles*)

;; Poubelle:
    ;; (progn
    ;;   (print premisse)    

    ;;   ;; (if (char= (char (string premisse) 0) #\!)
    ;;   ;;   (not (member premisse bdF))
    ;;   ;;   (member premisse bdF)
    ;;   ;; )
    ;; )

;; (defun premisseVerif (premisse)
;;   (if (listp premisse)
;;     (dolist (ppart premisse)
;;       (print ppart)
;;     )
;;     (progn
;;       (print premisse)    
;;       (if (char= (char (string premisse) 0) #\!)
;;         (print "not")
;;         (print "yes")
;;       )
;;     )
;;   )
;; )

;; (defun test (bdr)
;;   (setq firstElem (car bdr))
;;   (setq values (cdr firstElem))
;;   (dolist (val values)
;;   )
;; )

;; (premisseVerif '(antennes = 3))
;; (premisseVerif 'lol)
;; (test *bdr*)

;; idée d'amélioration check-compatibilité
;; (defun check-compatibilite (premisse1 premisse2)
;;   (let* ((operator1 (cadr premisse1))
;;          (value1 (caddr premisse1))
;;          (operator2 (cadr premisse2))
;;          (value2 (caddr premisse2))
;;          (vmin (if (equal operator1 '=) value1 most-negative-fixnum))
;;          (vmax (if (equal operator1 '=) value1 most-positive-fixnum)))
;;     (case operator1
;;       ((=) (setq vmin value1 vmax value1))
;;       ((>=) (setq vmin value1))
;;       ((<=) (setq vmax value1))
;;       ((<) (setq vmax (- value1 1)))
;;       ((>) (setq vmin (+ value1 1))))
;;     (and (>= value2 vmin) (<= value2 vmax))))