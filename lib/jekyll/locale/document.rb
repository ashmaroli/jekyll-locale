# frozen_string_literal: true

module Jekyll
  class Locale::Document < Document
    include Locale::Helper

    def initialize(canon, locale)
      setup(canon, locale)
      @collection = canon.collection
      @extname = File.extname(relative_path)
      @has_yaml_header = nil
      read

      special_dir = draft? ? "_drafts" : @collection.relative_directory
      categories_from_path(special_dir)

      configure_data
    end

    def url_template
      @url_template ||= File.join("", locale, super)
    end
  end
end
