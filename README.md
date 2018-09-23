# Jekyll Locale

A localization plugin for Jekyll.


## Features

* Exposes a `{{ locale }}` object for your Liquid templates. The *payload* for this object is derived from data files and
  has been *preconfigured* with the following:

    ```yaml
    locale      : en       # Sets the 'default locale' for the site
    locales_dir : locales  # Sets the base location for translation data, within your configured `data_dir`.
                           # Therefore, this setting implies that the plugin looks for translation data in
                           # either `_data/locales/` or a data file named `locales`. e.g. `_data/locales.yml`.
    ```
  Ergo, `{{ locale }}` is simply a *syntactic sugar* for the construct `{{ site.data[site.locales_dir][site.locale] }}`.
* Generates a *copy* of every page that renders into a HTML file, and every document set to be written, and renders
  them into dedicated urls prepended by a supported locale.
  For example, if one were to configure the plugin with `available_locales: ["de", "fr", "en", "es"]`, then a file
  named `about.md` with custom permalink set to `/about/` will result in the following files:
    * `_site/about/index.html`
    * `_site/de/about/index.html`
    * `_site/es/about/index.html`
    * `_site/fr/about/index.html`


## Usage

1. Add plugin to the `:jekyll_plugins` group in your Gemfile:

    ```ruby
    group :jekyll_plugins do
      gem "jekyll-locale", "~> 0.1"
    end
    ```

2. Decide what the default locale for your site is going to be, what other locales need to be rendered, and where you'd
  place the translation data files. Then edit your config file to override the default plugin configuration, as required.
  (See above section for default settings). For example, to render the site with data for just the custom `fr` locale:

    ```yaml
    # _config.yml

    author: John Doe
    locale: "fr"
    ```

    But if you'd like the site to be rendered using both the default `en` and custom `fr` locales, then

    ```yaml
    # _config.yml

    author: John Doe
    available_locales: ["fr"] # or ["fr", "en"] if you want
    ```

3. Prepare your locale data file(s) with appropriate key-value pairs. For example,

    ```yaml
    # _data/locales.yml

    en:
      home-page: Home
      about me : About Me
      portfolio: Portfolio
    fr:
      home-page: Accueil
      about me : À propos
      portfolio: Portefeuille
    ```
    *(Note the use of heterogeneous format of keys..)*

4. Use the data above in a template or a document through the {{ locale }} object. For example,

    ```
    List of link names in my navbar:
    * {{ locale.home_page }}
    * {{ locale.about_me }}
    * {{ locale.portfolio }}
    ```
    *(Note that the ids passed to the `locale` object contain an underscore instead.)*
    The locale data keys are stored internally as `snake_case` strings. So `about me` or `about-me` will always be stored
    as `about_me` internally and the corresponding value can only be retrieved by using the snake_cased key.

    Additionally, every page can determine its own locale via the `{{ page.locale }} construct. For example,

    ```html
    <!DOCTYPE html>
    <html lang="{{ page.locale }}">
    ```


## Advanced Usage

Each generated locale page is aware of its canonical page and its sibling locale page (for sites rendering three or more
locales) and can be used to render meta tags for optimal SEO.

Adding the following Liquid construct inside your `<head />` tag will render the markup that tells the crawler how the
pages are related to each other:

```html
{% for item in page.hreflangs %}
  <link rel="{{ item.relation }}" hreflang="{{ item.locale }}" href="{{ item.url | absolute_url }}" />
{% endfor %}
```

For example, `about.md` page with `permalink: /about/` in a site setup to render for locales `["en", "es", "fr"]`
and hosted at `http://example.com` will render with the following:

```html
  <link rel="canonical" hreflang="en" href="http://example.com/about/" />
  <link rel="alternate" hreflang="es" href="http://example.com/es/about/" />
  <link rel="alternate" hreflang="fr" href="http://example.com/fr/about/" />
```

*The above use of `rel="canonical"` with `hreflang` attribute is generally frowned upon and not recommended by Google.* </br>
Instead filter out the canonical url from the for-loop, and render the canonical link as an `alternate` with the
`x-default` tag, along with a self-referencing declaration:

```html
  <link rel="alternate" hreflang="{{ page.locale }}" href="{{ page.url | absolute_url }}" />
{% for item in page.hreflangs %}
{% unless item.relation == 'canonical' %}
  <link rel="{{ item.relation }}" hreflang="{{ item.locale }}" href="{{ item.url | absolute_url }}" />
{% endunless %}
{% endfor %}
  <link rel="alternate" hreflang="x-default" href="{{ page.url | absolute_url }}" />
```
