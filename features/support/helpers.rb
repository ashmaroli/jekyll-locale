# frozen_string_literal: true

require "fileutils"
require "jekyll"

require_relative "../../lib/jekyll-locale"

module Paths
  extend self

  SANDBOX = File.expand_path("../../tmp/sandbox", __dir__).freeze
  FIXTURE = File.expand_path("../../spec/fixtures", __dir__).freeze

  def setup_sandbox
    FileUtils.rm_rf(SANDBOX) if File.directory?(SANDBOX)
    FileUtils.mkdir_p(SANDBOX)
    FileUtils.cp_r File.join(FIXTURE, "."), SANDBOX
  end

  def sandbox_item(path)
    @sandbox ||= {}
    @sandbox[path] ||= File.join(SANDBOX, path)
  end

  def path(name)
    name.strip.split("/")
    Pathname.new(sandbox_item(name))
  end

  def content(path)
    path = sandbox_item(path)
    File.read path
  end

  def mk_locale_dir(dirname)
    @locale_dirname = dirname
    path = sandbox_item(dirname)
    FileUtils.mkdir_p(path) unless File.directory?(path)
  end

  def mk_dir(dirname)
    path = sandbox_item(dirname)
    FileUtils.rm_rf(path)
    FileUtils.mkdir_p(path)
  end

  def create_file(file, content)
    File.open(sandbox_item(file), "wb") do |f|
      f.puts content
    end
  end

  def locale_fixture(path)
    fixture_path = path.sub("#{@locale_dirname}/", "")
    src = sandbox_item(fixture_path)
    dest = sandbox_item(path)
    FileUtils.cp src, dest
  end

  def configure(key, data)
    config_file = sandbox_item("_config.yml")
    config = SafeYAML.load_file(config_file)
    config[key] = {}
    data.each do |entry|
      value = entry["value"]
      value = JSON.parse(value) if value.include?("[\"")
      config[key][entry["key"]] = value
    end
    File.open(config_file, "wb+") { |f| f.puts YAML.dump(config) }
  end
end

module Runner
  class << self
    attr_reader :exit_status

    def run(args)
      Dir.chdir(Paths::SANDBOX) do
        args = args.strip.split(" ")
        process, output = Jekyll::Utils::Exec.run("jekyll", *args)

        @exit_status = process.exitstatus
        File.open(Paths.sandbox_item("output.txt"), "wb") do |f|
          f.print "$ jekyll "
          f.puts args.join(" ")
          f.puts output
        end

        process
      end
    end
  end
end
