@isTest(SeeAllData=false)

private class EmailPublisherLoadertest {
    public static User testusr1;
    public static User testusr2;
    public static User testusr3;
    public static testMethod void EmailPublisherLoader() {
        
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='National Accounts'limit 1];
        Profile testprof2=[SELECT Id FROM Profile WHERE Name='System Administrator'limit 1];
        UserRole usrRole = [Select Id, Name from UserRole where Name='Consumer Relations - CSR'];
        UserRole usrRoleRCTechSupport = [Select Id, Name from UserRole where Name='RC Tech Support - RES'];
        
        
        // create new user with System Administrator
        testusr1=new User( email='testdealer.user13718@gmail.com',
                          profileid = testprof1.id,
                          UserRoleId=usrRole.Id,
                          UserName='test11.user13718@gmail.com', 
                          Alias = 'GDS',
                          TimeZoneSidKey='America/New_York',
                          EmailEncodingKey='ISO-8859-1',
                          LocaleSidKey='en_US', 
                          LanguageLocaleKey='en_US',
                          FirstName = 'test1',
                          LastName = 'user1');
        insert testusr1;  
        
         testusr2=new User( email='testdealer2.user137181@gmail.com',
                          profileid = testprof2.id,
                          UserRoleId=usrRole.Id,
                          UserName='test111.user137182@gmail.com', 
                          Alias = 'GDS1',
                          TimeZoneSidKey='America/New_York',
                          EmailEncodingKey='ISO-8859-1',
                          LocaleSidKey='en_US', 
                          LanguageLocaleKey='en_US',
                          FirstName = 'test2',
                          LastName = 'user2');
        insert testusr2; 
        
         testusr3=new User( email='testdealer3.user137183@gmail.com',
                          profileid = testprof2.id,
                          UserRoleId=usrRoleRCTechSupport.Id,
                          UserName='test1111.user137183@gmail.com', 
                          Alias = 'GDS1',
                          TimeZoneSidKey='America/New_York',
                          EmailEncodingKey='ISO-8859-1',
                          LocaleSidKey='en_US', 
                          LanguageLocaleKey='en_US',
                          FirstName = 'test3',
                          LastName = 'user3');
        insert testusr3; 
        
