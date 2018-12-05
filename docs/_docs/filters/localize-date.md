---
title: Localize Date Filter
permalink: /filters/localize_date/
---
<div>
  <blockquote>
    <small>
      <em>
        Adapted from
        <a href="https://github.com/borisschapira/borisschapira.com/blob
          /e3db4209536ea624466aa516e7feba79410b6719/_plugins/i18n_date_filter.rb#L9-L24">
          localize filter</a> by @borisschapira
      </em>
  </small>
</blockquote>
</div>

This plugin provides a `localize_date` filter to aid in localizing valid date strings. It takes an optional parameter to specify the format
of the output string.

The filter technically delegates to the `I18n` module and therefore requires the translation data to follow a certain convention to pass through without errors.

```yaml
date:
  day_names        : # Array of Day names in full. e.g. "Sunday", "Monday", ...
  month_names      : # Array of Month names in full. e.g. "January", "February", ...
  abbr_day_names   : # Array of abbreviations of above Day names. e.g. "Sun", "Mon", ...
  abbr_month_names : # Array of abbreviations of above Month names. e.g. "Jan", "Feb", ...
time:
  am: "am"                              # Placeholder for Ante-Meridian
  pm: "pm"                              # Placeholder for Post-Meridian
  formats:                              # A set of predefined strftime formats
    default: "%B %d, %Y %l:%M:%S %p %z" # Used by default if no other `format` has been specified.
    # my_format:                        # A valid strftime format of your choice.
                                        #   Usage: {% raw %}{{ your_date | localize_date: ":my_format" }}{% endraw %}
```

#### Requirements

The plugin also places a few conventions to streamline usage:
* All datetime data should be encompassed under a `locale_date` key for each locale except the default locale, for which, the datetime data has been set by default. But you're free to *redefine* it when necessary.
* The array of names are filled in by default using values defined in Ruby's `Date` class.
* The array of full day names and full month names have `nil` as the first entry. So locales for non-English languages should have `nil` as the first entry. (In YAML, null list item can be written as simply `~`)
* The optional parameter for the filter, `format` should either be a string that corresponds to the symbol of the `formats` subkey (e.g. `":default"`) or a valid `strftime` format.
