from pyelasticsearch import ElasticSearch
import xml.etree.ElementTree as etree
import sys,codecs
import time, csv
import Queue
from threading import Thread


reload(sys)
sys.setdefaultencoding('utf-8')
sys.stdout = codecs.getwriter('utf-8')(sys.stdout)


import urllib

host = "127.0.0.1"
#host = "diya.cc"
searchPort = "9200"
railsPort = "3000"

conn = ElasticSearch('http://'+host+':'+searchPort)
keepQueue = True 
q = Queue.Queue()


def CompanyListPull():
 pghandle = urllib.urlopen("http://"+host+":"+railsPort+"/companies.xml?id=18902cfc-eb7f-11df-bd7a-0019d12ccfbb")
 line = pghandle.readline()
 outFile = open("companies.xml","w")
 while (line != ""):
  outFile.write(line)
  line = pghandle.readline()
 outFile.close()



def doNothing(arg1,arg2):
 a = ""
 print arg1



incXLSDict = {}

incXLSDict["private-notes"] = False
incXLSDict["updated-at"] = False 
incXLSDict["created-at"] = False 
incXLSDict["id"] = False 
incXLSDict["market-segment"] = False 
incXLSDict["company-id"] = False 



def buildSegmentDict(eltDict):
    returnDict = { eltDict["id"]: eltDict["name"] }
    return returnDict

#case matters!
def processParticle(lookoutStr,nextFunction,fileHandle, ignoreStr):
 outcomeList = list()
 line = fileHandle.readline()
 startIgnoreStr = "<" + ignoreStr + ">"
 endIgnoreStr = "</" + ignoreStr + ">"
 startLookoutStr = "<" + lookoutStr + ">"
 endLookoutStr = "</" + lookoutStr + ">"
 tempStr = ""
 wholePiece = False
 sectionBuild = False
 # the following section collects a piece of xml 
 while (line != ""):
  #print line
  line = line.strip()
  if((line != startIgnoreStr) and (line != endIgnoreStr)): 
    if sectionBuild:
     tempStr += line
    if(line == startLookoutStr):
     tempStr = line
     sectionBuild = True 
    if line == endLookoutStr:
     wholePiece = True  
     sectionBuild = False
  if wholePiece:
    wholePiece = False 
    dictElt = getDictFromXML(tempStr)
    result = nextFunction(dictElt)
    if result != None: 
        outcomeList.append(result)
  line = fileHandle.readline()
 return outcomeList

def getIDFromXML(xml):
    tree = etree.fromstring(xml)
    for node in tree.getiterator():
        print node.tag, node.text, node.attrib
        if node.tag == "id": return node.text



railsbase = "http://"+host+":"+railsPort+"/"


url = railsbase + "companies.xml"

def cleanString(input):
 if type(input) == type(""):
  input = input.replace("\\","")
  input = input.replace("//","")
 return input


def rebaseDict(oldDict):
  newDict = {}
  for i in oldDict:
      if i in incXLSDict: 
          if not incXLSDict[i] == False:
             newDict[i] = oldDict[i]
      else: 
          newDict[i] = cleanString(oldDict[i])
      if oldDict[i] == None:
          newDict[i] = ""
  return newDict 


seqList = list()
seqList.append("name")
seqList.append("url")
seqList.append("description")
seqList.append("employee-number")
seqList.append("enabled")
seqList.append("partnerships")
seqList.append("products")
seqList.append("people")
seqList.append("founded")
seqList.append("segments")

writer = csv.writer(open('noneCategoy.csv', 'w'), delimiter = ',', quotechar="\"" )

def buildCompany(companyDict):
    id = companyDict["id"]
    companyDict = rebaseDict(companyDict)
 
    companyDict["products"] =  urlFieldGrab("products/find_by_company?company_id="+id,"product","products") 
    segmentList, companyDict["segments"] =  companySegmentFieldGrab(id) 
    companyDict["segments_id"] = segmentList
    companyDict["partnerships"] =  urlFieldGrab("partnerships/find_by_company?company_id="+id,"partnership","partnerships")
 
    companyDict["people"] = urlFieldGrab("personnels/find_by_company?company_id="+id,"personnel","personnels") 
    if companyDict["enabled"] == "true":      
      info = {}
      info["companyDict"] = companyDict
      info["index"] = "company"
      info["index-type"] = "index-type1"
      info["id"] = id
      q.put(info)
    
    #print conn.index(companyDict, "global1","index-type1",id)

    if len(segmentList) > 0:
      outputToSegmentFiles(segmentList,companyDict)
    else:
      outList = list()
      for i in seqList:
        outList.append(companyDict[i])
      writer.writerow(outList)

