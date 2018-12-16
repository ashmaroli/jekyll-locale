---
permalink: /modes/manuel/
title: Mode Manuel
translators:
  - name: DirtyF
    link: https://github.com/DirtyF
---

Les principales fonctionnalités de ce mode sont :
  * les fichiers présents seront traités comme n'importe quel autre fichier du site mais ils  devront **refléter en partie
    l'arborescence** de la langue par défaut.
  * si le fichier d'origine contient du front matter, alors sa version localisée aussi.
  * Une copie peut avoir un contenu distinct et utiliser un layout distinct si besoin.
  * les versions localisées des articles ou de tout autre document peuvent utiliser un slug différent en personnalisant
    la clé `slug` dans l'entête front matter.

En mode manuel, tous les sous-dossiers et fichiers présents dans le répertoire `content_dir` seront traités lors de
la génération du site.

Par défaut ce dossier `_locales` se trouve à la racine. Ainsi pour l'arborescence suivante :

```
.
├── _config.yml
├── _locales
|  ├── es
|  |  ├── tips/
|  |  |  └── optimized-site.md
|  |  ├── _posts/
|  |  ├──└── 2018-09-30-hello-world.md
|  ├── fr
|  |  ├── _posts/
|  └──└──└── 2018-09-30-hello-world.md
├── _posts
|  └── 2018-09-30-hello-world.md
├── english
|  └── its-a-new-day.md
├── tips
|  ├── optimized-site.md
└──└── url-filters-in-templates.md
```

les fichiers suivants seront générés dans le dossier de destination :

```
_site/2018-09-30-hello-world.html
_site/english/its-a-new-day.html
_site/es/2018-09-30-hello-world.html
_site/es/tips/optimized-site.html
_site/fr/2018-09-30-hello-world.html
_site/tips/optimized-site.html
_site/tips/url-filters-in-templates.html
```

#### Pré-requis

* Les fichiers doivent être regroupés dans un sous-dossier de premier niveau qui correspond à la locale souhaitée. Par exemple
  pour générer une version d'un article qui se trouve dans `movies/_posts/2018-09-24-hello.markdown` dans la langue `fr`, vous
  devez créer une copie dans `_locales/fr/movies/_posts/2018-09-24-hello.markdown`.

* Chaque page traduite doit se trouver **au même endroit** que dans l'arborescence du site par défaut, elle doit également avoir
  **le même nom** que le fichier par défaut.

  Par exemple si le fichier par défaut se nomme `about.md`, la traduction en français devra se trouver dans
  `_locales/fr/about.md` &mdash; et non dans `_locales/fr/a-propos.md`.
  Vous pouvez définir une URL personnalisée à l'aide des variables `permalink` ou `slug` dans le front matter.

* **Les fichiers doivent exister dans la langue par défaut.**

  Le fichier `_locales/fr/about.md` sera pris en compte **si et seulement si** le fichier `about.md` existe.
