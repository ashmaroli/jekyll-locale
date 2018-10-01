# frozen_string_literal: true

module Jekyll
  class Locale::Handler
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
    end

    def reset
      @locale_data = nil
      @portfolio   = nil
    end

    def data
      locale_data[current_locale] || locale_data[default_locale] || {}
    end

    def portfolio
      @portfolio ||= (site.docs_to_write + html_pages)
    end

    def filtered_portfolio
      @filtered_portfolio ||= begin
        portfolio.reject do |item|
          item.relative_path =~ exclusion_regex
        end
      end
    end

    def read
      available_locales.each do |locale|
        portfolio.each do |canon_doc|
          loc_page_path = site.in_source_dir(content_dirname, locale, canon_doc.relative_path)
          next unless File.exist?(loc_page_path)
          next unless Jekyll::Utils.has_yaml_header?(loc_page_path)

          case canon_doc
          when Jekyll::Page
            append_document(Locale::Page, canon_doc, locale, site.pages)
          when Jekyll::Document
            append_document(Locale::Document, canon_doc, locale, site.docs_to_write)
          end
        end
      end
    end

    def append_document(klass, canon_doc, locale, base_array)
      locale_page = klass.new(canon_doc, locale)
      canon_doc.locale_pages << locale_page
      base_array << locale_page
    end

    def available_locales
      @available_locales ||= begin
        locales = Array(config["locales_set"]) - [default_locale]
        locales.compact!
        locales
      end
    end

    def current_locale
      @current_locale ||= default_locale
    end

    def default_locale
      @default_locale ||= fetch("locale")
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
      @locales_dir ||= fetch("data_dir")
    end

    def locale_data
      @locale_data ||= begin
        ldata = site.site_data[locales_dir]
        return {} unless ldata.is_a?(Hash)

        # transform hash to one with "latinized lowercased string keys"
        Jekyll::Utils.snake_case_keys(ldata)
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
