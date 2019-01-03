@isTest
global class CCC_HttpRegCorrUtilityTest implements HttpCalloutMock {
public static String serialNumber='C133521015';
public static String modelNumner='PGS336090KGP0C';
public static String bodyreg;

Global HttpResponse respond(HttpRequest req)
{    
String baseURL='https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access'; 
        
  // asserting the endpoint from webservice an from mock
  //System.assertEquals( baseURL,req.getEndpoint());   
  
   //set the body 
   bodyreg='{"$id":"1","dataQualityIndicator":0,"derivedMfgDate":null,"mfgDate":null,"mfgWeek":0,"mfgYear":0,"model":"","msg":null,"serial":"","serialVerified":false,"shippedDate":null,"suggestedResults":[{"$id":"2","dataQualityIndicator":0,"derivedMfgDate":"2008-03-03T00:00:00","discreetNo":"CNPVP3017ACAABAA","mfgDate":"2008-03-03T00:00:00","mfgWeek":10,"mfgYear":2008,"model":"CNPVP3017ACA      ","suGuid":"d31a3200-cf4a-4cac-bfc2-8b60a67785b6","serial":"1008X29181        ","shippedDate":"2008-03-25T00:00:00","shipTo":"0000200403","productFamily":"CNPVP","mfgPlant":"X","toscode":"5ECP - CASED N PURON"}]}';
   
  
   
     

HttpResponse res= new HttpResponse();
 res.setBody(bodyreg);
return res;
}// method response(HttpRequest req)
}