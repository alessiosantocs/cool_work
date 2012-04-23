module PracticalHelper
  
  # link_to_delete ""
  def link_to_delete(link_text,options={},html_options={})
    options = {
      :with => %{'_method=delete'},
      :confirm => %{Are you sure you want to delete this item?\nWarning: there is no undo.}
    }.merge(options)
    
    html_options = {
      :href => 'javascript:void%200'
    }.merge(html_options)
    
    link_to_remote(link_text,options,html_options)
  end

  def markdown_link
    "<a href=\"http://daringfireball.net/projects/markdown\" target=\"_blank\">Markdown</a>"
  end

  def clearing(options={})
    options.reverse_merge!({
      :tag => 'div',
      :nbsp => false
    })
    
    content_tag options[:tag], (options[:nbsp] ? "&nbsp;" : ""), :style => 'clear:both;display:block'
  end
  
  def html_editor_with_preview(field_name="",field_value="")
    res  = "<ul id=\"PreviewTabs\">"
    res += "<li class=\"tab on\" id=\"EditTab\"><a href=\"#\" id=\"EditLink\">Edit</a></li>"
    res += "<li class=\"tab\" id=\"PreviewTab\"><a href=\"#\" id=\"PreviewLink\">Preview</a></li>"
    res += "<div style=\"clear:both\"></div>"
    res += "</ul>"
    res += content_tag 'div', text_area_tag(field_name, field_value.to_s.gsub(/\&/,"&amp;"), {:rows => '20', :class => 'StandardTextArea StandardField', :id => 'EditorText'}), :id => 'EditorBox', :class => 'PreviewBoxBasic'
    res += content_tag('div',content_tag('div','&nbsp;',:id => 'PreviewBoxContents', :onclick => 'switchToEditor();'), :id => 'PreviewBox', :class => 'PreviewBoxBasic',:style => 'display:none')
    res += "<div id=\"PreviewInfo\" class=\"label\" style=\"margin-top: 3px;\">"
    res += "You can use <a href=\"http://daringfireball.net/projects/markdown\" target=\"_blank\">Markdown</a> formatting or plain HTML to style this text."
    res += "</div>"
    res += content_tag('script', 'createLiveEditor();', :type => 'text/javascript')
    res += hidden_field_tag 'preview_ajax_url', url_for(:controller => 'articles', :action => 'preview_html'), :id => 'preview_ajax_url'
  end
  
end