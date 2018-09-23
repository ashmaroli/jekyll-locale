# frozen_string_literal: true

module Jekyll
  class Locale::Drop < Drops::Drop
    extend Forwardable

    mutable false
    private def_delegator :@obj, :data, :fallback_data
  end

  #

  class Locale::PageDrop < Locale::Drop
    def_delegators :@obj, :locale, :url
  end
end
