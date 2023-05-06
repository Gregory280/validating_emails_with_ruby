class EmailInfo
  attr_reader :email, :status

  def initialize email, status
    @email = email
    @status = status
  end
end