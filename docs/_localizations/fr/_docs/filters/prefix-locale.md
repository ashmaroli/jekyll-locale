---
title: Filtre préfixe locale
permalink: /filtres/prefix_locale/
translators:
  - name: DirtyF
    link: https://github.com/DirtyF
---

Ce filtre vous permet de convertir une chaîne de caractères sans espace en une URI relative à la racine du site et à la langue
courante.

L'URI générée se verra préfixée avec `/[langue]` (ou `/` pour la langue par défaut).

Le filtre vérifie que la valeur en entrée est bien une chaîne de caractères ou alors une URI absolue.

Le filtre s'occupera également de nettoyer la valeur si elles comporte plusieurs slashs d'affilée.

## Exemples

<div class="mobile-side-scroller">
<table>
  <caption>
    <div>Langue par défaut : <code>en</code></div>
    <div>Langue actuelle : <code>en</code></div>
  </caption>
  <thead>
    <tr>
      <th>Entrée</th>
      <th>Sortie</th>
    </tr>
  </thead>
  <tbody>
    {% for example in site.data.filter_examples.prefix_locale.en %}
      <tr>
        <td class="align-center">
          <code class="filter">{{ example.input }}</code>
        </td>
        <td class="align-center">
          <code class="output">{{ example.output }}</code>
        </td>
      </tr>
    {% endfor %}
  </tbody>
</table>

<table>
  <caption>
    <div>Langue par défaut : <code>en</code></div>
    <div>Langue courante : <code>fr</code></div>
  </caption>
  <thead>
    <tr>
      <th>Entrée</th>
      <th>Sortie</th>
    </tr>
  </thead>
  <tbody>
    {% for example in site.data.filter_examples.prefix_locale.fr %}
      <tr>
        <td class="align-center">
          <code class="filter">{{ example.input }}</code>
        </td>
        <td class="align-center">
          <code class="output">{{ example.output }}</code>
        </td>
      </tr>
    {% endfor %}
  </tbody>
</table>
</div>
