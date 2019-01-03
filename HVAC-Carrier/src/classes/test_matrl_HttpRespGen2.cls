@isTest
Global class test_matrl_HttpRespGen2 implements HttpCalloutMock
{

public static String partNo='1170003';
public static String body;

Global HttpResponse respond(HttpRequest req)
{    
String baseURL2='https://staging-services.ccs.utc.com/apps/erp/availability/part/'+partNo; 
        
  // asserting the endpoin from webservice an from mock
 // System.assertEquals( baseURL2,req.getEndpoint());   
  
   //set the body 
  
  body = '{"quantity":269,"leadTimeDays":52,"recoveryDate":"2018-01-07"}';  
    HttpResponse res= new HttpResponse();
     res.setBody(body);
return res;
}// method response(HttpRequest req)

}//class CCC_HttpResponseGeneratorCTI