function references_form_new(){
   var fi = new Array();
   fi["id"] = companyID;
   $.ajax({
   type: "GET",
   url: urlProcess("/references/add_references"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Add References',xml);

}
});
}



function reference_info_get(){
        info["reference"] = new Array();
        info["reference"]["commit"] = "Create";
        info["reference"]["actionID"] = 0;
	info["reference"]["count"] = 0; 
        references_form_contract();
        var fi = new Array();
        fi["company_id"] = companyID;
        notUrlKey = true;
$.ajax({

   url: urlProcess("/references/find_by_company"),
   datatype: "xml",
      data: returnStringArray(fi),
      type: "GET",
      complete: function(){ global_array[5] = 1;},
   success: function(xml){
    var count = 0;
    $(xml).find(xmlStyle("reference")).each(function(){
    var $marker = $(this);
    info["reference"][count] = new Array();
    info["reference"][count]["id"] = $marker.find("id").text();
    info["reference"][count]["URL"] = outputString($marker.find("url").text());
    info["reference"][count]["date"] = $marker.find("dateEntered").text();
    info["reference"][count]["article_field_name"] =$marker.find("article-field-name").text();
    info["reference"][count]["count"] = count;
    count += 1;

    });
    info["reference"]["count"] = count;
    reference_info_update();

}
});
}


function reference_form_update(count){
   var maker = info["reference"][count];
 

  var fi = new Array();
fi["id"] = companyID;
fi["reference_id"]=maker["id"];
   $.ajax({
   type: "GET",
   url: urlProcess("/references/add_references"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Edit Reference',xml);
}
});
}





function references_form_cancel(){
	references_form_contract();
}



function reference_info_update(){
var outString = "<ul>";
var count = 0;
$(info["reference"]).each(function(){
        var marker = info["reference"][count];
        
        if (admin){
	outString += "<li> "
        outString += "URL: " + marker["URL"]; 
        outString += "<a href=\"javascript:reference_form_delete("+count+");\"><img src=\"/images/icons/deleteitem.png\" /></a><a href=\"javascript:reference_form_update("+count+");\"><img src=\"/images/icons/pencil.png\" /></a>";
        outString +="<br>";
        outString += "Entered Date: "+ checkDate((marker["date"])) + "<br>";
	outString += "Article: <a target='_blank' href='"+marker['URL']+"'>"+marker['article_field_name']+"</a>" + "<br>";
	outString += "</li> "
        }
        else
	{
	        outString += "<li> "
	        outString += "Entered Date: "+ checkDate((marker["date"])) + "<br>";
		outString += "Article: <a target='_blank' href='"+marker['URL']+"'>"+marker['article_field_name']+"</a>" + "<br>";
	        outString += "</li> "
	}

  
        count += 1;

});
outString += "</ul>";

if (info["reference"]["count"]==0){
outString = "No references have been entered for this company yet.";
}

$("#references_info").html(outString);
}

