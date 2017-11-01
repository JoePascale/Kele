require 'httparty'
require 'json'

class Kele
  include HTTParty

  def initialize(email, password)
    @url = 'https://www.bloc.io/api/v1'
    response = self.class.post("#{@url}/sessions",
      body: {email: email, password: password })
    @auth_token = response['auth_token']
    puts response["message"] if response["message"]
  end

  def get_me
    response = self.class.get("#{@url}/users/me", headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    @id = mentor_id
    response = self.class.get("#{@url}/mentors/#{@id}/student_availability", headers: { "authorization" => @auth_token})
    hash = JSON.parse(response.body)
    hash.each do |time_slot|
      p time_slot["starts_at"]
    end
  end
end
