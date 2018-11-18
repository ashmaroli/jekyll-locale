# frozen_string_literal: true

RSpec.describe Jekyll::Locale::AutoPage do
  let(:page_name) { "about.md" }
  let(:locale)    { "en" }
  let(:config) do
    {
      "title"        => "Localization Test",
      "localization" => { "locale" => locale },
    }
  end
  let(:site)  { make_site(config) }
  let(:canon) { make_canon_page(site, page_name) }

  subject { described_class.new(canon, locale) }

  before do
    make_page_file("_locales/en/#{page_name}", :content => "Hello World")
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

  it "returns the 'locale' attribute" do
    expect(subject.locale).to eql("en")
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
      "name"    => "about.md",
      "path"    => "about.md",
      "url"     => "/en/about.html"
    )
  end

  it "returns hreflang data for Liquid templates" do
    expect(canon.locale_pages).to eql([])
    canon.locale_pages << subject

    subject.setup_hreflangs if subject.setup_hreflangs?
    expect(subject.hreflangs).to eql(
      [
        {
          "locale"   => "en",
          "relation" => "canonical",
          "url"      => "/about.html",
        },
      ]
    )
  end
end
