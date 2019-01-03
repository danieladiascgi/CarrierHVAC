@isTest
global class CCC_HttpResponseGeneratorICPFormNoSugRes implements HttpCalloutMock{
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
   body+='"shippedDate":null,"suggestedResults":[]}';
  
    HttpResponse res= new HttpResponse();
     res.setBody(body);
return res;
}// method response(HttpRequest req)
}