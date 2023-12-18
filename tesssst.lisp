;; Define rules for troubleshooting common computer issues
(setq *baseDeRegles* '( (internet-not-working ((wifi-off modem-issue) R1))
                        (computer-slow ((too-many-programs running-low-on-memory) R2))
                        (cannot-print ((printer-offline printer-not-connected) R3))))

;; Define an initial set of facts that might be found in an IT support context
(setq *baseDefaits* '(wifi-off running-low-on-memory printer-not-connected))

(defun cclRegle (regle) (car regle))
(defun premisseRegle (pregle) (car pregle))
(defun numRegle (pregle) (cadr pregle))

(defun regles_candidates (but bdR)
  (cdr (assoc but bdR)))

(defun chainage-arriere (but bdF bdR &optional (i 0))
  (if (member but bdF)
      (progn
        (format t "~V@t But: ~A proved~%" i but)
        T)
    (let ((regles (regles_candidates but bdR)) (sol nil))
      (while (and regles (not sol))
        (let ((premisses (premisseRegle (car regles))))
          (setq sol T)
          (while (and premisses sol)
            (setq sol (chainage-arriere (pop premisses) bdF bdR (+ 9 i))))
          (if sol
              (push (numRegle (car regles)) sol)))
        (pop regles))
      sol)))

(defun afficher-solution (solution)
  (if solution
      (format t "Solution found using rule(s): ~{~A ~}~%" solution)
    (format t "No solution found.~%")))

(defun lancer-systeme-expert ()
  (format t "What is the goal to achieve? ")
  (let ((but (intern (read-line))))
    (afficher-solution (chainage-arriere but *baseDefaits* *baseDeRegles*))))

;; Run the expert system
(lancer-systeme-expert)