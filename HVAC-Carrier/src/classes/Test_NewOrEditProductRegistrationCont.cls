@isTest(seeAllData=true)
public class Test_NewOrEditProductRegistrationCont {
public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
      public static User testusr1;
      public static Contact testCon1;
      public static Case testCase1;
      public static Account testAcc;
      public static Registration_Correction__c regcorrobj;
      public static CCC_IntegrationEndPoint__c endpoint;
      public boolean flag = true;
      public boolean flag1 = true;
     Public boolean EquipFlag = true;
      
      public static testMethod void setupData(){

    
              //create new account
             testAcc=new Account();
             RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Partner' Limit 1];
             testAcc.recordTypeId=rt2.id;
             testAcc.Name='Test Bryant Dealer';
             testAcc.Type='Dealer';
             testAcc.BillingPostalCode='1234567';
               insert testAcc;
        
            // create the new contact
             testCon1=(Contact)utilClass.setUpData(new Contact());
             testCon1.FirstName='Suchita';
             testCon1.LastName='Tewari';
             testCon1.AccountId=testAcc.id;
             testCon1=(Contact)utilClass.createTestRecord(testCon1);
             
               Profile testprof1=[SELECT Id FROM Profile WHERE Name='Tier 1 Agent Profile'limit 1];
      
      // create new user with System Administrator
        testusr1=new User( email='testdealer.user@gmail.com',
        profileid = testprof1.id,  
        UserName='test11.user@gmail.com', 
        Alias = 'GDS',
        TimeZoneSidKey='America/New_York',
        EmailEncodingKey='ISO-8859-1',
        LocaleSidKey='en_US', 
        LanguageLocaleKey='en_US',
        PortalRole = 'Manager',
        FirstName = 'test1',
        LastName = 'user1');
           insert testusr1;
            
      // create new case
        testCase1=(Case)utilClass.setUpData(new Case());
        testCase1.Subject='TestDIMSCase';
        testCase1.Origin='Email';
        testCase1.Status='Open'; 
        testCase1.AccountId=testAcc.id;
        testCase1.ContactId=testCon1.id;
        testCase1.CCC_Purpose__c  ='epic';
        testCase1.CCC_Purpose_Tier1_CR__c  ='epic';
        testCase1.CCC_Sub_Purpose__c  ='epic';
        testCase1.CCC_Sub_Purpose_Tier1_CR__c  ='epic';
        testCase1.RegCorrectionOncase__c = true;
        RecordType rt= [select id,Name from RecordType where SobjectType='Case' and Name='Consumer Relations' Limit 1];
        testCase1.recordTypeId=rt.id;
        testCase1=(Case)utilClass.createTestRecord(testCase1);
        //testCase1.RegCorrectionOncase__c = true;
       // update testCase1;
          
           //create new custom setting;
         /*endpoint= new CCC_IntegrationEndPoint__c();
         endpoint.UserName__c='app_salesforce';
         endpoint.Password__c='hy~jpmXm@2s6_@MM';
         endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
         endpoint.URL__c='https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access';
         endpoint.Name='PHDB_Token';*/
          // insert endpoint;
      }
      
