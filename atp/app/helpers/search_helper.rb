module SearchHelper
  def show_latest_news(entries_shown=15)
    list = []
    begin
      blog = BlogFeed.new(FEED_XML, FEED_YAML_PATH, FEED_TTL)
      if blog.available?
        entries_shown = blog.data[:entries].size if blog.data[:entries].size <= entries_shown
        show_this_many = ( (1..15).include?(entries_shown) ? entries_shown - 1 : blog.data[:entries].size - 1 )
        blog.data[:entries][0..show_this_many].each do |entry|
          list <<  content_tag("li", "#{entry[:date_published].time_ago}: " << link_to(entry[:title].maxlength(60), entry[:link]) )
        end
        content_tag("ul", list, {:class=>'feed'})
      else
        content_tag("p", "No news available at this time.", {:class=>'feed'})
      end
    rescue # ActionView::TemplateError
      content_tag("p", "No news available at this time.", {:class=>'feed'})
    end
  end
end
