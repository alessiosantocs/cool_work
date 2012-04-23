function investments_form_save(){
	investments_form_contract();
	
	var fi = new Array(); 
	fi["investment[agency]"] = $('#investmentAgency').val();
	fi["investment[funding_date]"] = $('#investmentDate').val();
	fi["investment[funding_type]"]=$("input[name='itype']:checked").val();
	fi["investment[funding_amount]"]=$('#investmentFundingAmount').val();
	
}

function investments_form_cancel(){
	investments_form_contract();
}


function investment_form_save(){
        investments_form_contract();

        var fi = new Array();
        fi["investment[agency]"] = $('#investmentAgency').val();
        fi["investment[funding_date]"] = $('#investmentDate').val();
        fi["investment[funding_type]"]=$("input[name='itype']:checked").val();
        fi["investment[funding_amount]"]=$('#investmentFundingAmount').val();
	fi["investment[company_id]"] = companyID;
	var commit = info["investment"]["commit"];
        fi["commit"]=commit;
        if(commit == "Update"){
             fi["id"] = info["investment"]["actionID"];
        }

        $.ajax({
        type: "POST",
        url: "investment.php",
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){

        investment_info_get();
        }});
        info["investment"]["commit"] = "Create";
        info["investment"]["actionID"] = 0;
}



function investment_info_get(){
        info["investment"] = new Array();
        info["investment"]["commit"] = "Create";
        info["investment"]["actionID"] = 0;
        info["investment"]["count"] = 0;
       people_form_contract();
        var fi = new Array();
        fi["companyID"] = companyID;
$.ajax({
   type: "GET",
   url: "investmentInfo.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    $(xml).find("investment").each(function(){
    var $marker = $(this);
    info["investment"][count] = new Array();
    info["investment"][count]["funding_type"] = $marker.find("funding-type").text();
    info["investment"][count]["funding_date"] = $marker.find("funding-date").text();
    info["investment"][count]["agency"] = $marker.find("agency").text();
    info["investment"][count]["funding_amount"] = $marker.find("funding-amount").text();
    info["investment"][count]["id"] = $marker.find("id").text();

    info["investment"][count]["count"] = count;
    count += 1;

    });
    info["investment"]["count"] = count;

    investment_info_update();

}
});
}

function investment_form_update(count){
   var maker = info["investment"][count];
   $("#itype").val(maker["funding_type"]);
   $("#investmentDate").val(maker["funding_date"]);
   $("#investmentAgency").val(maker["agency"]);
   $("#investmentFundingAmount").val(maker["funding_amount"]);


   info["investment"]["commit"]= "Update";
   info["investment"]["actionID"] = maker["id"];
   investments_form_expand();
}








function investment_form_delete(count){
   fi = new Array();
   fi["id"] =  info["investment"][count]["id"];
$.ajax({
   type: "GET",
   url: "investmentDelete.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    investment_info_get();

}
});
}











function investment_info_update(){
var outString = "<ul>";
var count = 0;
$(info["investment"]).each(function(){
        var marker = info["investment"][count];
        outString += "<li>Agency: " + marker["agency"];
        if (admin){
        outString += "<a href=\"javascript:investment_form_delete("+count+");\"><img src=\"css/blueprint/plugins/buttons/icons/deleteitem.png\" /></a><a href=\"javascript:investment_form_update("+count+");\"><img src=\"css/blueprint/plugins/buttons/icons/pencil.png\" /></a>";
        }
        outString +="<br>";
        outString += "Funding Date: " + marker["funding_date"] + "<br>";
        outString += "Funding Amount: " + marker["funding_amount"] + "<br>";
        outString += "Funding Type: " + marker["funding_type"] + "<br>";
        outString += "<br><br></li>";
        count += 1;

});
outString += "</ul>";

if (info["investment"]["count"]==0){
outString = "No investments have been entered for this company yet.";
}

$("#investments_info").html(outString);
}

