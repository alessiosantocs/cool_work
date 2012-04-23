require 'rubygems'
require 'yaml'
gem 'soap4r'
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')
SETTING = YAML::load(File.open("#{RAILS_ROOT}/config/settings.yml"))

Rails::Initializer.run do |config|
  config.frameworks -= [ :action_web_service ]
  config.plugins = [:hoptoad_notifier, :exception_notification, :simply_helpful, :resource_feeder, :request_routing, :tzinfo_timezone, :xml_simple_doctype_fix, 
    :acts_as_commentable, :acts_as_priceable, :acts_as_rateable, :acts_as_taggable, :acts_as_voteable, :responds_to_parent, 
    :attachment_fu, :core_ext, :will_paginate, :newrelic_rpm, :acts_as_list, :acts_as_tree, :auto_complete] # :engines, :datebocks_engine, :minus_r, :minus_mor,
  config.action_controller.session_store = :active_record_store
  config.active_record.schema_format = :ruby
  config.active_record.default_timezone = :utc
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers #{RAILS_ROOT}/app/observers #{RAILS_ROOT}/app/notifiers )
end

require 'aws/s3'
require 'money'
require 'tzinfo'
include TZInfo
include Utils
include AWS::S3
S3 = YAML.load_file("#{RAILS_ROOT}/config/amazon_s3.yml")[ENV['RAILS_ENV']].symbolize_keys
require "order"