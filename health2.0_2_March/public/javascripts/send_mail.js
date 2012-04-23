function send_mail_form_new(){
  var fi = new Array();
   fi["id"] = companyID;
   $.ajax({
   type: "GET",
   url: urlProcess("/email_trackers/show_send_mail"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){


   ModalPopups.Alert('1','Send Mail',xml);

}
})
}


function send_mail_form_cancel(){
	send_mail_form_contract();
}

