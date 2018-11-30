# frozen_string_literal: true

module Jekyll
  module Locale::Support
    attr_reader :site, :locale

    def setup_hreflangs?
      false
    end

    def locale_siblings
      @locale_siblings ||= sibling_data(locale_pages)
    end

    def hreflangs
      @hreflangs ||= sibling_data([self] + locale_pages)
    end

    def locale_pages
      @locale_pages ||= []
    end

    private

    def sibling_data(locale_page_set)
      locale_page_set.map do |locale_page|
        {
          "locale" => locale_page.locale || site.locale_handler.default_locale,
          "url"    => locale_page.url,
        }
      end
    end
  end
end
