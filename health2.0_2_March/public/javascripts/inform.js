function keywordStore_form_save(){
        keywordStore_form_contract();
		var	urlStr="/keyword_stores/updateByCompany";
        var fi = new Array();
        fi["keywordStore[keywords]"] = inputString($('#keywordStoreWords').val());
		fi["keywordStore[company_id]"]=companyID;

        $.ajax({
        type: "POST",
        url: urlProcess(urlStr),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){

        keywordStore_info_get();
        }});

}


function references_form_save(){
		info["reference"] = new Array(); 
        references_form_contract();
	 var urlStr = "/references/create";
        var fi = new Array();
        fi["reference[url]"] = $('#referencesURL').val();
	fi["reference[dateEntered]"] = $('#referencesDate').val();
	fi["reference[article_field_name]"] = $('#article_field_name').val();
	fi["reference[company_id]"]=companyID;
        var commit = info["reference"]["commit"];
        //fi["commit"]=commit;
        if(commit == "Update"){
			fi["_method"] = "put";
			fi["id"] = info["reference"]["actionID"];
			urlStr="/references/"+ fi["id"];
//             fi["reference[id]"] = info["reference"]["actionID"];
        }
       
       notUrlKey = true;
        $.ajax({
        type: "POST",
        url: urlProcess(urlStr),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){

        reference_info_get();
        }});
        info["reference"]["commit"] = "Create";
        info["reference"]["actionID"] = 0;
}


function product_form_save(){
        products_form_contract();
	 var urlStr = "/products/create";
        var fi = new Array();
        fi["product[name]"] = inputString($('#productName').val());
        fi["product[date_launched]"] = $('#productDate').val();
		fi["product[description]"] = $('#productDescription').val();
	fi["product[company_id]"]=companyID;
        var commit = info["product"]["commit"];
        //fi["commit"]=commit;
        if(commit == "Update"){
                        id=info["product"]["actionID"];
			fi["_method"] = "put";
			fi["id"] = info["product"]["actionID"];
			urlStr="/products/"+ id;
//             fi["product[id]"] = info["product"]["actionID"];
        }
       
       
        $.ajax({
        type: "POST",
        url: urlProcess(urlStr),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){

        product_info_get();
        }});
        info["product"]["commit"] = "Create";
        info["product"]["actionID"] = 0;
}


function send_mail_form_save(path){

	var vaild_email=echeck($('#email_return').val()); 

        if (vaild_email){
        send_mail_form_contract();
        var urlStr = path;
        var fi = new Array();
        fi["email[subject]"] = $('#email_subject').val();
        fi["email[message]"] = escape(tinyMCE.activeEditor.getContent({format:'raw'}));
        fi["email[return]"] = $('#email_return').val();
        fi["email[company_id]"]=companyID;
        $.ajax({
        type: "get",
        url: urlProcess(urlStr),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){
        }});
}
}



function template_form_save(){
        
        template_form_contract();
         var urlStr="/email_trackers/template_data_take";
        var fi = new Array();
        fi["template[name]"] = $('#templateName').val();
        fi["template[data]"] = escape($('#templateData').val());
        fi["template[company_id]"]=companyID;
        var commit = info["template"]["commit"];

        if(commit == "Update"){
			 fi["_method"] = "put";
			 	    urlStr ="/email_trackers/template_update";
             fi["id"] = info["template"]["actionID"];
     
        }  
        else{	 fi["_method"] = "post";}

        $.ajax({
        type: "post",
        url: urlProcess(urlStr),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){
        template_info_get();
        }});
        info["template"]["commit"] = "Create";
        info["template"]["actionID"] = 0;
     


}



function people_form_save(){
	people_form_contract();
	var urlStr = "/personnels/create";
	var fi = new Array();
	fi["personnel[first_name]"] = $('#personnelFirstName').val();
	fi["personnel[last_name]"] = $('#personnelLastName').val();
	fi["personnel[email]"] = $('#personnelEmail').val();
	fi["personnel[current_title]"]=$('#personnelCurrentTitle').val();
	fi["personnel[previous_title]"]=$('#personnelPreviousTitle').val();
	fi["personnel[grad_edu]"] = $('#personnelGradEdu').val();
	fi["personnel[undergrad_edu]"] = $('#personnelUndergraduateEdu').val();
	fi["personnel[other_edu]"]=$('#personnelOtherEdu').val();
	fi["personnel[founder]"]=$("input[name='ftype']:checked").val();
	fi["personnel[company_id]"]=companyID;
	var commit = info["people"]["commit"];

        if(commit == "Update"){
			 fi["_method"] = "put";
                          id= info["people"]["actionID"]
			 	    urlStr = "/personnels/"+ id;
             fi["id"] = info["people"]["actionID"];
        }  

	$.ajax({
   	type: "POST",
   	url: urlProcess(urlStr),
   	data: returnStringArray(fi),
   	datatype: "xml",
   	success: function(xml){
	
    	people_info_get();
        }});
	info["people"]["commit"] = "Create";
	info["people"]["actionID"] = 0;
}

