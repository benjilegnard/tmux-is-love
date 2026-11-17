---
title: Tmux is love, Tmux is life
author: Benjamin Legrand
theme:
  name: catppuccin-mocha
  override:
    default:
      colors:
        background: 11111b
options:
  implicit_slide_ends: true
  end_slides_shorthand: true
---

<!-- jump_to_middle -->

# Intro

<!-- speaker_note: |
  - PRÉPARATION (avant de monter sur scène) :
    - écran partagé : `tmux new -s talk -n slides`, puis `presenterm --publish-speaker-notes public/tmux-is-love.md`
    - écran perso, hors de cette session : `presenterm --listen-speaker-notes public/tmux-is-love.md`
    - sessions `logs` et `dev` déjà lancées à côté (adapter les noms dans les notes si besoin)
    - grossir la police du terminal, vérifier que `claude` est connecté
  - Toute la démo se fait dans cette même session tmux : la présentation EST la démo
-->

Qui suis-je, et une histoire d'horreur
===

<!-- speaker_note: |
  - Saluer, 15 secondes de présentation : nom + rôle
  - Demander à la salle : "Qui utilise tmux ici ?" / "qui a déjà utilisé le terminal" / "qui jamais ni l'un ni l'autre?"
  - Raconter l'histoire d'horreur : écran du laptop rabattu en plein déploiement, Wi-Fi coupé pendant une migration de 40 minutes, le Wi-Fi du train qui tue votre `tail -f`
  - Et la version 2026 : le laptop laissé entrouvert toute la nuit pour ne pas tuer la session de l'agent
  - Placer la chute : "Aujourd'hui, je veux m'assurer que ça ne vous arrive plus jamais."
  - Annoncer le fil rouge : les bases, comment tout s'intègre et se programme, et pourquoi les agents IA le parlent déjà couramment
-->

<!-- end_slide -->

<!-- jump_to_middle -->

# 1. Tmux, c'est quoi ?

<!-- speaker_note: |
  - Budget : ~4 minutes pour toute la partie
-->

<!-- end_slide -->

Mais dis-moi Jamy, c'est quoi un multiplexeur ?
===

<!-- speaker_note: |
  - En une phrase : "tmux est un multiplexeur de terminal" (TMUX = Terminal MUltipleXer)
  - Traduction pour les humains : un seul terminal contient plusieurs shells, et ces shells survivent à la fermeture du terminal
  - Le point clé : tmux est un serveur. Votre terminal n'est qu'un client qui s'y attache et s'en détache
  - DÉMO, la révélation : "d'ailleurs, ces slides tournent dans tmux"
    1. `Ctrl-b %` : un shell apparaît à droite des slides
    2. taper `echo "coucou depuis tmux"`
    3. `exit` : le pane se ferme, les slides reprennent toute la place
  - Gratuit, open source, présent dans tous les gestionnaires de paquets, fonctionne sur tous les Unix (et WSL)
-->

Histoire du terminal (version ultra-rapide)
===

<!-- speaker_note: |
  - Les téléscripteurs (TTY) : un clavier + une imprimante reliés à une machine. D'où le nom `/dev/tty`
  - Les terminaux vidéo, le VT100 (DEC, 1978) : les séquences d'échappement qu'on utilise encore aujourd'hui
  - Les émulateurs de terminal : xterm, iTerm, Gnome Terminal, Kitty, Ghostty... qui simulent un VT100 dans une fenêtre via un pseudo-terminal (pty)
  - Conséquence : fermer la fenêtre = tuer le pty = tuer tous les process qui y tournent. C'est ce problème que tmux résout
-->

Histoire de tmux (version ultra-rapide)
===

<!-- speaker_note: |
  - L'ancêtre : GNU screen, 1987. Toujours là sur beaucoup de serveurs
  - tmux : créé par Nicholas Marriott en 2007, intégré à OpenBSD en 2009, licence BSD
  - Bientôt vingt ans, toujours activement maintenu, une nouvelle version régulièrement
  - Vingt ans de doc, de dotfiles, de questions Stack Overflow et de billets de blog : retenez ça, ça reviendra à la fin avec les agents
-->

Concepts de base : session, window, pane
===

