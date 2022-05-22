# frozen_string_literal: true

require_relative "test_helper"
require_relative "../lib/ipgeobase"

class TestIpgeobase < Minitest::Test
  XML_US = "<query>
                  <country>United States</country>
                  <countryCode>US</countryCode>
                  <city>Ashburn</city>
                  <lat>39.03</lat>
                  <lon>-77.5</lon>
                  <query>8.8.8.8</query>
                </query>"

  XML_RU = "<query>
                <status>success</status>
                <country>Russia</country>
                <countryCode>RU</countryCode>
                <region>SVE</region>
                <regionName>Sverdlovsk Oblast</regionName>
                <city>Yekaterinburg</city>
                <zip>620000</zip>
                <lat>56.8439</lat>
                <lon>60.6524</lon>
                <timezone>Asia/Yekaterinburg</timezone>
                <isp>PJSC MegaFon</isp>
                <org>OJSC MegaFon GPRS/UMTS Network</org>
                <as>AS31224 PJSC MegaFon</as>
                <query>83.169.216.199</query>
              </query>"

  def setup
    stab_request_ru
    stab_request_us
  end

  def stab_request_us
    stub_request(:get, "http://[http//ip-api.com/xml/%5D:808.8.8.8")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Ruby"
        }
      )
      .to_return(status: 200, body: XML_US, headers: {})
  end

  def stab_request_ru
    stub_request(:get, "http://[http//ip-api.com/xml/%5D:8083.169.216.199")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Ruby"
        }
      )
      .to_return(status: 200, body: XML_RU, headers: {})
  end

  def test_that_it_has_a_version_number
    refute_nil ::Ipgeobase::VERSION
  end

  def test_empty_ip
    ip_meta = Ipgeobase.lookup("")
    assert { ip_meta == "Empty IP address!" }
  end

  def test_invalid_ip_length
    ip_meta = Ipgeobase.lookup("123.345.3")
    assert { ip_meta == "Invalid IP address length!" }

    ip_meta = Ipgeobase.lookup("123.345.3.5.6")
    assert { ip_meta == "Invalid IP address length!" }
  end

  def test_invalid_ip_not_numeric
    ip_meta = Ipgeobase.lookup("8.8.abc.8")
    assert { ip_meta == "Invalid IP address content! -> not numeric" }
  end

  def test_url_short
    ip_meta = Ipgeobase.lookup("8.8.8.8")

    assert { ip_meta.city == "Ashburn" }
    assert { ip_meta.country == "United States" }
    assert { ip_meta.countryCode == "US" }
    assert { ip_meta.lat == "39.03" }
    assert { ip_meta.lon == "-77.5" }
  end

  def test_url_full
    ip_meta = Ipgeobase.lookup("83.169.216.199")

    assert { ip_meta.city == "Yekaterinburg" }
    assert { ip_meta.country == "Russia" }
    assert { ip_meta.countryCode == "RU" }
    assert { ip_meta.lat == "56.8439" }
    assert { ip_meta.lon == "60.6524" }
  end
end

test_methods = TestIpgeobase.new({}).methods.select { |method| method.start_with? "test_" }
raise "TestIpgeobase has not tests!" if test_methods.empty?
