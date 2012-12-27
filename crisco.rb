#!/usr/bin/env ruby

require 'pry'
require 'thor'
require 'curb'
require 'json'
require 'ostruct'
require 'active_support/core_ext/hash'


module Api
  extend self

  def get uri_path, params={}
    full_uri = base_uri + uri_path
    c = Curl.get(full_uri, params.merge(auth_token: auth_token)) do |curl|
      curl.headers['Accept'] = 'application/json'
    end
    c.body_str
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
    @result ||= Api.get("/links")
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
    @result ||= Api.get("/l", {original_url: original_url})
  end
end

class Crisco < Thor
  map "-l" => :list

  desc 'list', 'list all shortened links'
  def list
    table = [ ['Original URL', 'Short URL', 'Created At'] ]
    links_list = FetchLinksList.new
    links_list.each do |link|
      table << [link.original_url, link.short_url, link.created_at]
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
end

begin
  Crisco.start
rescue => e
  $stderr.puts "[ERROR] " + e.message
  exit(1)
end
