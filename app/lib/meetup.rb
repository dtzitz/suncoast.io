class Meetup
  include HTTParty
  base_uri 'api.meetup.com'

  def self.token
    ENV['MEETUP_API_TOKEN']
  end

  def self.auth_params
    { sign: "true", key: token }
  end

  def self.path_for(path)
    ["/#{path}", auth_params.to_query].join '?'
  end

  def self.group(group_id)
    get path_for(group_id)
  end
end
