# Modèle Jekyll - RTD - GitHubPages

**Cette page est la *« Landing Page »* de notre site**  

Vous pouvez complètement la modifier à votre guise, à commencer par changer le titre du Site Web ci-haut.

Sur cette page, toutes l'information relative au fonctionnement du Site est synthétisée. De plus, il y est présenté les fichiers et répertoires prioritaires. Ainsi, il est peut-être plus facile de commencer premièrement par catégoriser les-dits répertoires & fichiers en deux groupes distincts : 

- **Modifiable**:

  Les répertoires et fichiers auxquels l'on réfère ici comme *modifiables* se veulent ceux dans lesquelles nous déployons le SiteWeb et ou l'administrateur est amené à effectuer les configurations nécessaires.

- **Secondaires**:

  Ces répertoires et fichiers n'ont pas à être modifier et servent davantages à la mise en page et aux déploiement global du site selon le thème. Ceux-ci ne seront donc pas aborder et expliquer.

### Répertoires et fichiers *Modifiables*

```
.
├── About
│   └── README.md
├── Librairie
│   ├── README.md
│   ├── Installation.md
│   └── Ressources.md
├── Documentations
|   ├── README.md
│   ├── exemples-fichiers
│   │   ├── fichier01.md
│   │   ├── fichier02.md
│   │   └── README.md
│   ├── repertoire-01
│   │   ├── markdown-syntaxe.md
│   │   ├── commandes.md
│   │   └── README.md
│   └── repertoire-02
│       ├── sous_repertoire-01.md
│       ├── sous_repertoire-02.md
│       └── README.md
|
├── README.md
├── CNAME
├── Gemfile
├── Makefile
└── _config.yml

```

> Les fichier ci-hauts sont ceux qui nous intéressent.
>

### Répertoires et fichiers *Secondaires*

```
.
├── _includes
│   └── [...]
├── _layouts
│   └── [...]
├── _sass
│   └── [...]
├── _site
│   └── [...]
├── assets
│   └── [...]
├── LICENSE
├── jekyll-modele.gemspec
├── package.json
├── requirements.txt
├── update.sh
└── webpack.config.js
```

> Il n'est pas nécessaire de modifier ces fichiers et répertoires, et ce, de façon récursive.
