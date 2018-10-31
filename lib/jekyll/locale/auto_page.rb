# frozen_string_literal: true

module Jekyll
  class Locale::AutoPage < Page
    include Locale::Helper

    attr_reader    :path
    attr_accessor  :data, :content, :output

    def initialize(canon, locale)
      setup(canon, locale)
      @path    = canon.path
      @content = canon.content
      @data    = canon.data
      @name    = File.basename(@path)
      @relative_path = canon.relative_path
      process(@name)
    end

    def url
      @url ||= File.join("", locale, canon.url)
    end

    def to_liquid
      @to_liquid ||= configure_payload(canon.to_liquid)
    end
  end
end
