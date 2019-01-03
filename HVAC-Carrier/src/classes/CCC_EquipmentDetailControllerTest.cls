@isTest
Public class CCC_EquipmentDetailControllerTest
{
//object of the helper class
 public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
 
  public static User testusr1;
  public static Contact testCon1;
  public static Case testCase1;
  public static Account testAcc;
  public static Registration_Correction__c regcorrobj;
  public static CCC_IntegrationEndPoint__c endpoint,endpoint2;
  public static CCC_IntegrationEndPoint__c  CustomSettingEndPoint;
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
          RecordType rt= [select id,Name from RecordType where SobjectType='Case' and Name='Consumer Relations' Limit 1];
          testCase1.recordTypeId=rt.id;
          testCase1=(Case)utilClass.createTestRecord(testCase1);
          
           //create new custom setting;
           endpoint= new CCC_IntegrationEndPoint__c();
           endpoint.Name='PHDB_Auth';
           endpoint.UserName__c='app_salesforce';
           endpoint.Password__c='hy~jpmXm@2s6_@MM';
           endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
           endpoint.URL__c='https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access';   
          insert endpoint;
          
           CustomSettingEndPoint = new CCC_IntegrationEndPoint__c();
            CustomSettingEndPoint.Name='Service Bench';
            CustomSettingEndPoint .UserName__c= 'test';
            CustomSettingEndPoint .Password__c= 'test@123';
            CustomSettingEndPoint.URL__c='https://www.servicebench.com/servicebenchv5/services/ProductEntitlementService';
            insert CustomSettingEndPoint ;
          
           endpoint2= new CCC_IntegrationEndPoint__c();
           endpoint2.Name='PHDB';
           endpoint2.UserName__c='app_salesforce';
           endpoint2.Password__c='hy~jpmXm@2s6_@MM';
           endpoint2.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
           endpoint2.URL__c='http://staging.phdbws.carrier.com/api/'; 
           insert endpoint2;      
    
    }//setupData()
    
     //test for constructor
    public static testMethod void testConstructor()
    {
    setupData();
    Test.startTest();
        
        System.runAs(testusr1)
        {
        //call to constructor
        ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
        CCC_EquipmentDetailController equipdetail = new CCC_EquipmentDetailController(casecontroller1); 
        Test.setMock(HttpCalloutMock.class,new CCC_HttpRespGeneratorEquipDetailTest());
        
        //for coverage of Controller variables 
        equipdetail.dModelNo_ModelNo=''; 
        equipdetail.dModelNo_SerialNo=''; 
              
        }
        
     Test.stopTest();
        
        }//testConstructor()
        
 
        
       public static testMethod void testRegistrationDataObj() {
    setupData();
    Test.startTest();
        
        System.runAs(testusr1)
        {
          CCC_EquipmentDetailController.RegistrationDataObj regobj= new CCC_EquipmentDetailController.RegistrationDataObj();
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
          
          list<CCC_EquipmentDetailController.RegistrationDataObj> regobjlist =new list<CCC_EquipmentDetailController.RegistrationDataObj>();    
            regobjlist.add(regobj);          
        }
        Test.stopTest();
    }  
       //test for testServiceHistoryWebService
   public static testMethod void testServiceHistoryWebService()
    {
    setupData();
    Test.startTest();
        
        System.runAs(testusr1)
        {
        //call to constructor
        ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
        CCC_EquipmentDetailController equipdetail = new CCC_EquipmentDetailController(casecontroller1); 
         SBEntitlementProductService  obj_wsdlClass = new SBEntitlementProductService ();
         SBEntitlementProductService.ProductEntitlementServicePort port = New SBEntitlementProductService.ProductEntitlementServicePort();

         equipdetail.strModelNumber='123';
         equipdetail.strSerialNumber='abc';        
         equipdetail.ServiceHistoryWebService();
         equipdetail.EntitlementDetail();
         
         Test.setMock(HttpCalloutMock.class,new CCC_HttpRespGeneratorEquipDetailTest());
        
        }
        
     Test.stopTest();
        
        }//testServiceHistoryWebService() 
        
        
              //test for testServiceHistoryWebService
   public static testMethod void testGetRegisteredEquipments()
    {
    setupData();
    Test.startTest();
        
        System.runAs(testusr1)
        {
        //call to constructor
        ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
        CCC_EquipmentDetailController equipdetail = new CCC_EquipmentDetailController(casecontroller1); 
         SBEntitlementProductService  obj_wsdlClass = new SBEntitlementProductService ();
         SBEntitlementProductService.ProductEntitlementServicePort port = New SBEntitlementProductService.ProductEntitlementServicePort();
          String JSONContent = '{"RegistrationDataList":[' +
        '{"RegistrationDataObj":[' +
            '{"Id":1.0,"agreementNumber":5.0,"alwaysReviewFlag":"Pencil" ,"UnitPrice":0.5,"Quantity":1.0,"ProductName":"Eraser"}],' +
                '"id":"1111"}' ;

        JSONParser parser = 
           JSON.createParser(JSONContent);
        // Make calls to nextToken() 
        // to point to the second
        // start object marker.
        parser.nextToken();
        parser.nextToken();
        parser.nextToken();
      
            PageReference PageRef = Page.CCC_EquipmentDetail;
            Test.setCurrentPage(PageRef);
          ApexPages.currentPage().getParameters().put('sn', '0211V00027');
          ApexPages.currentPage().getParameters().put('mn', 'BW9AAN000175');
         equipdetail.init();
         
         Test.setMock(HttpCalloutMock.class,new CCC_HttpRespGeneratorEquipDetailTest());
        
        }
        
     Test.stopTest();
        
        }//testServiceHistoryWebService() 
        
     static testMethod void getFormatDateTest()
                {
                test.StartTest();
                CCC_EquipmentDetailController.FormatDate('11111111111');
                test.StopTest();
                
                }
           
           static testMethod void getFormatDate1Test()
                {
                test.StartTest();
                CCC_EquipmentDetailController.FormatDate('111');
                test.StopTest();
                
                }     
    public static testMethod void TestRegistrationDataList(){
     
         String JSONContent = '{"RegistrationDataList":[' +
        '{"RegistrationDataObj":[' +
            '{"Id":1.0,"agreementNumber":5.0,"alwaysReviewFlag":"Pencil" ,"UnitPrice":0.5,"Quantity":1.0,"ProductName":"Eraser"}],' +
                '"id":"1111"}' ;

        JSONParser parser = 
           JSON.createParser(JSONContent);
        // Make calls to nextToken() 
        // to point to the second
        // start object marker.
        parser.nextToken();
        parser.nextToken();
        parser.nextToken();
        // Retrieve the RegistrationDataList object
        // from the JSON string.
      }     
      //this method does coverage of all wrapper classes
      public static testMethod void wrapperResponseClaimTest()
      {
           setupData();
        Test.startTest();
        {
          //call to constructor
            ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
        CCC_EquipmentDetailController equipdetail = new CCC_EquipmentDetailController(casecontroller1);  
        
        //insert value of parameters required in method
        //inserting value in lstService
        String strDataKey='123xyz';
        String strDataDiscription='abcd efgh';
        CCC_EquipmentDetailController.service serv= new CCC_EquipmentDetailController.service(strDataKey,strDataDiscription); 
        
        list<CCC_EquipmentDetailController.service> lstService= new list<CCC_EquipmentDetailController.service>(); 
        lstService.add(serv);
        
        //inserting value in lstPart
         String strPartNumber='asdf1234';
         String strPartName='test part';
         String strPartQuantity='good';
         CCC_EquipmentDetailController.partsDetail part= new CCC_EquipmentDetailController.partsDetail(strPartNumber,strPartName,strPartQuantity); 
         list<CCC_EquipmentDetailController.partsDetail> lstPart= new list<CCC_EquipmentDetailController.partsDetail>(); 
          lstPart.add(part);
       
        String strClaimNumber='876543';
        String strServiceDate='11-12-2015';
        String strCustomerComplaint='abc123';
        String strServiceExplanation='Explain';
        
        // call for constructor of wrapperResponseClaim 
        CCC_EquipmentDetailController.wrapperResponseClaim respclaim= new CCC_EquipmentDetailController.wrapperResponseClaim(strClaimNumber,strServiceDate,strCustomerComplaint,strServiceExplanation,lstService,lstPart);
        
       
       //coverage of wrapperResponse class
      String extDataKey='abc123';
      String extDataDescription='data description';
      String BRAND = 'BRAND';
      String APPLICATIONTYPE= 'APPLICATIONTYPE';
      String ORIGINALEQUIPMENTOWNER= 'ORIGINALEQUIPMENTOWNER';
      String COMPONENTCODE = 'COMPONENTCODE';
      String WARRANTYLENGTH= 'WARRANTYLENGTH';
      String INSTALLEDAFTER= 'INSTALLEDAFTER';
      String WARRANTYSTART= 'WARRANTYSTART';
      String WARRANTYSTOP= 'WARRANTYSTOP';
      
      CCC_EquipmentDetailController.serviceEntitlement servEnt= new CCC_EquipmentDetailController.serviceEntitlement(extDataKey,extDataDescription);
      list<CCC_EquipmentDetailController.serviceEntitlement> lstservEnt= new list<CCC_EquipmentDetailController.serviceEntitlement>(); 
          lstservEnt.add(servEnt);
       CCC_EquipmentDetailController.warrantyInfoTable servWarr2= new CCC_EquipmentDetailController.warrantyInfoTable(BRAND,APPLICATIONTYPE,ORIGINALEQUIPMENTOWNER,COMPONENTCODE,WARRANTYLENGTH,INSTALLEDAFTER,WARRANTYSTART,WARRANTYSTOP);
       list<CCC_EquipmentDetailController.warrantyInfoTable> lstservWarr2= new list<CCC_EquipmentDetailController.warrantyInfoTable>(); 
          lstservWarr2.add(servWarr2);

      
      CCC_EquipmentDetailController.wrapperResponse wrapres = new CCC_EquipmentDetailController.wrapperResponse(lstservEnt);
       CCC_EquipmentDetailController.wrapperResponseWarrantyInfo wrapresWarrnty = new CCC_EquipmentDetailController.wrapperResponseWarrantyInfo(lstservWarr2);
      
        
    }
  Test.stopTest();
  
  }
  
}//class CCC_EquipmentDetailControllerTest