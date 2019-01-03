@isTest
Global class CCC_HttpResponseGeneratorCTITest implements HttpCalloutMock
{


public static String bodyCTI;

Global HttpResponse respond(HttpRequest req)
{    
String baseURL= 'https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access';
        
  // asserting the endpoin from webservice an from mock
  // System.assertEquals(baseURL,req.getEndpoint());   
 
    //set the body 
   // bodyCTI='System.HttpResponse[Status=OK, StatusCode=200';
     bodyCTI='{"access_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI5OTIwMmMzNi0zZDIyLTRhZDMtYjMzOC1jOGUzZmVkZTJmZTIiLCJleHAiOjE0NTY5MTk4OTMsIm5iZiI6MCwiaWF0IjoxNDU2OTE4MDkzLCJpc';  
     bodyCTI+='3MiOiJodmFjIiwiYXVkIjoiYXBwX3NhbGVzZm9yY2UiLCJzdWIiOiI5ZGM2ZDIzNS1lOTE0LTRiZGUtYTg0MC1iMDJkMzYyMjllOTEiLCJhenAiOiJhcHBfc2FsZXNmb3JjZSIsInNlc3Npb25fc3RhdGUiOiI0N';
     bodyCTI+='WY4ZGI3YS0zYzgwLTQzYWYtYTU4ZC1lNmMzODNmY2E4YjYiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsicGFydHMiLCJwcm9kdWN0cyJdfSwicmVzb3VyY2VfYWNjZXNzI';
     bodyCTI+='jp7fX0.s_eHau6gvl5jSDTl16XqPe6VZn6MRlSwwH3RLHGjm7HvEmjxOVbAVSknUuJqgWu8O9X269oJIGmY7S5_KR5xHa3dYgll1GqF8WdMM9fuYcTw_ywslxMa4yEDEX2HPa3S9EEFEqPXW6RtzPw0Rq25VEDc8_';
     bodyCTI+='JJtqOw7L0Xswo0Z44","expires_in":1800,"refresh_expires_in":3600,"refresh_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI2YWRiN2E2Ny02ODZhLTQ0YTQtYTRlNy0zOGFiNWVmODNiOWU';
     bodyCTI+='iLCJleHAiOjE0NTY5MjE2OTMsIm5iZiI6MCwiaWF0IjoxNDU2OTE4MDkzLCJpc3MiOiJodmFjIiwic3ViIjoiOWRjNmQyMzUtZTkxNC00YmRlLWE4NDAtYjAyZDM2MjI5ZTkxIiwidHlwIjoiUkVGUkVTSCIsImF';
     bodyCTI+='6cCI6ImFwcF9zYWxlc2ZvcmNlIiwic2Vzc2lvbl9zdGF0ZSI6IjQ1ZjhkYjdhLTNjODAtNDNhZi1hNThkLWU2YzM4M2ZjYThiNiIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJwYXJ0cyIsInByb2R1Y3RzIl1';
     bodyCTI+='9LCJyZXNvdXJjZV9hY2Nlc3MiOnt9fQ.aUj7dFBoKteb1rqHXY792MfgXVy-XmYFJLoSu03VCgV8qY1R9CtOwQUbbWJb6XFu6iSRTs8TtFotWAn-3yIi2D8rZo-tgajsKUEPTXyjOYyarac7QZ1Eazmz41DXbW6e';
     bodyCTI+='HhdRZLb5uC371G00vdDvq4PTjZ0SqYNe3vmiKCCLSGg","token_type":"bearer","id_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI4NmE5NDFiYS1kOTIzLTQxZmMtYjM2ZC1kM2U5NjFjZTBlOTci';
     bodyCTI+='LCJleHAiOjE0NTY5MTk4OTMsIm5iZiI6MCwiaWF0IjoxNDU2OTE4MDkzLCJpc3MiOiJodmFjIiwiYXVkIjoiYXBwX3NhbGVzZm9yY2UiLCJzdWIiOiI5ZGM2ZDIzNS1lOTE0LTRiZGUtYTg0MC1iMDJkMzYyMjl';
     bodyCTI+='lOTEiLCJhenAiOiJhcHBfc2FsZXNmb3JjZSJ9.v9GuCN9r97Vk-W8u1od3c4lczjcA62OqzW_Fy__Zxnfr1YSNtN2ZvK6G32qzU1kNQnn3XJMXnd30ogaOh-owA1rf--e0_-iu3hcuO7GxLc7eUFL3rHnQJe4jQP';
     bodyCTI+='xdQHb7OpbbBMNgu4GHyMy-xjMkoWCda4RJ4g4kMqb4EAy7Psk","not-before-policy":0,"session-state":"45f8db7a-3c80-43af-a58d-e6c383fca8b6"}';
     

HttpResponse res= new HttpResponse();
//res='System.HttpResponse[Status=OK, StatusCode=200]';
 res.setBody(bodyCTI);
return res;
}// method response(HttpRequest req)

}//class CCC_HttpResponseGeneratorCTI