      //test for constructor
    public static testMethod void testConstructor()
    {
    setupData();
    Test.startTest();
        // Set mock callout class for http callouts
           Test.setMock(HttpCalloutMock.class,new CCC_HttpRespGenRegCorrectionNewTest());
           //Test.setMock(HttpCalloutMock.class, new  CCC_HttpRespGeneratorEquipDetailTest()); 
            //Test.setMock(HttpCalloutMock.class,new CCC_HttpRespGeneratorEquipDetailTest());
        System.runAs(testusr1)
        { 
            Integer index = 0;
            PageReference pageRef = new PageReference('/apex/CCC_RegistrationCorrectionPage');
            pageRef.getParameters().put('rowIndex', String.valueOf(index));
            Test.setCurrentPage(pageRef);
             // call for the constructor   
           ApexPages.currentPage().getParameters().put('id',testCase1.id);
            //?id='+testCase1.Id+'confNo=0908025129b&serialNo=2709A00692
           ApexPages.currentPage().getParameters().put('confNo','0908025129b'); 
           ApexPages.currentPage().getParameters().put('serialNo','2709A00692'); 
            ApexPages.currentPage().getParameters().put('sbRegnNo',''); 
           ApexPages.StandardController stdCon = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller1 = new NewOrEditProductRegistrationController(stdCon); 
            Registration_Correction__c regCorrecn = testcontroller1.regCorrection;
            //regCorrecn.Customer_Confirmation__c = '0908025129b';
            //testcontroller1.searchEquipments();
            
            //testcontroller1.addMore1();
            
            Test.setMock(HttpCalloutMock.class,new CCC_HttpRespGenRegCorrectionNewTest());
                        //equip.Serial__c = '2709A00692';
            
            testcontroller1.confNo = '';
            testcontroller1.sbRegnNo = '';
            testcontroller1.serialNo='';
            testcontroller1.redirectURL='';
			testcontroller1.setregoncasevalue(testCase1);
            //testcontroller1.searchEquipments();
            //testcontroller1.getRegisteredEquipments();
            //testcontroller1.getRegisCorrection();
            //testcontroller1.populateDetails();
            //testcontroller1.setSelectedCOnfirmation();
            //testcontroller1.getRegisteredEquipments();
            //testcontroller1.getSerialNumberResult();
          
                     
          
        }
    Test.stopTest();
    }//constructorTest()
          
    
      public static testMethod void testRegistrationDataObj() {
    setupData();
    Test.startTest();
        
        System.runAs(testusr1)
        {
          NewOrEditProductRegistrationController.RegistrationDataObj regobj= new NewOrEditProductRegistrationController.RegistrationDataObj();
          regobj.consumer_Name = 'registration name' ;
          regobj.consumer_BusinessName  = 'registration name' ;
          regobj.consumer_Address1  = 'registration name' ;
          regobj.consumer_Address2  = 'registration name' ;
          regobj.consumer_City  = 'registration name' ;
          regobj.consumer_State  = 'registration name' ;
          regobj.consumer_Country  = 'registration name' ;
          regobj.consumer_Zip  = 'registration name' ;
          regobj.consumer_Email  = 'registration name' ;
          regobj.consumer_Phone1  = 'registration name' ;
          regobj.consumer_Phone2  = 'registration name' ;
          regobj.equip_Address1  = 'registration name' ;
          regobj.equip_Address2  = 'registration name' ;
          regobj.equip_City  = 'registration name' ;
          regobj.equip_State  = 'registration name' ;
          regobj.equip_Country  = 'registration name' ;
          regobj.equip_Zip  = 'registration name' ;
          regobj.dealerName  = 'registration name' ;
          regobj.dealerPhone  = 'registration name' ;
          regobj.mfgAcctNum  = 'registration name' ;
          regobj.serviceBenchID  = 'registration name' ;
          regobj.hvacpId  = 'registration name' ;
          regobj.model  = 'registration name' ;
          regobj.serial  = 'registration name' ;
          regobj.equip_Description  = 'registration name' ;
          regobj.confirmationNumber  = 'registration name' ;
          regobj.registrationNumber  = 'registration name' ;
          regobj.source  = 'registration name' ;
          regobj.comments  = 'registration name' ;
          regobj.installationDate = 'registration name' ;
          regobj.registrationDate = 'registration name' ;
          regobj.transferDate = 'registration name' ;
          regobj.markAs = 'registration name' ;
          regobj.registrationDataInput = 'registration name' ;
          regobj.Id  = 'registration name' ;
          regobj.modelLocation  = 'registration name' ;
          regobj.furnaceOrientation  = 'registration name' ;
          regobj.furnaceFuel  = 'registration name' ;
          regobj.enhancedWarrantyFlag  = 'registration name' ;
          regobj.alwaysReviewFlag  = 'registration name' ;
          regobj.registeredOnTimeFlag  = 'registration name' ;
          regobj.proofOfPurchaseFlag  = 'registration name' ;
          regobj.agreementNumber  = 'registration name' ;
          regobj.tagNumber  = 'registration name' ;
          regobj.selected  = true ;
          
          list<NewOrEditProductRegistrationController.RegistrationDataObj> regobjlist =new list<NewOrEditProductRegistrationController.RegistrationDataObj>();    
            regobjlist.add(regobj);         
         
         
       
         
        }
    }
          
