# frozen_string_literal: true

RSpec.describe Jekyll::Locale::Document do
  let(:collection) { "posts" }
  let(:doc_name)   { "2018-10-15-hello-world.md" }
  let(:locale)     { "en" }
  let(:config) do
    {
      "title"        => "Localization Test",
      "localization" => { "locale" => locale },
    }
  end
  let(:site)  { make_site(config) }
  let(:canon) { make_canon_document(site, doc_name, collection) }

  subject { described_class.new(canon, locale) }

  before do
    make_page_file("_locales/en/_posts/#{doc_name}", :content => "Hello World")
  end

  after do
    content_dir = source_dir("_locales")
    FileUtils.rm_rf(content_dir) if File.directory?(content_dir)
  end

  it "returns the custom inspect string" do
    expect(subject.inspect).to eql(
      "#<Jekyll::Locale::Document @canon=#{canon.inspect} @locale=#{locale.inspect}>"
    )
  end

  it "returns the 'locale' attribute" do
    expect(subject.locale).to eql("en")
  end

  it "matches the 'relative_path' attribute with its canonical document" do
    expect(subject.relative_path).to eql(File.join("_locales", "en", canon.relative_path))
  end

  it "matches the 'url' attribute with its canonical document by default" do
    expect(subject.url).to eql(File.join("", "en", canon.url))
  end

  it "returns drop data for Liquid templates" do
    subject.content ||= "Random content"
    expect(subject.to_liquid.class.name).to eql("Jekyll::Drops::DocumentDrop")

    drop_data = JSON.parse(subject.to_liquid.to_json)
    drop_data.delete("date")
    expect(drop_data).to eql(
      "categories"    => [],
      "collection"    => "posts",
      "content"       => "Hello World\n{{ page.url }}\n\n{{ 'now' | localize_date }}\n",
      "draft"         => false,
      "excerpt"       => "<p>Hello World\n/en/2018/10/15/hello-world.html</p>\n\n",
      "ext"           => ".md",
      "foo"           => "bar",
      "id"            => "/en/2018/10/15/hello-world",
      "next"          => nil,
      "output"        => nil,
      "path"          => "_locales/en/_posts/2018-10-15-hello-world.md",
      "previous"      => nil,
      "relative_path" => "_locales/en/_posts/2018-10-15-hello-world.md",
      "slug"          => "hello-world",
      "tags"          => [],
      "title"         => "Hello World",
      "url"           => "/en/2018/10/15/hello-world.html"
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
          "url"      => "/2018/10/15/hello-world.html",
        },
      ]
    )
  end
end
