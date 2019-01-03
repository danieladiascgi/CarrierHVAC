@isTest
global class CCC_HttpResponseGeneratorICPForm implements HttpCalloutMock{
public static String serialNumber='C133521015';
public static String modelNumner='PGS336090KGP0C';
public static String body;

Global HttpResponse respond(HttpRequest req)
{    
String baseURL2='https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access'; 
        
  // asserting the endpoin from webservice an from mock
 // System.assertEquals( baseURL2,req.getEndpoint());   
  
   //set the body 
  
   body='{"$id":"1","dataQualityIndicator":0,"derivedMfgDate":null,"mfgDate":null,"mfgWeek":0,"mfgYear":0,"model":"","msg":null,"serial":"","serialVerified":false,';
   body+='"shippedDate":null,"suggestedResults":[{"$id":"2","dataQualityIndicator":0,"derivedMfgDate":"2013-08-27T00:00:00","discreetNo":null,"mfgDate":null,"mfgWeek":0,';  
   body+='"mfgYear":0,"model":"PGS336090KGP0C    ","suGuid":"202fcfd4-c7c8-4262-8051-37f735a695d4","serial":"C133521015        ","shippedDate":"2013-09-30T00:00:00","shipTo"';
   body+=':"406126    ","toscode":"1AM3 - 13 SEER - COMFORT PU"}]}';
  
    HttpResponse res= new HttpResponse();
     res.setBody(body);
return res;
}// method response(HttpRequest req)
}