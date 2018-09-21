# frozen_string_literal: true

module Jekyll
  class Locale::Handler
    def initialize(site)
      @site   = site
      @config = site.config
    end

    def reset
      @data = nil
    end

    def data
      @data ||= begin
        fallback = site.site_data.dig(locales_dir, locale)
        return {} unless fallback.is_a?(Hash)

        # transform hash to one with "latinized lowercased string keys"
        Jekyll::Utils.snake_case_keys(fallback)
      end
    end

    private

    attr_reader :site, :config

    def locales_dir
      @locales_dir ||= begin
        value = config["locales_dir"]
        value.to_s.empty? ? "locales" : value
      end
    end

    def locale
      @locale ||= begin
        value = config["locale"]
        value.to_s.empty? ? "en" : value
      end
    end
  end
end