    public static testMethod void testRegCorrectionOncase()
    {
        
    setupData();
    Test.startTest();
        
        System.runAs(testusr1)
        { 
          Case testCase = new Case();
          testCase.Subject='TestDIMSCase';
          testCase.Origin='Email';
          testCase.Status='Open'; 
          testCase.AccountId=testAcc.id;
          testCase.ContactId=testCon1.id;
          testCase.CCC_Purpose__c  ='epic';
          testCase.CCC_Purpose_Tier1_CR__c  ='epic';
          testCase.CCC_Sub_Purpose__c  ='epic';
          testCase.CCC_Sub_Purpose_Tier1_CR__c  ='epic';
          testCase.RegCorrectionOncase__c = true;
          insert testCase;
          
          Registration_Correction__c  regcorobj = new Registration_Correction__c();
          regcorobj.InCorrect_Model__c='123';
          regcorobj.InCorrect_Serial__c='123'; 
          regcorobj.First_Name__c='abc';
          regcorobj.Last_Name__c='xyz';
          regcorobj.Brand__c='abcxyz';
          regcorobj.Case_Number__c=testCase1.id;
          regcorobj.Registration__c='12345';
          regcorobj.Customer_Confirmation__c = 'tttt';
          regcorobj.SB_Registration_Number_Search__c = 'test';
          regcorobj.Serial_Number_Search__c  = 'test';
          regcorobj.Enhanced__c='Yes';
          regcorobj.Registered_On_Time__c='Yes';
          regcorobj.Requesting_Override_Enhanced_Exception__c = true ;
          regcorobj.Reasoning_for_Exception_Override__c = '';
          insert regcorobj;
          regcorobj.Requesting_Override_Enhanced_Exception__c = false;
          regcorobj.Confirmation__c = true ;
          regcorobj.Provide_Confirmation_to__c= 'Both';
          regcorobj.Homeowner_Emai1__c = '';
          regcorobj.Homeowner_Emai__c= '';
          regcorobj.Dealer_Email_Address__c= '';
          regcorobj.Dealer_Email_Address1__c= '';
          update regcorobj;
          
          Equipment__c equip = new Equipment__c();
          equip.Duplicate_Serial__c = true;
          equip.Mark_As__c = 'test';
          equip.Model__c = 'test';
          equip.Model_Correction__c = 'test';
          equip.Reasoning_for_Removing_Equipment__c = 'test';
          equip.Registration_Correction__c = regcorobj.id;
          equip.SB_Reg__c = 'test';
          equip.Select__c = true;
          equip.Serial__c = 'test';
          equip.Serial_Correction__c = 'test';
          equip.Source__c = 'test';
          insert equip ;
          
           List<Equipment__c> equiplist= new List<Equipment__c>();
            equiplist.add(equip);
            
           ApexPages.StandardController stdCon1 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller1 = new NewOrEditProductRegistrationController(stdCon1);
          
           
          ApexPages.StandardController stdCon2 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller2 = new NewOrEditProductRegistrationController(stdCon2);
          
           
          
          
           Id uniqueEquipmentId = equip.id;
           testcontroller2.populateDetails();
           System.currentPageReference().getParameters().put('id',testCase1.id);
            NewOrEditProductRegistrationController.SerialNumberResult serNo= new NewOrEditProductRegistrationController.SerialNumberResult(regcorobj,true); 
             serNo.selected=true;
            List<NewOrEditProductRegistrationController.SerialNumberResult> serNolist =new List<NewOrEditProductRegistrationController.SerialNumberResult>();
            serNolist.add( serNo);
            testcontroller2.serialResults=serNolist;
            
            PageReference pageRef = new PageReference('/apex/CCC_RegistrationCorrectionPage?confNo=0908025129b&serialNo=2709A00692');
            //Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',testCase1.id);
                
        }
    }
        
