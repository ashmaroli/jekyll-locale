# frozen_string_literal: true

module Jekyll
  module Locale::Helper
    attr_reader :canon, :relative_path

    def setup_hreflangs?
      true
    end

    def setup_hreflangs
      page_set = [canon] + canon.locale_pages
      @hreflangs = sibling_data(page_set)
      @locale_siblings = sibling_data(page_set - [self])
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
      Array(@data["categories"]).delete_if do |category|
        category == @site.locale_handler.content_dirname || category == @locale
      end

      @data = Jekyll::Utils.deep_merge_hashes(canon.data, @data)
      @data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, type, key)
      end
    end

    def configure_payload(payload)
      payload.to_h.tap do |data|
        data["path"] = self.relative_path
        data["url"]  = self.url
      end
    end
  end
end
