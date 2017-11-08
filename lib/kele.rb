require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    @url = 'https://www.bloc.io/api/v1'
    response = self.class.post("#{@url}/sessions",
      body: { email: email, password: password })
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

  def get_messages(page = nil)
    response = self.class.get("#{@url}/message_threads",
      headers: { "authorization" => @auth_token},
      body: { page: page })
    JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, subject, stripped_text)
    response = self.class.post("#{@url}/messages",
      headers: { "authorization" => @auth_token },
      body: { sender: sender, recipient_id: recipient_id,
      subject: subject, "stripped-text" => stripped_text })
    puts response["message"] if response["message"]
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id)
    response = self.class.post("#{@url}/checkpoint_submissions",
    headers: { "authorization" => @auth_token },
    body: { checkpoint_id: checkpoint_id, assignment_branch: assignment_branch,
      assignment_commit_link: assignment_commit_link, comment: comment, enrollment_id: enrollment_id })
    puts response["message"] if response["message"]
  end
end
