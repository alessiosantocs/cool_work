
function basic_form_expand(key){
// 	$('#basic_form').slideDown('slow');
// 	$('#basic_info').slideUp('fast');
var fi = new Array();
fi["id"] = companyID;
fi["key"]=key;
$.ajax({
   type: "GET",
   url: urlProcess("/companies/edit_basic_information"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Basic Information',xml);

}
});

}


function basic_form_contract(){
	$('#basic_info').slideDown('slow');
	$('#basic_form').slideUp('fast');

}

function keywords_form_expand(){
// 	category_info_get();
// 	$('#keywords_form').slideDown('slow');
// 	$('#keywords_info').slideUp('fast');
var fi = new Array();
fi["id"] = companyID;
$.ajax({
   type: "GET",
   url: urlProcess("/company_categories/show_segment"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Segments',xml);
}
});
}

function keywords_form_contract(){
	$('#keywords_info').slideDown('slow');
	$('#keywords_form').slideUp('fast');

}

function investments_form_expand(){
	$('#investments_form').slideDown('slow');
	$('#investments_info').slideUp('fast');
}


function investments_form_contract(){
	$('#investments_info').slideDown('slow');
	$('#investments_form').slideUp('fast');

}


function people_form_expand(){
	$('#people_form').slideDown('slow');
	$('#people_info').slideUp('fast');
      

}




function send_mail_form_expand(){
	$('#send_mail_form').slideDown('slow');
	$('#send_mail_info').slideUp('fast');
}


function people_form_contract(){
	$('#people_info').slideDown('slow');
	$('#people_form').slideUp('fast');

}


function singleVideos_form_expand(){
        $('#singleVideo_info').slideDown('slow');
	$('#singleVideo_form').slideUp('fast');

}

function template_form_expand(){
        $('#template_info').slideDown('slow');
	$('#template_form').slideUp('fast');
        $('#template_info').css('display','none');
	$('#template_form').css('display','block');
}

function template_form_contract(){
        $('#template_info').slideDown('slow');
	$('#template_form').slideUp('fast');

}

function singleVideo_form_contract(){
        $('#singleVideo_info').slideDown('slow');
	$('#singleVideo_form').slideUp('fast');

}

function send_mail_form_contract(){
	$('#send_mail_info').slideDown('slow');
	$('#send_mail_form').slideUp('fast');

}

function partnerships_form_expand(){
	$('#partnerships_form').slideDown('slow');
	$('#partnerships_info').slideUp('fast');
}



function partnerships_form_contract(){
	$('#partnerships_info').slideDown('slow');
	$('#partnerships_form').slideUp('fast');

}



function keywordStore_form_expand(){
	$('#keywordStore_form').slideDown('slow');
	$('#keywordStore_info').slideUp('fast');
}

function keywordStore_form_contract(){
	$('#keywordStore_info').slideDown('slow');
	$('#keywordStore_form').slideUp('fast');

}

function references_form_contract(){
	$('#references_info').slideDown('slow');
	$('#references_form').slideUp('fast');

}

function references_form_expand(){
	$('#references_form').slideDown('slow');
	$('#references_info').slideUp('fast');
}




function products_form_expand(){

	$('#products_form').slideDown('slow');
	$('#products_info').slideUp('fast');
}



function products_form_contract(){
	$('#products_info').slideDown('slow');
	$('#products_form').slideUp('fast');

}

function internal_form_expand(){

var fi = new Array();
fi["id"] = companyID;
$.ajax({
   type: "GET",
   url: urlProcess("/companies/internal_show"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Internal Only',xml);

}
});
}




function internal_form_contract(){
	$('#internal_info').slideDown('slow');
	$('#internal_form').slideUp('fast');

}

function singleVideos_form_expand(){
	
	$('#singleVideo_form').slideDown('slow');
	$('#singleVideo_info').slideUp('fast');
}

function singleVideos_form_contract(){
	$('#singleVideo_info').slideDown('slow');
	$('#singleVideo_form').slideUp('fast');

}

function echeck(str) {
		var at="@";
		var dot=".";
		var lat=str.indexOf(at);
		var lstr=str.length;
		var ldot=str.indexOf(dot);
		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr ||str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr||str.indexOf(" ")!=-1){
		   alert("Invalid E-mail ID");
		   return false;
		}
		 if (str.indexOf(at,(lat+1))!=-1){
		    alert("Invalid E-mail ID");
		    return false;
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		    alert("Invalid E-mail ID");
		    return false;
		 }
		 if (str.indexOf(dot,(lat+2))==-1){
		    alert("Invalid E-mail ID");
		    return false;
		 }

 		 return true;				
	}


