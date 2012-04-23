# -*- coding: utf-8 -*-
import urllib2
import urllib
import csv
from urllib2 import urlopen, Request, URLError
#from  ClientForm import ParseResponse 
import xml.etree.ElementTree as etree
from addFuxns import *
import sys, codecs
import time
reload(sys)
sys.setdefaultencoding('utf-8')
sys.stdout = codecs.getwriter('utf-8')(sys.stdout)

f = csv.reader(open("data.csv"), quotechar='"',delimiter=";")
malformed_list = list()
host = "127.0.0.1"
port = "3000"
cList = []

throwList = []

def CompanyInsertCheckByPost(companyName, private_notes, url, enabled, description):
    # return company id                                                                                                            
    info = dict()
    info["company[name]"] = companyName
    info["company[description]"] = description 
    info["company[private_notes]"]= private_notes
    info["company[url]"] = url
    info["company[enabled]"] = False
    info["commit"]= "Create"
    url = "http://"+host+":3000/companies.xml"
    print url
    try:
        data = urllib.urlencode(info)
        req = urllib2.Request(url,data)
        response = urllib2.urlopen(req)
        the_page = response.read()
        return (the_page)
    except URLError, e:
	print e
	return e

def PersonnelInsertCheck(first_name, last_name, title,  companyID):
    info = dict()
    info["personnel[first_name]"]=first_name
    info["personnel[last_name]"]=last_name
    info["personnel[current_title]"]=title
    info["personnel[company_id]"] = companyID
    info["commit"]= "Create"
    url = "http://"+host+":3000/personnels.xml"
    try:
        data = urllib.urlencode(info)
        req = urllib2.Request(url,data)
        response = urllib2.urlopen(req)
        the_page = response.read()
        return (the_page)
    except URLError, e:
   	print e
	return e 


def EmailInsertCheck(email,type, personID):
    info=dict()
    info['email_address[email]']=email
    info['email_address[type]']=type
    info['email_address[person_id]']=personID
    info["commit"]= "Create"
    url = "http://"+host+":3000/email_addresses.xml"
    try:
        data = urllib.urlencode(info)
        req = urllib2.Request(url,data)
        response = urllib2.urlopen(req)
        the_page = response.read()
        return (the_page)
    except URLError, e:
	print e

    #email
    #"http://%s:%s/email/new.xml?email=%s&type=%s&personnel_id=%i" % (host,port,email,type,personID)

def PhoneInsertCheck(number,type, personID):
    info = dict()
    info['phone_number[phone]'] = number
    info['phone_number[type]'] = type
    info['phone_number[person_id]'] = personID
    info["commit"]= "Create"
    url = "http://"+host+":3000/phone_numbers.xml"
    try:
        data = urllib.urlencode(info)
        req = urllib2.Request(url,data)
        response = urllib2.urlopen(req)
        the_page = response.read()
        return (the_page)
    except URLError, e:
	print e
    #phone
    #"http://%s:%s/phone/new.xml?phone=%s&type=%s&personnel_id=%i" % (host,port,phone,type,personID)

def getIDFromXML(xml):
    print xml
    tree = etree.fromstring(xml)
    for node in tree.getiterator():
        print node.tag, node.text, node.attrib
        if node.tag == "id": return node.text 
    

def getID(el):
    d={}
    if el.text:
        d[el.tag] = el.text
    else:
        d[el.tag] = {}
        children = el.getchildren()
    if children:
        d[el.tag] = map(xml_to_dict, children)
    return d    

count = 0
goodCompanyNameCount = 0

for datalist in f:
	time.sleep(.5)
	print(datalist)      
	print(len(datalist))
	enabled = True 
	company_private_notes = ""

	first_name = datalist[1] 
	last_name = datalist[2]
	title = datalist[3]
	company = datalist[4]
	url = datalist[5]
	email = datalist[6]
	twitter = datalist[7]
	
	phone = datalist[8]
	# mystring.sub('<[^>]*>', '')
	product = datalist[9].replace(r'<[^>]*>', '')
	product += datalist[10].replace(r'<[^>]*>', '')
	product += datalist[11].replace(r'<[^>]*>', '')
	product += datalist[12].replace(r'<[^>]*>', '')
		product += datalist[13].replace(r'<[^>]*>', '')
			product += datalist[14].replace(r'<[^>]*>', '')
	conference_session = ""
	stealth_mode = datalist[15]
	financing_history = datalist[16]
	financing_sought = datalist[17]
	revenues = datalist[18]
	location_submitted = ""
   	bio = datalist[19] 

 	count += 1
    
 	if company == "":
 		if not email == "":
 			if not email.find("@") == -1:
				company = email.split("@")[1] 
				enabled = False
				company_private_notes += "INFO FROM EXCEL SPREADSHEET.  COMPANY NAME EXTRACTED FROM EMAIL, PLEASE VERIFY ADDRESS BEFORE ENABLING. \n"
 			else: malformed_list.append(datalist)
		else: malformed_list.append(datalist)
	else: goodCompanyNameCount += 1 

	if not stealth_mode == "": enabled = False
	company_private_notes += " COMPANY IS IN STEALTH MODE. DO NOT ENABLE. \n"
        company_private_notes += " \n\n REVENUES: \n " + revenues + "\n FINANCING HISTORY: \n" + financing_history + "\n FINANCING SOUGHT: \n" + financing_sought + "\n REVENUES: \n" + revenues +"\n PEOPLE BIO:\n" + bio +"\n\n CONFERENCE SESSION: \n" + conference_session+ "\n LOCATION SUBMITTED:  \n" + location_submitted 
	if enabled == True: 
		enabled = 1
	else: enabled = 0
#	print company 
	company = cleanName(company)
#	print "clean company name"
#	print company
	cList.append(company)
#	print company
	cexists = companyExists(company)
	if cexists == "false":
        	companyXML = CompanyInsertCheckByPost(company,company_private_notes, url, enabled, product)
        	companyID = getIDFromXML(companyXML)
	else: 
		print cexists
		companyID = cexists["id"]
		if cexists["description"] == None:
                        companyUpdate(company,company_private_notes, url, enabled,companyID,product)
		#else:
		#	 if len(cexists["description"]) < len(product):
		#		companyUpdate(company,"", url, enabled,companyID,product)
	pexists = personnelExists(first_name,last_name,companyID)
	if pexists == "false":
        	personXML = PersonnelInsertCheck(first_name, last_name, title, companyID)
        	personID = getIDFromXML(personXML)
       		type="work"
        	EmailInsertCheck(email,type,personID)
        	type="not specified"
        	PhoneInsertCheck(phone,type, personID)





print count
c2List = set(cList)
print len(cList)
print len(c2List)
print malformed_list
malformedListStr = ""

for i in malformed_list:
	malformedListStr += ",".join(i) + "\n"


outputFile = open("info.text","w")
outputFile.write(malformedListStr)
outputFile.close()

    #personalID = 

    #print malformed_list
    #f.close()

print goodCompanyNameCount
randomFile = open("rando.txt","w")
randomFile.write("\n".join(cList))
randomFile.close()
 
