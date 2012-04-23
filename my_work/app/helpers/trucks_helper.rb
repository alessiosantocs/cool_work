module TrucksHelper
  def color_picker(id, name, hex_color)
    returning html = '' do
      html << "<select id=#{id}_#{name} name=#{id}[#{name}]>"
      html << color_option('CC3333', 'Firebrick', hex_color)
      html << color_option('DD4477', 'Hotpink', hex_color)
      html << color_option('994499', 'Darkorchid', hex_color)
      html << color_option('6633CC', 'Blueviolet', hex_color)
      html << color_option('336699', 'Steelblue', hex_color)
      html << color_option('3366CC', 'Royalblue', hex_color)
      html << color_option('22AA99', 'Seagreen', hex_color)
      html << color_option('329262', 'Palegreen', hex_color)
      html << color_option('109618', 'Limegreen', hex_color)
      html << color_option('66AA00', 'Lightgreen', hex_color)
      html << color_option('AAAA11', 'Greenyellow', hex_color)
      html << color_option('D6AE00', 'Yellow', hex_color)
      html << color_option('EE8800', 'Cadiumyellow', hex_color)
      html << color_option('DD5511', 'Orangebrick', hex_color)
      html << color_option('A87070', 'Peachpuff', hex_color)
      html << color_option('8C6D8C', 'Lightthistle', hex_color)
      html << color_option('627487', 'Slategray', hex_color)
      html << color_option('7083A8', 'Cadetblue', hex_color)
      html << color_option('5C8D87', 'Darkcyan', hex_color)
      html << color_option('898951', 'Autumnleaves', hex_color)
      html << color_option('B08B59', 'Tan', hex_color)
      html << "</select>"
    end
  end
  
  private
  def color_option(color, name, selected_color)
    selected = selected_color == color ? "selected" : ""
    "<option #{selected} value='#{color}' style='color: white; background-color: ##{color}'>#{name}</option>"
  end
end