module Roadmap
  def get_roadmap(roadmap_id)
    @id = roadmap_id
    response = self.class.get("#{@url}/roadmaps/#{@id}",
      headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    @id = checkpoint_id
    response = self.class.get("#{@url}/checkpoints/#{@id}",
      headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end
end