function people_form_delete(count){
   fi = new Array();
   fi["id"] =  info["people"][count]["id"];
$.ajax({
   type: "GET",
   url: urlProcess("/personnels/destroy_item"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    people_info_get();

}
});
}




function categories_form_save(){
        categories_form_contract();
		var urlStr = "/categories/create";
        var fi = new Array();
        fi["category[name]"] = $('#categoryName').val();
        
        fi["commit"]=commit;
        if(commit == "Update"){
			 var urlStr = "/categories/update";
             fi["id"] = info["category"]["actionID"];
        }

        $.ajax({
        type: "POST",
        url: urlProcess(urlStr),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){
	
        categories_info_get();
        }});
        info["category"]["commit"] = "Create";
        info["category"]["actionID"] = 0;
}

function categories_form_delete(count){
   fi = new Array();
   fi["id"] =  info["category"][count]["id"];
$.ajax({
   type: "GET",
   url: urlProcess("/categories/destroy_item"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    categories_info_get();

}
});
}

function categories_form_expand(){
   $("#categoryName").val("");

	$('#categories_form').slideDown('slow');
	$('#categories_info').slideUp('fast');
}


function categories_form_update(count){
   var maker = info["category"][count];
   $("#categoryName").val(maker["name"]);
   info["category"]["commit"]= "Update";
   info["category"]["actionID"] = maker["id"];
   categories_form_expand();
}


function basic_form_save(){
	
	basic_form_contract();
	showCompanyView();
	var fi = new Array();
	var urlStr = "/companies/create";
	fi["format"] = "xml";
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
	var urlStr = "/companies/update";
	fi["_method"]="put";
	fi["id"] = companyID;
	}


$.ajax({
   type: "POST",
   url: urlProcess(urlStr),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
     if (info["company"]["commit"] == "Create"){
     companyID = $("id",xml).text();
}

     info["company"]["commit"] = "Update";
    showCompanyView();
    basic_info_get();
	}});
}



function basic_form_cancel(){
	basic_form_contract();
}



function internal_form_save(){
	basic_form_save();
	internal_form_contract();

}

function internal_form_cancel(){
	internal_form_contract();
}





function companyCategoryCreate(categoryID){
        keywords_form_contract();

        var fi = new Array();
        fi["company_category[company_id"] = companyID;
        fi["company_category[category_id"] = categoryID;

        var commit = "Create";
        

        $.ajax({
        type: "POST",
        url: urlProcess("/company_categories/create"),
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
        url: urlProcess("/company_categories/destroy_item"),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){
	companyCategory_info_get();

        }});
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
		var urlStr = "/investments/create"; 
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
             urlStr = "/investments/update/"+fi["id"];
        }

        $.ajax({
        type: "POST",
        url: urlProcess(urlStr),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){

        investment_info_get();
        }});
        info["investment"]["commit"] = "Create";
        info["investment"]["actionID"] = 0;
        
}


function investment_form_update(count){
   var maker = info["investment"][count];

  var fi = new Array();
fi["id"] = companyID;
fi["investment_id"]=maker["id"];
   $.ajax({
   type: "GET",
   url: urlProcess("/investments/add_investments"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Edit Investments',xml);
}
});
}



function partnership_form_update(count){
   var maker = info["partnership"][count];
   
  var fi = new Array();
fi["id"] = companyID;
fi["partnership_id"]=maker["id"];
   $.ajax({
   type: "GET",
   url: urlProcess("/partnerships/add_partnerships"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Edit Partnership',xml);
}
});
}





function partnerships_form_cancel(){
	partnerships_form_contract();
}



function partnerships_form_save(){
        partnerships_form_contract();
		var urlStr = "/partnerships/create";
        var fi = new Array();
        fi["partnership[description]"] = $('#partnershipDescription').val();
        fi["partnership[date]"] = $('#partnershipDate').val();
        fi["partnership[company_id]"]=companyID;
        var commit = info["partnership"]["commit"];
        //fi["commit"]=commit;
        if(commit == "Update"){
			 urlStr = "/partnerships/update";
             fi["id"] = info["partnership"]["actionID"];
             fi["_method"] = "put";
        }

        $.ajax({
        type: "POST",
        url: urlProcess(urlStr),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){

        partnership_info_get();
        }});
        info["partnership"]["commit"] = "Create";
        info["partnership"]["actionID"] = 0;
}

function product_form_delete(count){
   fi = new Array();
   fi["id"] =  info["product"][count]["id"];
$.ajax({
   type: "GET",
   url: urlProcess("/products/destroy_item"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    
    product_info_get();

}
});
}


function template_form_delete(count){
   fi = new Array();
   fi["id"] =  info["template"][count]["id"];
$.ajax({
   type: "GET",
   url: urlProcess("/email_trackers/destroy_template"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    template_info_get();

}
});
}



function reference_form_delete(count){
   fi = new Array();
   fi["id"] =  info["reference"][count]["id"];
$.ajax({
   type: "GET",
   url: urlProcess("/references/destroy_item"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    
    reference_info_get();

}
});
}

