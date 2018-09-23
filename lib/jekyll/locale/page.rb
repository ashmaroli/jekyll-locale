# frozen_string_literal: true

module Jekyll
  class Locale::Page < Page
    extend Forwardable

    attr_reader    :canon, :locale
    attr_accessor  :data, :content, :output

    def_delegators :@canon, :site, :extname, :relative_path

    def initialize(canon, locale)
      @canon  = canon
      @locale = locale
    end

    def url
      @url ||= File.join(locale, canon.url)
    end

    def to_liquid
      @to_liquid ||= Locale::PageDrop.new(self)
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

    def inspect
      "#<#{self.class} @canon=#{canon.inspect} @locale=#{locale.inspect}>"
    end
    alias_method :to_s, :inspect
  end
end
