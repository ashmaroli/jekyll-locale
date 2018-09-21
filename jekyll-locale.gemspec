# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll/locale/version"

Gem::Specification.new do |spec|
  spec.name     = "jekyll-locale"
  spec.version  = Jekyll::Locale::VERSION
  spec.authors  = ["Ashwin Maroli"]
  spec.email    = ["ashmaroli@gmail.com"]

  spec.summary  = "A localization plugin for Jekyll"
  spec.homepage = "https://github.com/ashmaroli/jekyll-locale"
  spec.license  = "MIT"

  spec.metadata = { "allowed_push_host" => "https://rubygems.org" }

  spec.files    = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r!^(lib/|(LICENSE|README)((\.(txt|md|markdown)|$)))!i)
  end

  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.3.0"

  spec.add_runtime_dependency "jekyll", "~> 3.8"
end
