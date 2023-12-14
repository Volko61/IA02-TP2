(defun make-individu (individu attributs)
    (let ((frame (list individu)))
        (dolist (attribut attributs)
            (let ((nom-attribut (car attribut))
                    (valeur-attribut (cdr attribut))
                )
                (push (list nom-attribut valeur-attribut) frame)
            )
        )
        (pushnew frame *frame*)
    )
)
#|
(defun make-individu(concept attributs)
    if(member concept *frames*)
)|#

;'(ELEPHANT 'NAME "Clyde" COLOR "grey" AGE 5)))
#|(setq ELEPHANT 
    '(ELEPHANT
        (TYPE (VALUE CONCEPT))
        (IS-A (VALUE ETRE))
        (AGE (IF-NEEDED ask-user)
            (IF-NEEDED check-age)
        )
        (POIDS (IF-NEEDED compute-weight-from-age))
        (AFFICHAGE (IF-ADDED draw-elephant)
            (IF-REMOVED erase-elephant)
        )
    )
)

(defvar *frames* '())
(make-individu 'ELEPHANT '((NAME "Clyde") (COLOR "grey") (AGE 5)))
(pushnew 'ELEPHANT *frames*)
 |#
