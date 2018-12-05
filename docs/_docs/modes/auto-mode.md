---
permalink: /modes/auto/
---

This mode generates a localized version of *every published page / document* in your site, for each locale supported, by default.
In other words, if your site contains 1 post and 2 standalone pages published and the site is configured to render in 3 locales,
then this "mode" will generate a total of 1 x 2 x 3 web pages.

To prevent a certain file from being localized automatically, you may blacklist the file by listing it under the
`localization.exclude_set` key in your config file.

### Gotchas

This mode was originally intended for those sites that offer the same content with multiple localized interfaces. That is, sites
in which only the "*presentational*" aspects are localized and the content remains the same.

As a result, this mode has the following shortcomings:
  * The localized page has the same attributes as the canonical page / document &mdash; they have the same `path`, `relative_path`,
    `data`, `content`, etc. The only attribute they differ in is their `url` and their Liquid representation.
  * These attributes cannot be modified.
  * The localized object is a descendant of `Jekyll::Page` even if the canonical object is a Post or any other collection document.
    This means that the localized object may not respond to certain attributes of the canonical object. (e.g. a document's `id`)
