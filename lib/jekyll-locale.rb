# frozen_string_literal: true

module Jekyll
  module Locale
    autoload :Drop,    "jekyll/locale/drop"
    autoload :Page,    "jekyll/locale/page"
    autoload :Handler, "jekyll/locale/handler"
  end

  #

  module LocaleSupport
    attr_reader :locale

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

require_relative "jekyll/locale/page_generator"

require_relative "jekyll/patches/site"
require_relative "jekyll/patches/utils"

Jekyll::Hooks.register :site, :after_reset do |site|
  site.locale_handler.reset
end

Jekyll::Hooks.register [:pages, :documents], :pre_render do |document, payload|
  handler = document.site.locale_handler
  handler.current_locale = document.locale
  document.setup_hreflangs if document.is_a?(Jekyll::Locale::Page)
  payload["page"]["hreflangs"] = document.hreflangs
end
