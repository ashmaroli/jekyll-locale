---
title: Utilisation avancée
permalink: /utilisation/avancee/
translators:
  - name: DirtyF
    link: https://github.com/DirtyF
---

## Configuration des méta-données de langues

<div>
  <blockquote>
    <small>
      <em>
        Adaptaté d'une
        <a href="https://github.com/jekyll/jekyll/pull/7240#issuecomment-422914818">
          suggestion</a> de @letrastudio
      </em>
  </small>
</blockquote>
</div>

La méta-donnée par défaut pour chaque langue configurée  à l'aide du tableau `locales_set` est un simple identifiant du nom de
la langue.

Il est cependant possible de définir des méta-données supplémentaires en modifiant quelque peu les valeurs de `locales_set` :

```yaml
localization:
  locale: en-US
  locales_set:
    en-US:
      label: English
      dir: ltr
      img: /assets/img/en-US.png
    fr-FR:
      label: Français
      dir: ltr
      img: /assets/img/fr_FR.jpg
```

Vous êtes libres d'ajouter les clefs de votre choix, rien n'est imposé ou validé par le plugin, à l'exception de l'`id` de
la langue.

Une fois définies, vous pourrez faire appel à ces valeurs dans vos gabarits via `{% raw %}{{ page.locale }}{% endraw %}` :

```html
{%- raw -%}
<a href="#" title="{{ page.locale.label }}">
  <img src="{{ page.locale.img | relative_url }}" />
</a>
{% endraw %}
```

## Relier les pages avec hreflangs

Chaque page de langue générée possède une relation avec la page de la langue par défaut et celles disponibles dans les autres
langues (pour les sites en trois langues ou plus).
C'est une bonne pratique SEO de lister les alternatives d'une page dans d'autres langues dans les méta-données d'une page.

Pour en informer les moteurs de recherche, il vous suffit d'ajouter dans la balise `head` le code suivant :

```html
{% raw %}{% for item in page.hreflangs %}
  <link rel="alternate" hreflang="{{ item.locale.id }}" href="{{ item.url | absolute_url }}" />
{% endfor %}{% endraw %}
```

Par exemple, pour une page `about.md` en anglais américain par défaut avec la propriété `permalink: /about/` d'un site trilingue
configuré avec `["en-US", "es", "fr"]` ayant pour URL `http://example.com`, cela va générer le code HTML suivant :

```html
  <link rel="alternate" hreflang="en-US" href="http://example.com/about/" />
  <link rel="alternate" hreflang="es" href="http://example.com/es/about/" />
  <link rel="alternate" hreflang="fr" href="http://example.com/fr/about/" />
```

Le même code HTML sera généré pour toutes les versions "localisées" de la page `about.md`.

## Ajouter un menu de langues

Il est possible de lister les différentes versions d'une page traduite à l'aide de `page.locale_siblings`:

```html
<ul>
  {% raw %}{% for ref in page.locale_siblings %}
    <li><a href="{{ ref.url | relative_url }}">{{ ref.locale.id }}</a></li>
  {% endfor %}{% endraw %}
</ul>
```

*Si vous avez défini des méta-données supplémentaires dans votre configuration, vous pouvez également y accéder dans
ce contexte.*

```html
<!-- Pour chaque langue une propriété `label` a été définie dans la configuration  -->

<ul>
  {% raw %}{% for ref in page.locale_siblings %}
    <li><a href="{{ ref.url | relative_url }}">{{ ref.locale.label }}</a></li>
  {% endfor %}{% endraw %}
</ul>
```
