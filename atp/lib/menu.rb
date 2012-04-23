module Menu
  def generate_menu(id, menu = [], selected=nil)
    return if menu.length == 0
    txt = menu.collect{ |m|
      selected == m[:id] ? li_hash = { :id => "#{id}_#{m[:id]}", :class => 'selected' } : li_hash = { :id => "#{id}_#{m[:id]}" }
      content_tag('li', content_tag('a', m[:name], { :href => m[:url]}), li_hash ) 
    }
    <<-EOL
      #{render_menu_stylesheet()}
      <div id="#{id}">
        <ul>#{txt}</ul>
      </div>
    EOL
  end
  
  def render_menu_stylesheet
    <<-EOL
    <style type="text/css">
      .ddoverlap{
        border-bottom: 1px solid #bbb8a9;
      }
      
      .ddoverlap ul{
        padding: 0;
        margin: 0;
        font: bold 90% default;
        list-style-type: none;
      }
      
      .ddoverlap li{
        display: inline;
        margin: 0;
      }
      
      .ddoverlap li a{
        padding: 3px 7px;
        text-decoration: none;
        padding-right: 32px; /*extra right padding to account for curved right edge of tab image*/
        color: blue;
        background: transparent url('/images/righttabdefault.gif') 100% 1px no-repeat; /*give illusion of shifting 1px down vertically*/
        border-left: 1px solid #dbdbd5;
        position: relative;
        display: block;
        float: left;
        margin-left: -20px; /*shift tabs 20px to the left so they overlap*/
        left: 20px;
      }
      
      .ddoverlap li a:visited{
        color: blue;
      }
      
      .ddoverlap li a:hover{
        text-decoration: underline;
      }
      
      .ddoverlap li.selected a{ /*selected tab style*/
        color: black;
        z-index: 100; /*higher z-index so selected tab is topmost*/
        top: 1px; /*Shift tab 1px down so the border beneath it is covered*/
        background: transparent url('/images/righttabselected.gif') 100% 0 no-repeat;
      }
      
      .ddoverlap li.selected a:hover{
        text-decoration: none;
      }
      
      </style>
      
      <!--[if IE]>
      <style type="text/css">
      .ddoverlap{
        height: 1%;  /*Apply Holly 3px jog hack to get IE to position bottom border correctly beneath the menu*/
      }
      </style>
      <![endif]-->
    EOL
  end
end