         public static testMethod void CoverError1(){
            setupData();
            Test.startTest();
        
            System.runAs(testusr1)
        { 
          Case testCase = new Case();
          testCase.Subject='TestDIMSCase';
          testCase.Origin='Email';
          testCase.Status='Open'; 
          testCase.AccountId=testAcc.id;
          testCase.ContactId=testCon1.id;
          testCase.CCC_Purpose__c  ='epic';
          testCase.CCC_Purpose_Tier1_CR__c  ='epic';
          testCase.CCC_Sub_Purpose__c  ='epic';
          testCase.CCC_Sub_Purpose_Tier1_CR__c  ='epic';
          testCase.RegCorrectionOncase__c = true;
          insert testCase;
          
          Registration_Correction__c  regcorobj = new Registration_Correction__c();
          regcorobj.InCorrect_Model__c='123';
          regcorobj.InCorrect_Serial__c='123'; 
          regcorobj.First_Name__c='abc';
          regcorobj.Last_Name__c='xyz';
          regcorobj.Brand__c='abcxyz';
          regcorobj.Case_Number__c=testCase1.id;
          regcorobj.Registration__c='12345';
          regcorobj.Customer_Confirmation__c = 'tttt';
          regcorobj.SB_Registration_Number_Search__c = 'test';
          regcorobj.Serial_Number_Search__c  = 'test';
          regcorobj.Enhanced__c='Yes';
          regcorobj.Registered_On_Time__c='Yes';
          //regcorobj.Requesting_Override_Enhanced_Exception__c = true ;
          regcorobj.Reasoning_for_Exception_Override__c = '';
          insert regcorobj;
          regcorobj.Requesting_Override_Enhanced_Exception__c = true;
          regcorobj.Reasoning_for_Exception_Override__c = '';
          regcorobj.Confirmation__c = true ;
          regcorobj.Provide_Confirmation_to__c= 'Dealer';
          regcorobj.Homeowner_Emai1__c = '';
          regcorobj.Homeowner_Emai__c= '';
          regcorobj.Dealer_Email_Address__c= '';
          regcorobj.Dealer_Email_Address1__c= '';
          update regcorobj;
          
          Equipment__c equip = new Equipment__c();
          equip.Duplicate_Serial__c = true;
          equip.Mark_As__c = 'test';
          equip.Model__c = 'test';
          equip.Model_Correction__c = 'test';
          equip.Reasoning_for_Removing_Equipment__c = 'test';
          equip.Registration_Correction__c = regcorobj.id;
          equip.SB_Reg__c = 'test';
          equip.Select__c = true;
          equip.Serial__c = 'test';
          equip.Serial_Correction__c = 'test';
          equip.Source__c = 'test';
          insert equip ;
          
           List<Equipment__c> equiplist= new List<Equipment__c>();
            equiplist.add(equip);
            
           ApexPages.StandardController stdCon1 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller1 = new NewOrEditProductRegistrationController(stdCon1);
          
           
          ApexPages.StandardController stdCon2 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller2 = new NewOrEditProductRegistrationController(stdCon2);
          
           
          
          
           Id uniqueEquipmentId = equip.id;
           System.currentPageReference().getParameters().put('id',testCase1.id);
            NewOrEditProductRegistrationController.SerialNumberResult serNo= new NewOrEditProductRegistrationController.SerialNumberResult(regcorobj,true); 
             serNo.selected=true;
            List<NewOrEditProductRegistrationController.SerialNumberResult> serNolist =new List<NewOrEditProductRegistrationController.SerialNumberResult>();
            serNolist.add( serNo);
            testcontroller2.serialResults=serNolist;
            
            PageReference pageRef = new PageReference('/apex/CCC_RegistrationCorrectionPage?confNo=0908025129b&serialNo=2709A00692');
            //Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',testCase1.id);
                
        }
      }  
        public static testMethod void CoverError2(){
            setupData();
            Test.startTest();
        
            System.runAs(testusr1)
        { 
          Registration_Correction__c  regcorobj = new Registration_Correction__c();
          regcorobj.InCorrect_Model__c='123';
          regcorobj.InCorrect_Serial__c='123'; 
          regcorobj.First_Name__c='abc';
          regcorobj.Last_Name__c='xyz';
          regcorobj.Brand__c='abcxyz';
          regcorobj.Case_Number__c=testCase1.id;
          regcorobj.Registration__c='12345';
          regcorobj.Customer_Confirmation__c = 'tttt';
          regcorobj.SB_Registration_Number_Search__c = 'test';
          regcorobj.Serial_Number_Search__c  = 'test';
          regcorobj.Enhanced__c='Yes';
          regcorobj.Registered_On_Time__c='Yes';
          regcorobj.Confirmation__c = true ;
          regcorobj.Provide_Confirmation_to__c = '';
          regcorobj.Dealer_Email_Address__c= '';
          regcorobj.Dealer_Email_Address1__c= '';
          insert regcorobj;
          
          Equipment__c equip = new Equipment__c();
          equip.Duplicate_Serial__c = true;
          equip.Mark_As__c = 'test';
          equip.Model__c = 'test';
          equip.Model_Correction__c = 'test';
          equip.Reasoning_for_Removing_Equipment__c = 'test';
          equip.Registration_Correction__c = regcorobj.id;
          equip.SB_Reg__c = 'test';
          equip.Select__c = true;
          equip.Serial__c = 'test';
          equip.Serial_Correction__c = 'test';
          equip.Source__c = 'test';
          insert equip ;
          
           List<Equipment__c> equiplist= new List<Equipment__c>();
            equiplist.add(equip);
            
           ApexPages.StandardController stdCon1 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller1 = new NewOrEditProductRegistrationController(stdCon1);
          
           
          ApexPages.StandardController stdCon2 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller2 = new NewOrEditProductRegistrationController(stdCon2);
          
           
          
          
           Id uniqueEquipmentId = equip.id;
           System.currentPageReference().getParameters().put('id',testCase1.id);
            NewOrEditProductRegistrationController.SerialNumberResult serNo= new NewOrEditProductRegistrationController.SerialNumberResult(regcorobj,true); 
             serNo.selected=true;
            List<NewOrEditProductRegistrationController.SerialNumberResult> serNolist =new List<NewOrEditProductRegistrationController.SerialNumberResult>();
            serNolist.add( serNo);
            testcontroller2.serialResults=serNolist;
            
            PageReference pageRef = new PageReference('/apex/CCC_RegistrationCorrectionPage?confNo=0908025129b&serialNo=2709A00692');
            //Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',testCase1.id);
                
        }
    
    }
            public static testMethod void CoverError3(){
            setupData();
            Test.startTest();
        
            System.runAs(testusr1)
        { 
          Registration_Correction__c  regcorobj = new Registration_Correction__c();
          regcorobj.InCorrect_Model__c='123';
          regcorobj.InCorrect_Serial__c='123'; 
          regcorobj.First_Name__c='abc';
          regcorobj.Last_Name__c='xyz';
          regcorobj.Brand__c='abcxyz';
          regcorobj.Case_Number__c=testCase1.id;
          regcorobj.Registration__c='12345';
          regcorobj.Customer_Confirmation__c = 'tttt';
          regcorobj.SB_Registration_Number_Search__c = 'test';
          regcorobj.Serial_Number_Search__c  = 'test';
          regcorobj.Enhanced__c='Yes';
          regcorobj.Registered_On_Time__c='Yes';
          regcorobj.Confirmation__c = true ;
          regcorobj.Provide_Confirmation_to__c = 'Dealer';
          insert regcorobj;
          
          Equipment__c equip = new Equipment__c();
          equip.Duplicate_Serial__c = true;
          equip.Mark_As__c = 'test';
          equip.Model__c = 'test';
          equip.Model_Correction__c = 'test';
          equip.Reasoning_for_Removing_Equipment__c = 'test';
          equip.Registration_Correction__c = regcorobj.id;
          equip.SB_Reg__c = 'test';
          equip.Select__c = true;
          equip.Serial__c = 'test';
          equip.Serial_Correction__c = 'test';
          equip.Source__c = 'test';
          insert equip ;
          
           List<Equipment__c> equiplist= new List<Equipment__c>();
            equiplist.add(equip);
            
           ApexPages.StandardController stdCon1 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller1 = new NewOrEditProductRegistrationController(stdCon1);
          
           
          ApexPages.StandardController stdCon2 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller2 = new NewOrEditProductRegistrationController(stdCon2);
          
           
          
          
           Id uniqueEquipmentId = equip.id;
           System.currentPageReference().getParameters().put('id',testCase1.id);
            NewOrEditProductRegistrationController.SerialNumberResult serNo= new NewOrEditProductRegistrationController.SerialNumberResult(regcorobj,true); 
             serNo.selected=true;
            List<NewOrEditProductRegistrationController.SerialNumberResult> serNolist =new List<NewOrEditProductRegistrationController.SerialNumberResult>();
            serNolist.add( serNo);
            testcontroller2.serialResults=serNolist;
            
            PageReference pageRef = new PageReference('/apex/CCC_RegistrationCorrectionPage?confNo=0908025129b&serialNo=2709A00692');
            //Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',testCase1.id);
                
        }
    
    }

