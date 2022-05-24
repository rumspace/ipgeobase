# frozen_string_literal: true

require_relative "ipgeobase/version"
require_relative "metadata"

require "net/http"

# Service to fetch public metadata from IP-address
module Ipgeobase
  class Error < StandardError; end

  def self.lookup(ip)
    return "Empty IP address!" if ip.nil? || ip == ""
    return "Invalid IP address length!" if ip.split(".").length != 4
    return "Invalid IP address content! -> not numeric" if ip.split(".").any? { |num| num.to_i.zero? && num != "0" }

    url_response = Net::HTTP.get("http://ip-api.com/xml/", ip)

    Metadata.parse(url_response, single: true)
  end
end
