require 'rubygems'
require 'yaml'
require 'feed-normalizer'
module Feed
  class BlogFeed
    attr_reader :data, :errors
    def initialize(feed_url, file, ttl=30, reload=false)
      @file = file
      @errors = []
      @ttl = (reload ? 0 : ttl * 60)
      @data = YAML.load(File.open(@file)) if File.exists?(@file)
      @data ||= { :url => feed_url, :entries => [], :downloaded_on => nil }
      if download?
        fetch
        write_to_yaml if @errors.empty?
      end
    end
    
    def available?
      @errors.empty?
    end
    
    private
    def fetch
      begin
        feed = FeedNormalizer::FeedNormalizer.parse(open(@data[:url]))
        @data[:entries] = []
        feed.items.each do |item| 
          @data[:entries] << {
            :content => item.content, 
            :date_published => item.date_published.utc, 
            :title => item.title,
            :description => item.description, 
            :link =>  item.id
          }
        end
        @data[:downloaded_on] = Time.now.utc
      rescue
        @errors << "#{@feed_url} can't be reached."
      end
    end
  
    def download?
      return true if @data[:downloaded_on].nil?
      (@data[:downloaded_on] + @ttl <=> Time.now.utc) == -1 ? true : false
    end
  
    def write_file_atomic(path,&block)
      path_tmp = path + '.tmp'
      open(path_tmp,'w') do |file|
        yield file
      end
      system "mv #{path_tmp} #{path}"
    end

    def write_to_yaml
      write_file_atomic(@file){|fd| fd.write @data.to_yaml }
    end
  end
end