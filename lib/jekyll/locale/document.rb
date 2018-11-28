# frozen_string_literal: true

module Jekyll
  class Locale::Document < Document
    attr_reader :type
    include Locale::Helper

    def initialize(canon, locale)
      setup(canon, locale)
      @collection = canon.collection
      @extname = File.extname(relative_path)
      @has_yaml_header = nil
      @type = @collection.label.to_sym
      read

      special_dir = draft? ? "_drafts" : @collection.relative_directory
      categories_from_path(special_dir)

      configure_data
    end

    def cleaned_relative_path
      @cleaned_relative_path ||= begin
        rel_path = relative_path[0..-extname.length - 1]
        rel_path.sub!(@locale_page_dir, "")
        rel_path.sub!(collection.relative_directory, "")
        rel_path.gsub!(%r!\.*\z!, "")
        rel_path
      end
    end

    def url_template
      @url_template ||= File.join("", locale, super)
    end
  end
end
