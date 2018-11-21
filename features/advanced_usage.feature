Feature: Advanced Usage
  Heavily customized usage of `jekyll-locale`

  Scenario: Advanced usage with 'manual' mode
    Given I have a fixture site
    And I have the following "localization" configuration:
      | key         | value            |
      | mode        | manual           |
      | locale      | en               |
      | locales_set | ["en", "fr"]     |
      | data_dir    | localization     |
      | content_dir | _locale_contents |
    And I have a "_data/localization" directory
    And I have a "_data/localization/en" directory
    And I have a "_data/localization/en/strings.yml" file with content:
      """
      Welcome: Hello
      welcome: Namasté
      """
    And I have a "_data/localization/fr" directory
    And I have a "_data/localization/fr/strings.yml" file with content:
      """
      Welcome: Bonjour
      welcome: Namasté
      """
    And I have an "index.md" page with content:
      """
      {{ locale.strings.Welcome }} User.
      """
    And I have an "download.md" page with content:
      """
      Download our {{ locale.strings.welcome }} Collections here!!
      """
    And I have a "_locale_contents/fr" directory
    And I have a "_locale_contents/fr/index.md" page with content:
      """
      {{ locale.strings.Welcome }} User.
      """
    And I have a "_locale_contents/fr/download.md" file with content:
      """
      ---
      layout: none
      permalink: /télécharger/
      ---

      Téléchargez nos {{ locale.strings.welcome }} Collections ici !!
      """
    When I run jekyll build
    Then I should get a zero exit status
    And the "_site" directory should exist
    And I should see "Hello User" in "_site/index.html"
    And I should see "Download our Namasté Collections here!!" in "_site/download.html"
    And I should see "Bonjour User" in "_site/fr/index.html"
    And I should see "Téléchargez nos Namasté Collections ici !!" in "_site/fr/télécharger/index.html"

  Scenario: Advanced usage with 'auto' mode
    Given I have a fixture site
    And I have the following "localization" configuration:
      | key         | value           |
      | mode        | auto            |
      | locale      | en              |
      | locales_set | ["en", "fr"]    |
      | data_dir    | localization    |
      | exclude_set | ["download.md"] |
    And I have a "_data/localization" directory
    And I have a "_data/localization/en" directory
    And I have a "_data/localization/en/strings.yml" file with content:
      """
      welcome: Hello
      Welcome: Namasté
      """
    And I have a "_data/localization/fr" directory
    And I have a "_data/localization/fr/strings.yml" file with content:
      """
      welcome: Bonjour
      Welcome: Namasté
      """
    And I have a "index.md" page with content:
      """
      {{ locale.strings.welcome }} User.
      """
    And I have a "download.md" page with content:
      """
      Download our {{ locale.strings.Welcome }} Collections here!!
      """
    And I have a "_locales/fr" directory
    And I have a "_locales/fr/download.md" page with content:
      """
      Download our {{ locale.strings.Welcome }} Collections here!!
      """
    When I run jekyll build
    Then I should get a zero exit status
    And the "_site" directory should exist
    And I should see "Hello User" in "_site/index.html"
    And I should see "Bonjour User" in "_site/fr/index.html"
    And I should see "Canonical Content" in "_site/about.html"
    And I should see "Canonical Content" in "_site/fr/about.html"
    And I should see "Download our Namasté Collections here!!" in "_site/download.html"
    But the "_site/fr/download.html" file should not exist
