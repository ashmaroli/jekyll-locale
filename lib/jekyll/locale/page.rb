# frozen_string_literal: true

module Jekyll
  class Locale::Page < Page
    include Locale::Helper
    attr_reader :path

    def initialize(canon, locale)
      setup(canon, locale)
      @dir, @name = File.split(relative_path)
      @base = site.source
      process(@name)
      read_yaml(@dir, @name)
      configure_data

      # Empty the value as it is not longer required.
      @dir = ""
    end

    def to_liquid
      @to_liquid ||= configure_payload(super)
    end

    def template
      @template ||= File.join("", locale, super)
    end
  end
end
