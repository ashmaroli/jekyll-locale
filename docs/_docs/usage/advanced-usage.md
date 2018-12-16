---
permalink: /usage/advanced/
---

## Configuring Locale Metadata

<div>
  <blockquote>
    <small>
      <em>
        Adapted from a
        <a href="https://github.com/jekyll/jekyll/pull/7240#issuecomment-422914818">
          suggestion</a> by @letrastudio
      </em>
  </small>
</blockquote>
</div>

The default metadata for every locale configured via the `locales_set` array is simply an `id` referencing the locale name.
However, you may define custom metadata for your locales by slightly altering the `locales_set` setting:

```yaml
localization:
  locale: en-US
  locales_set:
    en-US:
      label: English
      dir: ltr
      img: /assets/img/en-US.png
    fr-FR:
      label: Francais
      dir: ltr
      img: /assets/img/fr_FR.jpg
```

*The metadata keys and values may be whatever your want it to be. It is not validated by the plugin.  
However, you will not be able to change the `id` attribute.*

Once configured properly, you will be able to reference them via `{% raw %}{{ page.locale }}{% endraw %}` in your templates:

```html
{%- raw -%}
<a href="#" title="{{ page.locale.label }}">
  <img src="{{ page.locale.img | relative_url }}" />
</a>
{% endraw %}
```

## Setting up hreflangs

Each generated locale page is aware of its canonical page and its sibling locale page (for sites rendering three or more locales)
and can be used to render meta tags for optimal SEO.

Adding the following Liquid construct inside your `<head />` tag will render the markup that tells the crawler how the pages are
related to each other:

```html
{% raw %}{% for item in page.hreflangs %}
  <link rel="alternate" hreflang="{{ item.locale.id }}" href="{{ item.url | absolute_url }}" />
{% endfor %}{% endraw %}
```

For example, `about.md` page with `permalink: /about/` in a site setup to render for locales `["en-US", "es", "fr"]` with `en-US`
as the default locale and hosted at `http://example.com` will render with the following hreflangs:

```html
  <link rel="alternate" hreflang="en-US" href="http://example.com/about/" />
  <link rel="alternate" hreflang="es" href="http://example.com/es/about/" />
  <link rel="alternate" hreflang="fr" href="http://example.com/fr/about/" />
```
Likewise, each of the *localized version* of the About page will also render with the **same hreflangs set as above**.


## Setting up a Locale Switcher

Since hreflang data includes a self-referencing entry, iterating through `page.hreflangs` will result in a confusing linkset.
Instead a subset of the hreflang data is available as `page.locale_siblings`:

```html
<ul>
  {% raw %}{% for ref in page.locale_siblings %}
    <li><a href="{{ ref.url | relative_url }}">{{ ref.locale.id }}</a></li>
  {% endfor %}{% endraw %}
</ul>
```

*If you've set up metadata for your locales, you may also reference a property here instead.*

```html
<!--
    locales have been configured with a `label` property for each locale in
    the config file
-->

<ul>
  {% raw %}{% for ref in page.locale_siblings %}
    <li><a href="{{ ref.url | relative_url }}">{{ ref.locale.label }}</a></li>
  {% endfor %}{% endraw %}
</ul>
```
