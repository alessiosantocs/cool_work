#For Storing authorized users in sessions table
class Auth
  attr_accessor :id, :username, :email, :country, :postal_code, :classic_view, :roles
  def initialize(id, username, email, country, postal_code, classic_view, roles)
    @id = id
    @username = username
    @email = email
    @country = country
    @postal_code = postal_code
    @classic_view = classic_view
    @roles = roles
  end
end