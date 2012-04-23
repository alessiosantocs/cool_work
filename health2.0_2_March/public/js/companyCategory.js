

function companyCategoryCreate(categoryID){
        keywords_form_contract();

        var fi = new Array();
        fi["companyID"] = companyID;
        fi["categoryID"] = categoryID;

        var commit = "Create";
        fi["commit"]=commit;

        $.ajax({
        type: "POST",
        url: "companyCategory.php",
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){

        companyCategory_info_get();
        }});
}

function companyCategoryDelete(id){

        var fi = new Array();
        fi["id"] = id;

        $.ajax({
        type: "GET",
        url: "companyCategoryDelete.php",
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){
	companyCategory_info_get();

        }});
}

var idInfo = new Array();
var idChecked = new Array();

function companyCategory_info_get(){
        info["companyCategory"] = new Array();
        info["companyCategory"]["commit"] = "Create";
        info["companyCategory"]["actionID"] = 0;
        info["companyCategory"]["count"] = 0;
       products_form_contract();
        var fi = new Array();
        fi["companyID"] = companyID;
	idChecked = new Array();
	idInfo = new Array();
	catString = "";
$.ajax({
   type: "GET",
   url: "companyCategoryInfo.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    $(xml).find("company-category").each(function(){
    var $marker = $(this);
    var categoryID = $marker.find("category-id").text();
    var id = $marker.find("id").text();
    info["companyCategory"][count] = new Array();
    if(admin == false){
    info["companyCategory"][count]["category_id"] = categoryID;
    info["companyCategory"][count]["id"] = id
    count += 1;
    companyCategoryName(categoryID);

    }
    else{
	if(idChecked[categoryID] == "exists"){
	 if(idInfo[categoryID] != id){    
	 companyCategoryDelete(id);

	}
	}
	else{
   	     info["companyCategory"][count]["category_id"] = categoryID;
	     info["companyCategory"][count]["id"] = id;
	     idChecked[categoryID] = "exists";
	     idInfo[categoryID] = id; 
             companyCategoryName(categoryID);
 	     count += 1;
	}
      }


    }



    );
    info["companyCategory"]["count"] = count;



}
});
}




function keywords_form_save(){
var fi = new Array();
fi["checked"] = "";
fi["unchecked"] = "";
fi["companyID"] = companyID;
var count = 0;
var sCount = 0;
$(info["category"]).each(function(){
	 

     var marker = info["category"][count];
  
    if($("#cc"+marker["id"]).is(':checked')){
	 fi["checked"] += marker["id"] + ",";
	companyCategoryCreate(marker["id"]);
	sCount += 1;
      }
      else{
	 fi["unchecked"] += marker["id"] + ",";
	 if(idChecked[marker["id"]] == "exists") companyCategoryDelete(idInfo[marker["id"]]);

      	// companyCategoryDelete(marker["id"]);
      }
	count += 1;	
});
    if(sCount == 0){
        $("#keywords_info").text("No categories have been entered for this company yet.");
         }



	keywords_form_contract();
}

function keywords_form_cancel(){
	keywords_form_contract();
}


var catString = "";

function companyCategoryName(categoryID){
        var fi = new Array();
        fi["id"] = categoryID;
$.ajax({
   type: "GET",
   url: "companyCategoryName.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    if (catString != "") catString += ", ";
    var $marker = $(xml);
    catString += $marker.find("name").text();




$("#keywords_info").html(catString);
}
});

}



function keywords_info_update(){
var outString = "";
var count = 0;
$(info["companyCategory"]).each(function(){
	if (count > 0) outString += ", "; 
        var marker = info["companyCategory"][count];
        outString += marker["name"];
        count += 1;

});

if (info["companyCategory"]["count"]==0){
outString = "No category names have been applied to this company yet.";
}

$("#keywords_info").html(outString);
}




