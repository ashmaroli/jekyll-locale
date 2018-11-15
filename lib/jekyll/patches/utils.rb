# frozen_string_literal: true

module Jekyll
  module Utils
    extend self

    # Convert all keys to snake_case by substituting non-alphanumeric characters
    # with an underscore.
    # The keys are first converted to lowercase strings and then any letters with accents
    # are replaced with their plaintext counterpart
    #
    # hash - the hash to which to apply this transformation
    #
    # Returns a new hash with snake_cased keys or a hash with stringified keys.
    def snake_case_keys(hash)
      transform_keys(hash) do |key|
        begin
          snakeify(key)
        rescue StandardError
          key.to_s
        end
      end
    end

    def snakeify(input)
      slugify(input.to_s, :mode => "latin", :cased => true, :replacement => "_")
    end

    def recursive_symbolize_hash_keys(hash)
      result = {}
      hash.each do |key, value|
        new_key = key.to_s.to_sym
        result[new_key] = value.is_a?(Hash) ? recursive_symbolize_hash_keys(value) : value
      end
      result
    end

    def slugify(string, mode: nil, cased: false, replacement: "-")
      mode ||= "default"
      return nil if string.nil?

      unless SLUGIFY_MODES.include?(mode)
        return cased ? string : string.downcase
      end

      # Drop accent marks from latin characters. Everything else turns to ?
      if mode == "latin"
        I18n.config.available_locales = :en if I18n.config.available_locales.empty?
        string = I18n.transliterate(string)
      end

      slug = replace_character_sequence(string, :mode => mode, :replacement => replacement)

      # Remove leading/trailing hyphen
      slug.gsub!(%r!^\-|\-$!i, "")

      slug.downcase! unless cased
      slug
    end

    private

    # Replace each character sequence with given character.
    #
    # See Utils#slugify for a description of the character sequence specified
    # by each mode.
    def replace_character_sequence(string, **opts)
      replaceable_char =
        case opts[:mode]
        when "raw"
          SLUGIFY_RAW_REGEXP
        when "pretty"
          # "._~!$&'()+,;=@" is human readable (not URI-escaped) in URL
          # and is allowed in both extN and NTFS.
          SLUGIFY_PRETTY_REGEXP
        when "ascii"
          # For web servers not being able to handle Unicode, the safe
          # method is to ditch anything else but latin letters and numeric
          # digits.
          SLUGIFY_ASCII_REGEXP
        else
          SLUGIFY_DEFAULT_REGEXP
        end

      # Strip according to the mode
      string.gsub(replaceable_char, opts[:replacement])
    end
  end
end
