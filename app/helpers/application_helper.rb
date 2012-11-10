module ApplicationHelper
  def tweetbot_custom_url user
    get_create_link_url + "?auth_token=#{user.authentication_token}&original_url=%@"
  end
end
