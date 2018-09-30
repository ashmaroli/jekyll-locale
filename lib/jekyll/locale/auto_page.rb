# frozen_string_literal: true

module Jekyll
  class Locale::AutoPage < Page
    extend Forwardable
    include Localizer

    attr_accessor  :data, :content, :output
    def_delegators :@canon, :site, :extname, :relative_path

    def initialize(canon, locale)
      setup(canon, locale)
      @path    = canon.path
      @content = canon.content
      @data    = canon.data
    end

    def url
      @url ||= File.join("", locale, canon.url)
    end

    def to_liquid
      @to_liquid ||= Locale::PageDrop.new(self)
    end
  end
end
