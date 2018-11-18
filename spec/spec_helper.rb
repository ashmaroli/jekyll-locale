# frozen_string_literal: true

require "simplecov"
require "fileutils"
require "jekyll"
require_relative "../lib/jekyll-locale"

Jekyll.logger.log_level = :error

def dest_dir(*subdirs)
  File.join(
    File.expand_path("../tmp/dest", __dir__),
    subdirs
  )
end

def source_dir(*subdirs)
  File.join(
    File.expand_path("fixtures", __dir__),
    subdirs
  )
end

CONFIG_DEFAULTS = {
  "source"      => source_dir,
  "destination" => dest_dir,
  "plugins"     => ["jekyll-locale"],
}.freeze

def make_site(options = {})
  config = Jekyll.configuration CONFIG_DEFAULTS.merge(options)
  Jekyll::Site.new(config)
end

def make_page_file(path, content: "", front_matter: nil)
  file_path = source_dir(path)
  dir_path  = File.dirname(file_path)
  front_matter ||= { "foo" => "bar" }
  FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  liquid_content = "{{ page.url }}\n\n{{ 'now' | localize_date }}"
  File.open(file_path, "wb") do |f|
    f.puts "#{YAML.dump(front_matter)}\n---\n#{content}\n#{liquid_content}\n"
  end
end

def make_canon_page(site, name, options = {})
  Jekyll::Page.new(site, CONFIG_DEFAULTS["source"], "", name).tap do |page|
    page.data = options
  end
end

def make_canon_document(site, name, collection, options = {})
  relations = { :site => site, :collection => site.collections[collection] }
  Jekyll::Document.new(source_dir("_#{collection}/#{name}"), relations).tap do |doc|
    doc.read
    doc.merge_data!(options)
  end
end
