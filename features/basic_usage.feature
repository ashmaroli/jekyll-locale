Feature: Basic Usage
  Basic usage of `jekyll-locale`

  Scenario: Basic Site under 'manual' mode
    Given I have a fixture site
    And I have the following "localization" configuration:
      | key         | value        |
      | mode        | manual       |
      | locale      | en           |
      | locales_set | ["en", "fr"] |
    And I have a "_locales/fr" locale content directory
    And I have a "_locales/fr/index.md" locale fixture
    When I run jekyll build
    Then I should get a zero exit status
    And the "_site" directory should exist
    And I should see "Hello!" in "_site/index.html"
    And I should see "Bonjour!" in "_site/fr/index.html"

  Scenario: Basic Site under 'auto' mode
    Given I have a fixture site
    And I have the following "localization" configuration:
      | key         | value        |
      | mode        | auto         |
      | locale      | en           |
      | locales_set | ["en", "fr"] |
    When I run jekyll build
    Then I should get a zero exit status
    And the "_site" directory should exist
    And I should see "Hello!" in "_site/index.html"
    And I should see "Bonjour!" in "_site/fr/index.html"
