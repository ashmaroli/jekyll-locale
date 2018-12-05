# Jekyll Locale

[![Linux Build Status](https://img.shields.io/travis/ashmaroli/jekyll-locale/master.svg?label=Linux%20build)][travis]
[![Windows Build status](https://img.shields.io/appveyor/ci/ashmaroli/jekyll-locale/master.svg?label=Windows%20build)][appveyor]
[![Maintainability](https://api.codeclimate.com/v1/badges/3a28682ac6c6693c4e77/maintainability)][maintainability]
[![Test Coverage](https://api.codeclimate.com/v1/badges/3a28682ac6c6693c4e77/test_coverage)][test_coverage]

[travis]: https://travis-ci.org/ashmaroli/jekyll-locale
[appveyor]: https://ci.appveyor.com/project/ashmaroli/jekyll-locale/branch/master
[maintainability]: https://codeclimate.com/github/ashmaroli/jekyll-locale/maintainability
[test_coverage]: https://codeclimate.com/github/ashmaroli/jekyll-locale/test_coverage

A localization plugin for Jekyll.


## Features

* Exposes a `{{ locale }}` object for your Liquid templates that can be used to "translate" strings in your site easily.
* Depending on configured `mode`, the plugin either generates a *copy* of every page that renders into a HTML file, and
  every document set to be written, and renders them into dedicated urls prepended by a supported locale, or, the plugin
  "processes" only those files placed inside the plugin's configured **`content_dir`** .

Read through the [documentation](https://jekyll-locale.netlify.com/) for details.
