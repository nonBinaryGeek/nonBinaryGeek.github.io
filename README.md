# Modèle Jekyll - RTD - GitHubPages

**Cette page est la *« Landing Page »* de notre site**  

Vous pouvez complètement la modifier à votre guise à commencer par changer le titre du Site Web ci-haut.

Sur cette page, toutes l'information relative au fonctionnement du Site est synthétisée. De plus, il y est présenté les fichiers et répertoires prioritaires. Ainsi, il est peut-être plus facile de commencer premièrement par catégoriser les-dits répertoires & fichiers en deux groupes distincts : 

- Modifiable :

  Ces répertoires et fichiers auxquels l'on réfère ici comme *modifiable* se veulent ceux dans lesquelles nous déployons le SiteWeb et ou l'administrateur est amené à effectuer les configurations nécessaires.

- Secondaires:

  Ces répertoires et fichiers n'ont pas à être modifier et servent davantages à la mise en page et aux déploiement global du site selon le thème. Ceux-ci ne seront donc pas aborder et expliquer.

### Répertoires et fichiers *Modifiables*

```
.
├── À propos
│   └── README.md
├── Librairie
│   ├── README.md
│   ├── Références.md
│   └── Ressources.md
├── Documentations
|   ├── README.md
│   ├── Linux
│   │   ├── Ubuntu_20.04_LTS.md
│   │   ├── Debian_11.md
│   │   ├── CentOS.md
│   │   └── README.md
│   ├── DNS
│   │   ├── BIND9.md
│   │   ├── Théorie_DNS.md
│   │   └── README.md
│   └── SSL-TLS
│       ├── Théorie_SSL.md
│       ├── Implémentation.md
│       └── README.md
|
├── README.md
├── CNAME
├── Gemfile
├── Gemfile.lock
├── LICENSE
├── Makefile
├── _config.yml
├── jekyll-rtd-theme.gemspec
├── package.json
├── requirements.txt
├── update.sh
└── webpack.config.js

```



### Répertoires et fichiers *Secondaires*

```
.
├── _includes
│   ├── README.md
│   ├── common
│   │   ├── assets
│   │   │   └── [...]
│   │   ├── core
│   │   │   └── [...]
│   │   ├── rest
│   │   │   └── [...]
│   │   └── [...]
│   ├── extra
│   │   └── [...]
│   ├── rest
│   │   └── [...]
│   ├── shortcodes
│   │   └── [...]
│   └── templates
|   |   └── [...]
│   └── [...]
|
├── _layouts
│   ├── default.liquid
│   └── tasks
│       └── [...]
├── _sass
│   ├── _direction.scss
│   ├── _font-face.scss
│   ├── _layout.scss
│   ├── _rest.scss
│   ├── _root.scss
│   ├── _variables.scss
│   ├── core
│   │   └── [...]
│   ├── lib
│   │   ├── @primer
│   │   │   └── css
│   │   │       ├── base
│   │   │       │   └── [...]
│   │   │       ├── breadcrumb
│   │   │       │   └── [...]
│   │   │       ├── buttons
│   │   │       │   └── [...]
│   │   │       ├── forms
│   │   │       │   └── [...]
│   │   │       ├── loaders
│   │   │       │   └── [...]
│   │   │       ├── markdown
│   │   │       │   └── [...]
│   │   │       ├── support
│   │   │       │   ├── README.md
│   │   │       │   ├── index.scss
│   │   │       │   ├── mixins
│   │   │       │   │   └── [...]
│   │   │       │   └── variables
│   │   │       │       └── [...]
│   │   │       ├── utilities
│   │   │       |   └── [...]
|   |   |       └── [...]
│   │   ├── font-awesome
│   │   │   └── [...]
│   │   ├── material-design-lite
│   │   │   └── [...]
│   │   └── rouge
│   │       └── github.scss
│   └── theme.scss
├── _site
│   ├── 404.html
│   ├── About
│   │   └── index.html
│   ├── Documentations
│   │   ├── Cisco
│   │   │   └── index.html
│   │   ├── DNS
│   │   │   └── index.html
│   │   ├── Linux
│   │   │   └── index.html
│   │   └── index.html
│   ├── Library
│   │   ├── Ressources.html
│   │   └── index.html
│   ├── README.md
│   ├── assets
│   │   ├── css
│   │   │   ├── fonts
│   │   │   │   └── [...]
│   │   │   └── [...]
│   │   ├── images
│   │   │   └── [...]
│   │   └── js
│   │       └── [...]
│   └── [...]
├── assets
│   ├── 404.liquid
│   ├── css
│   │   ├── fonts
│   │   │   └── [...]
│   │   └── [...]
│   ├── images
│   │   └── [...]
│   ├── js
│   │   └── [...]
│   └── [...]
├── jekyll-modele.gemspec
├── package.json
├── requirements.txt
├── update.sh
└── webpack.config.js
```

