# frozen_string_literal: true

module Jekyll
  class Drops::UnifiedPayloadDrop
    def locale
      @locale ||= Locale::Drop.new(@obj.locale_handler)
    end
  end

  class Site
    def locale_handler
      @locale_handler ||= Locale::Handler.new(self)
    end
  end
end