function partnership_form_delete(count){
   fi = new Array();
   fi["id"] =  info["partnership"][count]["id"];
$.ajax({
   type: "GET",
   url: urlProcess("/partnerships/destroy_item"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    
    partnership_info_get();

}
});
}


function partnerships_form_new(){
var fi = new Array();
fi["id"] = companyID;
   $.ajax({
   type: "GET",
   url: urlProcess("/partnerships/add_partnerships"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Add Partnership',xml);

}
});

}




function investment_form_delete(count){
   fi = new Array();
   fi["id"] =  info["investment"][count]["id"];
$.ajax({
   type: "GET",
   url: urlProcess("/investments/destroy_item"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    investment_info_get();

}
});
}


function preview_email(){

  fi = new Array();
var message_body=escape(document.getElementById("email_tracker_message").value);
fi["message_body"] =  message_body;

$.ajax({
   type: "post",
   url: urlProcess("/email_trackers/preview_email_page"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    new_window = window.open('', 'popup', 'toolbar = no, status = no');
    new_window.document.write(xml);

    new_window.document.close();
}
});
}


function preview_email_for_sending_mail(){

fi = new Array();
var message_body=escape(tinyMCE.activeEditor.getContent());
var message_subject=document.getElementById("email_tracker_subject").value;
var return_mail=document.getElementById("email_tracker_return_email").value;
fi["message_body"] =  message_body;
fi["message_subject"] =  message_subject;
fi["return_mail"] =  return_mail;
fi["send_mail"]= true;
$.ajax({
   type: "post",
   url: urlProcess("/email_trackers/preview_email_page"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   new_window = window.open('', 'popup', 'toolbar = no, status = no,scrollbars = yes');

    new_window.document.write(xml);

    new_window.document.close();

}
});
}


function preview_email_message(id){
 fi = new Array();
 var message_body=escape(document.getElementById(id).innerHTML);
 fi["message_body"] =  message_body;
$.ajax({
   type: "post",
   url: urlProcess("/email_trackers/preview_email_page"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){ 
    new_window = window.open('', 'popup', 'toolbar = no, status = no');
    new_window.document.write(xml);

    new_window.document.close();
}
});
}


function preview_email_template(template_id){

 fi = new Array();

   fi["id"] =  template_id;
// var message_body=document.getElementById("email_tracker_message").value;
// fi["message_body"] =  message_body;
$.ajax({
   type: "post",
   url: urlProcess("/email_trackers/preview_email_page"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){ 
    new_window = window.open('', 'popup', 'toolbar = no, status = no');
    new_window.document.write(xml);

    new_window.document.close();
}
});
}

function check_alert(id)
{
   fi = new Array();
   fi["id"]=id
   if (fi["id"]==""){
        tinyMCE.activeEditor.setContent("");
   }
   else{
        $.ajax({
        type: "GET",
        url: urlProcess("/email_trackers/give_body_for_template"),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){ 
                var count = 0;
                $(xml).find(xmlStyle("email-template")).each(function(){
                var $marker = $(this);   
                var data= $marker.find("template-data").text();
                $('#email_tracker_message')[0].value= data;
            tinyMCE.activeEditor.setContent($('#email_tracker_message')[0].value);

                });

        }
        });
    }
}



function give_template_body(id)
{
   fi = new Array();
   fi["id"]=id;
   if (fi["id"]==""){
//         tinyMCE.activeEditor.setContent("");
      $('#email_tracker_message')[0].value ="";
   }
   else{
        $.ajax({
        type: "GET",
        url: urlProcess("/email_trackers/give_body_for_template"),
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){ 
                var count = 0;
                $(xml).find(xmlStyle("email-template")).each(function(){
                var $marker = $(this);   
                var data= $marker.find("template-data").text();
                document.getElementById('email_tracker_message').value = data;
            //    tinyMCE.activeEditor.setContent(document.getElementById('email_tracker_message').value);
               // document.getElementById('sampledata').innerHTML = data;
             // tinyMCE.get('#email_message').setContent(request.responseText);
   
    //  tinyMCE.activeEditor.setContent($('#email_tracker_message')[0].value);
                

                });

        }
        });
    }
}

function preview_email_for_send_mail(){
  fi = new Array();
  var message_body=escape(tinyMCE.activeEditor.getContent({format:'raw'}));
  fi["message_body"] = message_body;
$.ajax({
   type: "post",
   url: urlProcess("/email_trackers/preview_email_page"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
     new_window = window.open('', 'popup', 'toolbar = no, status = no');
    new_window.document.write(xml);

    new_window.document.close();
}
});
}

function template_delete_from_view(id){
   fi = new Array();
   fi["id"] =  id;
$.ajax({
   type: "GET",
   url: urlProcess("/email_template/destroy_template"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    window.location="/email_template/give_all_template"
}
});
}


function show_email_template()
{

fi = new Array();
$.ajax({
   type: "GET",
   url: urlProcess("/companies/show_for_send_mail"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
       ModalPopups.Alert('1','Send Mail',xml);
            var allVals = [];
         $('#get_all_company :checked').each(function() {
                 allVals.push($(this).val());
            });
            $('#email_tracker_company_id').val(allVals);

   }

});
}