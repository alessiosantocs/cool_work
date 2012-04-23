function template_form_new(){
   var fi = new Array();
   fi["id"] = companyID;
   $.ajax({
   type: "GET",
   url: urlProcess("/email_template/add_template"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Add Template',xml);

}
});
}



function template_form_cancel(){
	template_form_contract();
}

function template_info_get(){
	info["template"] = new Array();
	info["template"]["commit"] = "Create";
        info["template"]["actionID"] = 0;
	info["template"]["count"] = 0;
        template_form_contract();
         var fi = new Array();
        fi["company_id"] = companyID;
        notUrlKey = true;
    $.ajax({
    type: "GET",
    url: urlProcess("/email_trackers/give_all_template"),
    data: returnStringArray(fi),
    datatype: "xml",
    success: function(xml){
        var count = 0;
        $(xml).find(xmlStyle("email-template")).each(function(){
        var $marker = $(this);   
        info["template"][count] = new Array(); 
        info["template"][count]["name"] = $marker.find("template-name").text();	
        info["template"][count]["data"] = $marker.find("template-data").text();
        info["template"][count]["id"] = $marker.find("id").text();
        info["template"][count]["count"] = count; 
        count += 1;
        });
        info["template"]["count"] = count;
 
        template_info_update();

}  
});
}


function template_form_update(count){
   var maker = info["template"][count];
   $("#templateName").val(maker["name"]);
   $("#templateData").val(maker["data"]);
   info["template"]["commit"]= "Update";
   info["template"]["actionID"] = maker["id"];
   template_form_expand();
}


function template_info_update(){
var outString = "<ul>";
var count = 0;
$(info["template"]).each(function(){
	var marker = info["template"][count];
	outString += "<li><div>Template: " + marker["name"]; 
	if (admin){

	outString += "<a href=\"javascript:template_form_delete("+count+");\"><img src=\"/images/icons/deleteitem.png\" /></a><a href=\"javascript:template_form_update("+count+");\"><img src=\"/images/icons/pencil.png\" /></a><button type=\"Preview\" class=\"negative\" onclick=\"preview_email_template("+marker["id"]+")\">Preview</button>";
	}
      
	outString+="</div></li>";
        count += 1;
});
outString += "</ul>";

if (info["template"]["count"]==0){
outString = "No people have been entered for this company yet.";
}

$("#template_info").html(outString);
}



function template_form_cancel(){
	template_form_contract();
}

