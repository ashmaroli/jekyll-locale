# frozen_string_literal: true

module Jekyll
  class Locale::Identity
    attr_reader  :id, :data
    alias_method :to_s, :id

    def initialize(locale_id, metadata)
      @id   = locale_id.to_s
      @data = metadata
    end

    def to_liquid
      @to_liquid ||= data.merge("id" => id)
    end
  end
end
