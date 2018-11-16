# frozen_string_literal: true

module Jekyll
  class Locale::Handler
    attr_reader :default_locale, :available_locales, :locale_dates, :content_dirname
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

      @default_locale    = fetch("locale")
      @available_locales = user_locales + [@default_locale]
      @content_dirname   = mode == "auto" ? "" : fetch("content_dir")

      @snakeified_keys = {}
    end

    def reset
      @locale_data  = {}
      @locale_dates = {}
      @portfolio = nil
    end

    def setup
      Locale::DateTimeHandler.bootstrap(self)
      setup_data if @locale_data.empty?
    end

    def data
      locale_data[snakeified_keys(current_locale)] ||
        locale_data[snakeified_keys(default_locale)] || {}
    end

    def read
      mode == "auto" ? auto_localization : manual_localization
    end

    def user_locales
      @user_locales ||= begin
        locales = Array(config["locales_set"]) - [default_locale]
        locales.compact!
        locales
      end
    end

    def current_locale
      @current_locale ||= default_locale
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

    def setup_data
      locales_dir = fetch("data_dir")
      base_data   = site.site_data[locales_dir]
      return @locale_data unless base_data.is_a?(Hash)

      base_data.each do |locale_id, data|
        next unless data.is_a?(Hash)
        process_locale_data(locale_id, data)
      end

      nil
    end

    def process_locale_data(loc, data_hash)
      locale = snakeified_keys(loc)
      @locale_data[locale] = {}

      date_data = Locale::DateTimeHandler::DATETIME_DEFAULTS
      data_hash.each do |key, value|
        if key == "locale_date"
          date_data = configure_locale_date(date_data, value)
        else
          @locale_data[locale][snakeified_keys(key)] = value
        end
      end
      @locale_dates[loc] = date_data
    end

    def configure_locale_date(date_defaults, data)
      return date_defaults unless data.is_a?(Hash)

      Jekyll::Utils.deep_merge_hashes(
        date_defaults, Utils.recursive_symbolize_hash_keys(data)
      )
    end

    # Instances of Jekyll class that include `Jekyll::Locale::Support` mixin
    # (which are simply Jekyll::Page and Jekyll::Document)
    def portfolio
      @portfolio ||= (site.docs_to_write + html_pages).select do |doc|
        doc.is_a?(Jekyll::Locale::Support)
      end
    end

    def auto_localization
      user_locales.each do |locale|
        portfolio.each do |canon_doc|
          next if canon_doc.relative_path =~ exclusion_regex
          append_page(Locale::AutoPage, canon_doc, locale)
        end
      end
    end

    def manual_localization
      user_locales.each do |locale|
        portfolio.each do |canon_doc|
          loc_page_path = site.in_source_dir(content_dirname, locale, canon_doc.relative_path)
          next unless File.exist?(loc_page_path)
          next unless Jekyll::Utils.has_yaml_header?(loc_page_path)

          case canon_doc
          when Jekyll::Page
            append_page(Locale::Page, canon_doc, locale)
          when Jekyll::Document
            append_document(Locale::Document, canon_doc, locale)
          end
        end
      end
    end

    def append_page(klass, canon_page, locale)
      locale_page = klass.new(canon_page, locale)
      canon_page.locale_pages << locale_page
      site.pages              << locale_page
      site.pages.uniq!
    end

    def append_document(klass, canon_doc, locale)
      locale_doc = klass.new(canon_doc, locale)
      canon_doc.locale_pages    << locale_doc
      canon_doc.collection.docs << locale_doc
      site.docs_to_write        << locale_doc
      site.docs_to_write.uniq!
    end

    def snakeified_keys(key)
      @snakeified_keys[key] ||= Utils.snakeify(key)
    end

    def mode
      @mode ||= begin
        value = config["mode"]
        value == "auto" ? value : DEFAULT_CONFIG["mode"]
      end
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
