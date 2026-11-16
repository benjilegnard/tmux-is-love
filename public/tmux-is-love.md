---
title: Tmux is love, Tmux is life
author: Benjamin Legrand
options:
  implicit_slide_ends: true
---

<!-- jump_to_middle -->

# Intro

Qui suis-je, et une histoire d'horreur
===

<!-- speaker_note: |
  - Saluer, 15 secondes de présentation : nom + rôle
  - Demander à la salle : "Qui a déjà perdu une longue session SSH ?"
  - Raconter l'histoire d'horreur : écran du laptop rabattu en plein déploiement, Wi-Fi coupé pendant une migration de 40 minutes, le Wi-Fi du train qui tue votre `tail -f`
  - Placer la chute : "Aujourd'hui, je veux m'assurer que ça ne vous arrive plus jamais."
-->

Qu'est-ce que tmux ?
===

<!-- speaker_note: |
  - En une phrase : "tmux est un multiplexeur de terminal"
  - Traduction pour les humains : un seul terminal contient plusieurs shells, et ces shells survivent à la fermeture du terminal
  - Mentionner que c'est gratuit, open source, présent dans tous les gestionnaires de paquets, et fonctionne sur tous les Unix
  - Ne pas parler de l'historique (screen, etc.) : c'est un lightning talk, on avance
-->

<!-- end_slide -->

<!-- jump_to_middle -->

# Les avantages

La persistance des sessions : la fonctionnalité qui tue
===

<!-- speaker_note: |
  - LA raison pour laquelle les gens tombent amoureux de tmux
  - `tmux new -s work` puis `Ctrl-b d` pour se détacher, `tmux attach -t work` pour revenir
  - Fermez votre laptop, partez, revenez demain : tout tourne encore
  - Démo si possible : lancer un `top`, se détacher, se rattacher
  - Rien que ça vaut les 10 minutes d'apprentissage
-->

Résilience SSH
===

<!-- speaker_note: |
  - Coupure réseau ? VPN instable ? Tunnel en train ? Votre travail distant survit
  - Workflow : se connecter en SSH, lancer `tmux`, travailler ; si la connexion tombe, il suffit de refaire `ssh` puis `tmux attach`
  - Comparer à nohup/disown : ce sont des rustines, tmux est la vraie solution
  - Particulièrement critique pour : longues migrations, déploiements, builds, suivi de logs
-->

Une fenêtre, plusieurs shells
===

<!-- speaker_note: |
  - Découpage (panes) horizontal et vertical dans une seule fenêtre
  - Plusieurs fenêtres (comme des onglets) dans une seule session
  - Moins d'alt-tab, moins de souris, moins de recherche visuelle entre les bureaux
  - Montrer une disposition typique : éditeur + serveur + logs + REPL, le tout sur un seul écran
  - Mentionner le préfixe par défaut `Ctrl-b`, la plupart des gens le remappent sur `Ctrl-a`
-->

Dispositions de projet scriptées
===

<!-- speaker_note: |
  - Scripter "ouvrir le projet X" une fois, le rejouer à l'infini
  - Outils : tmuxinator, tmuxp, ou un script shell de 10 lignes avec `tmux send-keys`
  - Exemple de disposition : pane de gauche = nvim, en haut à droite = serveur de dev, en bas à droite = tests en mode watch
  - Environnement de dev reproductible, qui vit dans git et pas dans votre tête
  - L'onboarding des nouveaux devs devient trivial
-->

Pair programming et aide à distance
===

<!-- speaker_note: |
  - Deux personnes s'attachent à la même session, voient le même écran, tapent dans le même shell
  - Workflow : `tmux new -s pair`, partager l'accès SSH, le collègue lance `tmux attach -t pair`
  - Plus léger que le partage d'écran d'un bureau entier
  - Idéal pour du debug "par-dessus l'épaule" entre fuseaux horaires
  - Mentionner `tmate` pour un partage sans configuration si le SSH interne est pénible
-->

Bonus : mode copie, plugins, thèmes
===

<!-- speaker_note: |
  - Mode copie : recherche et copie façon vim dans des milliers de lignes d'historique
  - Gestionnaire de plugins : tpm (Tmux Plugin Manager)
  - Plugins indispensables : tmux-resurrect (sauvegarder/restaurer les sessions après un redémarrage), tmux-continuum (sauvegarde automatique)
  - La barre de statut est entièrement personnalisable : batterie, CPU, branche git, météo, ce que vous voulez
  - Ne pas tout bidouiller dès le premier jour : d'abord prendre ses marques, personnaliser ensuite
-->

<!-- end_slide -->

<!-- jump_to_middle -->

# La douleur de NE PAS utiliser tmux

Fermer le laptop est destructeur
===

<!-- speaker_note: |
  - Cette migration de 40 minutes en SSH ? Perdue dès que le laptop se met en veille
  - Contournements : nohup, disown, unités systemd, tous plus lourds que `tmux`
  - "Il suffit de ne pas fermer le laptop" n'est pas une solution d'ingénieur
-->

L'amnésie du contexte chaque matin
===

<!-- speaker_note: |
  - Chaque matin : cd dans le projet, activer le venv, npm run dev, suivre les logs, ouvrir un shell DB
  - Encore. Et encore. Et encore.
  - Avec tmux + un script de disposition, c'est une seule commande. Ou zéro, si la session est encore attachée depuis la veille.
-->

La prolifération des fenêtres de terminal
===

<!-- speaker_note: |
  - 14 onglets iTerm répartis sur 3 bureaux
  - Lequel avait le shell de staging ? Les logs de prod ? Le serveur de dev local ?
  - tmux centralise tout dans des sessions nommées et des fenêtres nommées
-->

Le pairing et l'aide à distance sont pénibles
===

<!-- speaker_note: |
  - Partager tout son bureau juste pour montrer un terminal ? Excessif, lent, et ça expose les autres fenêtres
  - Aide asynchrone : "colle-moi ta sortie" au lieu de "laisse-moi voir"
  - tmux + ssh = collaboration en temps réel sans outil supplémentaire
-->

Le travail sur serveur est fragile
===

<!-- speaker_note: |
  - Une micro-coupure Wi-Fi tue votre `tail -f` distant, votre `htop`, votre commande à moitié tapée
  - Pire cas : ça tue un script long sans point de reprise
  - Sur tout serveur où vous vous connectez en SSH plus d'une fois, `tmux` devrait être la première chose que vous tapez
-->

<!-- end_slide -->

<!-- jump_to_middle -->

# Conclusion

Démarrer en 5 minutes
===

<!-- speaker_note: |
  - Installation : `apt install tmux`, `brew install tmux`, ou votre gestionnaire de paquets
  - Trois commandes à retenir le premier jour :
    - `tmux new -s work` : démarrer une session nommée
    - `Ctrl-b d` : se détacher
    - `tmux attach -t work` : revenir
  - C'est tout. Le reste, c'est du bonus.
  - Optionnel : remapper le préfixe sur `Ctrl-a`, activer le mode souris, installer tpm
-->

Une ligne de config, un raccourci, et on ne regarde plus en arrière
===

<!-- speaker_note: |
  - Rappeler la promesse : persistance, résilience, multiplexage, dispositions scriptées, pairing
  - "Si vous ne retenez qu'une chose de ce talk : la prochaine fois que vous vous connectez en SSH à un serveur, tapez `tmux` en premier."
  - Tmux is love. Tmux is life.
  - Merci + Q&R
-->
