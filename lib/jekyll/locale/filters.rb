# frozen_string_literal: true

module Jekyll
  module Locale
    module Filters
      def localize_date(input, format = :default)
        format = symbol_or_strftime(format)
        DateTimeHandler.localize(time(input), format)
      end

      def locale_url(input)
        input = "" unless input.is_a?(String)
        return input if Addressable::URI.parse(input).absolute?

        input   = relative_url(input)
        handler = @context.registers[:site].locale_handler

        locale_id = handler.current_locale
        locale_id = "" if handler.current_locale == handler.default_locale

        File.join("/", locale_id, input).tap do |result|
          result.squeeze!("/")
        end
      end

      private

      def symbol_or_strftime(format)
        return format if format.is_a?(Symbol)

        format = format.to_s
        if format.start_with?(":")
          format.sub(":", "").to_sym
        elsif format.start_with?("%")
          format
        else
          :default
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Locale::Filters)
