

function partnership_form_save(){
        partnerships_form_contract();

        var fi = new Array();
        fi["partnership[description]"] = $('#partnershipDescription').val();
        fi["partnership[date]"] = $('#partnershipDate').val();
        fi["partnership[company_id]"]=companyID;
        var commit = info["partnership"]["commit"];
        fi["commit"]=commit;
        if(commit == "Update"){
             fi["id"] = info["partnership"]["actionID"];
        }

        $.ajax({
        type: "POST",
        url: "partnership.php",
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){

        partnership_info_get();
        }});
        info["partnership"]["commit"] = "Create";
        info["partnership"]["actionID"] = 0;
}


function partnerships_form_new(){
	
   $("#partnershipDescription").val("");
   $("#partnershipDate").val("");
	partnerships_form_expand(); 

}

function partnership_info_get(){
        alert("partnerships");
        info["partnership"] = new Array();
        info["partnership"]["commit"] = "Create";
        info["partnership"]["actionID"] = 0;
        info["partnership"]["count"] = 0;
       partnerships_form_contract();
        var fi = new Array();
        fi["companyID"] = companyID;
$.ajax({
   type: "GET",
   url: "partnershipInfo.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    $(xml).find("partnership").each(function(){
    var $marker = $(this);
    info["partnership"][count] = new Array();
    info["partnership"][count]["description"] = outputString($marker.find("description").text());
    info["partnership"][count]["date"] = $marker.find("date").text();
    info["partnership"][count]["id"] = $marker.find("id").text();

    info["partnership"][count]["count"] = count;
    count += 1;

    });
    info["partnership"]["count"] = count;

    partnership_info_update();

}
});
}

function partnership_form_update(count){
   var maker = info["partnership"][count];
   $("#partnershipDescription").val(maker["name"]);
   $("#partnershipDate").val(maker["date"]);
   info["partnership"]["commit"]= "Update";
   info["partnership"]["actionID"] = maker["id"];
   partnerships_form_expand();
}





function partnerships_form_save(){
	partnerships_form_contract();
	
	var fi = new Array(); 
	fi["partnership[description]"] = inputString($('#partnershipDescription').val());
	fi["partnership[date]"] = $('#partnershipDate').val();
	fi["commit"]="Create";
	printArray(fi);
        fi["personnel[company_id]"]=companyID;
        fi["commit"]=commit;
        if(commit == "Update"){
             fi["id"] = id;
        }

        $.ajax({
        type: "POST",
        url: "people.php",
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){
        alert(xml);

        people_info_get();
        }});

	
}

function partnerships_form_cancel(){
	partnerships_form_contract();
}


function partnership_info_update(){
var outString = "<ul>";
var count = 0;
$(info["partnership"]).each(function(){
        var marker = info["partnership"][count];
        outString += "<li>" + marker["date"]+":"+marker["description"];
        if (admin){

        outString += "<a href=\"javascript:partnership_form_delete("+count+");\"><img src=\"css/blueprint/plugins/buttons/icons/deleteitem.png\" /></a><a href=\"javascript:partnership_form_update("+count+");\"><img src=\"css/blueprint/plugins/buttons/icons/pencil.png\" /></a>";

        }
        outString += "<br><br></li>";
        count += 1;

});
outString += "</ul>";

if (info["partnership"]["count"]==0){
outString = "No partnerships have been entered for this company yet.";
}

$("#partnerships_info").html(outString);
}