```text
serveur tmux
└── session "work"
    ├── window 1 "code"
    │   ├── pane 0 : nvim
    │   └── pane 1 : npm run dev
    └── window 2 "logs"
        └── pane 0 : tail -f app.log
```

<!-- speaker_note: |
  - Session : un espace de travail nommé, typiquement un par projet. C'est elle qui survit au détachement
  - Window : l'équivalent d'un onglet, occupe tout l'écran
  - Pane : un découpage d'une window, chaque pane est un shell indépendant
  - Un client (votre terminal) est attaché à une session à la fois ; plusieurs clients peuvent être attachés à la même session
  - DÉMO : `Ctrl-b w` montre l'arbre réel : les sessions `talk`, `logs` et `dev`, leurs windows et leurs panes, `Échap` pour revenir
-->

<!-- end_slide -->

<!-- jump_to_middle -->

# 2. Démo live

<!-- speaker_note: |
  - Budget : ~8 minutes pour toute la partie
  - Raccourci de survie pendant toute la démo : `Ctrl-b l` revient à la window précédente, donc aux slides
-->

<!-- end_slide -->

La touche leader : `Ctrl-b`
===

<!-- speaker_note: |
  - Toutes les commandes tmux commencent par le préfixe, par défaut `Ctrl-b`, puis une touche
  - DÉMO :
    1. `Ctrl-b ?` : la liste de tous les raccourcis, défiler un peu, `q` pour quitter
    2. `Ctrl-b :` puis `display-message "Bonjour la salle"` + `Entrée` : le message s'affiche dans la barre de statut
    3. "tout raccourci n'est qu'une commande tmux, on s'en resservira pour scripter"
  - La plupart des gens le remappent sur `Ctrl-a` (héritage de screen) ou `Ctrl-Space`
  - Une ligne dans `~/.tmux.conf` : `set -g prefix C-a`
-->

Navigation : panes, windows, sessions
===

<!-- speaker_note: |
  - Problème : 14 onglets de terminal répartis sur 3 bureaux. Lequel avait le shell de staging ? Les logs de prod ? Le serveur de dev ?
  - DÉMO windows :
    1. `Ctrl-b c` : nouvelle window, `Ctrl-b ,` pour la renommer `demo`
    2. montrer les deux windows dans la barre de statut, `Ctrl-b l` aller-retour avec les slides
  - DÉMO panes (dans `demo`) :
    1. `Ctrl-b %` (côte à côte), puis `Ctrl-b "` (haut/bas)
    2. `Ctrl-b ←` / `→` / `↑` / `↓` pour naviguer, `Ctrl-b o` pour tourner
    3. `Ctrl-b z` : zoomer un pane, `Ctrl-b z` à nouveau pour dézoomer
    4. `Ctrl-b x` pour en fermer un, garder deux panes pour la suite
  - DÉMO sessions :
    1. `Ctrl-b s` : liste des sessions `talk`, `logs`, `dev`, choisir `dev`
    2. `Ctrl-b s` à nouveau pour revenir sur `talk`
    3. dans un pane : `tmux new -d -s autre`, une session jetable qui servira plus tard
  - Moins d'alt-tab, moins de souris, moins de recherche visuelle
-->

Copier-coller sans heurts (et sans souris)
===