            public static testMethod void CoverError4(){
            setupData();
            Test.startTest();
        
            System.runAs(testusr1)
        { 
          Registration_Correction__c  regcorobj = new Registration_Correction__c();
          regcorobj.InCorrect_Model__c='123';
          regcorobj.InCorrect_Serial__c='123'; 
          regcorobj.First_Name__c='abc';
          regcorobj.Last_Name__c='xyz';
          regcorobj.Brand__c='abcxyz';
          regcorobj.Case_Number__c=testCase1.id;
          regcorobj.Registration__c='12345';
          regcorobj.Customer_Confirmation__c = 'tttt';
          regcorobj.SB_Registration_Number_Search__c = 'test';
          regcorobj.Serial_Number_Search__c  = 'test';
          regcorobj.Enhanced__c='Yes';
          regcorobj.Registered_On_Time__c='Yes';
          regcorobj.Confirmation__c = true ;
          regcorobj.Provide_Confirmation_to__c = 'HomeOwner';
          insert regcorobj;
          
          Equipment__c equip = new Equipment__c();
          equip.Duplicate_Serial__c = true;
          equip.Mark_As__c = 'test';
          equip.Model__c = 'test';
          equip.Model_Correction__c = 'test';
          equip.Reasoning_for_Removing_Equipment__c = 'test';
          equip.Registration_Correction__c = regcorobj.id;
          equip.SB_Reg__c = 'test';
          equip.Select__c = true;
          equip.Serial__c = 'test';
          equip.Serial_Correction__c = 'test';
          equip.Source__c = 'test';
          insert equip ;
          
           List<Equipment__c> equiplist= new List<Equipment__c>();
            equiplist.add(equip);
            
           ApexPages.StandardController stdCon1 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller1 = new NewOrEditProductRegistrationController(stdCon1);
          
           
          ApexPages.StandardController stdCon2 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller2 = new NewOrEditProductRegistrationController(stdCon2);
          
           
          
          
           Id uniqueEquipmentId = equip.id;
           System.currentPageReference().getParameters().put('id',testCase1.id);
            NewOrEditProductRegistrationController.SerialNumberResult serNo= new NewOrEditProductRegistrationController.SerialNumberResult(regcorobj,true); 
             serNo.selected=true;
            List<NewOrEditProductRegistrationController.SerialNumberResult> serNolist =new List<NewOrEditProductRegistrationController.SerialNumberResult>();
            serNolist.add( serNo);
            testcontroller2.serialResults=serNolist;
            
            
            NewOrEditProductRegistrationController.cRegCorrection RegCor= new NewOrEditProductRegistrationController.cRegCorrection(equip); 
            NewOrEditProductRegistrationController.cRegCorrection RegCor1= new NewOrEditProductRegistrationController.cRegCorrection(equip,false);
             RegCor.selected=false;
             RegCor1.selected=true;
            List<NewOrEditProductRegistrationController.cRegCorrection > RegCorlist =new List<NewOrEditProductRegistrationController.cRegCorrection>();
            RegCorlist .add(RegCor);
            //RegCorlist .add(RegCor1);
            testcontroller2.RegcorrecList =RegCorlist ;
            
            List<NewOrEditProductRegistrationController.cRegCorrection > RegCorlist1 =new List<NewOrEditProductRegistrationController.cRegCorrection>();
            RegCorlist1 .add(RegCor1);
            //RegCorlist .add(RegCor1);
            testcontroller2.RegcorrecEquipList =RegCorlist1 ;
            
            PageReference pageRef = new PageReference('/apex/CCC_RegistrationCorrectionPage?confNo=0908025129b&serialNo=2709A00692');
            //Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',testCase1.id);
                
        }
    
    }

