---
permalink: /configuration/
---

The plugin has been *preconfigured* with the following:

```yaml
localization:
  mode       : manual    # Sets the 'handler mode'
  locale     : en-US     # Sets the 'default locale' for the site
  data_dir   : locales   # Sets the base location for translation data, within your site's `data_dir`.
  content_dir: _locales  # Sets the base location for placing files to be re-rendered. Ignored in auto mode.
  locales_set: []        # A list of locales the site will re-render files into
  exclude_set: []        # A list of file paths the site will not re-render in "auto" mode.
```

* ### `data_dir`

  This setting defines the base location for *the translation data*, within your site's configured `data_dir`.

  The value defaults to `"locales"`. This implies that the plugin looks for "translation data" in either
  `_data/locales/` or a data file named `locales`. e.g. `_data/locales.yml` or `_data/locales.json`, etc.

  Irrespective of the format, the data should be a Hash table / dictionary of key-value pairs where the main key should
  correspond to locale defined in the `locales_set` array or the default locale `en-US`, and the subkeys set to string
  values.

  #### Example of a single data file corresponding to multiple locales

  ```yaml
  # --------------------------------------------------
  # _data/locales.yml
  # --------------------------------------------------

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
    user: l' usager
    navigation:
      home: Accueil
      about: À propos
      contact: Contacter
  ```
  <br>

  #### Example of dedicated data files corresponding to a single locale

  ```yaml
  # --------------------------------------------------
  # _data/locales/en-US.yml
  # --------------------------------------------------
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
  # --------------------------------------------------
  # _data/locales/fr-FR.yml
  # --------------------------------------------------
  #
  # French
  greeting: Bonjour
  user: l' usager
  navigation:
    home: Accueil
    about: À propos
    contact: Contacter
  ```

* ### `content_dir`

  Ignored in "auto mode", this setting defines the base location for placing "the physical copies" of the canonical pages
  and documents. Refer `mode` sub-section below for further details.

  The default setting is `_locales`

* ### `locales_set`

  Empty by default, this setting defines what locales to be used when "localizing" a site. Listing a locale (other than
  the default locale) will cause the entire site to render for that locale and the default locale while in "auto mode".

  You may also define this setting as an object with key-value pairs where keys are locale identifiers and values their
  metadata:

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
  *Metadata keys can be any string other than `id`.*

* ### `locale`

  Set to `en-US` by default, this setting defines the default locale of the site and will not be prepended to the URL of
  the generated files.

* ### `exclude_set`

  Empty by default, this setting defines what files to be *excluded* from being duplicated and re-rendered in the "auto"
  mode. Ignored in "manual" mode.

* ### `mode`

  This setting defines the plugin's operation strategy.

  When set to **`auto`**, the plugin will initialize a generator that will simply duplicate *every page and document set
  to be written to destination*, and re-render them into destination, for every locale defined in the `locales_set:`
  setting.

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
