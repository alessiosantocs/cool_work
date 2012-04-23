module InnovativeGateway
  class InnovativeGateway
    USERNAME = "FIRSTCLANDESTINEGROUPI59";
  	VERSION = "1.1";
  	CURL = "/usr/bin/curl";
  	GATEWAY_URL = "https://transactions.innovativegateway.com/servlet/com.gateway.aai.Aai ";
  	PASSWORD = "AkujaNwanya25";
  	TARGET_APP = "WebCharge_v5.06"
  	
  	attr_accessor :fulltotal, :ordernumber, :ccname, :cardtype, :baddress, :bcity, :bstate, :bzip, :bcountry, :bphone, :email, :trantype, :ccnumber, :month, :year, :saddress1, :saddress, :scity, :sstate, :szip, :scountry, :sphone, :ccidentifier
    def initialize
    end
    
    def create(elements = {})
    
    end
  end

  	def pgateway(ftotal,onumber,cardname,ctype,address,city,state,zip,country,phone,mail,type,cardnumber,expmonth,expyear,ccidentifier)
  		fulltotal=ftotal;
  		ordernumber= onumber;
      ccname = cardname; 
  		cardtype  = ctype; 
  		baddress = address; 
  		bcity = city;
  		bstate = state; 
  		bzip = zip; 
  		bcountry = country;
  		bphone = phone; 
  		email = mail; 
  		trantype = type; 
  		ccnumber = cardnumber; 
  		month= expmonth; 
  		year = expyear;
  		ccidentifier=ccidentifier;
  	end

  	def Post
      data  = "fulltotal=fulltotal&";
      data << "ordernumber=&";
      data << "ccname=ccname&";
      data << "cardtype=cardtype&";
      data << "baddress=baddress&";
      data << "bcity=bcity&";
      data << "bstate=bstate&";
      data << "bzip=bzip&";
      data << "bcountry=bcountry&";
      data << "bphone=bphone&";
      data << "email=email&";
  	  if(isset(saddress1))
        data << "saddress1=saddress1&";
        data << "saddress=saddress&";
        data << "scity=scity&";
        data << "sstate=sstate&";
        data << "szip=szip&";
        data << "scountry=scountry&";
        data << "sphone=sphone&";
      end
      data << "trantype=trantype&";
      data << "response_mode=simple&";
      data << "username=username&";
      data << "pw=pw&";
      data << "ccnumber=ccnumber&";
      data << "month=month&";
      data << "year=year&";
      data << "ccidentifier1=ccidentifier&";
      data << "connection_method=POST&";
      data << "delimited_fmt_field_delimiter==&";
      data << "delimited_fmt_include_fields=true&";
      data << "delimited_fmt_value_delimiter=|&";
      data << "delimitedresponse=Y&";
      data << "include_extra_field_in_response=N&";
      data << "last_used_response_num=5&";
      data << "response_fmt=delimited&";
      data << "upg_auth=zxcvlkjh&";
      data << "merch_ip=REMOTE_ADDR&";
      data << "upg_version=version&";
      #data << "test_override_errors=Y&";  //override errors(for testing purposes)
      data << "yes=Y";
  	  
  	  #replace all whitespace with a plus sign for the query string
      data = ereg_replace(" ", "+", data);
  
      #post the data
      cmd = "/usr/bin/curl -k -d \"data\" Gateway_url";
//	  print("cmd<br><br>");
        exec(cmd, return_string);
  	  
        // split up the results into name=value pairs
  	  
        tmp = explode("|", return_string[0]);
  	  //Comment Below
  	  /*
  		print(return_string[0]);
  		print("<br>");
  		print("cmd<br>");
  		print("return_string[0]<br><br>");*/
  		//Comment above
        for(i=0;i<count(tmp);i++)
        {
           tmp2 = explode("=", tmp[i]);
           tmp2[0] = tmp2[1];
        }
  
        // check for approval or error
        if(approval)
        {
           card_status[0] = "approved";
           card_status[1] = "approval";
        }
        elseif(error)
        {
           card_status[0] = "error";
           card_status[1] = "error";
  		 print("error<br>");
        }
  		
  		
        // return the card status as an array
        return card_status;
  	end
  	
  	def add_shipping(saddress1,saddress, scity, sstate, szip, scountry, sphone)
  		saddress1 = saddress1;
  		saddress = saddress; 
  		scity = scity;
  		sstate = sstate; 
  		szip = szip; 
  		scountry = scountry;
  		sphone = sphone; 
  	end
  	
  	def mail_confirm
  		to = email;
  		body = "Thank you for using AllTheParties.\n Your payment has been posted.\n Please keep this information for your records:\n";
    	body <<"Order Number: onumber \n";
  		body <<"Payment Amount: fulltotal\n";
  		body << "For more information about this transaction call 347-558-4020 and have your order number available.\n";
  		body << "Thanks again for using alltheparties.com\n";
  		subject = "AllTheParties Order Confirmation";
  		headers  = "MIME-Version: 1.0\r\n";
  		headers << "Content-type: application/xhtml+xml; charset=iso-8859-1\r\n";
  		headers << "From: Allnightclubs Customer Service<cs_NOREPLY@alltheparties.com>\r\n";		
  		mail(to,subject,body,headers);
  	end
end