# frozen_string_literal: true

module Jekyll
  module Locale
    autoload :Drop,     "jekyll/locale/drop"
    autoload :Document, "jekyll/locale/document"
    autoload :AutoPage, "jekyll/locale/auto_page"
    autoload :Page,     "jekyll/locale/page"
    autoload :Handler,  "jekyll/locale/handler"
  end

  #

  module Localizer
    attr_reader :canon, :relative_path

    def setup_hreflangs?
      true
    end

    def setup_hreflangs
      @hreflangs = (canon.locale_pages + [canon] - [self]).map do |locale_page|
        {
          "locale"   => locale_page.locale || site.locale_handler.default_locale,
          "relation" => locale_page.locale ? "alternate" : "canonical",
          "url"      => locale_page.url,
        }
      end
    end

    def permalink
      canon_link = super
      File.join(locale, canon_link) if canon_link
    end

    def inspect
      "#<#{self.class} @canon=#{canon.inspect} @locale=#{locale.inspect}>"
    end
    alias_method :to_s, :inspect

    private

    def setup(canon, locale)
      @locale = locale
      @canon = canon
      @site = canon.site
      @extname = canon.extname
      @relative_path = canon.relative_path
      @path = site.in_source_dir(site.locale_handler.content_dirname, locale, relative_path)
    end

    def configure_data
      Jekyll::Utils.deep_merge_hashes(canon.data, @data)
    end
  end

  #

  module LocaleSupport
    attr_reader :locale

    def setup_hreflangs?
      false
    end

    def hreflangs
      @hreflangs ||= locale_pages.map do |locale_page|
        {
          "locale"   => locale_page.locale,
          "relation" => "alternate",
          "url"      => locale_page.url,
        }
      end
    end

    def locale_pages
      @locale_pages ||= []
    end
  end

  # Enhance Jekyll::Page and Jekyll::Document classes
  [Page, Document].each { |klass| klass.include LocaleSupport }
end

require_relative "jekyll/patches/site"
require_relative "jekyll/patches/utils"

# Load Locale::Generator if requested
Jekyll::Hooks.register :site, :after_reset do |site|
  handler = site.locale_handler
  handler.reset
  require_relative "jekyll/locale/generator" if handler.mode == "auto"
end

Jekyll::Hooks.register :site, :post_read do |site|
  handler = site.locale_handler
  handler.read unless handler.mode == "auto"
end

Jekyll::Hooks.register [:pages, :documents], :pre_render do |document, payload|
  handler = document.site.locale_handler
  handler.current_locale = document.locale
  document.setup_hreflangs if document.setup_hreflangs?
  payload["page"]["hreflangs"] = document.hreflangs
end
