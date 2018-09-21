# frozen_string_literal: true

module Jekyll
  class Locale::Drop < Drops::Drop
    extend Forwardable

    mutable false
    private def_delegator :@obj, :data, :fallback_data
  end
end
