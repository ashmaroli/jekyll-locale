# frozen_string_literal: true

source "https://rubygems.org"
gemspec

def custom_gem_source(name, nwo, branch)
  path = File.expand_path("../#{name}", __dir__)

  if Dir.exist?(path)
    { :path => path }
  else
    { :git => "https://github.com/#{nwo}.git", :branch => branch }
  end
end

#

gem "kramdown", custom_gem_source("kramdown", "ashmaroli/kramdown", "lang-data-attr")

gem "jekyll-mentions"
gem "rspec"
gem "rubocop-jekyll"
gem "simplecov", :require => false
gem "tzinfo-data", :install_if => Gem.win_platform?
