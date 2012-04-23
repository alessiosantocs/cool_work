module AdminHelper
  def menu_for_admin(home=false)
    if home
      link = "<a href='/admin'>Admin Home</a>"
    else
      link = "Admin Home"
    end
    <<-EOL
    <h1><a href='http://www.#{SITE.url}/'>#{SITE.full_name} Home</a> &gt;&gt; <span id="current_section">#{link}</span></h1>
    EOL
  end
end