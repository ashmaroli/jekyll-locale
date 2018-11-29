# frozen_string_literal: true

module Jekyll
  module Locale::Support
    attr_reader :site, :locale

    def setup_hreflangs?
      false
    end

    def hreflangs
      @hreflangs ||= ([self] + locale_pages).map do |locale_page|
        {
          "locale"   => locale_page.locale || site.locale_handler.default_locale,
          "relation" => "alternate",
          "url"      => locale_page.url,
        }
      end
    end

    def locale_pages
      @locale_pages ||= []
    end
  end
end
