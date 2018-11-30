# frozen_string_literal: true

RSpec.describe Jekyll::Locale::Filters do
  class FilterMock
    def initialize(context)
      @context = context
    end
  end

  FilterMock.include(Liquid::StandardFilters)
  FilterMock.include(Jekyll::Filters)
  FilterMock.include(described_class)

  let(:site_locale) { "fr" }
  let(:page_locale) { "fr" }
  let(:config) do
    {
      "title"        => "Localization Test",
      "timezone"     => "America/New_York",
      "localization" => { "locale" => site_locale },
    }
  end
  let(:site)    { make_site(config) }
  let(:page)    { { "locale" => page_locale, "title" => "Hello World" } }
  let(:context) { Liquid::Context.new({}, {}, :site => site, :page => page) }

  subject { FilterMock.new(context) }

  before do
    site.read
    site.locale_handler.setup
  end

  context "with the 'localize_date' filter" do
    let(:input) { "2018-11-18T22:10:35-0500" }

    it "returns the 'default' localized date string" do
      expect(subject.localize_date(input)).to eql("18 novembre 2018 22 h 10 min 35 s")
    end

    it "returns the 'short' format of localized date string" do
      expect(subject.localize_date(input, ":short")).to eql("18 novembre 2018")
    end

    it "parses the strftime notation and returns the localized date string" do
      expect(subject.localize_date(input, "%Y %B %d")).to eql("2018 novembre 18")
    end

    it "uses the 'default' format with invalid format parameter" do
      expect(subject.localize_date(input, "short")).to eql("18 novembre 2018 22 h 10 min 35 s")
    end
  end

  context "with the 'prefix_locale' filter" do
    it "returns the input if it is not a String instance" do
      expect(subject.prefix_locale(nil)).to eql(nil)
      expect(subject.prefix_locale(site)).to eql(site)
      expect(subject.prefix_locale(page)).to eql(page)
    end

    it "ensures a single leading slash" do
      expect(subject.prefix_locale("about.html")).to eql("/about.html")
      expect(subject.prefix_locale("///about//")).to eql("/about/")
    end

    it "returns input if it is an absolute uri" do
      absolute_url = "https://www.example.com/about/"
      expect(subject.prefix_locale(absolute_url)).to eql(absolute_url)
    end

    context "with a non-default page locale" do
      let(:page_locale) { "ja" }

      it "returns the input if it is not a String instance" do
        expect(subject.prefix_locale(nil)).to eql(nil)
        expect(subject.prefix_locale(site)).to eql(site)
        expect(subject.prefix_locale(page)).to eql(page)
      end

      it "ensures a single leading slash" do
        expect(subject.prefix_locale("about.html")).to eql("/ja/about.html")
        expect(subject.prefix_locale("///about//")).to eql("/ja/about/")
      end

      it "returns input if it is an absolute uri" do
        absolute_url = "https://www.example.com/about/"
        expect(subject.prefix_locale(absolute_url)).to eql(absolute_url)
      end
    end
  end
end
