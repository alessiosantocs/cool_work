module Thoughtbot
	# Squirrel - SQL Simplification Plugin for ActiveRecord
	# This plugin extends the ActiveRecord::Base#find method to be able to
	# take a block of Ruby which will get parsed into a nice SQL string
	# and have its results returned.
	# 
	# Author::     Jon Yurek (mailto:jyurek@thoughtbot.com)
	# Copyright::  Copyright(c) 2006 thoughtbot, inc.
	# License::    Distributes under the same terms as Ruby

	# Squirrel is a plugin for ActiveRecord which attempts to make SQL
	# querier a much more natural prospect. You can write your queries
	# in Ruby code and they get translated, including all proper table
	# joins, into relevant SQL code and executed, returning your results.
	# 
	# == Basic Selection
	# 
	# Squirrel operates through overriding the ActiveRecord::Base#find method
	# If find is given a block parameter, Squirrel will take over execution.
	# If not, then it's passed to the original find method and normal execution
	# will take over.
	# 
	# Usage is similar to the ez_where[http://brainspl.at/articles/2006/01/30/i-have-been-busy] plugin, where columns
	# are used directly in the block, and compared to values.
	# 
	#   users = User.find do
	#       email =~ "%gmail.com"
	#       created_on > Time.now - 1.week
	#   end
	# 
	# Squirrel is different, however, in that it will generate the whole query as well as return all the results.
	# For example, the above code will generate the SQL
	# 
	#   SELECT users.* FROM users WHERE ( (users.email LIKE '%gmail.com') AND (created_on > '2006-09-01 12:13:37') )
	# 
	# and return all the relevant records.
	# 
	# The available operators are as follows:
	# 
	#   foo == 'bar'                                   =>  foo = 'bar'
	#   foo == nil                                     =>  foo IS NULL
	#   foo == [ 1, 2, 3 ]                             =>  foo IN ( 1, 2, 3 )
	#   foo =~ '%bar%'                                 =>  foo LIKE '%bar%'
	#   foo <=> (1..5)                                 =>  foo BETWEEN 1 AND 5
	#   foo <=> [ Time.now-2.years, Time.now-1.year ]  =>  foo BETWEEN '2004-09-08 12:13:37' AND '2005-09-08 12:13:37'
	#   foo > 3                                        =>  foo > 3
	#   ... and so on for >, <, <=, and >=
	# 
	# Conditions can be negated by using -
	# 
	#   posts = Post.find do
	#       id == 1
	#       - title == nil
	#   end
	# 
	# Generates...
	# 
	#   SELECT posts.* FROM posts WHERE ( (posts.id = 1) AND NOT (posts.title IS NULL) )
	# 
	# == Bringing Friends to the Party
	# 
	# Selecting on one table is usually pretty boring. One of the strengths of ActiveRecord is how it handles relationships,
	# so we should be able to easily bring in your model's friends, right? Right.
	# 
	#   posts = Post.find do
	#       user.id == [1, 4, 1092, 13]
	#       tags.name == "Rails"
	#   end
	# 
	# This will give you the results of (formatted for clarity)
	# 
	#   SELECT posts.*
	#   FROM posts
	#       LEFT OUTER JOIN users ON users.id = posts.user_id
	#       LEFT OUTER JOIN tags_posts ON tags_posts.post_id = posts.id
	#       LEFT OUTER JOIN tags ON tags.id = tags_posts.tag_id
	#   WHERE
	#       ( (users.id IN ( 1, 4, 1092, 13 )) AND (tags.name = 'Rails') )
	# 
	# because ActiveRecord so thoughtfully provides all the association SQL. What's more, is that these joins can be chained
	# together, and any column references will work correctly.
	# 
	#   posts = Post.find do
	#       user.company.addresses.city == "Cambridge"
	#       user.company.addresses.state == "MA"
	#   end
	# 
	# Gives us
	# 
	#   SELECT posts.*
	#   FROM posts
	#       LEFT OUTER JOIN users ON users.id = posts.user_id
	#       LEFT OUTER JOIN companies ON companies.id = users.company_id
	#       LEFT OUTER JOIN addresses ON companies.id = addresses.company_id
	#   WHERE
	#       ( (addresses.city = 'Cambridge') AND (addresses.state = 'MA') )
	# 
	# == Keeping Your Place in Line
	# 
	# Sometimes, you want to prepare a query in such a way that you can call it over and over without the overhead
	# of actually writing it out multiple times. In such cases, you'd really like a placeholder variable. Conveniently,
	# Squirrel has placeholder variables. They're of the form var? inside the query, and when you use them Squirrel
	# will give you the query object back. The query object is similar to a statement handle in more direct SQL libraries.
	# 
	#   posts = Post.find do
	#       id = id?
	#   end
	# 
	# This will assign the query object to posts. You can use the query object to get raw SQL (via to_s) as well as
	# SQL in a format that can be passed to ActiveRecord::Base#find_by_sql (via to_sql).
	# 
	#   posts.to_s( :id => nil ) # => "SELECT posts.* FROM posts WHERE id IS NULL"
	#   posts.to_sql( :id => 1 ) # => [ "SELECT posts.* FROM posts WHERE id = ?", 1 ]
	# 
	# To actually get your results, you'd use the find (or execute) method
	# 
	#   post = posts.find( :id => 1 )
	# 
	# Using the placeholders will change the operators as necessary. If you use, say, +id == id?+ in your query, you can
	# do all of the following, and the expected result will be achieved:
	# 
	#   posts.to_s( :id => 1 )             # => "SELECT posts.* FROM posts WHERE id = 1"
	#   posts.to_s( :id => "test" )        # => "SELECT posts.* FROM posts WHERE id = 'test'"
	#   posts.to_s( :id => nil )           # => "SELECT posts.* FROM posts WHERE id IS NULL"
	#   posts.to_s( :id => [1,2,3] )       # => "SELECT posts.* FROM posts WHERE id IN (1,2,3)"
	# 
	# If necessary, you can also obtain the query object from a normal call by passing :query to the find method.
	# 
	#   query = Post.find(:query) do
	#       id == 1
	#   end
	# 
	#   query.to_s                         # => "SELECT posts.* FROM posts WHERE id = 1"
	# 
	# 
	# == Letting the Database Do Its Work
	# 
	# Currently, the only extra thing that you can let the database handle is sorting order. Squirrel's roadmap says that eventually
	# you will be able to use more and more of the database's power for things like selecting counts, maxes, sums, and so on. However
	# right now, you can only sort.
	# 
	#   User.find do
	#       order_by created_on.desc
	#   end
	# 
	# Column#desc can be called on any column reference in the order_by clause and it will append the DESC properly in the SQL. Note that
	# any column in any table can be referenced in the order_by.
	# 
	#   User.find do
	#       order_by user_type.name, last_name
	#   end
	# 
	# This will create the same joins as selecting against the relationship, and it will maintain the proper column references.
	# 
	#   SELECT users.*
	#   FROM users
	#       LEFT OUTER JOIN user_types ON user_type.id = user.user_type_id
	#   ORDER BY
	#       user_types.name, users.last_name
	module Squirrel
		module ActiveRecordHook # :nodoc:
			def self.included base
				class << base
					alias_method :original_find, :find
					def find *args, &blk
						if blk
							query = Query.new(self, &blk) if blk
							case args.first
								when :query then query
								else (query.placeholders.blank? ? query.execute : query)
							end
						else
							original_find(*args)
						end
					end
				end
			end
		end

		# Query is the base of queries built with Squirrel.
		class Query
			attr_accessor :joins, :ordered_joins, :columns, :placeholders

			def initialize active_record, &blk
				@active_record = active_record
				@joins = {}
				@ordered_joins = []
				@columns = []
				@placeholders = {}
				@order_by = ""
				Table.new(self, @active_record).instance_eval &blk if blk
				self
			end

			def execute args = {}
				@active_record.find_by_sql( to_sql(args) )
			end
			alias_method :find, :execute

			def order_by *cols
				@order_by = "ORDER BY %s" % cols.collect(&:sortable_column).join(", ")
			end

			def to_s args = {}
				@active_record.send(:sanitize_sql, to_sql(args))
			end

			def to_sql args = {}
				args.each {|k,v| @placeholders[k.to_s].value = v}
				raise ArgumentError, "Wrong number of parameters, have #{args.size}, need #{@placeholders.size}" if @placeholders.size != args.size
				sql = "SELECT %s.* FROM %s " % [ @active_record.table_name, @active_record.table_name ]
				sql << @ordered_joins.collect{|j| j.join_associations.collect(&:association_join).join("") }.join(" ")
				wheres = []
				params = []
				@columns.each do |c|
					w, *v = c.to_sql
					wheres << w
					params += v
				end
				wheres << @active_record.class_eval{ type_condition } unless @active_record.class_eval{ descends_from_active_record? }
				sql << "WHERE (" << wheres.flatten.join(" AND ") << ")" unless wheres.empty?
				sql << @order_by
				[ sql, *params ]
			end

			class Table # :nodoc:
				attr_accessor :association, :reflection, :base, :active_record

				def initialize base, active_record
					@active_record = active_record
					@base = base

					existing_methods = [:method_missing, :order_by, :to_sql, :columns, :association]
					(@active_record.column_names - existing_methods).each do |col|
						(class << self; self; end).class_eval do
							define_method(col.to_s.intern) do
								column(col)
							end
						end
					end

					(@active_record.reflections.keys - existing_methods).each do |assn|
						(class << self; self; end).class_eval do
							define_method(assn.to_s.intern) do
								association(assn)
							end
						end
					end
				end

				def column *column_names
					column_names.collect{|c| Column.new(@base, @active_record, c.to_s.intern) }.last
				end

				def association assn_name
					assn_name = assn_name.to_s.intern
					reflection = @active_record.reflect_on_association(assn_name)
					association = ::ActiveRecord::Associations::ClassMethods::JoinDependency.new(@active_record, assn_name, nil)
					join_key = [@active_record.table_name, reflection.table_name].sort.join("_")
					unless @base.joins[ join_key ]
						@base.joins[ join_key ] = association
						@base.ordered_joins << association
					end
					Table.new(@base, reflection.klass)
				end
				alias_method :assoc, :association

				def method_missing meth, *args
					if (ph_match = meth.to_s.match /^(\w+)\?$/)
						return @base.placeholders[ph_match[1]] ||= Placeholder.new
					end
					raise NoMethodError, "Column or Relationship #{meth} not defined for #{@active_record.name}"
				end

				def order_by *cols
					@base.order_by *cols
				end
			end

			class Column # :nodoc:
				attr_accessor :column, :operator, :operand

				def initialize base, active_record, column
					@active_record = active_record
					@column = column
					@base = base
					@positive = true
					@descending = false
				end

				def column
					"%s.%s" % [ @active_record.table_name, @column ]
				end

				def sortable_column
					column + (@descending ? " DESC": "")
				end

				def descending
					@descending = true
					self
				end
				alias_method :desc, :descending

				def -@
					@positive = !@positive
					self
				end

				def +@
					self
				end

				def operand
					@operand.is_a?(Placeholder) ? @operand.value : @operand
				end

				[ :==, :===, :=~, :<=>, :<=, :<, :>, :>= ].each do |op|
					define_method(op) do |val|
						@operator = op
						@operand = val
						@base.columns << self
					end
				end

				def to_sql
					neg = @positive ? "" : "NOT "
					op, arg_format, values = @operator, "?", [operand]
					op, arg_format, values = case @operator
						when :<=>       then    [ "BETWEEN", "? AND ?",   [ operand.first, operand.last ] ]
						when :=~        then    [ "LIKE",    arg_format,  values ]
						when :==, :===  then case operand
							when Array then [ "IN",      "(?)",       values ]
							when nil then   [ "IS",      "NULL",      [] ]
							else            [ "=",       arg_format,  values ]
						end
						else                    [ op,        arg_format,  values ]
					end		
					sql = "%s(%s.%s %s %s)" % [neg, @active_record.table_name, @column, op, arg_format]
					[ sql, *values ]
				end
			end

			# The Placeholder values are created when you use the in a query. They take the form var?
			# and will cause the find call to return a Query object instead of a result set. When
			# the query is called later, you will pass a hash to it whose keys are the "var" part of the
			# Placeholder objects created inside the query.
			class Placeholder
				attr_accessor :name, :value
				def initialize name = nil, value = nil
					@name = name
					@value = value
				end
			end
		end
	end
end