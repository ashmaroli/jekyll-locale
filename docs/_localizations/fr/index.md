---
translators:
- name: ashmaroli
- name: Google Translate
---

*Jekyll Locale est un autre plugin pour gérer la localisation dans les sites Jekyll.*

Bien que le plugin ne traduise pas littéralement le contenu, il fournit le moyen de générer le contenu du site dans
plusieurs paramètres régionaux et langues, en tirant parti de la polyvalence des fichiers de données dans Jekyll.


## Installation

- Ajoutez le plugin au groupe `:jekyll_plugins` dans votre Gemfile et exécutez `bundle install` pour commencer:

  ```ruby
  group :jekyll_plugins do
    gem "jekyll-locale", "~> 0.5"
  end
  ```

- Configurez le site avec vos paramètres régionaux préférés et construisez votre site comme d'habitude.
