---
---

*Jekyll Locale is yet another plugin to handle localization in Jekyll sites.*

The plugin does not literally translate content. However, it provides the means to output site content in multiple
locales and languages by leveraging the versatility of Jekyll's Data files.


## Installation

- Add the plugin to the `:jekyll_plugins` group in your Gemfile and run `bundle install` to get started:

  ```ruby
  group :jekyll_plugins do
    gem "jekyll-locale", "~> 0.5"
  end
  ```

- Configure the site with your preferred locales and build your site as usual.
