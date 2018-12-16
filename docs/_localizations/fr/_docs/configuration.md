---
permalink: /configuration/
translators:
  - name: DirtyF
    link: https://github.com/DirtyF
---

Le plugin est *pré-configuré* avec les valeurs suivantes :

```yaml
localization:
  mode       : manual    # mode à utiliser ('auto' ou 'manual')
  locale     : en-US     # langue/région par défaut du site (ex: 'en', 'fr' ou 'en-GB', 'fr-CA')
  data_dir   : locales   # emplacement des données de traduction dans le dossier `data_dir` de Jekyll (défaut: `_data/locales`).
  content_dir: _locales  # emplacement de l'ensemble des fichiers traduits à générer. Ignoré en mode automatique.
  locales_set: []        # liste des langues à générer
  exclude_set: []        # liste des chemins à exclure de la génération en mode automatique.
```

* ### `data_dir`

  Ce paramètre précise l'emplacement des données de traduction des chaînes de caractères dans le dossier de Jekyll qui abrite
  les données.

  Par défaut ce dossier est nommée `locales`. Cela veut dire que le plugin ira chercher les fichiers de traduction de chaque
  langue dans `_data/locales/` ou dans un fichier unique de données nommé `locales`, par exemple `_data/locales.yml` ou
  `_data/locales.json`, etc.

  Les données doivent être agencées sous forme de dictionnaire de paires clé-valeur, dans lequel la clef principale doit
  correspondre à la locale définie dans le tableau `locales_set` ou à la locale par défaut `en-US`; les sous-clefs désignent
  ensuite des chaînes de caractères.

  #### Exemple de fichier unique avec plusieurs langues :

  ```yaml
  # ------------------------
  # _data/locales.yml
  # ------------------------

  # English US
  en-US:
    greeting: Hello
    user: user
    navigation:
      home: Home
      about: About
      contact: Contact

  # French
  fr-FR:
    greeting: Bonjour
    user: utilisateur
    navigation:
      home: Accueil
      about: À propos
      contact: Contact
  ```

  #### Exemples de fichiers de données dédiés à une seule langue

  ```yaml
  # ------------------------
  # _data/locales/en-US.yml
  # ------------------------
  #
  # English US
  greeting: Hello
  user: user
  navigation:
    home: Home
    about: About
    contact: Contact
  ```

  ```yaml
  # ------------------------
  # _data/locales/fr-FR.yml
  # ------------------------
  #
  # French
  greeting: Bonjour
  user: utilisateur
  navigation:
    home: Accueil
    about: À propos
    contact: Contact
  ```


* ### `content_dir`

  En mode manuel, vos fichiers et documents traduits sont à placer dans le dossier `_locales` situé à la racine du projet.

  Ce paramètre est ignoré en mode automatique.
  Reportez-vous à la sous-section `mode` ci-dessous pour plus de détails.

* ### `locales_set`

  Ce paramètre permet de définir les différentes langues et paramètres régionaux supportés, outre la locale par défaut. Toute
  locale ajoutée dans ce tableau sera entraînera une génération automatique du rendu de cette langue en "mode auto".

  Vous pouvez aussi écrire cette option de configuration sous forme d'objet avec des paires clé-valeurs, pour déclarer
  les identifiants de votre choix et leur affecter des valeurs :

  ```yaml
  localization:
    locales_set:
      en:
        label: English
        img: img/english.png
      fr:
        label: Français
        img: img/french.png
  ```

  _La clef `id` est une valeur réservée par le plugin, vous ne pouvez pas l'utiliser_.

* ### `locale`

  `en-US` par default, ce paramètre permet de définir la langue par défaut du site. La langue par défaut ne sera pas insérée
  dans les URLs du site.

* ### `exclude_set`

  Ignoré en mode "manuel", ce paramètre permet de définir les fichiers à exclure de la copie lorsque le mode "auto" est activé.

* ### `mode`

  Ce paramètre vous permet de choisir entre deux stratégies de traitement des fichiers par le plugin.

  Lorsqu'il est défini à **`auto`**, le plugin va initialiser une génération, qui va générer, pour chaque locale présente dans le
  tableau `locales_set`, *toutes les pages et les documents dans le dossier de destination*.

  Ce mode fera donc varier vos temps de génération en fonction du nombre total de pages et du nombre de locales à générer.
  Les URLs des différentes langues différeront simplement par le code de langue inséré dans l'URL.

  Par exemple, si on configure le plugin avec les valeurs suivantes pour `locales_set: ["de", "fr", "en-US", "es"]`, alors
  un fichier nommé `about.md` entraînera la création des fichiers suivants :
    * `_site/about.html`
    * `_site/de/about.html`
    * `_site/es/about.html`
    * `_site/fr/about.html`

  Si le mode n'est pas défini à `auto` alors c'est le mode "manuel" qui sera actif, et ce sera à vous de créer les fichiers dans
  le répertoire défini dans 'content_dir'.

  Reportez-vous à la section sur la [configuration du mode manuel](../modes/manuel/) pour plus de détails.