        system.runAs(testusr3){
            case c3=new case();
            c3.CCC_Purpose__c='Cancel Order';
            c3.RecordTypeId='01215000001JLpG';
            c3.CCC_Order__c='1232';
            c3.Status='Open';
            c3.CCC_Customer_PO__c='909';
            c3.Distributor_Order__c='7877';
            c3.CCC_Purpose__c='';
            c3.Origin='Email';
            c3.Type = 'EPIC';
            // RecordType rt1= [select id,Name from RecordType where SobjectType='Case' and Name='Replacement Component (RC)' Limit 1];
            // c.RecordTypeId=rt1.id;
            // c.Source='Email';
            //c.ownerId = testusr1.Id;
            insert c3;
              Exception failureDuringExecution = null;
            
            String defaultsAsJSON = '[{"targetSObject":{"attributes":{"type":"EmailMessage"},"TextBody":"",'
                + '"FromName":"Test","FromAddress":"test@example.com","HtmlBody":"<html><body></body></html>","BccAddress":"test@example.com",'
                + '"CcAddress":"","ToAddress":"test@example.com","Subject":"Testing"},"contextId":"'+c3.id+'","actionType":"Email",'
                + '"actionName":"Case.Email","fromAddressList":["salesforce@test.com"]}]';
            List<QuickAction.SendEmailQuickActionDefaults> defaultsSettings = 
                (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(defaultsAsJSON, List<QuickAction.SendEmailQuickActionDefaults>.class);
            
            //Test.startTest();
            EmailPublisherLoader em=new EmailPublisherLoader();
            em.customLabelValue='test';
            try { (new EmailPublisherLoader()).onInitDefaults(defaultsSettings); }
            catch(Exception failure) { failureDuringExecution = failure; }
            
          
        } 
          system.runAs(testusr2){
            case c2=new case();
            c2.CCC_Purpose__c='Cancel Order';
            c2.RecordTypeId='01215000001JLpG';
            c2.CCC_Order__c='1232';
            c2.Status='Open';
            c2.CCC_Customer_PO__c='909';
            c2.Distributor_Order__c='7877';
            c2.CCC_Purpose__c='';
            c2.Origin='RC Community';
            // RecordType rt1= [select id,Name from RecordType where SobjectType='Case' and Name='Replacement Component (RC)' Limit 1];
            // c.RecordTypeId=rt1.id;
            // c.Source='Email';
            //c.ownerId = testusr1.Id;
            insert c2;
              Exception failureDuringExecution = null;
            
            String defaultsAsJSON = '[{"targetSObject":{"attributes":{"type":"EmailMessage"},"TextBody":"",'
                + '"FromName":"Test","FromAddress":"test@example.com","HtmlBody":"<html><body></body></html>","BccAddress":"test@example.com",'
                + '"CcAddress":"","ToAddress":"test@example.com","Subject":"Testing"},"contextId":"'+c2.id+'","actionType":"Email",'
                + '"actionName":"Case.Email","fromAddressList":["salesforce@test.com"]}]';
            List<QuickAction.SendEmailQuickActionDefaults> defaultsSettings = 
                (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(defaultsAsJSON, List<QuickAction.SendEmailQuickActionDefaults>.class);
            
            //Test.startTest();
            EmailPublisherLoader em=new EmailPublisherLoader();
            em.customLabelValue='test';
            try { (new EmailPublisherLoader()).onInitDefaults(defaultsSettings); }
            catch(Exception failure) { failureDuringExecution = failure; }
            
          
        }  
      
        System.runAs(testusr1)
        { 
            
            case c=new case();
            c.CCC_Purpose__c='Cancel Order';
            c.RecordTypeId='01215000001UgLf';
            c.CCC_Order__c='1232';
            c.Status='Open';
            c.CCC_Customer_PO__c='909';
            c.Distributor_Order__c='7877';
            c.CCC_Purpose__c='';
            // c.Origin='RC Community';
            // RecordType rt1= [select id,Name from RecordType where SobjectType='Case' and Name='Replacement Component (RC)' Limit 1];
            // c.RecordTypeId=rt1.id;
            // c.Source='Email';
            //c.ownerId = testusr1.Id;
            insert c;
            
         
            
            
            National_Account_Purpose__c cs = new National_Account_Purpose__c();
            cs.name='tes';
            cs.EmailAddress__c  ='crnacancel@carrier.com';
            cs.Purpose__c='order processing';
            
            //cs.Other fiels values
            insert cs;
            Exception failureDuringExecution = null;
            
            String defaultsAsJSON = '[{"targetSObject":{"attributes":{"type":"EmailMessage"},"TextBody":"",'
                + '"FromName":"Test","FromAddress":"test@example.com","HtmlBody":"<html><body></body></html>","BccAddress":"test@example.com",'
                + '"CcAddress":"","ToAddress":"test@example.com","Subject":"Testing"},"contextId":"'+c.id+'","actionType":"Email",'
                + '"actionName":"Case.Email","fromAddressList":["salesforce@test.com"]}]';
            List<QuickAction.SendEmailQuickActionDefaults> defaultsSettings = 
                (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(defaultsAsJSON, List<QuickAction.SendEmailQuickActionDefaults>.class);
            
            Test.startTest();
            EmailPublisherLoader em=new EmailPublisherLoader();
            em.customLabelValue='test';
            try { (new EmailPublisherLoader()).onInitDefaults(defaultsSettings); }
            catch(Exception failure) { failureDuringExecution = failure; }
            
            Test.stopTest();
      }  
        //System.assertEquals(null, failureDuringExecution, 'There was an exception thrown during the test!');
        //Make other assertions here
        
        
    }
     
    
}