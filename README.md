# Tmux is love, Tmux is life.

## Abstract

```
Arrêtez de laisser entrouverts vos portable pour conserver vos sessions agentiques.

Vous en avez marre d'avoir 42 onglets ou fenêtres de terminal ouvertes sur 3 workspaces et vous ne retrouvez plus laquelle est importante ?

Marre de perdre vos session ssh à distance dès que le signal wifi s'affaiblit ?

Souffrez-vous d'amnésie du contexte ? qui vous fait faire toujours le même process tous les matins pour ouvrir les 15 milles micro-trucs qui composent votre projet ?

J'ai la solution miracle pour vous, qui lave plus blanc que blanc : TMUX.

Apprenez à utiliser tmux pour être encore plus efficace avec la ligne de commande et le terminal.

En quoi cet outil qui a bientôt vingt ans est intéressant pour le dev agentique ?

De l'utilisation de base aux plugins avancé, tour d'horizon rapide des fonctionnalités de TMUX.
```

## Plan


### 1. TMUX c'est quoi ? (4 minutes)
- mais dis moi-jamy, c'est quoi un multiplexeur ?

#### Terminal MULtiplexeur
- histoire du terminal (ultra-rapide)
- histoire de tmux (ultra-rapide)

#### Concepts de base / Termes
- session
- window
- pane

### 2. Démo live (~=8 minutes)

#### Utilisation de base
- Touche leader (ctrl+b)
- navigation entre pane / entre sessions / entre fenêtres
- copier coller sans heurts (et sans souris surtout)
- recherche / heure 
- connection à distance

#### Cas d'usage concrêts
- consultation de logs
- manipulation de panneaux / fenêtres / session
- édition & intégration vim
- sessions / envoi de messages
- sub-agents dans tmux avec claude code.

#### Plugins sympa / features avancées
- programmez vos sessions
- plugins (tpm / themes)
- persistence (resurrect)
- which-key, apprentissage

### 3. Conclusion ~3 minutes
- avantages / inconvénients
- alternatives anciennes et modernes (screen, zellij...)


## Présenter

Les slides sont dans `public/tmux-is-love.md`, au format [presenterm](https://github.com/mfontanini/presenterm) (version 0.16.1 lors de la rédaction).

### Sans notes

```sh
presenterm public/tmux-is-love.md
```

### Avec les notes de présentation

Les notes sont dans des commentaires `<!-- speaker_note: ... -->` : elles ne sont pas affichées sur les slides.

Ouvrir deux terminaux (par exemple deux fenêtres tmux) :

```sh
# Terminal 1 : la présentation, sur l'écran partagé
presenterm --publish-speaker-notes public/tmux-is-love.md

# Terminal 2 : les notes, sur votre écran
presenterm --listen-speaker-notes public/tmux-is-love.md
```

La navigation se fait dans le terminal 1, le terminal 2 suit automatiquement.

### Navigation

- slide suivante : `l`, `→`, `espace` ou `PageDown`
- slide précédente : `h`, `←` ou `PageUp`
- première / dernière slide : `gg` / `G`
- aller à la slide N : `N` puis `G`
- quitter : `Ctrl-c`

### Vérifier le rendu

```sh
# détecte les slides qui dépassent de l'écran
presenterm --validate-overflows public/tmux-is-love.md
```

### Préparation (avant de monter sur scène) 

- récupérer le nom de la seconde sortie HDMI (genre `HDMI-A-1`
  - écran partagé : `tmux new -s talk -n slides`, puis `presenterm --publish-speaker-notes public/tmux-is-love.md`
  - écran perso, hors de cette session : `presenterm --listen-speaker-notes public/tmux-is-love.md`
  - sessions `logs` et `dev` déjà lancées à côté (adapter les noms dans les notes si besoin)
  - grossir la police du terminal, vérifier que `claude` est connecté
- Toute la démo se fait dans cette même session tmux : la présentation EST la démo

## Sources

- Doc officielle / projet github : <https://github.com/tmux/tmux/wiki>
- TPM (Tmux Plugin Manager): <https://github.com/tmux-plugins/tpm>

