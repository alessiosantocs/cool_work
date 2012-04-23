function basic_form_save(){
	
	basic_form_contract();
	showCompanyView();
	var fi = new Array(); 
	fi["company[name]"] = inputString($('#companyName').val());
	fi["company[employee_number]"] = $('#companyEmployeeNumber').val();
	fi["company[description]"]=inputString($('#companyDescription').val());
	fi["company[founded]"]=$('#companyFoundeddate').val();
	fi["company[enabled]"]=$("input[name='pdisplay']:checked").val();
	fi["company[url]"]=$('#companyURL').val();
	fi["company[private_notes]"] = inputString($('#companyPrivateNotes').val());
	if (info["company"]["commit"] == "Create"){
	fi["commit"]="Create";
	}
	else{
	fi["commit"]="Update";
	fi["id"] = companyID;
	}

$.ajax({
   type: "POST",
   url: "company.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
     if (info["company"]["commit"] == "Create"){
     companyID = $("id",xml).text();
}
     info["company"]["commit"] = "Update";
    showCompanyView();
	}});
}





function basic_form_cancel(){
	basic_form_contract();
}



function basic_info_get(){

        basic_form_contract();
	//        showCompanyView();
        var fi = new Array();
        fi["companyID"] = companyID;
$.ajax({
   type: "GET",
   url: "companyInfo.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    //alert(xml);
    info["company"]["name"] =  outputString($("name",xml).text());
    info["company"]["description"] =  outputString($("description",xml).html());
    info["company"]["employee-number"] =  $("employee-number",xml).text();
    info["company"]["enabled"] =  $("enabled",xml).text();
    info["company"]["founded"] =  $("founded",xml).text();
    info["company"]["private-notes"] =  outputString($("private-notes",xml).text());
    info["company"]["url"] =  urlStyle(outputString($("url",xml).text()));
    basic_info_update();
    if (admin) basic_form_update(); 
        }
   });


}


function internal_form_save(){
	basic_form_save();
	internal_form_contract();

}

function internal_form_cancel(){
	internal_form_contract();
}


function basic_info_update(){
 $("#companyNameI").text(info["company"]["name"]);
 $("#companyDescriptionI").text(info["company"]["description"]);
 $("#companyEmployeeNumberI").text(info["company"]["employee-number"]);
 // radio button
 if (info["company"]["enabled"] == "true") $('#companyEnabledI').text("Enabled"); 
 else $('#companyEnabledI').text("Disabled");
 $("#companyFoundedI").text(info["company"]["founded"]);
 $("#companyURLI").html('<a href=http://'+info["company"]["url"]+'>'+info["company"]["url"]+'</a>');
 $("#companyPrivateNotesI").text(info["company"]["private-notes"]);
// $("#companyUrlI").text(info["company"]["url"]);
 
}

function basic_form_update(){
 $("#companyName").val(info["company"]["name"]);
 $("#companyDescription").val(info["company"]["description"]);
 $("#companyEmployeeNumber").val(info["company"]["employee-number"]);
 $("#companyEnabled").val(info["company"]["enabled"]);
 $("#companyFounded").val(info["company"]["founded"]);
 $("#companyPrivateNotes").val(info["company"]["private-notes"]);
  $("#companyURL").val(info["company"]["url"]);
// $("#companyUrl").text(info[["company"]"description"]);


}
