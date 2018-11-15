# Jekyll Locale

[![Maintainability](https://api.codeclimate.com/v1/badges/3a28682ac6c6693c4e77/maintainability)][maintainability]

[maintainability]: https://codeclimate.com/github/ashmaroli/jekyll-locale/maintainability

A localization plugin for Jekyll.


## Features

* Exposes a `{{ locale }}` object for your Liquid templates that can be used to "translate" strings in your site easily.
* Depending on configured `mode`, the plugin either generates a *copy* of every page that renders into a HTML file, and
  every document set to be written, and renders them into dedicated urls prepended by a supported locale, or, the plugin
  "processes" only those files placed inside the plugin's configured **`content_dir`** .


## Configuration

The plugin has been *preconfigured* with the following:

```yaml
localization:
  mode       : manual     # Sets the 'handler mode'
  locale     : en-US      # Sets the 'default locale' for the site
  data_dir   : locales    # Sets the base location for *translation data*, within your *site's `data_dir`*.
  content_dir: _locales   # Sets the base location for placing files to be re-rendered. Ignored in "auto mode".
  locales_set: []         # A list of locales the site will re-render files into
  exclude_set: []         # A list of file paths the site will not re-render in "auto" mode.
```

### `data_dir`

This setting defines the base location for *the translation data*, within your site's configured `data_dir`. The value
defaults to `"locales"`. This implies that the plugin looks for "translation data" in either `_data/locales/` or a data
file named `locales`. e.g. `_data/locales.yml` or `_data/locales.json`, etc.

Irrespective of the format, the data should be a Hash table / dictionary of key-value pairs where the main key should
correspond to locale defined in the `locales_set` array or the default locale `en-US`, and the subkeys set to string
values.

### `content_dir`

Ignored in "auto mode", this setting defines the base location for placing "the physical copies" of the canonical pages
and documents. Refer `mode` sub-section below for further details.

The default setting is `_locales`

### `locales_set`

Empty by default, this setting defines what locales to be used when "localizing" a site. Listing a locale (other than
the default locale) will cause the entire site to render for that locale and the default locale while in "auto mode".

### `locale`

Set to `en-US` by default, this setting defines the default locale of the site and will not be prepended to the URL of
the generated files.

### `exclude_set`

Empty by default, this setting defines what files to be *excluded* from being duplicated and re-rendered in the "auto"
mode. Ignored in "manual" mode.

### `mode`

This setting defines the plugin's operation strategy.

When set to **`auto`**, the plugin will initialize a generator that will simply duplicate *every page and document set
to be written to destination*, and re-render them into destination, for every locale listed in the `locales_set:`
array.

This mode will increase your build times in proportion to the total number pages, writable-documents and locales listed
but will result in simply the same canonical output and the canonical url prepended with an iterated locale.

For example, if one were to configure the plugin with `locales_set: ["de", "fr", "en-US", "es"]`, then a file named
`about.md` will result in the following files:
  * `_site/about.html`
  * `_site/de/about.html`
  * `_site/es/about.html`
  * `_site/fr/about.html`

Setting `mode` to any other value will automatically default to `"manual"` which **requires** you to create physical
files in a special directory (as configured under `localization["content_dir"]`) to render localized copies. The
salient features of this mode are:
  * The physical files are handled like any other file in the site, but, they **should partially mirror** their
    counterpart &mdash; **their relative_paths should match**. Additionally, if an original file contains front matter,
    the physical copy should contain front matter as well.
  * The physical files should reside inside sub-folders that match the desired locale. For example, to "localize" a post
    at path `movies/_posts/2018-09-24-hello.markdown` with locale `fr`, you should create the physical copy at path
    `_locales/fr/movies/_posts/2018-09-24-hello.markdown`.
  * Physical copies can render different content and into a different layout, if desired.
  * Physical copies of posts and other writable *documents* can be rendered to a different `slug` by defining the `slug`
    key in the front matter.


## Usage

### Auto Mode

1. Add plugin to the `:jekyll_plugins` group in your Gemfile:

    ```ruby
    group :jekyll_plugins do
      gem "jekyll-locale", "~> 0.1"
    end
    ```

2. Decide what the default locale for your site is going to be, what other locales need to be rendered, and where you'd
  place the translation data files. Then edit your config file to override the default plugin configuration, as required.
  (See above section for default settings). For example, to render the entire site with data for just the custom `fr`
  locale:

    ```yaml
    # _config.yml

    author: John Doe
    localization:
      mode: auto
      locale: fr
    ```

    But if you'd like the entire site to be rendered using both the default `en-US` and custom `fr` locales, then

    ```yaml
    # _config.yml

    author: John Doe
    localization:
      mode: auto
      locales_set: ["fr"] # or ["fr", "en-US"] if you want
    ```

3. Prepare your locale data file(s) with appropriate key-value pairs. For example,

    ```yaml
    # _data/locales.yml

    en:
      home-page: Home
      About Me : About Me
      portfolio: Portfolio
    fr:
      home-page: Accueil
      About Me : À propos
      portfolio: Portefeuille
    ```
    *(Note the use of heterogeneous format of keys..)*

4. Use the data above in a template or a document through the {{ locale }} object. For example,

    ```
    List of link names in my navbar:
    * {{ locale.home_page }}
    * {{ locale.About_Me }}
    * {{ locale.portfolio }}
    ```
    *(Note that the ids passed to the `locale` object contain an underscore instead.)*
    The locale data keys are stored internally as case-sensitive `snake_case` strings. So while `about me` or `about-me`
    will always be stored as `about_me`, `About Me` or `About-me` will be stored as `About_Me` and `About_me` respectively.
    The corresponding value can only be retrieved by using the snake_cased key.

    Additionally, every page can determine its own locale via the `{{ page.locale }} construct. For example,

    ```html
    <!DOCTYPE html>
    <html lang="{{ page.locale }}">
    ```

### Manual Mode

Similar to the *auto mode*, but requires the user to provide physical files in the configured `content_dir` with
sub-directories that match the defined locales.

For example, the following directory structure

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
will result in the generation of just the following files:

```
_site/2018-09-30-hello-world.html
_site/english/its-a-new-day.html
_site/es/2018-09-30-hello-world.html
_site/es/tips/optimized-site.html
_site/fr/2018-09-30-hello-world.html
_site/tips/optimized-site.html
_site/tips/url-filters-in-templates.html
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

For example, `about.md` page with `permalink: /about/` in a site setup to render for locales `["en-US", "es", "fr"]`
and hosted at `http://example.com` will render with the following:

```html
  <link rel="canonical" hreflang="en-US" href="http://example.com/about/" />
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

## Liquid Filters

### `localize_date`

> **Adapted from [`localize` filter](https://github.com/borisschapira/borisschapira.com/blob/e3db4209536ea624466aa516e7feba79410b6719/_plugins/i18n_date_filter.rb#L9-L24) by Boris Schapira**

This plugin provides a `localize_date` filter to aid in localizing valid date strings. It takes an optional parameter to specify the format
of the output string.

The filter technically delegates to the `I18n` module and therefore requires the translation data to follow a certain convention to pass through without errors.

```yaml
date:
  day_names        : # Array of Day names in full. e.g. "Sunday", "Monday", ...
  month_names      : # Array of Month names in full. e.g. "January", "February", ...
  abbr_day_names   : # Array of abbreviations of above Day names. e.g. "Sun", "Mon", ...
  abbr_month_names : # Array of abbreviations of above Month names. e.g. "Jan", "Feb", ...
time:
  am: "am"                              # Placeholder for Ante-Meridian
  pm: "pm"                              # Placeholder for Post-Meridian
  formats:                              # A set of predefined strftime formats
    default: "%B %d, %Y %l:%M:%S %p %z" # Used by default if no other `format` has been specified.
    # my_format:                        # A valid strftime format of your choice.
                                        #   Usage: {{ your_date | localize_date: ":my_format" }}
```

#### Requirements

The plugin also places a few conventions to streamline usage:
* All datetime data should be encompassed under a `locale_date` key for each locale except the default locale, for which, the datetime data has been set by default. But you're free to *redefine* it when necessary.
* The array of names are filled in by default using values defined in Ruby's `Date` class.
* The array of full day names and full month names have `nil` as the first entry. So locales for non-English languages should have `nil` as the first entry. (In YAML, null list item can be written as simply `~`)
* The optional parameter for the filter, `format` should either be a string that corresponds to the symbol of the `formats` subkey (e.g. `":default"`) or a valid `strftime` format.


### `locale_url`

This filter aids in generating a URL string based on the current locale and delegates internally to Jekyll's `relative_url` to take the site's `baseurl` under consideration.

If a non-string object is passed as the argument, the filter ignores it and proceeds to generate an output for an empty string.
If an absolute URL is provided, then it is returned as is.

#### Usage

```ruby
{{ '//foobar//' | locale_url }}
  # => "/foobar/"         # when current locale equals default locale
  # => "/fr/foobar/"      # when current locale equals "fr"
  # => "/fr/blog/foobar"  # when current locale equals "fr" and baseurl equals "blog"

{{ 'http://foobar//' | locale_url }}
  # => "http://foobar//"  # when current locale equals default locale
  # => "http://foobar//"  # when current locale equals "fr"
  # => "http://foobar//"  # when current locale equals "fr" and baseurl equals "blog"
```
