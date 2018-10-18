# frozen_string_literal: true

module Jekyll
  module Locale::Helper
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
      @locale  = locale
      @canon   = canon
      @site    = canon.site
      @extname = canon.extname
      @locale_page_dir = File.join(@site.locale_handler.content_dirname, locale, "")
      @relative_path   = File.join(@locale_page_dir, canon.relative_path)
      @path = @site.in_source_dir(@relative_path)
    end

    def configure_data
      Jekyll::Utils.deep_merge_hashes(canon.data, @data)
      @data["categories"] = canon.data["categories"]
    end
  end
end
