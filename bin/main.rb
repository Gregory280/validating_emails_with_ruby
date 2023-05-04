require_relative '../lib/read_csv.rb'
require_relative '../lib/verify_emails.rb'
require_relative '../lib/report_formatter.rb'

emails = ReadCsv.new('emails_list.csv').read
verified_emails = VerifyEmails.new(emails).validate
formatter = ReportFormatter.new(verified_emails)
formatter.create

