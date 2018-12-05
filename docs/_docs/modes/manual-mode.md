---
permalink: /modes/manual/
---

This mode requires the user to provide physical files in the configured `content_dir` with
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

#### Known Limitations

* The plugin requires that a canonical page and a locale page have the same "relative path" (from the site's `source` and
  from the `content_dir` respectively).

  This means that **`about.md` will expect to link to `_locales/fr/about.md` instead of `_locales/fr/apropos.md`**.
  To force the locale page to render into a different url, you'll need to either explicitly set a `permalink` key or a
  `slug` key in the locale page's front matter.
* **Canonical files are mandatory.**

  This means that `_locales/fr/about.md` will only be **read-in** if `about.md` exists.
