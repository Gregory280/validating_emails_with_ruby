%w{net/http uri json}.each { |e| require e }
require_relative 'email_info.rb'

class VerifyEmails
  API_KEY = ENV['BOUNCER_API_KEY']
  API_ENDPOINT = 'https://api.usebouncer.com/v1.1/email/verify?email='
  
  attr_accessor :emails
  def initialize emails
      @emails = emails
  end

  def validate
    emails.map do |email|
      response = request email
      response.code == '200' ? data = filter(response) : next
      EmailInfo.new(data['email'], data['status'])
    end
  end

  private
  def request email
    uri = URI.parse("#{API_ENDPOINT}#{email}")
    request = Net::HTTP::Get.new(uri)
    request["x-Api-Key"] = API_KEY
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) { |http| http.request(request) }
  end

  def filter response
    JSON
      .parse(response.body)
      .slice("email", "status")
  end
end
