#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'rake/version_task'
Rake::VersionTask.new do |task|
  task.with_git_tag = false
end

require File.expand_path('../config/application', __FILE__)

Crisco::Application.load_tasks
