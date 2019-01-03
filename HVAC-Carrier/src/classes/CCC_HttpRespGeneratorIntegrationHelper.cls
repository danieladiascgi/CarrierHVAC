@isTest
Global class CCC_HttpRespGeneratorIntegrationHelper implements HttpCalloutMock
{
public static String body;

Global HttpResponse respond(HttpRequest req)
{
String clientKey = 'b5563182-208c-4667-adc0-5592c75a8f89';      
String baseURL = 'https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access';
        
 // asserting the endpoin from webservice an from mock
 //System.assertEquals(baseURL,req.getEndpoint());      
 body='{"$id":"1","registrationDataResults":[{"$id":"2","consumer_Name":"LALITA, BATRA","consumer_Address1":"6330 TEAKWOOD CT","consumer_Address2":"",';
 body+='"consumer_City":"BURKE","consumer_State":"VA","consumer_Country":"US","consumer_Zip":"22015","consumer_Phone1":"7034554247","consumer_Phone2":"';
 body+='7033688106","consumer_Email":"","equip_Address1":"6330 TEAKWOOD CT","equip_Address2":"","equip_City":"BURKE","equip_State":"VA","equip_Country"';
 body+=':"US","equip_Zip":"22015","dealerName":"","dealerPhone":"","mfgAcctNum":"","serviceBenchID":"","hvacpId":"","model":"TB-NHP01","serial":"1512N130272",';
 body+='"equip_Description":"OBS USE TB-NHP01-A","confirmationNumber":"1209030719c","registrationNumber":"R185354365","source":"0","comments":"","installationDate"';
 body+=':"09/12/2012","registrationDate":"09/25/2012 08:53:21","transferDate":"01/23/2015","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"",';
 body+='"enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":""';
 body+=',"productNumber":"TB-N","serial":"0211V00027"}';
 
 HttpResponse res= new HttpResponse();
 res.setBody(body);
return res;
}// method response(HttpRequest req)

}//class CCC_HttpRespGeneratorIntegrationHelper