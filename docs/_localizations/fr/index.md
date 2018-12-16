---
translators:
  - name: ashmaroli
    link: https://github.com/ashmaroli
  - name: DirtyF
    link: https://github.com/DirtyF
---

*Jekyll Locale est un plugin de plus qui gère la localisation de sites Jekyll.*

Le plugin ne s'occupe pas de la traduction de vos contenus, il permet toutefois de générer l'arborescence de votre site dans
plusieurs langues et paramètres régionaux, en tirant parti de la polyvalence des fichiers de données de Jekyll.

## Installation

- Ajoutez le plugin au groupe `:jekyll_plugins` dans votre fichier `Gemfile` et lancez la commande `bundle install` pour
  commencer :

  ```ruby
  group :jekyll_plugins do
    gem "jekyll-locale", "~> 0.5"
  end
  ```

- [Configurez](configuration/) le site avec vos préférences régionales et générez votre site comme à l'accoutumée.
