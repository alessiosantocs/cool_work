include Util
class Search < Merb::Controller
  before :get_site
  
  def index
    list=[]
    @site.regions.map do |r|
      list << "<li><a href='http://#{r.short_name}.#{domain}#{port==4000 ? ":3000" : ''}'>#{r.full_name}</a></li>"
    end
    @list = "<ul class='region'>#{list}</ul>"
    render
  end

  def results
    render
  end
  
  def new
    session[:foo] = 'bar'
    puts session.sess_id
    #render
  end

  def sess
    puts "session cookie: #{session[:user]}"
  end

  def test
    puts "protocol: #{protocol}"
    puts "ssl?: #{ssl?}"
    puts "uri: #{uri}"
    puts "path: #{path}"
    puts "path_info: #{path_info}"
    puts "port: #{port}"
    puts "host: #{host}"
    puts "domain: #{domain}"
    puts "get?: #{get?}"
    puts "post?: #{post?}"
    puts "put?: #{put?}"
    puts "delete?: #{delete?}"
    puts "head?: #{head?}"
    puts "xhr?: #{xhr?}"
    puts @env.inspect
  end
end
