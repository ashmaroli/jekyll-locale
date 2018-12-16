---
permalink: /usage/intro/
---

The plugin does not literally translate content. However, it provides the means to output site content in multiple locales and
languages by leveraging the versatility of Jekyll's Data files.

## Locale Data Files

Data files for defining locales should reside in the directory configured as `localization.data_dir` (*Default: `locales`*) which
in turn should reside in the site's `data_dir` (*Default: `_data`*).  
In other words, the default locale data directory is at `./_data/locales`.  
Data files can be of any format supported by Jekyll but should be named according to the configured locales.

**NOTE: Top-level keys are stored internally as case-sensitive "underscore-delimited strings". This means that
`_data/locales/en-US.yml` and `_data/locales/en_US.yml` map to the same locale `en-US`.**

## Templating

A Liquid object `{% raw %}{{ locale }}{% endraw %}` serves as the main interface to this plugin. Technically, this object acts as
an alias for the following:

```html
{%- raw -%}
{% assign current_locale = 'fr' %}
{{ site.data.locales[current_locale] }} <!-- This equals '{{ locale }}' -->
{% endraw %}
```
The plugin sets the "*current locale*" attribute under the hood, automatically in sync with the current page's locale.
Consequently allowing one to *simplify their Liquid templates*:

```html
{%- raw -%}
{{ locale.foo_bar }} <!-- instead of the verbose '{{ site.data.locales[current_locale][foo_bar] }}' -->
{% endraw %}
```

Apart from the `{% raw %}{{ locale }}{% endraw %}` object, the plugin also provides some filters to further ease Liquid
templating.
