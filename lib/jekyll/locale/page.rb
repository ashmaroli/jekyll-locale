# frozen_string_literal: true

module Jekyll
  class Locale::Page < Page
    include Localizer

    def initialize(canon, locale)
      setup(canon, locale)
      @dir, @name = File.split(relative_path)
      @dir  = "" if @dir == "."
      @base = site.source
      process(@name)
      read_yaml(@dir, @name)
      configure_data
    end

    def template
      @template ||= File.join("", locale, super)
    end
  end
end