def worker():
        while True:
                infoDict = q.get()
                try:
    			conn.index(infoDict["companyDict"],infoDict["index"],infoDict["index-type"],infoDict["id"])
                except Exception, e:
			q.put(infoDict)
                        print str(e)
			time.sleep(4)
                q.task_done()

               

def readyIndex():
  #  conn.status(["index-type1"])

  propertiesDict = {"name": {"type": "string", "store" : "no" },"url": {"type": "string", "store" : "no" },"description": {"type": "string", "store" : "no" },"segments": {"type": "string", "store" : "no" },"products": {"type": "string", "store" : "no" },"partnerships": {"type": "string", "store" : "no" },"people": {"type": "string", "store" : "no" }}
  
  segmentsDict = {"name": {"type": "string", "store" : "no" }}
                                    

  conn.put_mapping("index-type1",{"index-type1" : {"properties" : propertiesDict}}) 
  
  conn.delete_index("global1")
  conn.create_index("global1")



def outputToSegmentFiles(segmentList,companyDict):
  for seg in segmentList: 
    outList = list()
    for i in seqList:
      outList.append(companyDict[i])
    fDict[seg]["csv"].writerow(outList)
    
    
def closeHandles():
  for key in fDict:
    fDict[key]["fileHandle"].close()

def buildField(iDict):
    iDict = rebaseDict(iDict)
    tempStr = ""
    for i in iDict:
        if not i in incXLSDict:
            tempStr += i+": " + iDict[i] + "\n"
    return tempStr


def urlFieldGrab(urlSuffix,lookoutStr,ignoreStr):
    url = "http://"+host+":"+railsPort+"/"+urlSuffix

    pghandle = urllib.urlopen(url)
    iList = processParticle(lookoutStr,buildField,pghandle, ignoreStr)
    pghandle.close()
    return "\n".join(iList)

def getCategoryID(eltDict):
  return eltDict["category-id"]


def buildSegNamesList(iList):
  tempStr = ""
  for i in iList:
    tempStr += segmentNamesDict[i]+", "
  return tempStr

def companySegmentFieldGrab(cID):
  pghandle = urllib.urlopen("http://"+host+":"+railsPort+"/company_categories/find_by_company/?company_id="+cID)
  iList = processParticle("company-category",getCategoryID,pghandle,"company-categories")
  segmentNames = buildSegNamesList(iList)
  pghandle.close()
  return iList, segmentNames


def SegmentNameGrab():
  pghandle = urllib.urlopen("http://"+host+":"+railsPort+"/categories.xml")
  iList = processParticle("category",buildSegmentDict,pghandle,"categories")
  pghandle.close()
  return unpackDictFromList(iList)


def unpackDictFromList(iList):
  iDict = dict()
  for i in iList:
    for k in i:
      iDict[k] = i[k]
  return iDict 

def getDictFromXML(xml):
    eltDict = {}
    tree = etree.fromstring(xml)
    for node in tree.getiterator():
        
        eltDict[node.tag] = node.text
    return eltDict

def genFileHandlesFromVals(iDict):
  fDict = dict()
  for k in iDict: 
    fDict[k] = dict()
    fDict[k]["fileHandle"] = open(iDict[k].replace('/'," and ")+".csv","w")
    fDict[k]["csv"] = csv.writer(fDict[k]["fileHandle"], delimiter = ',', quotechar="\"" )
    genCSVHeader(fDict[k]["csv"])
  return fDict 

def genCSVHeader(csvwriter):
  csvwriter.writerow(seqList)

CompanyListPull()
t = Thread(target=worker)
t.daemon = True
t.start()
print "finished pulling company list"
readyIndex()
segmentNamesDict = SegmentNameGrab()
fileHandleDict = genFileHandlesFromVals(segmentNamesDict)
fDict = fileHandleDict
print "segment names finished grab" 
fh = open("companies.xml")
processParticle("company",buildCompany,fh,"companies")
print "finished processing file"
q.join()


closeHandles()


