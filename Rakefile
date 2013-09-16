#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require "bundler/gem_tasks"
require 'find'
require 'rake/clean'
require 'guard'
require 'headless'
require 'fileutils'

Rizzo::Application.load_tasks

CLOBBER.include('public/assets/javascripts/lib')
CLOBBER.include('public/assets/javascripts/spec')

desc 'Compile CoffeeScript files to JavaScript'
task :compile => [:clobber] do
  Guard.setup
  Guard::Dsl.evaluate_guardfile(:guardfile => 'Guardfile')
  Guard.guards(:group => :assets).each{|g| g.run_all()}
end

namespace :jasmine do
  namespace :ci do
    desc "Run Jasmine CI build headlessly"
    task :headless do
      Headless.ly do
        puts "Running Jasmine Headlessly"
        Rake::Task['jasmine:ci'].invoke
      end
    end
  end
end

# default jasmine init task
begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end

desc 'clean, compile coffescript, run jasmine:ci'
task :jasmine_ccci=>[:clobber, :compile, 'jasmine:ci:headless']
