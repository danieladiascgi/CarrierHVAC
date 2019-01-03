@isTest
Public class MaterialSearchTest
 {
     public static CCC_IntegrationEndPoint__c endpoint;
      public static Case testCase1;
      public static void setupData()
      {
         //create new account
           Account testAcc=new Account();
           RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Partner' Limit 1];
           testAcc.recordTypeId=rt2.id;
           testAcc.Name='Test Bryant Dealer';
           testAcc.Type='Dealer';
           testAcc.BillingPostalCode='1234567';
           testAcc.BillingStreet = '555 columbus avenue';
           testAcc.BillingCity = 'Syracuse';
           testAcc.BillingState = 'NY';
           testAcc.BillingCountry = 'US';
                   
           insert testAcc;
      
       // create the new contact
           Contact testCon1=new Contact();
           testCon1.FirstName='Suchita';
           testCon1.LastName='Tewari';
           testCon1.AccountId=testAcc.id;
           testCon1.MailingStreet = '555 columbus avenue';
           testCon1.MailingCity = 'Syracuse';
           testCon1.MailingState = 'NY';
           testCon1.MailingCountry = 'US';
           testCon1.MailingPostalCode = '13057';
           
           insert testCon1;
           
        // create new case
          testCase1=new Case();
          testCase1.Subject='TestDIMSCase';
          testCase1.Origin='Email';
          testCase1.Status='Open'; 
          testCase1.AccountId=testAcc.id;
          testCase1.ContactId=testCon1.id;
          RecordType rt= [select id,Name from RecordType where SobjectType='Case' and Name='Consumer Relations' Limit 1];
          testCase1.recordTypeId=rt.id;
          insert testCase1;         
       	  endpoint= new CCC_IntegrationEndPoint__c();
            endpoint.Name='PHDB_Auth';
            endpoint.UserName__c='app_salesforce';
            endpoint.Password__c='mypwd';
            endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
            endpoint.URL__c='http://sharedservices.carrier.com/BlackJackRestService/search?';  
            insert endpoint;  
      }
      public static testMethod void testConstructor()
      {
       setupData();
       Test.startTest();
         Test.setMock(HttpCalloutMock.class,new test_matrl_HttpRespGen());
         
         MaterialSearchDemoController.JSONWrapper wrapvar = new MaterialSearchDemoController.JSONWrapper();//call for the wrapper class
         wrapvar.quantity = '30';
         wrapvar.leadTimeDays = '26';
         wrapvar.recoveryDate = '2018-01-07';
         
         MaterialSearchDemoController.SaveMaterial('1170003','324',true,testCase1.Id);
         String valCase = String.valueOf(testCase1.Id);
         String s = MaterialSearchDemoController.getValOfSapShipTo(valCase);
         
         
       Test.stopTest();
      }
      
      public static testMethod void testConstructor2()
      {
       setupData();
       Test.startTest();
         Test.setMock(HttpCalloutMock.class,new test_matrl_HttpRespGen2());         
         MaterialSearchDemoController.JSONWrapper wrapvar2 = MaterialSearchDemoController.getMaterialAvailability('1170003',true);
       Test.stopTest();
      }
     
 }