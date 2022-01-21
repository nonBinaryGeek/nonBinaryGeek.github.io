---
source: page.path
sort: 5
title: Syntaxe Markdown
---

{% include list.liquid all=true %}

# Syntaxe Markdown

## Codes

### Code simple

### Blocs de codes

La syntaxe de base de Markdown vous permet de créer [des blocs de code ](https://www.markdownguide.org/basic-syntax#code-blocks)en indentant les lignes de quatre espaces ou d'une tabulation. Si vous  trouvez cela gênant, essayez d'utiliser des blocs de code clôturés. En  fonction de votre processeur ou éditeur Markdown, vous utiliserez trois backticks `( ``` )`



````
```
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```
````

La sortie rendue ressemble à ceci : 

```
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```

### Mise en évidence de la syntaxe

Pour ajouter une coloration syntaxique, spécifiez une langue à côté des backticks avant le bloc de code clôturé.

````
```json
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```
````

La sortie rendue ressemble à ceci : 

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```

## En-Têtes

| Markdown                 | HTML                        | Rendered Output |
| ------------------------ | --------------------------- | --------------- |
| `# Heading level 1`      | `<h1>Heading level 1</h1>`  | Heading level 1 |
| `## Heading level 2`     | `<h2>Heading level 2</h2>`  | Heading level 2 |
| `### Heading level 3`    | `<h3>Heading level 3</h3>`  | Heading level 3 |
| `#### Heading level 4`   | `<h4>Heading level  4</h4>` | Heading level 4 |
| `##### Heading level 5`  | `<h5>Heading level 5</h5>`  | Heading level 5 |
| `###### Heading level 6` | `<h6>Heading level 6</h6>`  | Heading level 6 |

### Syntaxe alternative

| Markdown                         | HTML                       | Rendered Output |
| -------------------------------- | -------------------------- | --------------- |
| `Heading level 1===============` | `<h1>Heading level 1</h1>` | Heading level 1 |
| `Heading level 2---------------` | `<h2>Heading level 2</h2>` | Heading level 2 |

**Gras / Bold**

| Markdown                     | HTML                                      | Rendered Output            |
| ---------------------------- | ----------------------------------------- | -------------------------- |
| `I just love **bold text**.` | `I just love <strong>bold text</strong>.` | I just love **bold text**. |
| `I just love __bold text__.` | `I just love <strong>bold text</strong>.` | I just love **bold text**. |
| `Love**is**bold`             | `Love<strong>is</strong>bold`             | Love**is**bold             |

### Italique

| Markdown                               | HTML                                          | Rendered Output                      |
| -------------------------------------- | --------------------------------------------- | ------------------------------------ |
| `Italicized text is the *cat's meow*.` | `Italicized text is the <em>cat's meow</em>.` | Italicized text is the *cat’s meow*. |
| `Italicized text is the _cat's meow_.` | `Italicized text is the <em>cat's meow</em>.` | Italicized text is the *cat’s meow*. |
| `A*cat*meow`                           | `A<em>cat</em>meow`                           | A*cat*meow                           |

### Gras et italique

Pour mettre en évidence du texte en gras et en italique en même temps, ajoutez trois astérisques ou traits de soulignement avant et après un mot ou une phrase. Pour mettre en gras et en italique le milieu d'un mot pour le souligner, ajoutez trois astérisques sans espaces autour des lettres. 

| Markdown                                  | HTML                                                         | Rendered Output                          |
| ----------------------------------------- | ------------------------------------------------------------ | ---------------------------------------- |
| `This text is ***really important***.`    | `This text is <strong><em>really important</em></strong>.`   | This text is ***really important\***.    |
| `This text is ___really important___.`    | `This text is <strong><em>really important</em></strong>.`   | This text is ***really important\***.    |
| `This text is __*really important*__.`    | `This text is <strong><em>really important</em></strong>.`   | This text is ***really important\***.    |
| `This text is **_really important_**.`    | `This text is <strong><em>really important</em></strong>.`   | This text is ***really important\***.    |
| `This is really***very***important text.` | `This is really<strong><em>very</em></strong>important text.` | This is really***very\***important text. |

## Citations en bloc

Pour créer un bloc de citation, ajoutez un `>`devant un paragraphe. 

```
> Dorothy la suivit à travers de nombreuses belles pièces de son château.
```

La sortie rendue ressemble à ceci : 

> Dorothy la suivit à travers de nombreuses belles pièces de son château. 

### Blocs de citations avec plusieurs paragraphes 

Les blocs de citations peuvent contenir plusieurs paragraphes.  Ajouter un `>`sur les lignes vides entre les paragraphes. 

```
> Dorothy la suivit à travers de nombreuses belles pièces de son château. 
>
> La sorcière lui ordonna de nettoyer les marmites et les bouilloires, de balayer le sol et d'alimenter le feu avec du bois. 
```

La sortie rendue ressemble à ceci : 

> Dorothy la suivit à travers de nombreuses belles pièces de son château. 
>
> La sorcière lui ordonna de nettoyer les marmites et les bouilloires, de balayer le sol et d'alimenter le feu avec du bois. 

### Citations imbriquées

Les blocs de citations peuvent être imbriqués.  Ajouter un `>>`devant le paragraphe que vous souhaitez imbriquer. 

Les blocs de citations peuvent être imbriqués.  Ajouter un `>>`devant le paragraphe que vous souhaitez imbriquer. 

```
> Dorothy la suivit à travers de nombreuses belles pièces de son château. 
>
>> La sorcière lui ordonna de nettoyer les marmites et les bouilloires, de balayer le sol et d'alimenter le feu avec du bois. 
```

La sortie rendue ressemble à ceci : 

> Dorothy la suivit à travers de nombreuses belles pièces de son château. 
>
> > La sorcière lui ordonna de nettoyer les marmites et les bouilloires, de balayer le sol et d'alimenter le feu avec du bois. 

## Listes

Vous pouvez organiser les éléments en listes ordonnées et non ordonnées. 

### Liste à points

- Bullet list
  - Nested bullet
    - Sub-nested bullet etc
- Bullet list item 2

```
 Markup : * Bullet list
              * Nested bullet
                  * Sub-nested bullet etc
          * Bullet list item 2

-OR-

 Markup : - Bullet list
              - Nested bullet
                  - Sub-nested bullet etc
          - Bullet list item 2 
```

### Liste à chiffres

1. A numbered list
   1. A nested numbered list
   2. Which is numbered
2. Which is numbered

```
 Markup : 1. A numbered list
              1. A nested numbered list
              2. Which is numbered
          2. Which is numbered
```



## Autres

### Ligne Horizontale

------

```
Markup :  - - - -
```



### Images

[![picture alt](https://camo.githubusercontent.com/2d4a8f835fecf8bee4caa27930ddd7c012ea4bb8023909ee093ee9f5a327ca06/687474703a2f2f7669612e706c616365686f6c6465722e636f6d2f32303078313530)](https://camo.githubusercontent.com/2d4a8f835fecf8bee4caa27930ddd7c012ea4bb8023909ee093ee9f5a327ca06/687474703a2f2f7669612e706c616365686f6c6465722e636f6d2f32303078313530)

```
Markup : ![picture alt](http://via.placeholder.com/200x150 "Title is optional")
```

### Lien vers une partie spécifique de la page

[Go To TOP](https://github.com/tchapi/markdown-cheatsheet#TOP)

```
Markup : [text goes here](#section_name)
          section_title<a name="section_name"></a>    
```

