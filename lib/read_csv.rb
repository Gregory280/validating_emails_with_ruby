require 'csv'
require_relative 'verify_emails.rb'

class ReadCsv
  def initialize filename
    @csv = CSV.new(File.read(filename), headers: true)
  end

  def read
    @csv.map do |row|
      row = row.to_h
      row['email']
    end
  end
end
