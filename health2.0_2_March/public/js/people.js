
function people_form_save(){
	people_form_contract();
	
	var fi = new Array(); 
	fi["personnel[first_name]"] = $('#personnelFirstName').val();
	fi["personnel[last_name]"] = $('#personnelLastName').val();
	fi["personnel[current_title]"]=$('#personnelCurrentTitle').val();
	fi["personnel[previous_title]"]=$('#personnelPreviousTitle').val();
	fi["personnel[grad_edu]"] = $('#personnelGradEdu').val();
	fi["personnel[undergrad_edu]"] = $('#personnelUndergraduateEdu').val();
	fi["personnel[other_edu]"]=$('#personnelOtherEdu').val();
	fi["personnel[founder]"]=$("input[name='ftype']:checked").val();
	fi["personnel[company_id]"]=companyID;
	var commit = info["people"]["commit"];
        fi["commit"]=commit;
        if(commit == "Update"){
             fi["id"] = info["people"]["actionID"];
        }  

	$.ajax({
   	type: "POST",
   	url: "people.php",
   	data: returnStringArray(fi),
   	datatype: "xml",
   	success: function(xml){
	
    	people_info_get();
        }});
	info["people"]["commit"] = "Create";
	info["people"]["actionID"] = 0;
}
function people_info_get(){
        
	info["people"] = new Array();
	info["people"]["commit"] = "Create";
        info["people"]["actionID"] = 0;
	info["people"]["count"] = 0;
        people_form_contract();
        var fi = new Array();
        fi["companyID"] = companyID;
$.ajax({
   type: "GET",
   url: "peopleInfo.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    $(xml).find("personnel").each(function(){
    var $marker = $(this);    
    info["people"][count] = new Array(); 
    info["people"][count]["first_name"] = $marker.find("first-name").text();	
    info["people"][count]["last_name"] = $marker.find("last-name").text();      
    info["people"][count]["current_title"] = $marker.find("current-title").text();  
    info["people"][count]["previous_title"] = $marker.find("previous-title").text();  
    info["people"][count]["grad_edu"] = $marker.find("grad-edu").text();  
    info["people"][count]["undergrad_edu"] = $marker.find("undergrad-edu").text();  
    info["people"][count]["other_edu"] = $marker.find("other-edu").text();
    info["people"][count]["founder"] = $marker.find("founder").text();
    info["people"][count]["id"] = $marker.find("id").text();
    info["people"][count]["count"] = count; 
    count += 1;

    });
    info["people"]["count"] = count;

    people_info_update();

}  
});
}

function people_form_delete(count){
   fi = new Array();
   fi["id"] =  info["people"][count]["id"];
$.ajax({
   type: "GET",
   url: "peopleDelete.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    people_info_get();

}
});
}


function people_form_new(){
   $("#personnelFirstName").val("");
   $("#personnelLastName").val("");
   $("#personnelCurrentTitle").val("");
   $("#personnelPreviousTitle").val("");
   $("#personnelGradEdu").val("");
   $("#personnelUndergradEdu").val("");
   $("#personnelOtherEdu").val("");
   $("#personnelFounder").val("");
	people_form_expand(); 

}


function people_form_cancel(){

	people_form_contract();
}




function people_form_update(count){
   var maker = info["people"][count];
   $("#personnelFirstName").val(maker["first_name"]);
   $("#personnelLastName").val(maker["last_name"]);
   $("#personnelCurrentTitle").val(maker["current_title"]);
   $("#personnelPreviousTitle").val(maker["previous_title"]);
   $("#personnelGradEdu").val(maker["grad_edu"]);
   $("#personnelUndergradEdu").val(maker["undergrad_edu"]);
   $("#personnelOtherEdu").val(maker["other_edu"]);
   $("#personnelFounder").val(maker["founder"]);
   info["people"]["commit"]= "Update";
   info["people"]["actionID"] = maker["id"];
   people_form_expand();
}

function people_info_update(){
var outString = "<ul>";
var count = 0;
$(info["people"]).each(function(){
	var marker = info["people"][count];
       
	outString += "<li>Name: " + marker["first_name"] + " " + marker["last_name"]; 
	if (admin){

	outString += "<a href=\"javascript:people_form_delete("+count+");\"><img src=\"css/blueprint/plugins/buttons/icons/deleteitem.png\" /></a><a href=\"javascript:people_form_update("+count+");\"><img src=\"css/blueprint/plugins/buttons/icons/pencil.png\" /></a>";

	}
	outString +="<br>";
	outString += "Position: " + marker["current_title"] + "<br>";
	outString += "Former Position: " + marker["previous_title"] + "<br>";
	outString += "Graduate Education: " + marker["grad_edu"] + "<br>";
	outString += "Undergraduate Education: " + marker["undergrad_edu"] + "<br>";
	outString += "Other Education: " + marker["other_edu"] + "<br>";
	outString += "Founder: ";
	if (marker["founder"] == "true") outString += "Yes";
	else outString += "No";
	outString += "<br><br></li>";
	count += 1;

});
outString += "</ul>";

if (info["people"]["count"]==0){
outString = "No people have been entered for this company yet.";
}

$("#people_info").html(outString);
}
