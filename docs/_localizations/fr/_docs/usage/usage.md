---
title: Utilisation
permalink: /utilisation/intro/
translators:
  - name: DirtyF
    link: https://github.com/DirtyF
---

Ce plugin ne s'occupe pas de la traduction de vos contenus, il vous permet toutefois de générer l'arborescence de votre site dans
plusieurs langues et paramètres régionaux, en tirant parti de la polyvalence des fichiers de données de Jekyll.

## Traduction des chaînes de caractères

Les traductions des chaînes de caractères sont stockées dans des fichiers de données, par défaut dans le dossier
`_data/locales/`.

Les fichiers de données peuvent être dans n'importe quel format supporté par Jekyll (YAML, JSON, CSV) et doivent être nommés en
fonction des clés utilisées dans la configuration des langues.

Pour un site configuré avec les langues `en-US`, 'de', 'es', 'fr', on aura donc les fichiers de traductions suivants :

```
_data/locales/en-US.yml
_data/locales/de.yml
_data/locales/es.yml
_data/locales/fr.yml
```

Attention, les codes de langue sont sensibles à la casse, le tiret du bas peut être utilisé comme séparateur.
`_data/locales/en-US.yml` et `_data/locales/en_US.yml` feront référence à la même langue `en-US`.

## Gabarits

Ce plugin met à disposition l'objet Liquid `{% raw %}{{ locale }}{% endraw %}`, un raccourci syntaxique qui donnera le même
résultat que le code suivant :

```html
{%- raw -%}
{% assign current_locale = 'fr' %}
{{ site.data.locales[current_locale] }} <!-- la valeur de '{{ locale }}' -->
{% endraw %}
```

Le plugin récupère automatiquement la langue utilisée sur la page courante.
Ainsi votre code Liquid sera moins verbeux :

```html
{%- raw -%}
{{ locale.foo_bar }} <!-- moins verbeux que '{{ site.data.locales[current_locale][foo_bar] }}' -->
{% endraw %}
```

Outre l'objet `{% raw %}{{ locale }}{% endraw %}`, le plugin fournit également quelques [filtres](../filtres/prefix_locale/)
Liquid bien [pratiques](../filtres/localize_date/).
