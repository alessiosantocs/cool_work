require 'test/unit'
require File.dirname(__FILE__) + "/test_helper.rb"
require File.dirname(__FILE__) + "/../init.rb"

class Post < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :tags
end

class User < ActiveRecord::Base
	belongs_to :company
	has_many :posts
end

class Company < ActiveRecord::Base
	has_many :users
	has_many :addresses
end

class Address < ActiveRecord::Base
	belongs_to :company
end

class Tag < ActiveRecord::Base
end

class SquirrelTest < Test::Unit::TestCase
	fixtures :posts, :users, :companies, :addresses, :tags, :posts_tags

	def test_simple_operators
		posts = Post.find { title =~ "%Rails%" }
		assert_equal 2, posts.first.id

		posts = Post.find { id == 1 }
		assert_equal 1, posts.first.id
	end

	def test_query_object
		query = Post.find(:query) do
			+ id == 1
			+ id == [1,2,3]
			+ id <=> (0..10)
			+ id > 0
			+ id < 10
			+ id >= 0
			+ id <= 10
			- id == nil
			- title =~ "%Rails%"
		end
		assert_equal "SELECT posts.* FROM posts WHERE ((posts.id = 1) AND (posts.id IN (1,2,3)) AND (posts.id BETWEEN 0 AND 10) AND (posts.id > 0) AND (posts.id < 10) AND (posts.id >= 0) AND (posts.id <= 10) AND NOT (posts.id IS NULL) AND NOT (posts.title LIKE '%Rails%'))".squeeze(" "),
		             query.to_s.squeeze(" ")

                query = Company.find(:query) do
                        users.name =~ "%Jon%"
                        users.posts.tags.name == "Stuff"
                end
		assert_equal "SELECT companies.* FROM companies  LEFT OUTER JOIN users ON users.company_id = companies.id   LEFT OUTER JOIN posts ON posts.user_id = users.id   LEFT OUTER JOIN posts_tags ON posts_tags.post_id = posts.id  LEFT OUTER JOIN tags ON tags.id = posts_tags.tag_id WHERE ((users.name LIKE '%Jon%') AND (tags.name = 'Stuff'))".squeeze(" "),
		             query.to_s.squeeze(" ")
		assert_equal 1, query.find.first.id
	end
 
	def test_joins
		posts = Post.find do
			- user.company.addresses.city == "Cambridge"
			+ tags.name =~ "%Stuff%"
			order_by id.desc
		end
		assert_equal 3, posts.length
		assert_equal [6,3,1], posts.collect{|post| post.id}
	end

	def test_placeholders
		users = User.find { - email =~ email? }
		assert_equal [1,2], users.find(:email => "%google%").collect{|u| u.id}

		posts = Post.find { tags.name == tag? }
		assert_equal (posts.find(:tag => "rails") + posts.find(:tag => "stuff")).collect(&:id).uniq.sort,
		             posts.find(:tag => ["rails", "stuff"]).collect(&:id).uniq.sort
	end
end
