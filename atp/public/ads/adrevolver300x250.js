// Instructions:
// 1. Create a file on your web server called ad.js using a text editor.
//    (any name with the .js extension will work)
// 2. Paste this code into the .js file
// 3. Update the "... Javascript URL" in your Fastclick default to point to the .js file on your server.

var dz=document;
dz.writeln("<!--AdRevolver code begin-->");
dz.writeln("<SCRIPT language=\"JavaScript\" type=\"text/javascript\">");
dz.writeln("<!--");
dz.writeln("var rnd = Math.round(Math.random() * 10000000);");
dz.writeln("document.writeln('<IFRAME src=\"http://media.adrevolver.com/adrevolver/banner?place=4505&cpy='+rnd+'\" width=300 height=250 scrolling=no allowtransparency=true frameborder=0 marginheight=0 marginwidth=0></IFRAME>\\n');");
dz.writeln("//-->");
dz.writeln("<\/script>");
dz.writeln("<!--AdRevolver code end-->");