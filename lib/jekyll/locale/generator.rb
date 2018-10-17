# frozen_string_literal: true

module Jekyll
  class Locale::Generator < Generator
    safe true
    priority :lowest

    def generate(site)
      @site   = site
      handler = site.locale_handler
      return if handler.user_locales.empty?

      handler.user_locales.each do |locale|
        handler.filtered_portfolio.each do |canon_doc|
          handler.append_document(Locale::AutoPage, canon_doc, locale)
        end
      end
    end

    def inspect
      "#<#{self.class} @site=#{@site}>"
    end
  end
end
