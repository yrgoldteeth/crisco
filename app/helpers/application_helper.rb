module ApplicationHelper
  def tweetbot_custom_url user
    get_create_link_url + "?auth_token=#{user.authentication_token}&original_url=%@"
  end

  def example_curl_command user
    "curl #{get_create_link_url}?auth_token=#{user.authentication_token}&original_url=http://google.com"
  end

  def crisco_version
    `cat ./VERSION`
  end
end
