require 'csv'

class ReportFormatter
  attr_reader :verified_emails

  def initialize *verified_emails
    @verified_emails = verified_emails
  end

  def create
    csv 'valid_emails.csv'
    File.write("emails.html", html)
  end

  private
  def csv file
    CSV.open(file, 'wb') do |writer|
      @verified_emails[0].each do |e|
        if e.status == 'deliverable'
          writer << [e.email, e.status]
        end
      end
    end
  end

  def html
    tag("html", [head, body].join("\n"))
  end

  def body
    tag("body", [headline, table].join("\n"))
  end

  def headline
    tag("h1", "Email Verification")
  end

  def table
    tag("table", [thead, tbody].join("\n"))
  end

  def thead
    tag("thead", ths.join("\n"))
  end
  
  def ths
    headers = ["Email", "Status"]
    headers.map { |content| tag("th", content) }
  end

  def tbody
    tag("tbody", trs.join("\n"))
  end

  def trs
    rows.map { |row| tr(row) }
  end

  def tr(row)
    tag("tr", tds(row).join("\n"))
  end

  def tds(row)
    row.collect do |content| 
        tag("td", content)
    end
  end

  def rows
    @verified_emails[0].collect do |email|
      [email.email, email.status]
    end
  end

  def tag(name, content)
    content = "\n#{content}\n" unless ["h1", "td", "th"].include?(name)
    html = "<#{name} #{'class=\' undeliverable\'' if content == 'undeliverable'}>#{content}</#{name}>"
    html = indent(html) unless name == :html
    html
  end

  def indent(html)
    lines = html.split("\n")
    lines = lines.map { |line| " " * 2 + line }
    lines.join("\n")
  end

  def head
    "<head>
      <style>
        h1 {
          color:#009879;
          font-family:sans-serif
        }
        table {
          border-collapse:collapse;
          margin: 25px 0;
          font-size: 0.9em;
          font-family: sans-serif;
          min-width: 400px;
          box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
        }
        thead tr {
          background-color: #009879;
          color: #ffffff;
          text-align: left;
        }
        td, th {
          padding: 12px 15px;
        }
        .undeliverable {
          color: red
        }
      </style>
    </head>"
  end
end