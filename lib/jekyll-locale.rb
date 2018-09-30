# frozen_string_literal: true

module Jekyll
  module Locale
    autoload :Drop,     "jekyll/locale/drop"
    autoload :Document, "jekyll/locale/document"
    autoload :AutoPage, "jekyll/locale/auto_page"
    autoload :Page,     "jekyll/locale/page"
    autoload :Handler,  "jekyll/locale/handler"
  end
end

require_relative "jekyll/patches/site"
require_relative "jekyll/patches/utils"

require_relative "jekyll/locale/mixins/support"
require_relative "jekyll/locale/mixins/helper"

# Enhance Jekyll::Page and Jekyll::Document classes
[Jekyll::Page, Jekyll::Document].each do |klass|
  klass.include Jekyll::Locale::Support
end

# Load Locale::Generator if requested
Jekyll::Hooks.register :site, :after_reset do |site|
  handler = site.locale_handler
  handler.reset
  require_relative "jekyll/locale/generator" if handler.mode == "auto"
end

Jekyll::Hooks.register :site, :post_read do |site|
  handler = site.locale_handler
  handler.read unless handler.mode == "auto"
end

Jekyll::Hooks.register [:pages, :documents], :pre_render do |document, payload|
  handler = document.site.locale_handler
  handler.current_locale = document.locale
  document.setup_hreflangs if document.setup_hreflangs?
  payload["page"]["hreflangs"] = document.hreflangs
end
