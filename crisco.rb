#!/usr/bin/env ruby

require 'pry'
require 'thor'
require 'curb'
require 'json'
require 'ostruct'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/array'

class Api

  def method_missing meth, *args, &block
    if [:get, :delete].include?(meth)
      params = args.extract_options!
      params.merge!(auth_token: auth_token)
      full_uri = base_uri + args[0]
      curl_args = [full_uri, params]
      c = Curl.send(meth, *curl_args) do |curl|
        curl.headers['Accept'] = 'application/json'
      end
      c.body_str
    else
      super
    end
  end

  private
  def base_uri
    ENV['CRISCO_BASE_URI'] || die('CRISCO_BASE_URI')
  end

  def auth_token
    ENV['CRISCO_AUTH_TOKEN'] || die('CRISCO_AUTH_TOKEN')
  end

  def die var
    raise "Environment variable #{var} must be set."
  end
end

class FetchLinksList
  include Enumerable

  def each
    links.map {|link| yield link}
  end

  def links
    @links ||= parsed_results["links"].map{|l| OpenStruct.new(l.symbolize_keys)}
  end

  private
  def raw_request_result
    @result ||= Api.new.get("/links")
  end

  def parsed_results
    JSON.parse(raw_request_result)
  end
end

class CreateNewLink

  attr_reader :original_url

  def initialize original_url
    @original_url = original_url
  end

  def result_message
    if parsed_results["shorturl"]
      parsed_results["shorturl"]
    else
      raise "An error occurred shortening the url"
    end
  end

  private
  def parsed_results
    JSON.parse(raw_request_result)
  end

  def raw_request_result
    @result ||= Api.new.get("/l", {original_url: original_url})
  end
end

class DeleteLink

  attr_reader :slug

  def initialize slug
    @slug = slug
  end

  def result_message
    if parsed_results["success"]
      "The link was successfully destroyed."
    else
      raise "An error occurred destroying the link"
    end
  end

  private
  def parsed_results
    JSON.parse(raw_request_result)
  end

  def raw_request_result
    @result ||= Api.new.delete("/links/#{slug}")
  end
end

class Crisco < Thor
  map "-l" => :list

  desc 'list', 'list all shortened links'
  def list
    table = [ ['Slug', 'Original URL', 'Short URL', 'Created At', 'Visit Count'] ]
    links_list = FetchLinksList.new
    links_list.each do |link|
      table << [link.slug, link.original_url[0..40], link.short_url, link.created_at, link.visits_count]
    end
    print_table table
  end

  map "-n" => :new

  desc 'new', 'shorten a new link'
  def new original_url=nil
    unless original_url
      original_url = ask 'What URL would you like to shorten?'
    end
    linker = CreateNewLink.new(original_url)
    say linker.result_message
  end

  map "-d" => :delete

  desc 'delete', 'delete a link'
  def delete slug=nil
    unless slug
      slug = ask 'What is the slug of URL you would like to delete?'
    end
    deleter = DeleteLink.new(slug)
    say deleter.result_message
  end
end

begin
  Crisco.start
rescue => e
  $stderr.puts "[ERROR] " + e.message
  exit(1)
end
