# frozen_string_literal: true

RSpec.describe Jekyll::Locale::Page do
  let(:page_name) { "about.md" }
  let(:locale)    { "en" }
  let(:config) do
    {
      "title"        => "Localization Test",
      "localization" => {
        "locale"      => locale,
        "locales_set" => %w(en fr ja)
      },
    }
  end
  let(:site)  { make_site(config) }
  let(:canon) { make_canon_page(site, page_name) }

  subject { described_class.new(canon, locale) }

  before do
    make_page_file("_locales/#{locale}/#{page_name}", :content => "Hello World")
    make_page_file("_locales/fr/#{page_name}", :content => "Hello World")
    make_page_file("_locales/ja/#{page_name}", :content => "Hello World")
  end

  after do
    content_dir = source_dir("_locales")
    FileUtils.rm_rf(content_dir) if File.directory?(content_dir)
  end

  it "returns the custom inspect string" do
    expect(subject.inspect).to eql(
      "#<Jekyll::Locale::Page @canon=#{canon.inspect} @locale=#{locale.inspect}>"
    )
  end

  it "returns the 'locale' attribute" do
    expect(subject.locale).to eql("en")
  end

  it "matches the 'relative_path' attribute with its canonical page" do
    expect(subject.relative_path).to eql(File.join("_locales", "en", canon.relative_path))
  end

  it "matches the 'url' attribute with its canonical page by default" do
    expect(subject.url).to eql(File.join("", "en", canon.url))
  end

  it "returns a hash for Liquid templates" do
    subject.content ||= "Random content"
    expect(subject.to_liquid.class.name).to eql("Hash")
    expect(subject.to_liquid).to eql(
      "content" => "Hello World\n{{ page.url }}\n\n{{ 'now' | localize_date }}\n",
      "dir"     => "/en/",
      "foo"     => "bar",
      "layout"  => "none",
      "meta"    => "about_locale",
      "name"    => "about.md",
      "path"    => "_locales/en/about.md",
      "url"     => "/en/about.html"
    )
  end

  it "returns hreflang and locale_sibling data for Liquid templates" do
    site.process

    hreflangs = [
      { "locale" => "en", "url" => "/about.html"    },
      { "locale" => "fr", "url" => "/fr/about.html" },
      { "locale" => "ja", "url" => "/ja/about.html" },
    ]
    canon = site.pages.find { |p| p.is_a?(Jekyll::Page) && p.url == "/about.html" }
    expect(canon.hreflangs).to eql(hreflangs)
    expect(canon.locale_siblings).to eql(
      [
        { "locale" => "fr", "url" => "/fr/about.html" },
        { "locale" => "ja", "url" => "/ja/about.html" },
      ]
    )

    locale_page = site.pages.find { |p| p.is_a?(described_class) && p.url == "/fr/about.html" }
    expect(locale_page.hreflangs).to eql(hreflangs)
    expect(locale_page.locale_siblings).to eql(
      [
        { "locale" => "en", "url" => "/about.html"    },
        { "locale" => "ja", "url" => "/ja/about.html" },
      ]
    )
  end
end
