@isTest
Global class test_matrl_HttpRespGen implements HttpCalloutMock
{

public static String custNumber='2134';
public static String partNo='1170003';
public static String body;

Global HttpResponse respond(HttpRequest req)
{    
String baseURL2='https://staging-services.ccs.utc.com/apps/erp/prices/part/'+custNumber+'/'+partNo; 
        
  // asserting the endpoin from webservice an from mock
 // System.assertEquals( baseURL2,req.getEndpoint());   
  
   //set the body 
  
  body = '{"listPrice":63.48,"multiplier":0.325,"netPrice":20.63,"currencyCode":"USD"}';  
    HttpResponse res= new HttpResponse();
     res.setBody(body);
return res;
}// method response(HttpRequest req)

}//class CCC_HttpResponseGeneratorCTI