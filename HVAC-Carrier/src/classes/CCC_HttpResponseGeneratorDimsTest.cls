@isTest
Global class CCC_HttpResponseGeneratorDimsTest implements HttpCalloutMock
{

 public static  Integer docInfo_resultCount;
 public static String baseURL;
 public static String tittle;
 public static String brands;
 public static String Modelno;
 public static String body;
 global HTTPResponse respond(HTTPRequest req) 
     {
     docInfo_resultCount=20;
     tittle='TestDIMSCase';
     brands='Bryant';
     Modelno='561';
     
     body='{"ResultCount":"20",';
     body+='"Documents":[{"ID":"37683","DocumentTitle":"TSTATCCPRH Thermostat and Thermidistat Product Data","Type":["TechLit"],';
     body+='"Subtype":["Product Data"],"Brands":["Carrier"],"CatalogueNumber":"02TS-TA6","Status":"Obsolete",';
     body+='"ModelNumbers":["tstat","tstatccprh01-b","tstatccpac01-b","tstatccphp01-b","tstatccp2s01-b","tstatccpdf01-b","tstatccprf01","tstatccrec01","tstatccpb501","tstatccp2w01","tstatccsac01",';
     body+='"tstatccshp01","tstatccpb101","tstatccnac01-b","tstatccnhp01-b","tstatccn2s01-b","tstatccntt01-b"],';
     body+='"DocumentMIMEType":"application\\/pdf","DocumentBaseURL":"http:\\/\\/www.utcccs-cdn.com\\/hvac\\/","DocumentPath":"\\/docs\\/1009\\/Public\\/02\\/TSTAT-6PD.pdf",';
     body+='"Verticals":[],"Language":"EN","Country":"","PublishedDate":"6\\/6\\/2008","DocumentSize":"303805","Region":"","ReleaseDate":"9\\/23\\/2004",';
     body+='"FormNumber":"TSTAT-6PD","ContentID":"TSTAT-6PD","Author":"aranney","PrintDate":"4\\/1\\/2003","SampleMail":"No","SourceDepartment":"RES Tech Writing",';
     body+='"Division":"RES","ModelCategory":"Controls; Thermostat","PartNumber":"","DocumentGroup":"","FileType":"Adobe Acrobat",';
     body+='"Category":"Thermostats","Comments":"","SubCategory":"","BrandFamily":"","DMSCategory":"","DMSType":"","SecurityGroup":"Public"}]}';
     
     
     
     baseURL='http://sharedservices.carrier.com/BlackJackRestService/search?'; 
     System.assertEquals(baseURL+'clientkey=1ED5E7FA-E8F3-4D5F-A9FC-371D37F0A115&format=json&ResultCount='+docInfo_resultCount
     +'&DocumentTitle='+tittle+'&brands='+brands+'&ModelNumbers='+Modelno,req.getEndpoint());
     System.assertEquals('GET', req.getMethod());
 
 //creating a fake response
 
     HttpResponse res = new HttpResponse();
     res.setHeader('Content-Type', 'application/json');
     res.setBody(body);
     res.setStatusCode(200);
     return res;
 
     }// method respond 
 
}// class HttpResponseGeneratorDims