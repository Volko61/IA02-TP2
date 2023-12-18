;Base de connaissance
(setq *jeux* '(
        (SuperMarioBros '(Plateforme 6 8 '(Switch)))
        (DonkeyKong '(Plateforme 4 5 '(Switch)))
        (Sonic '(Plateforme 15 20 '(Switch)))
        (PrinceOfPersia '(Plateforme 6 7 '(Windows PS XBOX)))
        (CS '(FPS 0.2 0.4 '(Windows, Mac, XBOX, PS)))
        (CallOfDuty '(FPS 6 9 '(Windows, Mac, XBOX, PS)))
        (BattleField '(FPS 8 25 '(Windows, Mac, XBOX, PS)))
        (TeamFortress '(FPS 178 642 '(Windows, Mac, Linux)))
        (Valorant '(FPS 0.1 0.5 '(Windows)))
        (FinalFantasy '(RPG 18 40 '(Switch PS Windows XBOX)))
        (Skyrim '(RPG 56 80 '(Windows PS XBOX Mac)))
        (Fables '(RPG 10 17 '(Windows XBOX Mac)))
        (Zelda '(RPG 40 60 '(Switch)))
        (TheWitcher '(RPG 100 150 '(Windows Mac)))
        (KingdomHearth '(RPG 100 150 '(Windows PS XBOX Switch)))
    )
)
;ENTREE
;L'utilisateur se voit montré 10 jeux au hasard et pour chaque jeu il dit si il l'aime ou pas
;L'utilisateur dit quels plateformes il possède
;L'utilisateur dit combien de temps il veut jouer (temps min et max)

;REGLES

;SORTIE
;L'utilisateur se voit proposé des jeux qui correspondent à ses critères et de la même catégorie que ceux qu'il a aimé

;Etablissement des règles
(setq R1 '())
(setq *bdr* '(R1 R2 R3 R4 R5))

;Etablissement des faits
(setq *bdf* )



;------------------------------------------------------------------;