           static testMethod void getFormatDateTest()
                {
                test.StartTest();
                NewOrEditProductRegistrationController.FormatDate('11111111111');
                test.StopTest();
                
                }
           
           static testMethod void getFormatDate1Test()
                {
                test.StartTest();
                NewOrEditProductRegistrationController.FormatDate('111');
                test.StopTest();
                
                }
            public static testMethod void CoverError5(){
            setupData();
            Test.startTest();
        
            System.runAs(testusr1)
        { 
          
          Registration_Correction__c  regcorobj = new Registration_Correction__c();
          regcorobj.InCorrect_Model__c='123';
          regcorobj.InCorrect_Serial__c='123'; 
          regcorobj.First_Name__c='abc';
          regcorobj.Last_Name__c='xyz';
          regcorobj.Brand__c='abcxyz';
          regcorobj.Case_Number__c=testCase1.id;
          regcorobj.Registration__c='12345';
          regcorobj.Customer_Confirmation__c = '';
          regcorobj.SB_Registration_Number_Search__c = '';
          regcorobj.Serial_Number_Search__c  = 'test';
          regcorobj.Enhanced__c='Yes';
          regcorobj.Registered_On_Time__c='Yes';
          regcorobj.Confirmation__c = true ;
          regcorobj.Provide_Confirmation_to__c = 'HomeOwner';
          insert regcorobj;
          
          Equipment__c equip = new Equipment__c();
          equip.Duplicate_Serial__c = true;
          equip.Mark_As__c = 'test';
          equip.Model__c = 'test';
          equip.Model_Correction__c = 'test';
          equip.Reasoning_for_Removing_Equipment__c = 'test';
          equip.Registration_Correction__c = regcorobj.id;
          equip.SB_Reg__c = 'test';
          equip.Select__c = true;
          equip.Serial__c = 'test';
          equip.Serial_Correction__c = 'test';
          equip.Source__c = 'test';
          insert equip ;
          
           List<Equipment__c> equiplist= new List<Equipment__c>();
            equiplist.add(equip);
            
           ApexPages.StandardController stdCon1 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller1 = new NewOrEditProductRegistrationController(stdCon1);
          
           
          ApexPages.StandardController stdCon2 = new ApexPages.StandardController(testCase1);
           NewOrEditProductRegistrationController testcontroller2 = new NewOrEditProductRegistrationController(stdCon2);
          
           
          
          
           Id uniqueEquipmentId = equip.id;
           System.currentPageReference().getParameters().put('id',testCase1.id);
            NewOrEditProductRegistrationController.SerialNumberResult serNo= new NewOrEditProductRegistrationController.SerialNumberResult(regcorobj,false); 
             serNo.selected=false;
            List<NewOrEditProductRegistrationController.SerialNumberResult> serNolist =new List<NewOrEditProductRegistrationController.SerialNumberResult>();
            serNolist.add( serNo);
            testcontroller2.serialResults=serNolist;
            
            PageReference pageRef = new PageReference('/apex/CCC_RegistrationCorrectionPage?confNo=0908025129b&serialNo=2709A00692');
            //Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',testCase1.id);
                
        }
    
    }
}