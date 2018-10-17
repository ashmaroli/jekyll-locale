# frozen_string_literal: true

module Jekyll
  class Locale::Handler
    attr_reader :locale_dates
    attr_writer :current_locale

    DEFAULT_CONFIG = {
      "mode"        => "manual",
      "locale"      => "en-US",
      "data_dir"    => "locales",
      "content_dir" => "_locales",
      "locales_set" => [],
      "exclude_set" => [],
    }.freeze

    def initialize(site)
      @site   = site
      config  = site.config["localization"]
      @config = if config.is_a?(Hash)
                  Jekyll::Utils.deep_merge_hashes(DEFAULT_CONFIG, config)
                else
                  DEFAULT_CONFIG
                end
      @sanitized_locale = {}
    end

    def reset
      @portfolio    = nil
      @locale_data  = {}
      @locale_dates = {}
    end

    def data
      locale_data[sanitized_locale(current_locale)] ||
        locale_data[sanitized_locale(default_locale)] || {}
    end

    def portfolio
      @portfolio ||= (site.docs_to_write + html_pages)
    end

    def filtered_portfolio
      @filtered_portfolio ||= begin
        portfolio.reject do |item|
          # consider only instances of class that include `Jekyll::Locale::Support` mixin
          next true unless item.is_a?(Jekyll::Locale::Support)

          item.relative_path =~ exclusion_regex
        end
      end
    end

    def read
      user_locales.each do |locale|
        portfolio.each do |canon_doc|
          # consider only instances of class that include `Jekyll::Locale::Support` mixin
          next unless canon_doc.is_a?(Jekyll::Locale::Support)

          loc_page_path = site.in_source_dir(content_dirname, locale, canon_doc.relative_path)
          next unless File.exist?(loc_page_path)
          next unless Jekyll::Utils.has_yaml_header?(loc_page_path)

          case canon_doc
          when Jekyll::Page
            append_document(Locale::Page, canon_doc, locale)
          when Jekyll::Document
            append_document(Locale::Document, canon_doc, locale)
          end
        end
      end
    end

    def append_document(klass, canon_doc, locale)
      locale_page = klass.new(canon_doc, locale)
      canon_doc.locale_pages << locale_page
      site.pages << locale_page
    end

    def user_locales
      @user_locales ||= begin
        locales = Array(config["locales_set"]) - [default_locale]
        locales.compact!
        locales
      end
    end

    def available_locales
      @available_locales ||= user_locales + [default_locale]
    end

    def current_locale
      @current_locale ||= default_locale
    end

    def default_locale
      @default_locale ||= fetch("locale")
    end

    def sanitized_locale(locale_key)
      @sanitized_locale[locale_key] ||= locale_key.downcase.tr("-", "_")
    end

    def content_dirname
      @content_dirname ||= fetch("content_dir")
    end

    def mode
      @mode ||= begin
        value = config["mode"]
        value == "auto" ? value : DEFAULT_CONFIG["mode"]
      end
    end

    def setup
      @date_handler = Locale::DateTimeHandler
      @date_handler.bootstrap(self)
      @locale_data = setup_data if @locale_data.empty?
      nil
    end

    def inspect
      "#<#{self.class} @site=#{site}>"
    end

    private

    attr_reader :site, :config, :locale_data

    def html_pages
      pages = site.site_payload["site"]["html_pages"] || []
      pages.reject { |page| page.name == "404.html" }
    end

    def locales_dir
      @locales_dir ||= fetch("data_dir")
    end

    def setup_data
      ldata  = site.site_data[locales_dir]
      result = {}
      return result unless ldata.is_a?(Hash)

      ldata.each do |loc, loc_data|
        locale = Utils.snakeify(loc)
        result[locale] = {}
        next unless loc_data.is_a?(Hash)

        date_data = @date_handler::DATETIME_DEFAULTS
        loc_data.each do |key, value|
          if key == "locale_date"
            date_data = Utils.recursive_symbolize_hash_keys(value) if value.is_a?(Hash)
          elsif value.is_a?(String)
            result[locale][Utils.snakeify(key)] = value
          end
        end
        @locale_dates[loc] = date_data
      end

      result
    end

    def fetch(key)
      value   = config[key]
      default = DEFAULT_CONFIG[key]
      return default unless value.class == default.class
      return default if value.to_s.empty?

      value
    end

    def exclusion_regex
      @exclusion_regex ||= Regexp.new("\\A(?:#{Regexp.union(Array(config["exclude_set"]))})")
    end
  end
end
