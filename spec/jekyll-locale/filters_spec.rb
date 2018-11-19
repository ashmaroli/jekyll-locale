# frozen_string_literal: true

RSpec.describe Jekyll::Locale::Filters do
  FilterMock = Class.new
  FilterMock.include(Liquid::StandardFilters)
  FilterMock.include(Jekyll::Filters)
  FilterMock.include(described_class)

  let(:locale)    { "fr" }
  let(:config) do
    {
      "title"        => "Localization Test",
      "timezone"     => "America/New_York",
      "localization" => { "locale" => locale },
    }
  end
  let(:site) { make_site(config) }

  subject { FilterMock.new }

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
end
