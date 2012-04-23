function keywordStore_form_new(){

      var fi = new Array();
   fi["id"] = companyID;
   $.ajax({
   type: "GET",
   url: urlProcess("/keyword_stores/modify_keyword"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Add References',xml);

}
});

}



function keywordStore_info_get(){

       keywordStore_form_contract();
        var fi = new Array();
        fi["company_id"] = companyID;
        notUrlKey = true;
$.ajax({

   url: urlProcess("/keyword_stores/find_by_company"),
   datatype: "xml",
      data: returnStringArray(fi),
      type: "GET",
      complete: function(){ global_array[6] = 1;},
       
   success: function(xml){
    info["keywordStore"] = $(xml).find("keywords").text();
    keywordStore_info_update();

}
});
}


function keywordStore_form_update(){

   $("#keywordStoreWords").val(maker["name"]);
   keywordStore_form_expand();
}





function keywordStore_form_cancel(){
	keywordStore_form_contract();
}



function keywordStore_info_update(){
var outString = info["keywordStore"];
$("#keywordStore_info").html(outString);
}