<!-- speaker_note: |
  - DÉMO (dans `demo`, nécessite `set -g mode-keys vi`) :
    1. `seq 1 2000` : beaucoup trop de lignes pour l'écran
    2. `Ctrl-b [` : mode copie, `Ctrl-u` / `Ctrl-d` pour remonter / descendre dans l'historique
    3. `Espace` sur une ligne, se déplacer avec `j`, `Entrée` pour copier
    4. dans l'autre pane : `echo '` puis `Ctrl-b ]` pour coller
  - Fonctionne sur des milliers de lignes d'historique, y compris dans une session SSH
  - Bonus : `set -g set-clipboard on` pour envoyer vers le presse-papier système (OSC 52), ou le plugin tmux-yank
-->

Recherche et heure
===

<!-- speaker_note: |
  - DÉMO recherche :
    1. `Ctrl-b [` puis `?1337` + `Entrée` : saute à la ligne 1337 du `seq` précédent
    2. `n` / `N` : occurrence suivante / précédente, `q` pour sortir
  - `Ctrl-b f` : chercher une window par son nom ou son contenu (le montrer en tapant `seq`)
  - DÉMO heure : `Ctrl-b t`, la grosse horloge. Totalement inutile, donc indispensable. N'importe quelle touche pour sortir
-->

Connexion à distance : détacher, rattacher
===

<!-- speaker_note: |
  - LA fonctionnalité qui tue, la raison pour laquelle les gens tombent amoureux de tmux
  - DÉMO détachement (le moment "wow") :
    1. dans `demo` : lancer `top`
    2. `Ctrl-b d` : TOUT disparaît, slides comprises. Laisser un silence
    3. `tmux ls` : la session `talk` est toujours là
    4. `tmux attach -t talk` : les slides reviennent, `top` tourne toujours
  - DÉMO SSH (si un serveur est accessible, sinon `localhost`) :
    1. `ssh serveur -t tmux new -A -s remote` (`-A` : crée ou rattache)
    2. lancer `ping 1.1.1.1` pour avoir un truc qui tourne
    3. tuer la connexion : `Entrée` puis `~.`
    4. relancer la même commande ssh : le `ping` n'a jamais arrêté
  - Problème : la migration de 40 minutes en SSH, perdue dès que le laptop se met en veille ou que le Wi-Fi tousse
  - Comparer à nohup / disown / unités systemd : des rustines, tmux est la vraie solution
  - Sur tout serveur où vous vous connectez plus d'une fois, `tmux` devrait être la première chose que vous tapez
-->

<!-- end_slide -->

<!-- jump_to_middle -->

# Cas d'usage concrets

<!-- end_slide -->

Consultation de logs
===

<!-- speaker_note: |
  - DÉMO (dans la session `logs` déjà prête) :
    1. `Ctrl-b s` vers `logs` : les flux défilent, un pane par service
    2. `Ctrl-b z` sur un pane pour le lire en plein écran, `Ctrl-b z` pour revenir
    3. `Ctrl-b [` puis `?ERROR` (ou un mot présent dans les logs) : remonter à une erreur sans couper le flux, `q` pour sortir
    4. `Ctrl-b :` `setw monitor-activity on`, puis `Ctrl-b s` vers `talk`
  - Aussi : `pipe-pane -o 'cat >> ~/session.log'` pour enregistrer tout ce qui passe dans un pane
  - `synchronize-panes` (dans `demo`) : `Ctrl-b :` `setw synchronize-panes on`, taper `date` une fois, ça s'exécute dans tous les panes (la remettre à `off`). Imaginez 4 serveurs
-->

Manipulation de panneaux, fenêtres, sessions
===

<!-- speaker_note: |
  - DÉMO (dans `demo`, pas dans `logs` pour ne pas casser sa disposition ; ajouter un pane ou deux avec `Ctrl-b %`) :
    1. `Ctrl-b Espace` plusieurs fois : les dispositions prédéfinies (even-horizontal, main-vertical, tiled...)
    2. `Ctrl-b {` / `}` : échanger les panes
    3. `Ctrl-b Ctrl-→` : redimensionner
    4. `Ctrl-b !` : le pane part dans sa propre window
    5. `Ctrl-b :` `join-pane -t :demo` : il revient
  - `move-window`, `link-window` : déplacer ou partager une window entre sessions
  - Tout ce qu'on fait au clavier est une commande tmux, donc scriptable : on y revient juste après
-->

Édition & intégration vim
===

<!-- speaker_note: |
  - DÉMO (dans `demo`) :
    1. `nvim ~/.tmux.conf` dans le pane de gauche, `:vsplit`
    2. `Ctrl-h` / `Ctrl-l` : on passe d'un split vim à l'autre, puis au pane tmux voisin, sans préfixe (vim-tmux-navigator)
    3. montrer dans la conf : `set -sg escape-time 0` (sinon `Échap` traîne dans vim), `focus-events on`
  - Envoyer la ligne courante ou un bloc vers un REPL dans le pane voisin (vimux, vim-slime)
  - Même principe avec les éditeurs "terminal-first" : nvim, helix, kakoune, emacs -nw
-->

Sessions et envoi de messages
===

<!-- speaker_note: |
  - DÉMO (depuis un pane de `demo`, la session `autre` existe déjà) :
    1. `tmux send-keys -t autre 'echo "envoyé depuis une autre session"' Enter`
    2. `Ctrl-b s` vers `autre` pour prouver que la commande a bien été tapée, `Ctrl-b s` pour revenir sur `talk`
    3. `tmux capture-pane -p -t logs | tail -5` : on lit les derniers logs sans quitter les slides
    4. `tmux display-message "Coucou"` : notifier depuis un script
  - Pair programming : deux personnes s'attachent à la même session, voient le même écran, tapent dans le même shell
  - DÉMO pairing (si un 2e terminal est sous la main) : `tmux attach -t talk` dedans, taper d'un côté, ça s'affiche des deux
  - Plus léger et plus sûr qu'un partage d'écran du bureau entier, qui expose toutes vos autres fenêtres
  - Fini le "colle-moi ta sortie", place au "laisse-moi voir"
-->

Sub-agents dans tmux avec Claude Code
===

<!-- speaker_note: |
  - DÉMO :
    1. `Ctrl-b c`, `Ctrl-b ,` pour la nommer `agent`, lancer `claude`
    2. lui donner une tâche un peu longue, préparée à l'avance, qui lance des sub-agents / une agent team
    3. avec les agent teams en mode tmux, chaque coéquipier s'ouvre dans son propre pane (vérifier le réglage dans la version utilisée le jour J)
    4. `Ctrl-b d`, "je ferme le laptop", `tmux attach -t talk` : l'agent a continué
  - Plusieurs agents en parallèle : une window par agent / par worktree git, nommées, faciles à retrouver
  - On peut se rattacher depuis une autre machine, voire son téléphone en SSH
-->

Les agents parlent déjà tmux
===

<!-- speaker_note: |
  - Vingt ans de doc, de dotfiles et de Stack Overflow : tmux est massivement présent dans les données d'entraînement
  - DÉMO (dans la window `agent`) :
    1. demander : "regarde ce qui tourne dans les sessions tmux `dev` et `logs`, et dis-moi s'il y a des erreurs"
    2. le regarder enchaîner tout seul `tmux ls`, `tmux list-panes`, `tmux capture-pane -p -t logs`
    3. `Ctrl-b s` vers `logs` : on regarde les mêmes panes que l'agent
    4. `Ctrl-b s` pour revenir sur `talk`
  - Il sait aussi piloter un REPL ou un programme interactif avec `send-keys`, et écrire votre `~/.tmux.conf` mieux que vous
  - Conséquence : tmux devient l'interface commune entre vous et vos agents
-->

<!-- end_slide -->

<!-- jump_to_middle -->

# Plugins sympas et features avancées

<!-- end_slide -->

Programmez vos sessions
===

<!-- speaker_note: |
  - Problème : l'amnésie du contexte chaque matin. cd dans le projet, activer le venv, npm run dev, suivre les logs, ouvrir un shell DB. Encore. Et encore.
  - L'idée : tout ce qu'on a tapé au clavier depuis le début est une commande tmux (`new-session`, `split-window`, `send-keys`...), donc tout se rejoue
  - DÉMO : `Ctrl-b s` vers `dev`, puis vers `logs` : "ces sessions étaient prêtes avant que je monte sur scène, et elles le seront encore demain matin"
  - Outils pour décrire ses sessions sans écrire de code : tmuxinator / tmuxp (un fichier YAML par projet), sesh / tmux-sessionizer pour sauter de projet en projet
  - Environnement de dev reproductible, qui vit dans git et pas dans votre tête. L'onboarding devient trivial
-->

Plugins : tpm et thèmes
===

<!-- speaker_note: |
  - DÉMO :
    1. `Ctrl-b %` puis `nvim ~/.tmux.conf`, aller à la section des `set -g @plugin '...'`
    2. montrer `run '~/.tmux/plugins/tpm/tpm'` en bas du fichier
    3. `Ctrl-b I` : installer, `Ctrl-b U` : mettre à jour
    4. pointer la barre de statut catppuccin : "c'est ce plugin-là"
  - Les classiques : tmux-sensible (de bons réglages par défaut), tmux-yank (presse-papier)
  - La barre de statut est entièrement personnalisable : batterie, CPU, branche git, météo, ce que vous voulez
  - Ne pas tout bidouiller dès le premier jour : d'abord prendre ses marques, personnaliser ensuite
-->

Persistance : tmux-resurrect et tmux-continuum
===

<!-- speaker_note: |
  - La limite de tmux : le serveur tourne en mémoire, un redémarrage de la machine et tout disparaît
  - DÉMO (NE PAS tuer le serveur, les slides tournent dedans) :
    1. `Ctrl-b Ctrl-s` : message "Tmux environment saved!"
    2. `tmux kill-session -t autre`, `Ctrl-b s` : la session a disparu
    3. `Ctrl-b Ctrl-r` : `autre` revient, avec ses windows, ses panes et ses dossiers
  - tmux-continuum : sauvegarde automatique toutes les 15 minutes, et restauration au démarrage avec `@continuum-restore 'on'`
-->

which-key et apprentissage
===

<!-- speaker_note: |
  - Le frein principal de tmux : se souvenir des raccourcis
  - DÉMO natif :
    1. `Ctrl-b <` : le menu contextuel de la window ; `Ctrl-b >` : celui du pane (tmux 3+)
    2. clic droit à la souris si `mouse on` : les mêmes menus
  - DÉMO plugin tmux-which-key : le raccourci configuré ouvre un menu qui affiche les touches disponibles, comme dans nvim / Spacemacs
  - Conseil : apprendre 3 raccourcis par semaine, pas 30 le premier jour
-->

<!-- end_slide -->

<!-- jump_to_middle -->

# 3. Conclusion

<!-- speaker_note: |
  - Budget : ~3 minutes
  - Fermer les windows de démo si on veut une barre de statut propre, ou les laisser : elles prouvent tout ce qu'on vient de faire
-->

<!-- end_slide -->

Avantages / inconvénients
===

<!-- speaker_note: |
  - Avantages : persistance, résilience SSH, multiplexage, dispositions scriptées, pairing, tout est une commande donc tout se programme, et les agents le maîtrisent déjà
  - Inconvénients :
    - courbe d'apprentissage et raccourcis peu découvrables
    - le préfixe entre en conflit avec d'autres raccourcis (readline, vim, l'émulateur de terminal)
    - presse-papier et couleurs parfois capricieux (surtout en SSH ou en tmux imbriqué)
    - pas de Windows natif (passer par WSL)
    - ne survit pas à un redémarrage sans plugin
-->

Alternatives anciennes et modernes
===

<!-- speaker_note: |
  - L'ancien : GNU screen (1987), toujours présent sur les vieux serveurs ; byobu, une surcouche conviviale à screen/tmux
  - Le minimaliste : dtach / abduco, juste le détachement, sans découpage
  - Le partage : tmate, un fork de tmux pour partager une session sans configuration SSH
  - Le moderne : zellij (Rust, interface découvrable, plugins WASM, layouts en KDL)
  - Les émulateurs qui multiplexent eux-mêmes : WezTerm, Kitty. Pratiques en local, mais rien ne remplace tmux sur un serveur distant
-->

Démarrer en 5 minutes
===

<!-- speaker_note: |
  - Installation : `apt install tmux`, `brew install tmux`, ou votre gestionnaire de paquets
  - Trois commandes à retenir le premier jour :
    - `tmux new -s work` : démarrer une session nommée
    - `Ctrl-b d` : se détacher
    - `tmux attach -t work` : revenir
  - C'est tout. Le reste, c'est du bonus.
  - Optionnel : remapper le préfixe sur `Ctrl-a`, activer le mode souris (`set -g mouse on`), installer tpm
  - Ou demander à votre agent préféré de vous écrire un `~/.tmux.conf` commenté
-->

Une ligne de config, un raccourci, et on ne regarde plus en arrière
===

<!-- speaker_note: |
  - Rappeler la promesse : persistance, résilience, multiplexage, dispositions scriptées, pairing, agents
  - "Si vous ne retenez qu'une chose de ce talk : la prochaine fois que vous vous connectez en SSH à un serveur, ou que vous lancez un agent, tapez `tmux` en premier."
  - Tmux is love. Tmux is life.
  - Sortie de scène possible : `Ctrl-b d`, les slides disparaissent, "Merci !" ; `tmux attach -t talk` pour les Q&R
  - Merci + Q&R
-->
