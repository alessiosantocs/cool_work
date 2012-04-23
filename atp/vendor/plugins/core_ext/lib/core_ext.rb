require "utils"
require "string"
require "hash"
require "array"
require "time_utils"
require "asset_package_helper"
ActionView::Base.send :include, ActionView::Helpers

# require "right_aws"
# require 'sdb/active_sdb'
# require "active_sdb"
# RightAws::ActiveSdb::Base.send :include, ActiveSdb::Ext
# RightAws::ActiveSdb::Base.send :extend, ActiveSdb::ExtClass
# 
# require "cache"
# ActiveRecord::Base.send :include, Cache::InstanceMethods
# ActiveRecord::Base.send :extend, Cache::ClassMethods

include Utils