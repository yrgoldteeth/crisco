module ApplicationHelper
  def tweetbot_custom_url user
    get_create_link_url + command_query_string(user.authentication_token, '%@')
  end

  def example_curl_command user
    query = command_query_string(user.authentication_token, 'http://google.com')
    "curl #{get_create_link_url + query}"
  end

  def command_query_string auth_token, original_url
    "?auth_token=#{auth_token}&original_url=#{original_url}"
  end

  def crisco_version
    `cat ./VERSION`
  end
end
