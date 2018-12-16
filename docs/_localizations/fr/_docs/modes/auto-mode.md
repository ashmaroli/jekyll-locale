---
permalink: /modes/auto/
title: Mode automatique
translators:
  - name: DirtyF
    link: https://github.com/DirtyF
---

Le mode automatique va générer des versions locales de **toutes les pages et documents présents** dans le site par défaut.
En d'autres termes, si votre site comporte 10 articles, 3 pages et est configuré pour être traduit dans 3 langues, ce mode
va alors générer (10 + 3) x 3, soit 39 pages web.

Pour empêcher la copie de certains fichiers, vous avez la possibilité d'exclure des dossiers et des fichiers dans la directive
de configuration `localization.exclude_set` :

```yaml
localization:
  mode: auto
  locale: en
  locales_set: ["en", "fr"]
  exclude_set:
    - _posts/2018-10-18-english-only.md
    - _puppies
```

### Conventions

Ce mode a été pensé pour les sites qui veulent avoir des versions _identiques_ pour chaque langue.

En conséquence, ce mode adopte les conventions suivantes :
  * La page traduite possède les mêmes attributs que la page de la langue par défaut, elles possèdent les mêmes attributs `path`,
    `relative_path`, `data`, `content`, etc. Seul l'attribut `url` diffère.
  * Ces attributs ne peuvent donc être modifiés.
  * L'object localisé sera toujours un descendant de `Jekyll::Page`, même si le document d'origine est un post ou un document
    appartenant à une collection.<br>
    Cela signifie qu'un object localisé ne répondra pas forcément à certains attributs de l'objet d'origine (par exemple
    la `date` d'un document)
