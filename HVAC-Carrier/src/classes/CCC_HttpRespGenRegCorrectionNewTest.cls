@isTest
Global class CCC_HttpRespGenRegCorrectionNewTest implements HttpCalloutMock
{

public static String serialNumber='C133521015';
public static String modelNumner='PGS336090KGP0C';
public static String bodyreg;

Global HttpResponse respond(HttpRequest req)
{    
String baseURL='https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access'; 
        
  // asserting the endpoint from webservice an from mock
  //System.assertEquals( baseURL,req.getEndpoint());   
  
   //set the body 
   bodyreg='{"$id":"1","registrationDataResults":[{"$id":"2","consumer_Name":"Jim,Deopere","consumer_BusinessName":"","consumer_Address1":"1756 Green Acres Drive","consumer_Address2":"","consumer_City":"North Mankato","consumer_State":"MN","consumer_Country":"US","consumer_Zip":"56003","consumer_Phone1":"5076253019","consumer_Phone2":"5073873101","consumer_Email":"llapoint@schwickerts.com","equip_Address1":"1756 Green Acres Drive","equip_Address2":"","equip_City":"North Mankato","equip_State":"MN","equip_Country":"US","equip_Zip":"56003","dealerName":"Schwickerts Tecta America","dealerPhone":"5073873101","mfgAcctNum":"98610-30222","serviceBenchID":"494229378","hvacpId":"12856","model":"355CAV042060","serial":"2709A00692","equip_Description":"G/F,4-Way Cond,Plus 95s,Media Cab","confirmationNumber":"0908025129b","registrationNumber":"R153626264","source":"W","comments":"~ConsumerEmail:llapoint@schwickerts.com","installationDate":"08/27/2009","registrationDate":"08/27/2009 12:00:00","transferDate":"","markAs":"","modelLocation":"BS","furnaceOrientation":"UP","furnaceFuel":"N","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"355CAV","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"BRY","consumer_MarketingOptIn":"N","equip_FirstName":"Jim","equip_LastName":"Deopere","equip_BusinessName":"","equip_Email":"llapoint@schwickerts.com","registeredBy":"S","installingDealer":"98610-30222","servicingDealer":"","distributor":"30222","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"Auer Steel and Heating Supply Company, Plymouth, HQ","internalComments":""},{"$id":"3","consumer_Name":"Jim,Deopere","consumer_BusinessName":"","consumer_Address1":"1756 Green Acres Drive","consumer_Address2":"","consumer_City":"North Mankato","consumer_State":"MN","consumer_Country":"US","consumer_Zip":"56003","consumer_Phone1":"5076253019","consumer_Phone2":"5073873101","consumer_Email":"llapoint@schwickerts.com","equip_Address1":"1756 Green Acres Drive","equip_Address2":"","equip_City":"North Mankato","equip_State":"MN","equip_Country":"US","equip_Zip":"56003","dealerName":"Schwickerts Tecta America","dealerPhone":"5073873101","mfgAcctNum":"98610-30222","serviceBenchID":"494229378","hvacpId":"12856","model":"CNPVP3017ACA","serial":"1008X29181","equip_Description":"OBS USE CNPVP****ALA","confirmationNumber":"0908025129b","registrationNumber":"R153626265","source":"W","comments":"~ConsumerEmail:llapoint@schwickerts.com","installationDate":"08/27/2009","registrationDate":"08/27/2009 12:00:00","transferDate":"","markAs":"E","modelLocation":"BS","furnaceOrientation":"UP","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"CNPVP","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"","brand":"BRY","consumer_MarketingOptIn":"N","equip_FirstName":"Jim","equip_LastName":"Deopere","equip_BusinessName":"","equip_Email":"llapoint@schwickerts.com","registeredBy":"S","installingDealer":"98610-30222","servicingDealer":"","distributor":"30222","modelUsage":"","application":"R","installationType":"R","replacementModel":"CNPVP3017ALA","replacementSerial":"2113X36781","propertyId":"","distributorName":"Auer Steel and Heating Supply Company, Plymouth, HQ","internalComments":""},{"$id":"4","consumer_Name":"Jim,Deopere","consumer_BusinessName":"","consumer_Address1":"1756 Green Acres Drive","consumer_Address2":"","consumer_City":"North Mankato","consumer_State":"MN","consumer_Country":"US","consumer_Zip":"56003","consumer_Phone1":"5076253019","consumer_Phone2":"5073873101","consumer_Email":"llapoint@schwickerts.com","equip_Address1":"1756 Green Acres Drive","equip_Address2":"","equip_City":"North Mankato","equip_State":"MN","equip_Country":"US","equip_Zip":"56003","dealerName":"","dealerPhone":"","mfgAcctNum":"","serviceBenchID":"","hvacpId":"","model":"124ANA024000","serial":"2309E00962","equip_Description":"14S,LEGACY,AC PURON,2T,208/230-1","confirmationNumber":"0908025129b","registrationNumber":"R153626263","source":"W","comments":"~ConsumerEmail:llapoint@schwickerts.com","installationDate":"08/27/2009","registrationDate":"08/27/2009 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"124A","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"","brand":"BRY","consumer_MarketingOptIn":"N","equip_FirstName":"Jim","equip_LastName":"Deopere","equip_BusinessName":"","equip_Email":"llapoint@schwickerts.com","registeredBy":"S","installingDealer":"","servicingDealer":"","distributor":"","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"","internalComments":""}]}';
   
  
   
     

HttpResponse res= new HttpResponse();
 res.setBody(bodyreg);
return res;
}// method response(HttpRequest req)

}//class CCC_HttpResponseGeneratorCTI