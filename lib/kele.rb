class Kele
  include HTTParty

  def initialize(email, password)
    @email = email
    @password = password
    @url = 'https://www.bloc.io/api/v1'
    @auth_token =
  end
end
