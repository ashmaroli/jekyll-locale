# frozen_string_literal: true

module Jekyll
  class Locale::PageGenerator < Generator
    safe true
    priority :lowest

    def generate(site)
      @site   = site
      handler = site.locale_handler
      return if handler.available_locales.empty?

      handler.available_locales.each do |locale|
        handler.portfolio.each do |canon_doc|
          locale_page = Locale::Page.new(canon_doc, locale)
          locale_page.content = canon_doc.content
          locale_page.data    = canon_doc.data

          # add locale_page to parent document and base array of pages
          canon_doc.locale_pages << locale_page
          site.pages << locale_page
        end
      end
    end

    def inspect
      "#<#{self.class} @site=#{@site}>"
    end
  end
end
