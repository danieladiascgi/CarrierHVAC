@IsTest
public with sharing class AsyncSBEntitlement_Test{
  
   public static CCC_IntegrationEndPoint__c  CustomSettingEndPoint;
  
  
    public static testMethod void methodOne(){

          CustomSettingEndPoint = new CCC_IntegrationEndPoint__c();
          
        
            CustomSettingEndPoint.Name='Service Bench';
            CustomSettingEndPoint .UserName__c= 'test';
            CustomSettingEndPoint .Password__c= 'test@123';
            CustomSettingEndPoint.URL__c='https://www.servicebench.com/servicebenchv5/services/ProductEntitlementService';
            insert CustomSettingEndPoint ;
     
      AsyncSBEntitlementProductService  obj_wsdlClass = new AsyncSBEntitlementProductService ();
       // Set mock callout class for http callouts
           Test.setMock(HttpCalloutMock.class, new  CCC_HttpResponseGeneratorCTITest());
      AsyncSBEntitlementProductService.ServiceHistoryResponse_elementFuture obj1=new AsyncSBEntitlementProductService.ServiceHistoryResponse_elementFuture ();
      obj1.getValue();
      AsyncSBEntitlementProductService.EntitlementResponse_elementFuture obj2=new AsyncSBEntitlementProductService.EntitlementResponse_elementFuture();
      obj2.getValue();
      AsyncSBEntitlementProductService.AsyncProductEntitlementServicePort obj3=new AsyncSBEntitlementProductService.AsyncProductEntitlementServicePort();
      obj3.beginGetServiceHistory( new System.Continuation(10) ,'serviceAdministrator','1324dse','15644' );
      obj3.beginGetEntitlementDetail(new System.Continuation(10) ,'serviceAdministrator','1324dse','15644','firstName','lastName','49842113','561611','1266628','purchasedFrom');
     
     
    }
    
    
    
}