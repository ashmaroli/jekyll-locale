# frozen_string_literal: true

module Jekyll
  module Utils
    extend self

    def snakeify(input)
      slug = slugify(input.to_s, :mode => "latin", :cased => true)
      slug.tr!("-", "_")
      slug
    end

    def recursive_symbolize_hash_keys(hash)
      result = {}
      hash.each do |key, value|
        new_key = key.to_s.to_sym
        result[new_key] = value.is_a?(Hash) ? recursive_symbolize_hash_keys(value) : value
      end
      result
    end
  end
end
