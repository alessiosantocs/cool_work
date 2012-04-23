import urllib2
import urllib
from urllib2 import urlopen, Request, URLError
import xml.etree.ElementTree as etree
import sys,codecs
reload(sys)
sys.setdefaultencoding('utf-8')
sys.stdout = codecs.getwriter('utf-8')(sys.stdout)

host= "127.0.0.1"
port= "80"

def companyExists(name):
	url = "http://"+host+":"+port+"/"+"companies/find_by_company_name?name="+urllib.quote(name)
	try:
        	#data = urllib.urlencode(info)
	        req = urllib2.Request(url)
		print url
	        response = urllib2.urlopen(req)
	        the_page = response.read()
	        eltDict = getDictFromXML(the_page)
		if "id" in eltDict:
			return eltDict
		else: 
			return "false"	
    	except URLError, e:
        	print e
        	return e

def getDictFromXML(xml):
    eltDict = {}
    tree = etree.fromstring(xml)
    for node in tree.getiterator():
        #print node.tag, node.text, node.attrib
	eltDict[node.tag] = node.text
    return eltDict 

def personnelExists(fname,lname,companyID):
        url = "http://"+host+":"+port+"/"+"personnels/find_by_name?first_name="+urllib.quote(fname.strip())+"&last_name="+urllib.quote(lname.strip())+"&companyID="+companyID
	print url
	try:
                #data = urllib.urlencode(info)
                req = urllib2.Request(url)
                response = urllib2.urlopen(req)
                the_page = response.read()
                eltDict = getDictFromXML(the_page)
                if "last_name" in eltDict:
                        return "true"
                else:
                        return "false"  
        except URLError, e:
                print e
                return e


def updatePInfo(companyID, notes):
        url = "http://"+host+":"+port+"/"+"companies/"+companyID+".xml"
        try:
                req = urllib2.Request(url)
                response = urllib2.urlopen(req)
                the_page = response.read()
                eltDict = getDictFromXML(the_page)
               	pnotes = eltDict["private-notes"]
		pnotes += "\n\n\n     "+ notes
     		companyUpdate(eltDict["name"],pnotes,eltDict["url"],eltDict["enabled"],companyID)           
        except Exception, e:
                print e
                return e


def companyUpdate(companyName, private_notes, url, enabled,companyID,description):
    # return company id                                                                                                            
    info = dict()
    info["company[name]"] = companyName
    info["company[private_notes]"]= private_notes
    info["company[url]"] = url
    info["company[description]"] = description 
    info["company[enabled]"] = False
    info["id"] = companyID
    info["commit"]= "Update"
    url = "http://127.0.0.1/company.php"
    print url
    try:
        data = urllib.urlencode(info)
        req = urllib2.Request(url,data)
        response = urllib2.urlopen(req)
        the_page = response.read()
	print "update edit" 
	print the_page
        return (the_page)
	print "\n\n\n\n"
    except URLError, e:
		print e
		return e

def cleanName(name):
	name = name.replace(".", "")
	name = name.replace(",", "")
	name = name.strip()
	nameLower = name.lower()

	index = nameLower.find("inc")
	if index != -1:
		name = name[:index]
		nameLower = nameLower[:index]
		print name	

	index = nameLower.find("llc")
	if index != -1:
		name = name[:index]
	        nameLower = nameLower[:index]
		print name
		print index

	index = nameLower.find("corporation")
	if index != -1:
		name = name[:index]
		nameLower = nameLower[:index]
		print name
		print index

	index = nameLower.find("corp")
	if index != -1:
		name = name[:index]
		nameLower = nameLower[:index]
		print name

	return name.strip()
	

	
