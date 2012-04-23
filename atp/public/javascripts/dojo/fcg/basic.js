/* 
   The dojo.provide statement specifies that this .js source file provides a 
   fcg.basic module. Semantically, the fcg.basic module also provides a namespace for 
   functions that are included in the module On disk, this file 
   would be named basic.js and be placed inside of a fcg directory. 
*/ 
dojo.provide("fcg.basic"); 
//Note that the function is relative to the module's namespace 
fcg.basic.swap_css_class_name = function(array_of_ids, start_class, destination_class) { 
  var nl = new dojo.NodeList();
  nl = nl.concat(array_of_ids);
  nl.toggleClass(start_class).toggleClass(destination_class);
  return false;
}