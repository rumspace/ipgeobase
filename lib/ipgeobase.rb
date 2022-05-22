# frozen_string_literal: true

require_relative "ipgeobase/version"

require "happymapper"
require "addressable/template"
require "net/http"
require "uri"

# Service to fetch public metadata from IP-address
module Ipgeobase
  class Error < StandardError; end

  class Metadata
    include HappyMapper

    tag "query"
    element :city, String
    element :country, String
    element :countryCode, String
    element :lat, String
    element :lon, String
  end

  def self.lookup(ip)
    return "Empty IP address!" if ip.nil? || ip == ""
    return "Invalid IP address length!" if ip.split(".").length != 4
    return "Invalid IP address content! -> not numeric" if ip.split(".").any? { |num| num.to_i.zero? && num != "0" }

    # url = Addressable::Template.new("http://ip-api.com/xml/{query}")
    # url.expand({"query" => ip})

    url_response = Net::HTTP.get("http://ip-api.com/xml/", ip)

    Metadata.parse(url_response, single: true)
  end
end
