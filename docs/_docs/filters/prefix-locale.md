---
title: Prefix Locale Filter
permalink: /filters/prefix_locale/
---

This is a basic helper to convert a simple string devoid of whitespaces, into a URI relative to the server root and
current locale. The generated URI will essentially have `/[locale]` (or just `/` for the default locale) prepended to
the given `input`.

The only validations this filter involve are checking if the given `input` is a String or if the input is an absolute URI.
Additionally, the filter strips away multiple slashes in the input string.

<div class="mobile-side-scroller">
<table>
  <caption>
    <div>Default Locale: <code>en-US</code></div>
    <div>Current Locale: <code>en-US</code></div>
  </caption>
  <thead>
    <tr>
      <th>Input</th>
      <th>Output</th>
    </tr>
  </thead>
  <tbody>
    {% for example in site.data.filter_examples.prefix_locale.en_US %}
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
    <div>Default Locale: <code>en-US</code></div>
    <div>Current Locale: <code>fr-FR</code></div>
  </caption>
  <thead>
    <tr>
      <th>Input</th>
      <th>Output</th>
    </tr>
  </thead>
  <tbody>
    {% for example in site.data.filter_examples.prefix_locale.fr_FR %}
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
