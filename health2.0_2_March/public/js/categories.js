




function categories_form_expand(){
   $("#categoryName").val("");

	$('#categories_form').slideDown('slow');
	$('#categories_info').slideUp('fast');
}



function categories_form_delete(count){
   fi = new Array();
   fi["id"] =  info["category"][count]["id"];
$.ajax({
   type: "GET",
   url: "categoriesDelete.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    categories_info_get();

}
});
}


function categories_form_update(count){
   var maker = info["category"][count];
   $("#categoryName").val(maker["name"]);
   info["category"]["commit"]= "Update";
   info["category"]["actionID"] = maker["id"];
   categories_form_expand();
}




function categories_info_get(){
        info["category"] = new Array();
        info["category"]["commit"] = "Create";
        info["category"]["actionID"] = 0;
        info["category"]["count"] = 0;
       categories_form_contract();
        var fi = new Array();
$.ajax({
   type: "GET",
   url: "categoriesInfo.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    $(xml).find("category").each(function(){
    var $marker = $(this);
    info["category"][count] = new Array();
    info["category"][count]["name"] = $marker.find("name").text();
    info["category"][count]["id"] = $marker.find("id").text();
    info["category"][count]["count"] = count;
    count += 1;

    });
    info["category"]["count"] = count;
   categories_info_update();

}
});
}




function categories_form_save(){
        categories_form_contract();

        var fi = new Array();
        fi["category[name]"] = $('#categoryName').val();
        var commit = info["category"]["commit"];
        fi["commit"]=commit;
        if(commit == "Update"){
             fi["id"] = info["category"]["actionID"];
        }

        $.ajax({
        type: "POST",
        url: "categories.php",
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){
	
        categories_info_get();
        }});
        info["category"]["commit"] = "Create";
        info["category"]["actionID"] = 0;
}



function categories_info_update(){
var outString = "<ul>";
var count = 0;
$(info["category"]).each(function(){
        var marker = info["category"][count];
        outString += "<h3>"+marker["name"];

        outString += "<a href=\"javascript:categories_form_delete("+count+");\"><img src=\"css/blueprint/plugins/buttons/icons/deleteitem.png\" /></a><a href=\"javascript:categories_form_update("+count+");\"><img src=\"css/blueprint/plugins/buttons/icons/pencil.png\" /></a>";

        outString += "<br><br></h3>";
        count += 1;

});
outString += "</ul>";

if (info["category"]["count"]==0){
outString = "No categories have been entered yet.";
}

$("#categories_info").html(outString);
}


function categories_form_contract(){
	$('#categories_info').slideDown('slow');
	$('#categories_form').slideUp('fast');
}


function categories_form_cancel(){
	$('#categories_form').slideUp('fast');
	$('#categories_info').slideDown('slow');
}

function category_info_get(){
        info["category"] = new Array();
        info["category"]["commit"] = "Create";
        info["category"]["actionID"] = 0;
        info["category"]["count"] = 0;
        var fi = new Array();
$.ajax({
   type: "GET",
   url: "categoriesInfo.php",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    $(xml).find("category").each(function(){
    var $marker = $(this);
    info["category"][count] = new Array();
    info["category"][count]["name"] = String($marker.find("name").text());
    info["category"][count]["id"] = String($marker.find("id").text());
    info["category"][count]["count"] = String(count);
    count += 1;

    });
    info["category"]["count"] = count;
    category_info_update(); 

}
});
}




function category_info_update(){
var outString = "<ul>";
var count = 0;
$(info["category"]).each(function(){
        var marker = info["category"][count];
        outString += "<input name=\"cc"+marker["id"]+"\" type=\"checkbox\"";
	if(idChecked[marker["id"]] == "exists"){
		outString += " checked ";     


	}
	outString += "id=\"cc"+marker["id"]+"\">"+marker["name"]+"<br>";

        count += 1;

});
outString += "</ul>";

if (info["category"]["count"]==0){
outString = "No categories have been entered for this company yet.";
}

$("#category_form").html(outString);


if(admin){
$(info["category"]).each(function(){
        var marker = info["category"][count];
        if(idChecked[marker["id"]] == "exists"){
                $('input[name=cc'+marker["id"]+']').attr('checked', true);


        }
});


}

}
