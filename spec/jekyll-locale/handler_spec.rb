# frozen_string_literal: true

RSpec.describe Jekyll::Locale::Handler do
  let(:config) { { "title" => "Localization Test" } }
  let(:site)   { make_site(config) }
  subject { described_class.new(site) }

  before do
    site.process
  end

  it "returns the custom inspect string" do
    expect(subject.inspect).to eql("#<Jekyll::Locale::Handler @site=#{site}>")
  end

  it "returns the default locale" do
    expect(subject.default_locale).to eql("en-US")
  end

  it "returns the default locale as the current locale" do
    expect(subject.current_locale).to eql("en-US")
  end

  it "returns the available locales" do
    expect(subject.available_locales).to eql(["en-US"])
  end

  it "runs in 'manual' mode" do
    expect(subject.content_dirname).to eql("_locales")
  end

  context "in 'auto' mode" do
    let(:config) do
      {
        "localization" => {
          "mode"        => "auto",
          "locale"      => "en",
          "locales_set" => %w(fr en),
        },
      }
    end

    it "returns the default locale" do
      expect(subject.default_locale).to eql("en")
    end

    it "returns the available locales" do
      expect(subject.available_locales).to eql(%w(fr en))
    end

    it "returns an empty content dirname" do
      expect(subject.content_dirname).to eql("")
    end
  end

  context "in 'manual' mode" do
    let(:config) do
      {
        "localization" => {
          "mode"            => "manual",
          "locale"          => "fr",
          "locales_set"     => %w(fr en),
          "content_dirname" => "_locales",
        },
      }
    end

    after do
      content_dir = source_dir("_locales")
      FileUtils.rm_rf(content_dir) if File.directory?(content_dir)
    end

    it "returns the default locale" do
      expect(subject.default_locale).to eql("fr")
    end

    it "returns the available locales" do
      expect(subject.available_locales).to eql(%w(en fr))
    end

    it "returns the configured content dirname" do
      expect(subject.content_dirname).to eql("_locales")
    end

    it "generates localized content 'lazily'" do
      expect(Pathname.new(dest_dir("index.html"))).to exist
      expect(Pathname.new(dest_dir("2018/10/15/hello-world.html"))).to exist

      expect(Pathname.new(dest_dir("en/index.html"))).to_not exist
      expect(Pathname.new(dest_dir("en/2018/10/15/hello-world.html"))).to_not exist

      make_page_file("_locales/en/index.md", :content => "Hello World")
      make_page_file("_locales/en/_posts/2018-10-15-hello-world.md", :content => "Hello World")
      site.process

      expect(Pathname.new(dest_dir("index.html"))).to exist
      expect(Pathname.new(dest_dir("en/index.html"))).to exist
      expect(Pathname.new(dest_dir("en/2018/10/15/hello-world.html"))).to exist
    end
  end
end
