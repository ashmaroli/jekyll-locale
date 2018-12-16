---
title: Filtre de localisation de date
permalink: /filtres/localize_date/
translators:
  - name: DirtyF
    link: https://github.com/DirtyF
---

<div>
  <blockquote>
    <small>
      <em>
        Adapté du
        <a href="https://github.com/borisschapira/borisschapira.com/blob
          /e3db4209536ea624466aa516e7feba79410b6719/_plugins/i18n_date_filter.rb#L9-L24">
          filtre de localisation</a> de @borisschapira
      </em>
  </small>
</blockquote>
</div>


Le filtre `localize_date` vous aide à localiser des dates. Optionnellement, il prend en paramètre le format de sortie désiré.

Le filtre reprend les conventions du module `i18n`, que vous devez donc respecter :

```yaml
date:
  day_names        : # Tableau des jours de la semaine, ex: "Lundi", "Mardi", etc.
  month_names      : # Tableau des mois de l'année, ex: "Janvier", "Février", etc.
  abbr_day_names   : # Tableau des jours de la semaine, forme abrégée, ex: "Lun", "Mar", etc.
  abbr_month_names : # Tableau des mois de l'année, forme abrégée, ex: "Jan", "Fév", etc.
time:
  am: "am"                              # Placeholder pour Ante-Meridian
  pm: "pm"                              # Placeholder pour Post-Meridian
  formats:                              # Liste des formats préféfinis
    default: "%B %d, %Y %l:%M:%S %p %z" # Valeur par défault si aucun autre `format` n'est spécifié
    # my_format:                        # Un format valide strftime de votre choix.
                                        #   Usage : {% raw %}{{ votre_date | localize_date: ":my_format" }}{% endraw %}
```

#### Conventions

Avec ce plugin, vous devez respecter les conventions suivantes :

* Toutes les paramètres de localisation de date peuvent être définis à l'aide de la clé `locale_date` dans les fichiers
  de données de chaque langue. La langue par défaut est déjà pré-configurée mais vous êtes libre de redéfinir ses valeurs
  si besoin.
* Le tableau des noms est rempli par défaut avec les valeurs de la classe `date` de Ruby.
* Le premier élément des listes des noms complets des jours et des mois pour les langues non-anglo-saxonnes doit être `nil`.
  En YAML, on peut aussi utiliser `~` pour désigner la valeur `nil`.
* Le paramètre optionnel `format` du filtre est soit une chaîne de caractères qui correspond à la valeur de la sous-clef
  de `formats` (ex: `":default"`) soit une valeur `strftime` valide.
