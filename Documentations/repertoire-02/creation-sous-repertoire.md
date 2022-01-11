---
sort: 1
---

# Création de sous-répertoires



Le présent fichier se trouve dans une sous repertoire représenté comme suit:

```
repertoire-02/
├── README.md
├── sous_Repertoire-01
│   └── README.md
├── sous_Repertoire-02
│   └── README.md
└── creation-sous-repertoire.md --> fichier en cours
```

Ainsi, on obtient pour résultat une organisation claire permettant de subdiviser nos documents, offrant la possibilité d'introduire une organisation complète de notre siteweb.

Afin de créer les dîts sous-répertoires, nous utilisons la technique des fichiers `README.md` précédemment mentionnée. Ceux-ci servent donc d'index, et se retrouve dans **CHAQUE** répertoire de notre siteweb.

Les fichiers `README.md` ont donc besoin de 3 composantes essentielles afin d'organiser notre site:

- [Directive `YAML Front Matter`](#yaml-front-matter)
- [Titre](#titre)
- [Directive `LIQUID`](#directive-liquid)

> note: Les fichiers `README.md` peuvent être compris comme l'équivalent des fichiers `index.html` pour les connaisseurs de ce standard web. Fans les faits, les `README.md` de notre site sont convertis en `index.html` une fois que l'on active **Jekyll**.

Un exemple complet se retrouve au bas de la présente page:

- [Solution Complète](#solution-complète)

## YAML Front Matter

À l'exception du premier fichier `README.md` qui représente la *landing page* de notre site, **TOUS** les fichiers `README.md` doivent avoir la directive `YAML Front Matter` suivante:

```
# Directive YAML Front Matter pour l'organisation des repertoires
---
source: page.path
sort: _$ 
---
```

Celle-ci permet d'indiquer la source et, comme pour les fichiers, l'ordre de naviguation, en remplaçant `_$` par une valeur numérique , -e.g `1`.

> note: la source `page.path` est une valeur réelle et s'inscrit dans les fichiers `README.md` de notre répertoire principale. Dans le présent siteweb, on parle du répertoire `Documentations` en adressant le répertoire principal. Vous remarquerez que l'indicatif `source: page.path` est présent dans **TOUS** les `README.md` de **TOUS** les `/répertoires` et `/sous-répertoires` présent **SOUS** `./Documentations/`.

## Titre

Ensuite, on indique simplement le titre du répertoire, tel qu'il apparaîtra sur le siteweb. Afin de préciser un titre dans un fichier `markdown`, nous tappons un dièse, suivit d'un espace et de notre titre tel que dans l'exemple suivant:

```
# SOUS RÉPERTOIRE 02
```



## Directive LIQUID

Afin d'obtenir une mise en page appropriée, notre site est construit à l'aide de fichiers `LIQUID`. Ceux-ci offrent l'avantage de n'occuper qu'une fraction d'espace disque. Utilisant leur propre language, l'explication relative à leur fonctionnement dépasse largement le présent guide et ne sera donc pas abordé.

Ce qui doit être retenu ici est donc simplement la directive suivante enveloppée par des *braces* `{		}`:

```plaintext
% include list.liquid all=true %
```

Cette directive doit être inscrite dans chaque `README.md` où nous souhaitons indiquer au répertoire qu'il insert une table des matières automatiquement dans la naviguation. Cette directive doit entre encadrée par des *braces* -i.e *curly brackets*: `{		}`. Lorsqu'il est inséré avec les *braces*, le langage *LIQUID* s'occupe de la transformation. Ainsi, le code ci-haut sera automatiquement transformé dans le format suivant (une fois les *braces* ajoutées):

```
{% include list.liquid all=true %}
```

Textuellement parlant, la seule et unique différence entre le code `% include list.liquid all=true %` et le résultat ci-haut est l'ajout des *braces*. Si on insert le code avec les *braces* en dehors d'un *code block*, et donc directement dans le fichier *markdown*, on obtient le résultat suivant:

{% include list.liquid all=true %}

On observe donc que l'utilisation de la directive du code *LIQUID* permet aussi de créer des liens entre les pages dans les fichiers `markdown` autres que les `README.md`. L'effet est toutefois différent alors que les fichiers `README.md` associés à la directive *LIQUID* permettent de définir la naviguation globale du site et que la directive *LIQUID*, une fois insérée dans les autres fichiers `markdown`, permet plutôt des liens entre les pages.  



## Solution Complète

Somme toute, les fichiers `README.md`, à l'execption du fichier à la racine, ont le format suivant:

```
---
source: page.path
sort: 2
---

# Sous-Répertoire 02

% include list.liquid all=true % 		# IMPORTANT: AJOUTER LES BRACES - { } - AUTOUR DU CODE
```

Dans l'exemple ci-haut, nous indiquons donc que le *Sous-Répertoire 02* doit se trouver en deuxième position, à partir d'où il se trouve, et qu'il doit défiler les en-têtes des fichiers automatiquements lorsque l'utilisateur navigue. 

Plus précisément, si nous souhaitons que le *Sous-Répertoire 02* se retrouve sous le *Répertoire 01* (tel que dans l'exemple du présent siteweb), notre structure de fichiers `README.md` correspondra à la suivante:

```
Documentations/
├── README.md	--> À la racine --> N'utilise donc pas les directives ci-haut
├── repertoire-01
│   └── README.md	--> YAML = sort: 1 
└── repertoire-02
    └── README.md	--> YAML = sort: 2
    ├── sous_repertoire-01
    │	└── README.md		--> YAML = sort: 1
    └── sous_repertoire-02
    	└── README.md		--> YAML = sort: 2
```

Pour voir concrètement l'illustration présentée ci-haut, vous référez au présent site en étudiant les codes sources situés sous`./Documentations/repertoire-02`.