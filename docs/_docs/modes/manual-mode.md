---
permalink: /modes/manual/
---

The key features of this mode are:
  * The physical files are handled like any other file in the site, but, they **should partially mirror** their
    counterpart &mdash; **their relative_paths should match**.
  * If an original file contains front matter, the physical copy should contain front matter as well.
  * Physical copies can render different content and into a different layout, if desired.
  * Physical copies of posts and other writable *documents* can be rendered to a different `slug` by defining the `slug` key in
    the front matter.

This mode requires the user to provide physical files in the configured `content_dir` with sub-directories that match
the defined locales.

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

#### Prerequisites

* The physical files should reside inside sub-folders that match the desired locale. For example, to "localize" a post at path
  `movies/_posts/2018-09-24-hello.markdown` with locale `fr`, you should create the physical copy at path
  `_locales/fr/movies/_posts/2018-09-24-hello.markdown`.

* The file path of *an original page* relative to the *site's source*, should match the file path of the corresponding *locale
  page* relative to the `localization.content_dir` config value.

  This means that the locale page which would correspond to *an original page* `about.md` will be **`_locales/fr/about.md`**
  instead of **`_locales/fr/apropos.md`**. To force the locale page to render into a different url, you'll need to either
  explicitly set a `permalink` key or a `slug` key in the locale page's front matter.

* **Files must exist in the default language.**

  The file `_locales/fr/about.md` will be **read** if and only if the file `about.md` exists.
