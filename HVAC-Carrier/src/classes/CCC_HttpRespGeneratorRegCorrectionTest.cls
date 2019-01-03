@isTest
Global class CCC_HttpRespGeneratorRegCorrectionTest implements HttpCalloutMock
{

public static String serialNumber='C133521015';
public static String modelNumner='PGS336090KGP0C';
public static String bodyreg;

Global HttpResponse respond(HttpRequest req)
{    
String baseURL='https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access'; 
        
  // asserting the endpoint from webservice an from mock
  System.assertEquals( baseURL,req.getEndpoint());   
  
   //set the body 
   bodyreg='{"access_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI5YWQwNGFiMS04NWM5LTRkZDEtODZiNS01ODk2Y2NhMWJiMTciLCJleHAiOjE0NTY5MjE2MzIsIm5iZiI6MCwiaWF0IjoxNDU2OTE5ODMyLCJpc';
   bodyreg+='3MiOiJodmFjIiwiYXVkIjoiYXBwX3NhbGVzZm9yY2UiLCJzdWIiOiI5ZGM2ZDIzNS1lOTE0LTRiZGUtYTg0MC1iMDJkMzYyMjllOTEiLCJhenAiOiJhcHBfc2FsZXNmb3JjZSIsInNlc3Npb25fc3RhdGUiOiIxM';
   bodyreg+='zc3NjM0ZS04MTZlLTQ1NGQtYmZmZC1mNDlmYWJhOTY4MzkiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsicGFydHMiLCJwcm9kdWN0cyJdfSwicmVzb3VyY2VfYWNjZXNzI';
   bodyreg+='jp7fX0.GRXETZampUKSjxc3haWF-O5_ksyXNDHiWrTnHbpYxk8G7TYZziM3YwDb6Hv2RIVOVafn_9UphXkWDC40b8Nm2OHG8M6as2TI2kunonXaCPIwiQh5rk9dKgsttoUenqgk65fXAb682-AQG1iFArZWsqQZB';
   bodyreg+='0AIHyQC-YSGASt6go8","expires_in":1800,"refresh_expires_in":3600,"refresh_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiJhODg5ZDIxMC1kMGUyLTRiMDQtYjM1NC03ZjlkOTNiYjlmNz';
   bodyreg+='AiLCJleHAiOjE0NTY5MjM0MzIsIm5iZiI6MCwiaWF0IjoxNDU2OTE5ODMyLCJpc3MiOiJodmFjIiwic3ViIjoiOWRjNmQyMzUtZTkxNC00YmRlLWE4NDAtYjAyZDM2MjI5ZTkxIiwidHlwIjoiUkVGUkVTSCIsIm';
   bodyreg+='F6cCI6ImFwcF9zYWxlc2ZvcmNlIiwic2Vzc2lvbl9zdGF0ZSI6IjEzNzc2MzRlLTgxNmUtNDU0ZC1iZmZkLWY0OWZhYmE5NjgzOSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJwYXJ0cyIsInByb2R1Y3RzIl';
   bodyreg+='19LCJyZXNvdXJjZV9hY2Nlc3MiOnt9fQ.cK9_zN1nalQdR-PWKDjlyT2i8aLn6Y-mmnVWKxl6x-5TzPUkHb4qL6S9_ZJlPGWxT0PWar9AQq4JV_ovUuK2YN2nZuH_K6TOOROy2T4bV0kE2VTRZgjwMKE4_yXp3';
   bodyreg+='A1LHYWqLdd7otLetF-PsNT7joo4rPNhoqc3h3NcHwQW2mc","token_type":"bearer","id_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiIwMGJmNTY0YS1kZGE2LTQ0YmEtYWFlZS1lNWI5NWU4OGNl';
   bodyreg+='YjYiLCJleHAiOjE0NTY5MjE2MzIsIm5iZiI6MCwiaWF0IjoxNDU2OTE5ODMyLCJpc3MiOiJodmFjIiwiYXVkIjoiYXBwX3NhbGVzZm9yY2UiLCJzdWIiOiI5ZGM2ZDIzNS1lOTE0LTRiZGUtYTg0MC1iMDJkMzY';
   bodyreg+='yMjllOTEiLCJhenAiOiJhcHBfc2FsZXNmb3JjZSJ9.dRGdqDg4VlSWv1xudE3cnpSZHIqfmtuPeZ5hgRb613-R7E-nYpwLcqTQpS49wapLPfNzon9VQuBEnHp7J0tmQM84J48oBHchF4VTp9K4UyQ7DQxYSKC1e';
   bodyreg+='iMI_YQyIsl_U1qaL3GgcBMKItpIPayn6LN9wKXdpN9fG3TsjDiLd5Y","not-before-policy":0,"session-state":"1377634e-816e-454d-bffd-f49faba96839"}';
              
  bodyreg+='{"$id":"1","suggestedRegistrationResults":[{"$id":"2","regDate":"2013-11-14T00:00:00","regNo":"R208159743","model":';
   bodyreg+='"PGS336090KGP0C","serial":"C133521015","firstName":"LARRY & CHRISTY","lastName":"LUCKEY","address1":"3117 EXETER ROAD","address2":"","city":';
   bodyreg+='"AUGUSTA","state":"GA","zip":"30909","phone1":"7062845017","source":"W","regStatus":"","tableSrc":"SB_.CustProdRegistration"}],"isReg":"Yes"}';
  
   
     

HttpResponse res= new HttpResponse();
 res.setBody(bodyreg);
return res;
}// method response(HttpRequest req)

}//class CCC_HttpResponseGeneratorCTI