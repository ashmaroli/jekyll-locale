# frozen_string_literal: true

RSpec.describe Jekyll::Locale::Handler do
  let(:config)    { { "title" => "Localization Test" } }
  let(:site)      { make_site(config) }
  let(:locale_id) { "en-US" }
  let(:metadata)  { {} }
  let(:locale)    { Jekyll::Locale::Identity.new(locale_id, metadata) }

  subject { described_class.new(site) }

  before do
    site.process
  end

  it "returns the custom inspect string" do
    expect(subject.inspect).to eql("#<Jekyll::Locale::Handler @site=#{site}>")
  end

  it "returns the default 'locale identity' object" do
    expect(subject.default_locale.class).to eql(locale.class)
    expect(subject.default_locale.id).to eql(locale.id)
    expect(subject.default_locale.id).to eql("en-US")
  end

  it "returns the default 'locale identity' object as the current locale" do
    expect(subject.current_locale.class).to eql(locale.class)
    expect(subject.current_locale.id).to eql(locale.id)
    expect(subject.current_locale.id).to eql("en-US")
  end

  it "returns an array of available locale ids" do
    expect(subject.available_locales).to eql(["en-US"])
  end

  it "runs in 'manual' mode by default" do
    expect(subject.content_dirname).to eql("_locales")
  end

  context "in 'auto' mode" do
    let(:locale_id) { "en" }
    let(:metadata)  { { "label" => "English" } }
    let(:config) do
      {
        "localization" => {
          "mode"        => "auto",
          "locale"      => locale_id,
          "locales_set" => %w(fr en),
        },
      }
    end

    it "returns the default 'locale identity' object" do
      expect(subject.default_locale.class).to eql(locale.class)
      expect(subject.default_locale.id).to eql("en")
    end

    it "returns an array of available locale ids" do
      expect(subject.available_locales).to eql(%w(en fr))
    end

    it "returns an empty content dirname" do
      expect(subject.content_dirname).to eql("")
    end
  end

  context "in 'manual' mode" do
    let(:locale_id) { "fr" }
    let(:metadata)  { { "label" => "Français" } }
    let(:config) do
      {
        "localization" => {
          "mode"            => "manual",
          "locale"          => locale_id,
          "locales_set"     => %w(en fr),
          "content_dirname" => "_locales",
        },
      }
    end

    after do
      content_dir = source_dir("_locales")
      FileUtils.rm_rf(content_dir) if File.directory?(content_dir)
    end

    it "returns the default 'locale identity' object" do
      expect(subject.default_locale.class).to eql(locale.class)
      expect(subject.default_locale.id).to eql("fr")
    end

    it "returns an array of available locale ids" do
      expect(subject.available_locales).to eql(%w(fr en))
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

    it "allows withelding publish until ready" do
      expect(Pathname.new(dest_dir("about.html"))).to exist
      expect(Pathname.new(dest_dir("en/about.html"))).to_not exist

      make_page_file(
        "_locales/en/about.md",
        :content      => "Hello World",
        :front_matter => { "published" => true }
      )
      site.process
      expect(Pathname.new(dest_dir("en/about.html"))).to exist

      make_page_file(
        "_locales/en/about.md",
        :content      => "Hello World",
        :front_matter => { "published" => false }
      )
      site.process
      expect(Pathname.new(dest_dir("en/about.html"))).to_not exist
    end
  end

  context "with locale metadata hash via locales_set configuration" do
    let(:config) do
      {
        "localization" => {
          "mode"            => "manual",
          "locale"          => "fr",
          "locales_set"     => {
            "en" => { "label" => "English" },
            "fr" => { "label" => "Français" },
          },
          "content_dirname" => "_locales",
        },
      }
    end

    it "returns the default 'locale identity' object" do
      expect(subject.default_locale.class).to eql(locale.class)
      expect(subject.default_locale.id).to eql("fr")
      expect(subject.default_locale.data).to eql("label" => "Français")
    end

    it "returns the default 'locale identity' object as the current locale" do
      expect(subject.current_locale).to eql(subject.default_locale)
    end

    it "returns an array of available locale ids" do
      expect(subject.available_locales).to eql(%w(fr en))
    end
  end

  context "with invalid locale metadata via locales_set configuration" do
    let(:config) do
      {
        "localization" => {
          "mode"            => "manual",
          "locale"          => "fr",
          "locales_set"     => "fr: Français, en: English",
          "content_dirname" => "_locales",
        },
      }
    end

    it "returns the default 'locale identity' object" do
      expect(subject.default_locale.class).to eql(locale.class)
      expect(subject.default_locale.id).to eql("fr")
      expect(subject.default_locale.data).to eql({})
    end

    it "returns the default 'locale identity' object as the current locale" do
      expect(subject.current_locale).to eql(subject.default_locale)
    end

    it "returns an array of available locale ids" do
      expect(subject.available_locales).to eql(%w(fr))
    end
  end
end
