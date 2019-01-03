@isTest
Global class CCC_HttpRespGeneratorEquipDetailTest implements HttpCalloutMock
{
public static String body;

Global HttpResponse respond(HttpRequest req)
{
String clientKey = 'b5563182-208c-4667-adc0-5592c75a8f89';      
String baseURL = 'http://staging.phdbws.carrier.com/api/RestRegistrationModelSerial/25HBC542A003/3113E11567';
        
 // asserting the endpoin from webservice an from mock
 //System.assertEquals(baseURL,req.getEndpoint());      
 body='{"access_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI3NDFlZmE0OS02NjhlLTQ5MDAtOGE5My1hN2FmYzY0Y2JmMWQiLCJleHAiOjE0NTc5NDY2NDAsIm5iZiI6MCwiaWF0IjoxNDU3OTQ0OD';
 body+='QwLCJpc3MiOiJodmFjIiwiYXVkIjoiYXBwX3NhbGVzZm9yY2UiLCJzdWIiOiI5ZGM2ZDIzNS1lOTE0LTRiZGUtYTg0MC1iMDJkMzYyMjllOTEiLCJhenAiOiJhcHBfc2FsZXNmb3JjZSIsInNl';
 body+='c3Npb25fc3RhdGUiOiIxYjdjZjhjMS02ZDliLTQ1MmEtOTMyYy1mMTFiY2MwYmViOWUiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsicGFydHMiLCJwcm9kdWN0c';
 body+='yJdfSwicmVzb3VyY2VfYWNjZXNzIjp7fX0.H19Xo5Oeunez180nJannSjlYNZFqyLiRBqN5ItHDkMWAW3UyG0WXBn2XISiQJGvvQjD_ewebDCUPglimICgQx4BTLtaFVfAl_V6zJSxFurEtMgNIUNfGsOi0Fyg';
 body+='GSVQk09VJjiQBxRQBGsPWVVaeig2tLH-d3wkPWhpAknW7ImE","expires_in":1800,"refresh_expires_in":3600,"refresh_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiJjYzY2YjgzMS03NW';
 body+='I0LTQyM2MtYjVhYS05MDQ1MjMwNWUwZGEiLCJleHAiOjE0NTc5NDg0NDAsIm5iZiI6MCwiaWF0IjoxNDU3OTQ0ODQwLCJpc3MiOiJodmFjIiwic3ViIjoiOWRjNmQyMzUtZTkxNC00YmRlLWE4NDAtYjAyZDM';
 body+='2MjI5ZTkxIiwidHlwIjoiUkVGUkVTSCIsImF6cCI6ImFwcF9zYWxlc2ZvcmNlIiwic2Vzc2lvbl9zdGF0ZSI6IjFiN2NmOGMxLTZkOWItNDUyYS05MzJjLWYxMWJjYzBiZWI5ZSIsInJlYWxtX2FjY2VzcyI6';
 body+='eyJyb2xlcyI6WyJwYXJ0cyIsInByb2R1Y3RzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnt9fQ.LBIvYbuOK1Ciu-lYlC5rAs15wE2bX1fEf2i6d0CRgqq5hjGli1xYtdBRPQp8AcD95O9o7JNSUT6E00FVczVG5K';
 body+='g80em5kgYRKOhOCo_zTe4O9VzbIroF-t4k8MuobcHpfwH6s28z4NU3e2v3opxLg-tn2EhWUv3IYgoSZR1xZqM","token_type":"bearer","id_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI5NmNkZ';
 body+='WQ1NS1iMTA0LTQxNmUtYjM3MC0xNTBmODRiYjFmMzQiLCJleHAiOjE0NTc5NDY2NDAsIm5iZiI6MCwiaWF0IjoxNDU3OTQ0ODQwLCJpc3MiOiJodmFjIiwiYXVkIjoiYXBwX3NhbGVzZm9yY2UiLCJzdWIiOiI5ZGM';
 body+='2ZDIzNS1lOTE0LTRiZGUtYTg0MC1iMDJkMzYyMjllOTEiLCJhenAiOiJhcHBfc2FsZXNmb3JjZSJ9.cOLdJ-cUr34L1m-nr3ZHipxMqEkaMNFBnAxnWjW4hJXoZpjbpS0Yfqulqmb_eVBqKA0ZL89VU94yPPZB0OqY';
 body+='mwnC8wt4DEwTZsa00XSH2LcpB8DmzsOqYiyqNHRrUz6HBOQq_SVZqlNVksP9gZeQaLZuWUFzrJ9PH159JoxK_WE","not-before-policy":0,"session-state":"1b7cf8c1-6d9b-452a-932c-f11bcc0beb9e"}';
  
 
 HttpResponse res= new HttpResponse();
 res.setBody(body);
return res;
}// method response(HttpRequest req)

}//class CCC_HttpRespGeneratorEquipDetailTest