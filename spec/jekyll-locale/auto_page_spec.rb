# frozen_string_literal: true

RSpec.describe Jekyll::Locale::AutoPage do
  let(:page_name)   { "about.md" }
  let(:locale_id)   { "en" }
  let(:metadata)    { {} }
  let(:locale)      { Jekyll::Locale::Identity.new(locale_id, metadata) }
  let(:locales_set) { %w(en fr ja) }
  let(:config) do
    {
      "title"        => "Localization Test",
      "localization" => {
        "mode"        => "auto",
        "locale"      => locale_id,
        "locales_set" => locales_set,
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
      "#<Jekyll::Locale::AutoPage @canon=#{canon.inspect} @locale=#{locale.inspect}>"
    )
  end

  it "returns the 'locale identity' object" do
    expect(subject.locale).to eql(locale)
    expect(subject.locale.id).to eql("en")
  end

  it "matches the 'relative_path' attribute with its canonical page" do
    expect(subject.relative_path).to eql(canon.relative_path)
  end

  it "matches the 'url' attribute with its canonical page by default" do
    expect(subject.url).to eql(File.join("", "en", canon.url))
  end

  it "returns a hash for Liquid templates" do
    subject.content ||= "Random content"
    expect(subject.to_liquid.class.name).to eql("Hash")
    expect(subject.to_liquid).to eql(
      "content" => "{{ locale.welcome }}!\nCanonical Content.\n",
      "dir"     => "/",
      "layout"  => "none",
      "meta"    => "about_site",
      "name"    => "about.md",
      "path"    => "about.md",
      "url"     => "/en/about.html"
    )
  end

  it "returns hreflang and locale_sibling data for Liquid templates" do
    site.process

    hreflangs = [
      { "locale" => { "id" => "en" }, "url" => "/about.html"    },
      { "locale" => { "id" => "fr" }, "url" => "/fr/about.html" },
      { "locale" => { "id" => "ja" }, "url" => "/ja/about.html" },
    ]
    canon = site.pages.find { |p| p.is_a?(Jekyll::Page) && p.url == "/about.html" }
    expect(canon.hreflangs).to eql(hreflangs)
    expect(canon.locale_siblings).to eql(
      [
        { "locale" => { "id" => "fr" }, "url" => "/fr/about.html" },
        { "locale" => { "id" => "ja" }, "url" => "/ja/about.html" },
      ]
    )

    auto_page = site.pages.find { |p| p.is_a?(described_class) && p.url == "/fr/about.html" }
    expect(auto_page.hreflangs).to eql(hreflangs)
    expect(auto_page.locale_siblings).to eql(
      [
        { "locale" => { "id" => "en" }, "url" => "/about.html"    },
        { "locale" => { "id" => "ja" }, "url" => "/ja/about.html" },
      ]
    )
  end

  context "with locale metadata via locales_set configuration" do
    let(:locales_set) do
      {
        "fr" => { "label" => "Français" },
        "en" => { "label" => "English" },
        "ja" => { "label" => "日本語" },
      }
    end

    it "returns hreflang and locale_sibling data for Liquid templates" do
      site.process

      hreflangs = [
        { "locale" => { "id" => "en", "label" => "English"  }, "url" => "/about.html"    },
        { "locale" => { "id" => "fr", "label" => "Français" }, "url" => "/fr/about.html" },
        { "locale" => { "id" => "ja", "label" => "日本語"    }, "url" => "/ja/about.html" },
      ]
      canon = site.pages.find { |p| p.is_a?(Jekyll::Page) && p.url == "/about.html" }
      expect(canon.hreflangs).to eql(hreflangs)
      expect(canon.locale_siblings).to eql(
        [
          { "locale" => { "id" => "fr", "label" => "Français" }, "url" => "/fr/about.html" },
          { "locale" => { "id" => "ja", "label" => "日本語"    }, "url" => "/ja/about.html" },
        ]
      )

      auto_page = site.pages.find { |p| p.is_a?(described_class) && p.url == "/fr/about.html" }
      expect(auto_page.hreflangs).to eql(hreflangs)
      expect(auto_page.locale_siblings).to eql(
        [
          { "locale" => { "id" => "en", "label" => "English" }, "url" => "/about.html"    },
          { "locale" => { "id" => "ja", "label" => "日本語"   }, "url" => "/ja/about.html" },
        ]
      )
    end
  end
end
