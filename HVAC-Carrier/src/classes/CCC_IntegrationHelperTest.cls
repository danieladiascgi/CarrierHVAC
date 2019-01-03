@isTest(SeeAllData=true)
public class CCC_IntegrationHelperTest {
 public static User testusr1;
   public static CCC_IntegrationEndPoint__c  CustomSettingEndPoint1, CustomSettingEndPoint2 ;
   
   public static void setupData()
   {
   
    Profile testprof2=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        testusr1=new User( email='testdealer.user@gmail.com',
                          profileid = testprof2.id,  
                          UserName='test9.user@gmail.com', 
                          Alias = 'GDS',
                          TimeZoneSidKey='America/New_York',
                          EmailEncodingKey='ISO-8859-1',
                          LocaleSidKey='en_US', 
                          LanguageLocaleKey='en_US',
                          //ContactId = testCon1.id,
                          PortalRole = 'Manager',
                          FirstName = 'test1',
                          LastName = 'user1');
        
        insert testusr1;
        
   
     /*       
    CustomSettingEndPoint2 = new CCC_IntegrationEndPoint__c();
          
            CustomSettingEndPoint2.Name='PHDB';
            CustomSettingEndPoint2.UserName__c='app_salesforce';
            CustomSettingEndPoint2.Password__c='hy~jpmXm@2s6_@MM';
            CustomSettingEndPoint2.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
            CustomSettingEndPoint2.URL__c='https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access';
            insert CustomSettingEndPoint2; 
            */
   
   }
    static testMethod void testintHelper()
    {      
         setupData();
         Test.startTest();
        System.runAs(testusr1){
         CCC_IntegrationHelper  helper = new CCC_IntegrationHelper();
         
         //Set mock callout class for http callouts
         Test.setMock(HttpCalloutMock.class, new  CCC_HttpRespGeneratorEquipDetailTest());
        // Test.setMock(HttpCalloutMock.class, new  CCC_HttpRespGeneratorIntegrationHelper ());
         
         helper.getPHDBInformation('Lastname', 'Street','Phone','PhoneNo2', 'PostalCode','FirstName','City','lstName', 'ConfNo','Zipcode', 'instalAddress', 'PhNo','RegisNo', 'email','serialNo','model');
         
         }
           Test.stopTest();
    }

}