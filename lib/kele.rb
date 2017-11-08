require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    @url = 'https://www.bloc.io/api/v1'
    response = self.class.post("#{@url}/sessions",
      body: {email: email, password: password })
    @auth_token = response['auth_token']
    puts response["message"] if response["message"]
  end

  def get_me
    response = self.class.get("#{@url}/users/me",
      headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("#{@url}/mentors/#{mentor_id}/student_availability",
      headers: { "authorization" => @auth_token})
    hash = JSON.parse(response.body)
    hash.each do |time_slot|
      p time_slot["starts_at"]
    end
  end

  def get_messages(*page)
    response = self.class.get("#{@url}/message_threads",
      headers: { "authorization" => @auth_token})
    if page.empty?
      JSON.parse(response.body)
    else
      JSON.parse(response.body["page"])
    end
  end

  def create_message(sender, recipient_id, token, subject, stripped_text)
    response = self.class.post("#{@url}/messages",
      headers: { "authorization" => @auth_token },
      body: {sender: sender, recipient_id: recipient_id,
      token: token, subject: subject, stripped_text: stripped_text })
    puts response["message"] if response["message"]
  end
end
