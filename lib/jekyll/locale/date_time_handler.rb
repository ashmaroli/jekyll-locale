# frozen_string_literal: true

module Jekyll
  module Locale::DateTimeHandler
    DATETIME_DEFAULTS = {
      :date => {
        :day_names        => Date::DAYNAMES,
        :month_names      => Date::MONTHNAMES,
        :abbr_day_names   => Date::ABBR_DAYNAMES,
        :abbr_month_names => Date::ABBR_MONTHNAMES,
      },
      :time => {
        :am      => "am",
        :pm      => "pm",
        :formats => {
          :default => "%B %d, %Y %l:%M:%S %p %z",
        },
      },
    }.freeze

    class << self
      extend Forwardable
      [:config, :backend].each do |method|
        private def_delegator I18n, method
      end

      def bootstrap(handler)
        @handler = handler
        config.available_locales = @handler.available_locales
      end

      def localize(input, format)
        object = date_cache(input)
        locale = @handler.current_locale.id.to_sym
        data   = @handler.locale_dates[locale.to_s] || {}
        store_translations(locale, data) unless translations.key?(locale)
        backend.localize(locale, object, format)
      end

      def store_translations(locale, data)
        backend.store_translations(
          locale,
          Utils.deep_merge_hashes(
            DATETIME_DEFAULTS, Utils.recursive_symbolize_hash_keys(data)
          )
        )
      end

      private

      def translations
        backend.send(:translations)
      end

      def date_cache(input)
        @date_cache ||= {}
        @date_cache[input] ||= Liquid::Utils.to_date(input)
      end
    end
  end
end
