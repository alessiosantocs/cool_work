module Merb
  module GlobalHelper
    def party_url(p, domain = "alltheparties.com")
      "http://#{p.city.region.short_name}.#{domain}/party/#{p.id}"
    end
  end
end