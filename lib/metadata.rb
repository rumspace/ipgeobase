# frozen_string_literal: true

require "happymapper"

# A class for mapping of metadata using HappyMapper
class Metadata
  include HappyMapper

  tag "query"
  element :city, String
  element :country, String
  element :countryCode, String
  element :lat, String
  element :lon, String
end
