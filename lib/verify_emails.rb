require 'net/http'
require 'uri'
require 'json'
require_relative 'email_info.rb'

class VerifyEmails
  API_KEY = ENV['BOUNCER_API_KEY']
  API_ENDPOINT = 'https://api.usebouncer.com/v1.1/email/verify?email='
  
  attr_accessor :emails
  def initialize emails
      @emails = emails
  end

  def validate
    verified_emails = Array.new
    emails.each do |email|
      response = request email
      data = filter response
      verified_emails << EmailInfo.new(data['email'], data['status'])
    end
    verified_emails
  end

  private
  def request email
    uri = URI.parse("#{API_ENDPOINT}#{email}")
    request = Net::HTTP::Get.new(uri)
    request["x-Api-Key"] = API_KEY
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

  def filter response
    JSON
      .parse(response.body)
      .slice("email", "status")
  end
end