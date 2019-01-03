@IsTest
public with sharing class SBEntitlementProductService_Test{
   public static CCC_IntegrationEndPoint__c  CustomSettingEndPoint;
  
    public static testMethod void methodOne(){
      test.startTest();
        CustomSettingEndPoint = new CCC_IntegrationEndPoint__c();
       
        
            CustomSettingEndPoint.Name='Service Bench';
            CustomSettingEndPoint .UserName__c= 'test';
            CustomSettingEndPoint .Password__c= 'test@123';
            CustomSettingEndPoint.URL__c='https://www.servicebench.com/servicebenchv5/services/ProductEntitlementService';
         insert CustomSettingEndPoint ;
         SBEntitlementProductService  obj_wsdlClass = new SBEntitlementProductService ();
         SBEntitlementProductService.UsernameToken_element obj1 = new SBEntitlementProductService.UsernameToken_element ('xyz', 'xyz@123');       
         SBEntitlementProductService.Security_element obj0 = new SBEntitlementProductService.Security_element ('abc', 'abc@123');
         
         SBEntitlementProductService.requestDetails obj2 = new SBEntitlementProductService.requestDetails();
         SBEntitlementProductService.serviceDetail obj3 = new SBEntitlementProductService.serviceDetail();
         SBEntitlementProductService.ServiceHistoryResponse_element obj4 = new SBEntitlementProductService.ServiceHistoryResponse_element ();
         SBEntitlementProductService.productData obj5 = new SBEntitlementProductService.productData ();
         SBEntitlementProductService.EntitlementResponse_element obj6 = new SBEntitlementProductService.EntitlementResponse_element();
         SBEntitlementProductService.responseStatus  obj7 = new SBEntitlementProductService.responseStatus();
         SBEntitlementProductService.partDetail obj8 = new SBEntitlementProductService.partDetail ();
         SBEntitlementProductService.detailExt obj9 = new SBEntitlementProductService.detailExt ();
         SBEntitlementProductService.service obj10 = new SBEntitlementProductService.service ();
         SBEntitlementProductService.EntitlementRequest_element obj11 = new SBEntitlementProductService.EntitlementRequest_element ();
         SBEntitlementProductService.ServiceHistoryRequest_element obj12 = new SBEntitlementProductService.ServiceHistoryRequest_element ();
         SBEntitlementProductService.parts obj13 = new SBEntitlementProductService.parts ();
         SBEntitlementProductService.claim obj14 = new SBEntitlementProductService.claim ();
         SBEntitlementProductService.detail obj15 = new SBEntitlementProductService.detail ();
         SBEntitlementProductService.messageDetail obj16 = new SBEntitlementProductService.messageDetail ();
         SBEntitlementProductService.entitlementInfo obj17 = new SBEntitlementProductService.entitlementInfo ();
         SBEntitlementProductService.serviceData obj18 = new SBEntitlementProductService.serviceData();
         SBEntitlementProductService.ProductEntitlementServicePort obj19=new SBEntitlementProductService.ProductEntitlementServicePort();
         obj19.getServiceHistory('serviceAdministrator','1erff7','12345');
         obj19.getEntitlementDetail('serviceAdministrator','1324dse','15644','firstName','lastName','49842113','561611','purchaseDate','purchasedFrom');
         
      test.stopTest();   
    }
}