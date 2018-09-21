# frozen_string_literal: true

module Jekyll
  module Locale
    autoload :Drop,    "jekyll/locale/drop"
    autoload :Handler, "jekyll/locale/handler"
  end
end

require_relative "jekyll/patches/site"
require_relative "jekyll/patches/utils"

Jekyll::Hooks.register :site, :after_reset do |site|
  site.locale_handler.reset
end
