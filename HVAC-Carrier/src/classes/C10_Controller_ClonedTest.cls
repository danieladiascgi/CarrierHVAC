@IsTest
public class C10_Controller_ClonedTest {
    
    public static CCC_IntegrationEndPoint__c endpoint;
    
    public static testmethod void C10POSearch(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test1812171.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test181217144',
                         LastName = 'user181217144');
        insert u1;
        
        //create new custom setting;
        
        System.runAs(u1){
            endpoint= new CCC_IntegrationEndPoint__c();
            endpoint.Name='PHDB_Auth';
            endpoint.UserName__c='app_salesforce';
            endpoint.Password__c='mypwd';
            endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
            endpoint.URL__c='http://sharedservices.carrier.com/BlackJackRestService/search?';  
            insert endpoint;
            
            account acct =new account();
            acct.AccountNumber='1234';
            acct.Name='Manjula';
            acct.CCC_C10_Parent__c='123';
            insert acct;
            contact cnt = new contact();
            cnt.AccountId=acct.Id;
            cnt.Email='manjula.r@lntinfotech.com';
            cnt.LastName='Manju';
            insert cnt;
            
            test.startTest();
            //  Test.setMock(HttpCalloutMock.class, new CCC_HttpResponseGeneratorDimsTest()); 
            C10_controller_cloned obj = new C10_controller_cloned();
            Test.setMock(HttpCalloutMock.class, new HttpResponseGeneratorC10Test()); 
            
            C10_controller_cloned.searchC10records('14412', '06456', null);
            C10_controller_cloned.fetchUser();
            C10_controller_cloned.getparsePayloadAndGetValues('SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=');
            
            test.stopTest();
        }
    }
    
    public static testmethod void C10OrderSearch(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test1812171.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test181217144',
                         LastName = 'user181217144');
        insert u1;
        
        //create new custom setting;
        
        System.runAs(u1){
            endpoint= new CCC_IntegrationEndPoint__c();
            endpoint.Name='PHDB_Auth';
            endpoint.UserName__c='app_salesforce';
            endpoint.Password__c='mypwd';
            endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
            endpoint.URL__c='http://sharedservices.carrier.com/BlackJackRestService/search?';  
            insert endpoint;
            
            account acct =new account();
            acct.AccountNumber='1234';
            acct.Name='Manjula';
            acct.CCC_C10_Parent__c='123';
            insert acct;
            contact cnt = new contact();
            cnt.AccountId=acct.Id;
            cnt.Email='manjula.r@lntinfotech.com';
            cnt.LastName='Manju';
            insert cnt;
            
            test.startTest();
            //  Test.setMock(HttpCalloutMock.class, new CCC_HttpResponseGeneratorDimsTest()); 
            C10_controller_cloned obj = new C10_controller_cloned();
            Test.setMock(HttpCalloutMock.class, new HttpResponseGeneratorC10OrderSearch()); 
            
            C10_controller_cloned.searchC10records('14412', null, '2334');
            
            test.stopTest();
        }
    }
    
    public static testmethod void PartsSearch(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user17812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test1812171.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test181217144',
                         LastName = 'user181217144');
        insert u1;
        
        //create new custom setting;
        
        System.runAs(u1){
            endpoint= new CCC_IntegrationEndPoint__c();
            endpoint.Name='PHDB_Auth';
            endpoint.UserName__c='app_salesforce';
            endpoint.Password__c='mypwd';
            endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
            endpoint.URL__c='http://sharedservices.carrier.com/BlackJackRestService/search?';  
            insert endpoint;
            
            
            account acct =new account();
            acct.AccountNumber='1234';
            acct.Name='Manjula';
            acct.CCC_C10_Parent__c='123';
            insert acct;
            contact cnt = new contact();
            cnt.AccountId=acct.Id;
            cnt.Email='manjula.r@lntinfotech.com';
            cnt.LastName='Manju';
            insert cnt;
            
            test.startTest();
            //  Test.setMock(HttpCalloutMock.class, new CCC_HttpResponseGeneratorDimsTest()); 
            C10_controller_cloned obj = new C10_controller_cloned();
            Test.setMock(HttpCalloutMock.class, new HttpResponseGeneratorC10PartSearch()); 
            
            C10_controller_cloned.typeAheadforParts('test');
            
            test.stopTest();
        }
    }
    public static testmethod void salesOrderByPartIdSearch(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user18512171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test1812171.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test181217144',
                         LastName = 'user181217144');
        insert u1;
        
        //create new custom setting;
        
        System.runAs(u1){
            endpoint= new CCC_IntegrationEndPoint__c();
            endpoint.Name='PHDB_Auth';
            endpoint.UserName__c='app_salesforce';
            endpoint.Password__c='mypwd';
            endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
            endpoint.URL__c='http://sharedservices.carrier.com/BlackJackRestService/search?';  
            insert endpoint;
            
            
            
            account acct =new account();
            acct.AccountNumber='1234';
            acct.Name='Manjula';
            acct.CCC_C10_Parent__c='123';
            insert acct;
            contact cnt = new contact();
            cnt.AccountId=acct.Id;
            cnt.Email='manjula.r@lntinfotech.com';
            cnt.LastName='Manju';
            insert cnt;
            
            test.startTest();
            //  Test.setMock(HttpCalloutMock.class, new CCC_HttpResponseGeneratorDimsTest()); 
            C10_controller_cloned obj = new C10_controller_cloned();
            Test.setMock(HttpCalloutMock.class, new HttpResponseGeneratorsalesOrderByPartId()); 
            
            C10_controller_cloned.showPartRecord('10', '10');
            
            test.stopTest();
        }
    }
    
    public static testmethod void C10ParentVal(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test1812171.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test181217144',
                         LastName = 'user181217144');
        insert u1;
        
        //create new custom setting;
        
        System.runAs(u1){
            endpoint= new CCC_IntegrationEndPoint__c();
            endpoint.Name='PHDB_Auth';
            endpoint.UserName__c='app_salesforce';
            endpoint.Password__c='mypwd';
            endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
            endpoint.URL__c='http://sharedservices.carrier.com/BlackJackRestService/search?';  
            insert endpoint;
            
            
            account acct =new account();
            acct.AccountNumber='1234';
            acct.Name='Manjula';
            acct.CCC_C10_Parent__c='123';
            insert acct;
            contact cnt = new contact();
            cnt.AccountId=acct.Id;
            cnt.Email='manjula.r@lntinfotech.com';
            cnt.LastName='Manju';
            insert cnt;
            Id [] fixedSearchResults= new Id[1];
            fixedSearchResults[0] = cnt.Id;
            Test.setFixedSearchResults(fixedSearchResults);
            
            test.startTest();
            //  Test.setMock(HttpCalloutMock.class, new CCC_HttpResponseGeneratorDimsTest()); 
            //  C10_controller_cloned obj = new C10_controller_cloned();
            //  Test.setMock(HttpCalloutMock.class, new HttpResponseGeneratorC10Test()); 
            
            //  C10_controller_cloned.searchC10records('14412', '06456', null);
            C10_controller_cloned.fetchUser();
            C10_controller_cloned.getparsePayloadAndGetValues('SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=');
            //  C10_controller_cloned.testTokenGenerator();
            //  C10_controller_cloned.showPartRecord('10', '10');
            C10_controller_cloned.typeAheadforCustNum('test');
            //   C10_controller_cloned.typeAheadforParts('test');
            
            C10_controller_cloned.getC10ParentVal(u1.Id, 'test');
            //String salesorderno = null;
            // C10_controller_cloned.searchC10records('10', 'test', salesorderno);
            
            test.stopTest();
        }
    }
}