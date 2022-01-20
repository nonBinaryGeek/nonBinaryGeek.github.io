---
source: page.path
sort: 1
title: Préparation
---

{% include list.liquid all=true %}

# Préparation

Sur cette page, l'information relative au fonctionnement du site web est synthétisée. Plus précisément, les fichiers et répertoires prioritaires seront présentés. Ainsi, il est peut-être plus facile de commencer, avant tout, par catégoriser les-dits répertoires & fichiers en deux groupes distincts: 

- **Modifiable**:

  Les répertoires et fichiers auxquels l'on réfère ici comme *modifiables* se veulent ceux dans lesquelles nous déployons le SiteWeb et ou l'administrateur est amené à effectuer les configurations nécessaires.

- **Secondaires**:

  Ces répertoires et fichiers n'ont pas à être modifier et servent davantages à la mise en page et aux déploiement global du site selon le thème. Ceux-ci ne seront donc pas abordés et expliqués.



```note
Les répertoires et fichiers présentés ci-bas ne représentent pas l'organisation du présent site. Ceux-ci réfèrent à la *repository* que nous utiliseront afin de monter le nouveau siteweb. Somme toute, le présent site <`https://docs.nonbinarygeek.ca/`> sert avant tout de guide afin de déployer un siteweb contenant, au départ, les répertoires et fichiers suivant.   
```



### Répertoires et fichiers *Modifiables*

```
.
├── About
│   └── README.md
│ 
├── Librairie
│   ├── README.md
│   ├── fichier01.md
│   ├── fichier02.md
│   └── fichier03.md
│ 
├── Documentations
|   ├── README.md
|   |
│   ├── repertoire-01
│   |   ├── sous_repertoire-01.md
|   │   │   └── README.md
│   |   ├── sous_repertoire-02.md
|   │   │   └── README.md
│   │   └── README.md
│   │ 
│   └── repertoire-02
│       ├── fichier01.md
│       ├── fichier02.md
│       └── README.md
|
├── README.md
├── CNAME
├──jekyll-modele.gemspec
└── _config.yml

```

> Les fichier ci-hauts sont ceux qui nous intéressent.

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
├── Gemfile
├── Gemfile.lock
├── package.json
├── requirements.txt
└── webpack.config.js
```

> Il n'est pas nécessaire de modifier ces fichiers et répertoires, et ce, de façon récursive.
