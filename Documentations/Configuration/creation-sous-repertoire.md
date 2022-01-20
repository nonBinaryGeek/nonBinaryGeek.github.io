---
title: Création de sous-répertoires
sort: 1
---

# Création de sous-répertoires

## Arborescance

Le présent fichier se trouve sous le répertoire `/repertoire-01` représenté comme suit:

```SH
repertoire-01/
│
├── creation-sous-repertoire.md 					# FICHIER EN COURS
├── README.md
│
├── sous_repertoire-01
│   └── README.md
│
└── sous_repertoire-02
    └── README.md
```

Les solutions de la présente page reflète exactement cette arborescance.

Ainsi, on obtient pour résultat une définition claire permettant de subdiviser nos documents et offrant la possibilité d'introduire une organisation complète de notre siteweb. Plus précisément, on introduit ici la possibilité de créer des répertoires et sous-répertoires, puis de les ordonner comme bon nous semble.

## Création de répertoire et de sous-répertoires

Concrètement, la première étape consiste à créer les *directories* que nous désirons utiliser comme répertoire pour notre site. On  exécute la commande `mkdir` pour les créer. 

Exemple:

```shell
_:~$ pwd
/home/phil/github/jekyll-modele

_:~$ ls -ldG */
drwxr-xr-x 2 phil 4096 Jan 11 16:05 About/
drwxr-xr-x 5 phil 4096 Jan 11 13:39 Documentations/
drwxr-xr-x 3 phil 4096 Jan 11 13:39 Librairie/
drwxr-xr-x 7 phil 4096 Jan 11 13:39 _includes/
drwxr-xr-x 3 phil 4096 Jan 11 13:39 _layouts/
drwxr-xr-x 4 phil 4096 Jan 11 13:39 _sass/
drwxr-xr-x 6 phil 4096 Jan 11 16:56 _site/
drwxr-xr-x 5 phil 4096 Jan 11 13:39 assets/

_:~$ cd Documentations/

_:~$ mkdir -p repertoire-01/{sous_repertoire-01,sous_repertoire-02}

_:~$ ls repertoire-01/
sous_repertoire-01	sous_repertoire-02

```



Finalement, afin d'organiser les dîts sous-répertoires, nous utilisons les fichiers `README.md`. Ceux-ci servent d'index, et se retrouvent dans **CHAQUE** répertoire et sous-répertoire de notre siteweb.



## README.md

Les fichiers `README.md` ont donc besoins de 3 composantes essentielles afin d'organiser notre site:

- [Directive `YAML Front Matter`](#yaml-front-matter)
- [Titre](#titre)
- [Directive `LIQUID`](#directive-liquid)

> note: Les fichiers `README.md` peuvent être compris comme l'équivalent des fichiers `index.html` pour les connaisseurs de ce standard web. Dans les faits, les `README.md` de notre site sont convertis en `index.html` une fois que l'on active **Jekyll**.



## YAML Front Matter

**Organisation des répertoires**

À l'exception du premier fichier `README.md` qui représente la *landing page* de notre site, **TOUS** les fichiers `README.md` doivent avoir la directive `YAML Front Matter` suivante afin de faire acte d'index:

```yaml
---
source: page.path
sort: _$
---
```

Celle-ci permet d'indiquer la source et, comme pour les fichiers, l'ordre de naviguation, en remplaçant `_$` par une valeur numérique , -e.g `2` si l'on souhaite que le répertoire où nous sommes soit le 2e .

> note: la source `page.path` est une valeur réelle et s'inscrit dans les fichiers `README.md` de notre répertoire principale. Dans le présent siteweb, on parle du répertoire `Documentations` en adressant le répertoire principal. Vous remarquerez que l'indicatif `source: page.path` est présent dans **TOUS** les `README.md` de **TOUS** les `/répertoires` et `/sous-répertoires` présent **SOUS** `./Documentations/`.

**Solution 01**

```plaintext
---
source: page.path
sort: 2
---
```



## Titre

**Nommer un répertoire**

Ensuite, on indique simplement le titre du répertoire, tel qu'il apparaîtra sur le siteweb. Afin de préciser un titre dans un fichier `markdown`, nous tappons un dièse -i,e `#`, suivit d'un espace et de notre titre tel que dans l'exemple suivant:

```
# Sous-Répertoire 02
```

**Solution 02**

```
---
source: page.path
sort: 2
---
# Sous-Répertoire 02
```



## Directive LIQUID

**Directive LIQUID dans les fichiers `README.md`**

Afin d'obtenir une mise en page appropriée, notre site est construit à l'aide de fichiers `LIQUID`. Ceux-ci offrent l'avantage de n'occuper qu'une fraction d'espace disque. Utilisant leur propre language, l'explication relative à leur fonctionnement dépasse largement le présent guide et ne sera donc pas abordé.

Ce qui doit être retenu ici est donc simplement la directive suivante enveloppée par des *braces* `{		}`:

<div class="language-liquid highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p"><a>{</a>%</span><span class="w"> </span><span class="nt">include</span><span class="w"> </span><span class="s2">list.liquid</span><span class="w"> </span><span class="s3">all=true</span><span class="w"> </span><span class="p">%}</span></code></pre></div></div>

Cette directive doit être inscrite dans chaque `README.md` où nous souhaitons indiquer au répertoire que soient défilées les en-têtes des fichiers ainsi que les noms des sous-répertoire. Sans cette directive, **Jekyll** ne génèra pas le contenu des sous-répertoires et des en-têtes.

**Directive LIQUID dans les autre fichiers Markdown**

Si on insert le code avec les *braces* en dehors d'un *code block*, et donc directement dans le fichier *markdown*, on obtient le résultat suivant:

{% include list.liquid all=true %}

On observe donc que l'utilisation de la directive du code *LIQUID* permet aussi de créer des liens entre les pages dans les fichiers `markdown` autres que les `README.md`. L'effet est toutefois différent alors que les fichiers `README.md` associés à la directive *LIQUID* permettent de définir la naviguation globale du site et que la directive *LIQUID*, une fois insérée dans les autres fichiers `markdown`, permet plutôt des liens entre les pages.  



**Solution 03 (finale)**

Somme toute, les fichiers `README.md`, à l'execption du fichier à la racine, ont le format suivant:

<div class="CodeMirror-code" role="presentation" style=""><div class="" style="position: relative;"><pre class=" CodeMirror-line " role="presentation"><span role="presentation" style="padding-right: 0.1px;"><span class="cm-def">---</span></span>
<span role="presentation" style="padding-right: 0.1px;"><span class="cm-atom">source</span><span class="cm-meta">: </span>page.path</span>
<span role="presentation" style="padding-right: 0.1px;"><span class="cm-atom">sort</span><span class="cm-meta">: </span><span class="cm-number">2</span></span>
<span role="presentation" style="padding-right: 0.1px;"><span class="cm-def">---</span></span>
<span role="presentation" style="padding-right: 0.1px;"><span cm-text="" cm-zwsp="">&ZeroWidthSpace;</span></span>
<span role="presentation" style="padding-right: 0.1px;"><span class="cm-comment"># Sous-Répertoire 02</span></span>
<span role="presentation" style="padding-right: 0.1px;"><span class="cm-comment"> </span></span>
<span role="presentation" style="padding-right: 0.1px;"><span class="cm-comment"> <span class="cm-comment">{</span>%</span><span class="w"> </span><span class="nt">include</span><span class="w"> </span><span class="s2">list.liquid</span><span class="w"> </span><span class="s3">all=true</span><span class="w"> </span><span class="p">%}</span></span></pre></div></div>


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