# frozen_string_literal: true

module Jekyll
  class Locale::Handler
    attr_writer :current_locale

    def initialize(site)
      @site   = site
      @config = site.config
    end

    def reset
      @locale_data = nil
      @portfolio   = nil
    end

    def data
      locale_data[current_locale] || locale_data[default_locale]
    end

    def portfolio
      @portfolio ||= (site.docs_to_write + html_pages)
    end

    def available_locales
      @available_locales ||= begin
        locales = Array(config["available_locales"]) - [default_locale]
        locales.compact!
        locales
      end
    end

    def current_locale
      @current_locale ||= default_locale
    end

    def default_locale
      @default_locale ||= begin
        value = config["locale"]
        value.to_s.empty? ? "en" : value
      end
    end

    def inspect
      "#<#{self.class} @site=#{site}>"
    end

    private

    attr_reader :site, :config

    def html_pages
      @html_pages ||= begin
        pages = site.site_payload["site"]["html_pages"] || []
        pages.reject { |page| page.name == "404.html" }
      end
    end

    def locales_dir
      @locales_dir ||= begin
        value = config["locales_dir"]
        value.to_s.empty? ? "locales" : value
      end
    end

    def locale_data
      @locale_data ||= begin
        ldata = site.site_data[locales_dir]
        return {} unless ldata.is_a?(Hash)

        # transform hash to one with "latinized lowercased string keys"
        Jekyll::Utils.snake_case_keys(ldata)
      end
    end
  end
end
