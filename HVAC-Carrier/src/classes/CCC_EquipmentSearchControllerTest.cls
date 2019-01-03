@isTest(SeeAllData=true)
Public class CCC_EquipmentSearchControllerTest
{
//object of the helper class
 public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
 //public static CCC_EquipmentSearchController equipsearch3 =new CCC_EquipmentSearchController();
   
  public static User testusr1;
  public static Contact testCon1;
  public static Case testCase1;
  public static Account testAcc;
  public static Asset testAsset;
  public static CCC_junctionCaseAsset__c junAsset;
  public static CCC_IntegrationEndPoint__c endpoint;
  Public static list<Asset>assetList ; 
  Public static List<Asset> toUpdateTosCodeAssets;
  public static set<string> strSet;  
   // this method is used to setup the data
    public static void setupData()
    {
    
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
           
     
               
            Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'limit 1];
      
        // create new user with Partner Community Warranty Admin profile
           testusr1=new User( email='testdealer.user@gmail.com',
            profileid = testprof1.id,  
            UserName='test11.user1207182@gmail.com', 
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
            
          // create new case
          testCase1=(Case)utilClass.setUpData(new Case());
          testCase1.Subject='TestDIMSCase';
          testCase1.Origin='Email';
          testCase1.Status='Open'; 
          testCase1.AccountId=testAcc.id;
          testCase1.ContactId=testCon1.id;
          RecordType rt= [select id,Name from RecordType where SobjectType='Case' and Name='Consumer Relations' Limit 1];
          testCase1.recordTypeId=rt.id;
          testCase1=(Case)utilClass.createTestRecord(testCase1);
          
           //create new asset
          testAsset= new Asset();
         //  testAsset.Id= testAsset.id;
          testAsset.Name='765435uyrertyjhtrhj';
          testAsset.Brand__c='';
          testAsset.CCC_Disc_Model_Number__c='';
          testAsset.CCC_Model_Number__c='';
          testAsset.SerialNumber='';
          testAsset.CCC_Validation_status__c=true;
          testAsset.AccountId=testAcc.id;
      //  testAsset.ContactId=testCon1.id;
          insert testAsset;
          
          //create new CCC_junctionCaseAsset__c
          junAsset= new CCC_junctionCaseAsset__c();
          junAsset.Asset__c= testAsset.id;
          junAsset.Case__c=testCase1.id;
          insert junAsset;
          /*
          //create new custom setting;
           endpoint= new CCC_IntegrationEndPoint__c();
           endpoint.name='PHDB';
           endpoint.UserName__c='app_salesforce';
           endpoint.Password__c='hy~jpmXm@2s6_@MM';
           endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
           endpoint.URL__c='https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access';
           //endpoint.Name='PHDB_Token';
           insert endpoint;
           
            //create new custom setting;
           endpoint= new CCC_IntegrationEndPoint__c();
           endpoint.name='PHDB_Token';
           endpoint.UserName__c='app_salesforce';
           endpoint.Password__c='hy~jpmXm@2s6_@MM';
           endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
           endpoint.URL__c='https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access';
           insert endpoint;
            */            
    }//setupData()
    
    //test constructor which calls getAllAssets()
    //testdelRecord() and getDiscreteModelNo()
    public static testMethod void testConstructor()
    {
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
        {
          // call for the constructor   
          ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
          CCC_EquipmentSearchController equipsearch =new CCC_EquipmentSearchController(casecontroller1);  
          
          //constructor without parameter
          CCC_EquipmentSearchController equipsearch2 =new CCC_EquipmentSearchController(); 
          
           //test delRecord method
          equipsearch.delRecord ();
         
         //test getDiscreteModelNo method
          equipsearch.getDiscreteModelNo(); 
          
          //code coverage for the wrapper classes DiscreteModelNumbersWrapper and FindRegisteredWrapper 
          CCC_EquipmentSearchController.DiscreteModelNumbersWrapper modelwrap = new CCC_EquipmentSearchController.DiscreteModelNumbersWrapper();
          CCC_EquipmentSearchController.FindRegisteredWrapper findregwrap = new CCC_EquipmentSearchController.FindRegisteredWrapper();
          
          //cover the wrapper classDiscreteModelNumbersWrapper 
          modelwrap.dataQualityIndicator=111;
          modelwrap.mfgDate='';
          modelwrap.derivedMfgDate='';
          modelwrap.mfgWeek=222;
          modelwrap.mfgYear=1992;
          modelwrap.msg='';
          modelwrap.serialVerified=true;
          modelwrap.shippedDate='';
          modelwrap.suGuid='';
          modelwrap.shipTo='';
       
       //cover the wrapper class FindRegisteredWrapper 
          findregwrap.consumer_Name='';
          findregwrap.consumer_BusinessName='';
          findregwrap.consumer_Address1='';
          findregwrap.consumer_Address2='';
          findregwrap.consumer_City='';
          findregwrap.consumer_State='';
          findregwrap.consumer_Country='';
          findregwrap.consumer_Zip='';
          findregwrap.consumer_Phone1='';
          findregwrap.consumer_Phone2='';
          findregwrap.equip_Address1='';
          findregwrap.equip_Address2='';
          findregwrap.equip_City='';
          findregwrap.equip_State='';
          findregwrap.equip_Country='';
          findregwrap.equip_Zip='';
          findregwrap.dealerName='';
          findregwrap.dealerPhone='';
          findregwrap.mfgAcctNum='';
          findregwrap.serviceBenchID='';
          findregwrap.hvacpId='';
          findregwrap.model='';
          findregwrap.equip_Description='';
          findregwrap.confirmationNumber='';
          findregwrap.registrationNumber='';
          findregwrap.source='';
          findregwrap.comments='';
          findregwrap.installationDate='';
          findregwrap.registrationDate='';
          findregwrap.transferDate='';
          findregwrap.markAs='';
          findregwrap.registrationDataInput='';
          findregwrap.Id='';
          findregwrap.modelLocation='';
          findregwrap.furnaceOrientation='';
          findregwrap.furnaceFuel='';
          findregwrap.enhancedWarrantyFlag='';
          findregwrap.alwaysReviewFlag='';
          findregwrap.registeredOnTimeFlag='';
          findregwrap.proofOfPurchaseFlag='';
          findregwrap.agreementNumber='';
          findregwrap.tagNumber='';
             
          
        }
        Test.stopTest();
    
    }//testConstructor()
    
    //test CreateAsset method which calls createJunctionObject
     public static testMethod void testCreateAsset()
    {
       
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
         {
           
            ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
            CCC_EquipmentSearchController equipsearch2 =new CCC_EquipmentSearchController(casecontroller1);
           
           //insert data in lstDisNum 
            CCC_EquipmentSearchController.DiscreteModelNumbersWrapper modelwrap = new CCC_EquipmentSearchController.DiscreteModelNumbersWrapper();
            modelwrap.Serial='123';
            modelwrap.Model='123';
            modelwrap.selected=true;
            modelwrap.discreetNo='123';   
            
            list< CCC_EquipmentSearchController.DiscreteModelNumbersWrapper> modelwraplist= new list< CCC_EquipmentSearchController.DiscreteModelNumbersWrapper>();
            modelwraplist.add(modelwrap);
            equipsearch2.lstDisNum=modelwraplist;
            modelwrap.suggestedResults=modelwraplist;
              
           PageReference pgref1 = Page.CCC_EquipmentSearch;
           pgref1.getParameters().put('id',testCase1.id);
           Test.setCurrentPage(pgref1);
           PageReference result1=equipsearch2.CreateAsset();
           System.assertEquals(null,result1);
           
           strSet = new set<string>();
           strSet.add('123');
           assetList=new list <Asset>();
   
        for (integer i = 0; i < 1; i++){
                    
           testAsset= new Asset();
          testAsset.Name='765435uyrertyjhtrhj';
          testAsset.Brand__c='';
          testAsset.CCC_SerialModelNumber__c='123';
          testAsset.CCC_Disc_Model_Number__c='';
          testAsset.CCC_Model_Number__c='';
          testAsset.SerialNumber='';
          testAsset.CCC_Validation_status__c=true;
          testAsset.AccountId=testAcc.id;
          assetList.add(testAsset);
         }    
         insert assetList;   
         
         equipsearch2 .createJunctionObject(strSet,assetList);
           
          
         }
       Test.stopTest();
    }// testCreateAsset()
    
    
     //test CreateAssetForSS() which calls createJunctionObject
     public static testMethod void CreateAssetForSS()
    {
       
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
         {
           
            ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
            CCC_EquipmentSearchController equipsearch3 =new CCC_EquipmentSearchController(casecontroller1);
           
           //insert data in lstRegEq
            CCC_EquipmentSearchController.FindRegisteredWrapper findregwrap = new CCC_EquipmentSearchController.FindRegisteredWrapper();
            findregwrap.Serial='123';
            findregwrap.Model='123';
            findregwrap.selected=true;
            
            list<CCC_EquipmentSearchController.FindRegisteredWrapper>regwraplist= new list< CCC_EquipmentSearchController.FindRegisteredWrapper>();
            regwraplist.add(findregwrap);
            equipsearch3.lstRegEq=regwraplist;
              
            PageReference pgref1 = Page.CCC_EquipmentSearch;
            pgref1.getParameters().put('id',testCase1.id);
            Test.setCurrentPage(pgref1);
            PageReference result1=equipsearch3.CreateAssetForSS();
            System.assertEquals(null,result1);
         }
       Test.stopTest();
    }//getAllAssetsSS()
    
    
    // test for method getEquippmentInfo() which calls getEquipmentInfo()(test for web service callouts)
     public static testMethod void getEquippmentInfoTest()
    {
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
        {
          // call for the constructor   
          ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
          CCC_EquipmentSearchController equipsearch =new CCC_EquipmentSearchController(casecontroller1); 
          
           Test.setMock(HttpCalloutMock.class,new CCC_HttpResponseGeneratorEquipSearchTest());
           equipsearch.dModelNo_LstName='abc';
           equipsearch.dModelNo_ConfNo='abc';
           equipsearch.dModelNo_Zipcde='123';
           equipsearch.dModelNo_InstAddres='asdf';
           equipsearch.dModelNo_PhNo='6543';
           equipsearch.dModelNo_RegisNo='34567';
          
          
          equipsearch.getEquippmentInfo();
    }
    }//getEquippmentInfoTest()
    
    //call getDiscreteModelNo() which calls getDiscreteModelNumbers(test for web service callouts)
     public static testMethod void getDiscreteModelNoTest()
    {
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
        {
          // call for the constructor   
          ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
          CCC_EquipmentSearchController equipsearch =new CCC_EquipmentSearchController(casecontroller1); 
           Test.setMock(HttpCalloutMock.class,new CCC_HttpResponseGeneratorEquipSearchTest());
           equipsearch.dModelNo_ModelNo='abc';
           equipsearch.dModelNo_SerialNo='abc';
           equipsearch.dModelNo_DiscModelNo='123';
           equipsearch.dModelNo_Brand='Bryant';
   
          equipsearch.getDiscreteModelNo();
        }
    }//getEquippmentInfoTest()
    
    //call for CancelAsset() and Detailpage()
    public static testMethod void CancelAssetTest()
    {
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
        {
          ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
          CCC_EquipmentSearchController equipsearch =new CCC_EquipmentSearchController(casecontroller1);
          equipsearch.CancelAsset();
          
          PageReference pgref1 = Page.CCC_EquipmentSearch;
            pgref1.getParameters().put('id',testCase1.id);
            Test.setCurrentPage(pgref1);
            PageReference result1=equipsearch .Detailpage();
            System.assertNotEquals(null,result1);
            
              
         }
        
      } //CancelAssetTest()
  
    public static testMethod void getTosCodeFromSerialNumberTest()    
    {
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
        {
          // call for the constructor   
          ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
          CCC_EquipmentSearchController equipsearch =new CCC_EquipmentSearchController(casecontroller1); 
          
          Test.setMock(HttpCalloutMock.class,new CCC_HttpResponseGeneratorEquipSearchTest());
            equipsearch.dModelNo_TossCode='2HPA - 13 SEER R22';
            String serialNnumber ='4314X61390';
   			equipsearch.getTosCodeFromSerialNumber(serialNnumber);
        }
    }//getTosCodeFromSerialNumberTest
     
    
    public static testMethod void UpdateTosCodeOnExistingAssetsTest()
       {
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
        {
          // call for the constructor   
          ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
          CCC_EquipmentSearchController equipsearch =new CCC_EquipmentSearchController(casecontroller1); 
          
           toUpdateTosCodeAssets =new list <Asset>();
   
           for (integer i = 0; i < 1; i++){
                    
          testAsset= new Asset();
          testAsset.Name='765435uyrertyjhtrhj';
          testAsset.Brand__c='';
          testAsset.CCC_SerialModelNumber__c='123';
          testAsset.CCC_Disc_Model_Number__c='';
          testAsset.CCC_Model_Number__c='';
          testAsset.SerialNumber='';
          testAsset.CCC_Validation_status__c=true;
          testAsset.Toss_Code__c='2HPA - 13 SEER R22';
          testAsset.AccountId=testAcc.id;
               
          toUpdateTosCodeAssets.add(testAsset);
         }    
         insert toUpdateTosCodeAssets;   
            
         equipsearch.UpdateTosCodeOnExistingAssets(toUpdateTosCodeAssets);
        }
       } //UpdateTosCodeOnExistingAssetsTest
  
    public static testMethod void UpdateBrandOnExistingAssetsTest(){
        //ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
          //CCC_EquipmentSearchController equipsearch =new CCC_EquipmentSearchController(casecontroller1); 
        CCC_EquipmentSearchController.RegistrationDataObj rec = new CCC_EquipmentSearchController.RegistrationDataObj();
        rec.consumer_Name = 'Prabharan';
        rec.consumer_BusinessName = 'Business Name';
        rec.consumer_Address1 ='Test';
        rec.consumer_Address2 ='Test';
        rec.consumer_City ='Test';
        rec.consumer_State ='Test';
        rec.consumer_Country ='Test';
        rec.consumer_Zip ='Test';
        rec.consumer_Email ='Test';
        rec.consumer_Phone1 ='Test';
        rec.consumer_Phone2 ='Test';
        rec.equip_Address1 ='Test';
        rec.equip_Address2 ='Test';
        rec.equip_City ='Test';
        rec.equip_State ='Test';
        rec.equip_Country ='Test';
        rec.equip_Zip ='Test';
        rec.dealerName ='Test';
        rec.dealerPhone ='Test';
        rec.mfgAcctNum ='Test';
        rec.serviceBenchID ='Test';
        rec.hvacpId ='Test';
        rec.model ='Test';
        rec.serial ='Test';
        rec.equip_Description ='Test';
        rec.confirmationNumber ='Test';
        rec.registrationNumber ='Test';
        rec.source ='Test';
        rec.comments ='Test';
        rec.installationDate='Test';
        rec.registrationDate='Test';
        rec.transferDate='Test';
        rec.markAs='Test';
        rec.registrationDataInput='Test'; 
        rec.Id ='Test';
        rec.modelLocation ='Test';
        rec.furnaceOrientation ='Test';
        rec.furnaceFuel ='Test';
        rec.enhancedWarrantyFlag ='Test';
        rec.alwaysReviewFlag ='Test';
        rec.registeredOnTimeFlag ='Test';
        rec.proofOfPurchaseFlag ='Test';
        rec.agreementNumber ='Test';
        rec.tagNumber ='Test';
        rec.selected =false;  
        rec.brand='Test';
        /*for (integer i = 0; i < 1; i++){
                    
          testAsset= new Asset();
          testAsset.Name='765435uyrertyjhtrhj';
          testAsset.Brand__c='';
          testAsset.CCC_SerialModelNumber__c='123';
          testAsset.CCC_Disc_Model_Number__c='';
          testAsset.CCC_Model_Number__c='';
          testAsset.SerialNumber='';
          testAsset.CCC_Validation_status__c=true;
          testAsset.Toss_Code__c='2HPA - 13 SEER R22';
          testAsset.AccountId=testAcc.id;
               
          
         }*/
    }
  
    public static testMethod void selectedAsset()
    {
        
        setupData();
        Test.startTest();
        
        System.runAs(testusr1)
        {
             Case c= new Case();
            c.Subject='test';
            c.Description='testDesc';
            c.Priority='Medium';
            c.New_Comment__c=true;
            c.CCC_Turn_Back_Code__c ='Not Applicable';
            c.CCC_Part_Number__c='56756';
            c.SuppliedEmail='ian.sfdc@gmail.com';           
            insert c;
             Account acc = new Account();
            acc.Name='Test';
            acc.BillingCity='Milwaukee';
            acc.BillingState='WI';
            acc.BillingCountry='United States';
            insert acc;
            list<asset> asset =new  list<asset> ();
            Asset ast = new Asset();
            ast.Name='765435uyrertyjhtrhj';
            ast.Brand__c='CAR';
            ast.CCC_Disc_Model_Number__c='';
            ast.CCC_Model_Number__c='';
            ast.SerialNumber='';
            ast.CCC_Validation_status__c=true;
            ast.AccountId=Acc.id;
            asset.add(ast);
            insert asset;
            junAsset= new CCC_junctionCaseAsset__c();
            junAsset.Asset__c= testAsset.id;
            junAsset.Case__c=testCase1.id;
            insert junAsset;
            ApexPages.StandardController controller = new ApexPages.standardController(c);
          CCC_EquipmentSearchController equipsearch =new CCC_EquipmentSearchController(controller);
          
            c.TOS_Code__c=ast.Toss_Code__c;
            c.CCC_Serial_Number__c=ast.CCC_SerialModelNumber__c;
            c.CCC_Model_Number__c=ast.CCC_Model_Number__c;
            c.Ship_Date__c=ast.Ship_Date__c;
            c.Plant_Name__c=ast.Plant_Name__c;
            update c;
            equipsearch.selectedAsset(ast.Id);
            equipsearch.getSelected();
            equipsearch.getShippedDate();
        }
    }
      
      
    
}//class CCC_EquipmentSearchControllerTest