@isTest
Public class AddfindEquipment_test
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
           testAcc.BillingStreet = '555 columbus avenue';
           testAcc.BillingCity = 'Syracuse';
           testAcc.BillingState = 'NY';
           testAcc.BillingCountry = 'US';
                   
           insert testAcc;
    
         // create the new contact
           testCon1=(Contact)utilClass.setUpData(new Contact());
           testCon1.FirstName='Suchita';
           testCon1.LastName='Tewari';
           testCon1.AccountId=testAcc.id;
           testCon1.MailingStreet = '555 columbus avenue';
           testCon1.MailingCity = 'Syracuse';
           testCon1.MailingState = 'NY';
           testCon1.MailingCountry = 'US';
           testCon1.MailingPostalCode = '13057';
           testCon1=(Contact)utilClass.createTestRecord(testCon1);
           
     
               
            Profile testprof1=[SELECT Id FROM Profile WHERE Name='CCC Base Profile' limit 1];
      
        // create new user with Partner Community Warranty Admin profile
           testusr1=new User( email='testdealer.user.211120172@gmail.com',
            profileid = testprof1.id,  
            UserName='test11.user.211120172@gmail.com', 
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
          testAsset.CCC_SerialModelNumber__c = '1750PSV009RPT3--30';
          testAsset.CCC_Validation_status__c=true;
          testAsset.AccountId=testAcc.id;
      //  testAsset.ContactId=testCon1.id;
          insert testAsset;
          
          //create new CCC_junctionCaseAsset__c
          junAsset= new CCC_junctionCaseAsset__c();
          junAsset.Asset__c= testAsset.id;
          junAsset.Case__c=testCase1.id;
          insert junAsset;
         
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
                       
    }//setupData()
    
    //test constructor which calls get
    
    //testdelRecord() and getDiscreteModelNo()
    public static testMethod void testConstructor()
    {
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
        {
          // call for the constructor   
          //ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
          
         
         //test getDiscreteModelNo method
           
          Date dt = AddFindEquipment_Controller.getShippedDate();
          //code coverage for the wrapper classes DiscreteModelNumbersWrapper and FindRegisteredWrapper 
          AddFindEquipment_Controller.DiscreteModelNumbersWrapper modelwrap = new AddFindEquipment_Controller.DiscreteModelNumbersWrapper();
          AddFindEquipment_Controller.FindRegisteredWrapper findregwrap = new AddFindEquipment_Controller.FindRegisteredWrapper();
          AddFindEquipment_Controller.AllAsset allAssetWrp = new AddFindEquipment_Controller.AllAsset(testAsset,'',junAsset.Id);
          
          
          allAssetWrp.objAsset=testAsset;
          allAssetWrp.strURL='';
          allAssetWrp.junctionAssetId=junAsset.Id;
          
          //test delRecord method
          //List<AddFindEquipment_Controller.AllAsset> lstWrp = AddFindEquipment_Controller.delRecord(testAsset,testCase1.Id);
          List<AddFindEquipment_Controller.AllAsset> lstWrpN = AddFindEquipment_Controller.getAllAssets(testCase1.Id);
          
          List<AddFindEquipment_Controller.AllAsset> lstWrpDel = AddFindEquipment_Controller.delRecord(testAsset.Id,testCase1.Id);
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
           Access_Token__c at = new Access_Token__c();
           at.Name = 'PHDB Smart Search';
           at.PHDB_Access_Token__c = '5bb2dafa-f9e0-4a27-8471-5c2c5e1bc4fc';
           insert at;
           Test.setMock(HttpCalloutMock.class,new CCC_HttpResponseGeneratorEquipSearchTest());  
           try{
             List<AddFindEquipment_Controller.DiscreteModelNumbersWrapper> ls = AddFindEquipment_Controller.getDiscreteModelNumbers(testCase1.Id,null,'17',null,null);
           }
           catch(Exception e) 
           {

           }
          
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
           Test.setMock(HttpCalloutMock.class,new CCC_HttpResponseGeneratorEquipSearchTest());
            //ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
            //AddFindEquipment_Controller equipsearch2 =new AddFindEquipment_Controller();
           
           //insert data in lstDisNum 
            AddFindEquipment_Controller.DiscreteModelNumbersWrapper modelwrap = new AddFindEquipment_Controller.DiscreteModelNumbersWrapper();
            modelwrap.Serial='123';
            modelwrap.Model='123';
            modelwrap.selected=true;
            modelwrap.discreetNo='123';   
            
            list<AddFindEquipment_Controller.DiscreteModelNumbersWrapper> modelwraplist= new list<AddFindEquipment_Controller.DiscreteModelNumbersWrapper>();
            modelwraplist.add(modelwrap);
            //equipsearch2.lstDisNum=modelwraplist;
            modelwrap.suggestedResults=modelwraplist;
              
          // PageReference result1=equipsearch2.CreateAsset();
          // System.assertEquals(null,result1);
           
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
         
         String st ='[{"dataQualityIndicator":0,"derivedMfgDate":"2008-05-24T00:00:00","discreetNo":"","mfgDate":"2008-05-24T00:00:00","mfgWeek":0,"mfgYear":0,"model":"50PSV009RPT3--30","productHierarchy":"ANCILWSHP","serial":"17","shippedDate":"2008-08-22T00:00:00","shipTo":"0000999999","suGuid":"9a9191b9-0270-4af4-94b9-c4a5a265a3e5","toscode":"1292 - WSHP 50P SERIES"},{"dataQualityIndicator":0,"derivedMfgDate":"2010-03-16T00:00:00","discreetNo":"","mfgDate":"2010-03-16T00:00:00","mfgWeek":0,"mfgYear":0,"model":"36CBX-AZ-18-3-1","productHierarchy":"ANCILAIRTM","serial":"17","shippedDate":"2010-06-14T00:00:00","shipTo":"0000999999","suGuid":"432c03a1-9f34-4d25-8b6c-4592107da658","toscode":"1661 - Chilled Beam Tr unit"}]';
         AddFindEquipment_Controller.CreateAsset(testCase1.id,modelwraplist,st);
           
          
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
           
            //ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
           // AddFindEquipment_Controller equipsearch3 =new AddFindEquipment_Controller();
           
           //insert data in lstRegEq
            AddFindEquipment_Controller.FindRegisteredWrapper findregwrap = new AddFindEquipment_Controller.FindRegisteredWrapper();
            findregwrap.Serial='123';
            findregwrap.Model='123';
            findregwrap.selected=true;
            
            list<AddFindEquipment_Controller.FindRegisteredWrapper>regwraplist= new list<AddFindEquipment_Controller.FindRegisteredWrapper>();
            regwraplist.add(findregwrap);
            AddFindEquipment_Controller.lstRegEq=regwraplist;
             
            //String st2 = '[{"agreementNumber":"","alwaysReviewFlag":"False","comments":"Dealer Name:,Dealer Phone:,Dealer Email:,Brand Installed: Airquest,Brand Replaced:~ConsumerEmail:ordering@stratford.com","confirmationNumber":"Z001369319411","consumer_Address1":"436 Glenwood Road","consumer_Address2":"","consumer_BusinessName":"Legacy Bay Townhomes","consumer_City":"Binghamton","consumer_Country":"US","consumer_Name":"Legacy Bay Townhomes,Leasing Office","consumer_Phone1":"6077292432","consumer_Phone2":"","consumer_State":"NY","consumer_Zip":"13","dealerName":",Dealer Phone:,Dealer Email:,Brand Installed: Airquest,Brand Replaced:","dealerPhone":"Dealer Name:,,Dealer Email:,Brand Installed: Airquest,Brand Replaced:","enhancedWarrantyFlag":"True","equip_Address1":"436 Glenwood Road","equip_Address2":"","equip_City":"Binghamton","equip_Country":"US","equip_Description":"\"COIL-N VERT 2T R4 14.2\"\"\"","equip_State":"NY","equip_Zip":"13","furnaceFuel":"","furnaceOrientation":"","hvacpId":"","installationDate":"09/04/2014","markAs":"","mfgAcctNum":"","model":"END4X24L14A","modelLocation":"","proofOfPurchaseFlag":"False","registeredOnTimeFlag":"True","registrationDate":"09/11/2014 12:00:00","registrationNumber":"R222393819","serial":"X142258557","serviceBenchID":"","source":"W","tagNumber":"","transferDate":""}]'; 
            //String st3 = '[{"agreementNumber":"","alwaysReviewFlag":"False","comments":"Dealer Name:,Dealer Phone:,Dealer Email:,Brand Installed: Airquest,Brand Replaced:~ConsumerEmail:ordering@stratford.com","confirmationNumber":"Z001369319411","consumer_Address1":"436 Glenwood Road","consumer_Address2":"","consumer_BusinessName":"Legacy Bay Townhomes","consumer_City":"Binghamton","consumer_Country":"US","consumer_Name":"Legacy Bay Townhomes,Leasing Office","consumer_Phone1":"6077292432","consumer_Phone2":"","consumer_State":"NY","consumer_Zip":"13","dealerName":",Dealer Phone:,Dealer Email:,Brand Installed: Airquest,Brand Replaced:","dealerPhone":"Dealer Name:,,Dealer Email:,Brand Installed: Airquest,Brand Replaced:","enhancedWarrantyFlag":"True","equip_Address1":"436 Glenwood Road","equip_Address2":"","equip_City":"Binghamton","equip_Country":"US","equip_Description":"13 SEER AC  (Built 2014 or prior)","equip_State":"NY","equip_Zip":"13","furnaceFuel":"","furnaceOrientation":"","hvacpId":"","installationDate":"09/04/2014","markAs":"","mfgAcctNum":"","model":"N4A318GKC","modelLocation":"","proofOfPurchaseFlag":"False","registeredOnTimeFlag":"True","registrationDate":"09/11/2014 12:00:00","registrationNumber":"R222393818","serial":"E141923523","serviceBenchID":"","source":"W","tagNumber":"","transferDate":""},{"agreementNumber":"","alwaysReviewFlag":"False","comments":"Dealer Name:,Dealer Phone:,Dealer Email:,Brand Installed: Airquest,Brand Replaced:~ConsumerEmail:ordering@stratford.com","confirmationNumber":"Z001369319411","consumer_Address1":"436 Glenwood Road","consumer_Address2":"","consumer_BusinessName":"Legacy Bay Townhomes","consumer_City":"Binghamton","consumer_Country":"US","consumer_Name":"Legacy Bay Townhomes,Leasing Office","consumer_Phone1":"6077292432","consumer_Phone2":"","consumer_State":"NY","consumer_Zip":"13","dealerName":",Dealer Phone:,Dealer Email:,Brand Installed: Airquest,Brand Replaced:","dealerPhone":"Dealer Name:,,Dealer Email:,Brand Installed: Airquest,Brand Replaced:","enhancedWarrantyFlag":"True","equip_Address1":"436 Glenwood Road","equip_Address2":"","equip_City":"Binghamton","equip_Country":"US","equip_Description":"\"COIL-N VERT 2T R4 14.2\"\"\"","equip_State":"NY","equip_Zip":"13","furnaceFuel":"","furnaceOrientation":"","hvacpId":"","installationDate":"09/04/2014","markAs":"","mfgAcctNum":"","model":"END4X24L14A","modelLocation":"","proofOfPurchaseFlag":"False","registeredOnTimeFlag":"True","registrationDate":"09/11/2014 12:00:00","registrationNumber":"R222393819","serial":"X142258557","serviceBenchID":"","source":"W","tagNumber":"","transferDate":""}]';
            
            String body ='';
            /* body='{"$id":"1","dataQualityIndicator":0,"derivedMfgDate":null,"mfgDate":null,"mfgWeek":0,"mfgYear":0,"model":"","msg":null,"serial":"","serialVerified":false,';
   body+='"shippedDate":null,"suggestedResults":[{"$id":"2","dataQualityIndicator":0,"derivedMfgDate":"2013-08-27T00:00:00","discreetNo":null,"mfgDate":null,"mfgWeek":0,';  
   body+='"mfgYear":0,"model":"PGS336090KGP0C    ","suGuid":"202fcfd4-c7c8-4262-8051-37f735a695d4","serial":"C133521015        ","shippedDate":"2013-09-30T00:00:00","shipTo"';
   body+=':"406126    "}]}';*/
   //body = '{"$id":"1","registrationDataResults":[{"$id":"2","consumer_Name":"UNKNOWN,UNKNOWN","consumer_BusinessName":"","consumer_Address1":"6304 THOMPSON RD","consumer_Address2":"","consumer_City":"E.SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"8669892524","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 THOMPSON RD","equip_Address2":"","equip_City":"E.SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"SOUTHERN REFRIGERATION CORP","dealerPhone":"+15403423493","mfgAcctNum":"571098","serviceBenchID":"565779239","hvacpId":"571098","model":"FXM4X3600AL","serial":"A141882870","equip_Description":"FANCOIL-ECM TXV 3.0T R410A AL","confirmationNumber":"","registrationNumber":"R217542661","source":"W","comments":"Dealer Name: GEORGE HALL                                        Dealer Phone: 3018844111           Dealer Email:                                                    Comments:                                                    Brand Replaced:                           Brand Installed: HEIL~ConsumerEmail:","installationDate":"06/04/2014","registrationDate":"06/04/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"FXM4X","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"ICP","consumer_MarketingOptIn":"N","equip_FirstName":"UNKNOWN","equip_LastName":"UNKNOWN","equip_BusinessName":"","equip_Email":"","registeredBy":"S","installingDealer":"571098","servicingDealer":"","distributor":"571098","modelUsage":"","application":"R","installationType":"A","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"SOUTHERN REFRIGERATION CORP","internalComments":"DLR REGISTERED WRONG SN. CHANGED HOMEOWNER INFO FROM \" MARK & ANNA JONES, 26300 MEADOW WOOD DRIVE, MECHANICSVILLE MD 20659, 301-884-8781, 06/03/2014, 1406002319E\" TO \" UNKNOWN\" PER INTERNAL REQUEST FROM MAX LYSIUS---1-667UKK"},{"$id":"3","consumer_Name":"UNKOWN,UNKOWN","consumer_BusinessName":"","consumer_Address1":"6304 THOMPSON RD","consumer_Address2":"","consumer_City":"E SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"8669892524","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 THOMPSON RD","equip_Address2":"","equip_City":"E SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"North East Distribution, Pittsburgh Dwntwn","dealerPhone":"4124711419","mfgAcctNum":"10014","serviceBenchID":"","hvacpId":"9005799","model":"CNPVP3621ALA","serial":"4112X32486","equip_Description":"CASED VERT N-ALUM","confirmationNumber":"","registrationNumber":"R195888646","source":"W","comments":"","installationDate":"10/03/2014","registrationDate":"10/03/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"CNPVP","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"BRY","consumer_MarketingOptIn":"N","equip_FirstName":"UNKOWN","equip_LastName":"UNKOWN","equip_BusinessName":"","equip_Email":"","registeredBy":"H","installingDealer":"10014","servicingDealer":"","distributor":"10014","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"North East Distribution, West Caldwell, LE","internalComments":"1-67U9ED"},{"$id":"4","consumer_Name":"GERARD,CARGES","consumer_BusinessName":"","consumer_Address1":"7312 SNOWBALL RUN","consumer_Address2":"","consumer_City":"EAST SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"3154392749","consumer_Phone2":"3154741177","consumer_Email":"dawnchard@yahoo.com","equip_Address1":"7312 SNOWBALL RUN","equip_Address2":"","equip_City":"EAST SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"Spencer Heating & Air Conditioning Inc","dealerPhone":"315-474-1177","mfgAcctNum":"207274-10014","serviceBenchID":"494175297","hvacpId":"110549","model":"987MA42080V17","serial":"4712A46605","equip_Description":"G/F,4-WAY 97 AFUE MOD VS EVOL Z","confirmationNumber":"1303018065b","registrationNumber":"R195889418","source":"W","comments":"~ConsumerEmail:dawnchard@yahoo.com","installationDate":"03/07/2013","registrationDate":"03/19/2013 12:00:00","transferDate":"","markAs":"","modelLocation":"BS","furnaceOrientation":"UP","furnaceFuel":"N","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"987M","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"BRY","consumer_MarketingOptIn":"Y","equip_FirstName":"GERARD","equip_LastName":"CARGES","equip_BusinessName":"","equip_Email":"dawnchard@yahoo.com","registeredBy":"H","installingDealer":"207274-10014","servicingDealer":"","distributor":"10014","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"North East Distribution, West Caldwell, LE","internalComments":""},{"$id":"5","consumer_Name":"GERARD,CARGES","consumer_BusinessName":"","consumer_Address1":"7312 SNOWBALL RUN","consumer_Address2":"","consumer_City":"EAST SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"3154392749","consumer_Phone2":"3154741177","consumer_Email":"dawnchard@yahoo.com","equip_Address1":"7312 SNOWBALL RUN","equip_Address2":"","equip_City":"EAST SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"","dealerPhone":"","mfgAcctNum":"","serviceBenchID":"","hvacpId":"","model":"SYSTXBBUIZ01-D","serial":"4712W002752","equip_Description":"OBS USE SYSTXBBECN01-A FOR WARRANTY","confirmationNumber":"1303018065b","registrationNumber":"R195889514","source":"W","comments":"~ConsumerEmail:dawnchard@yahoo.com","installationDate":"03/07/2013","registrationDate":"03/19/2013 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"SYST","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"","brand":"BRY","consumer_MarketingOptIn":"Y","equip_FirstName":"GERARD","equip_LastName":"CARGES","equip_BusinessName":"","equip_Email":"dawnchard@yahoo.com","registeredBy":"H","installingDealer":"","servicingDealer":"","distributor":"","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"","internalComments":""},{"$id":"6","consumer_Name":"GERARD,CARGES","consumer_BusinessName":"","consumer_Address1":"7312 SNOWBALL RUN","consumer_Address2":"","consumer_City":"EAST SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"3154392749","consumer_Phone2":"3154741177","consumer_Email":"dawnchard@yahoo.com","equip_Address1":"7312 SNOWBALL RUN","equip_Address2":"","equip_City":"EAST SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"","dealerPhone":"","mfgAcctNum":"","serviceBenchID":"","hvacpId":"","model":"SYSTXBB4ZC01","serial":"0713N175555","equip_Description":"1-PK/BRY EVOLUTION DAMPER CONTROL","confirmationNumber":"1303018065b","registrationNumber":"R195889515","source":"W","comments":"~ConsumerEmail:dawnchard@yahoo.com","installationDate":"03/07/2013","registrationDate":"03/19/2013 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"SYST","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"","brand":"BRY","consumer_MarketingOptIn":"Y","equip_FirstName":"GERARD","equip_LastName":"CARGES","equip_BusinessName":"","equip_Email":"dawnchard@yahoo.com","registeredBy":"H","installingDealer":"","servicingDealer":"","distributor":"","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"","internalComments":""},{"$id":"7","consumer_Name":"Unknown,Unknown","consumer_BusinessName":"","consumer_Address1":"6304 Thompson Rd.","consumer_Address2":"","consumer_City":"East Syracuse","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 Thompson Rd.","equip_Address2":"","equip_City":"East Syracuse","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"FLORIDA COOLING SUPPLY #272","dealerPhone":"+19413665804","mfgAcctNum":"110992","serviceBenchID":"565791582","hvacpId":"110992","model":"FXM4X3000AT","serial":"A143273701","equip_Description":"FANCOIL-ECM MULTI 2.5T R4 TIN","confirmationNumber":"","registrationNumber":"R222169171","source":"W","comments":"Dealer Name:Airrific ,Dealer Phone:9413713355,Dealer Email:,Brand Installed: Comfortmaker,Brand Replaced:~ConsumerEmail:","installationDate":"09/05/2014","registrationDate":"09/07/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"FXM4X","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"ICP","consumer_MarketingOptIn":"N","equip_FirstName":"Unknown","equip_LastName":"Unknown","equip_BusinessName":"","equip_Email":"","registeredBy":"S","installingDealer":"110992","servicingDealer":"","distributor":"110992","modelUsage":"","application":"R","installationType":"A","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"FLORIDA COOLING SUPPLY #272","internalComments":"1-695ZOQ"},{"$id":"8","consumer_Name":"UNKOWN,UNKOWN","consumer_BusinessName":"","consumer_Address1":"6304 THOMPSON RD","consumer_Address2":"","consumer_City":"E SYRACSUE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"8669892524","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 THOMPSON RD","equip_Address2":"","equip_City":"E SYRACSUE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"Mid-Atlantic Totaline, Beltsville","dealerPhone":"3014701703","mfgAcctNum":"11036","serviceBenchID":"","hvacpId":"1934","model":"213CNA030000","serial":"3414E24122","equip_Description":"13S,LEGACY, HP PURON DENSE GRILLE 2.5 T","confirmationNumber":"","registrationNumber":"R225219066","source":"W","comments":"","installationDate":"11/17/2014","registrationDate":"11/17/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"213C","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"CAR","consumer_MarketingOptIn":"N","equip_FirstName":"UNKOWN","equip_LastName":"UNKOWN","equip_BusinessName":"","equip_Email":"","registeredBy":"S","installingDealer":"11036","servicingDealer":"","distributor":"11036","modelUsage":"","application":"R","installationType":"A","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"Mid-Atlantic Distribution, Richmond, LE","internalComments":"1-6CD2E8"},{"$id":"9","consumer_Name":"UNKNOWN,UNKNOWN","consumer_BusinessName":"","consumer_Address1":"6304 THOMPSON  RD","consumer_Address2":"","consumer_City":"E. SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"8669892524","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 THOMPSON  RD","equip_Address2":"","equip_City":"E. SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"Refrigeration Sales Corporation, Valley View, HQ","dealerPhone":"216-525-8100","mfgAcctNum":"31196","serviceBenchID":"493878798","hvacpId":"2202","model":"GAPAAXBB1625-A08","serial":"0911V00187","equip_Description":"PERFECT AIR PURIFIER 8-PER SKID 16\"X25\"","confirmationNumber":"","registrationNumber":"R166251171","source":"W","comments":"","installationDate":"09/29/2014","registrationDate":"09/29/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"GAPAA","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"CAR","consumer_MarketingOptIn":"N","equip_FirstName":"UNKNOWN","equip_LastName":"UNKNOWN","equip_BusinessName":"","equip_Email":"","registeredBy":"H","installingDealer":"31196","servicingDealer":"","distributor":"31196","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"Refrigeration Sales Corporation, Valley View, HQ","internalComments":"1-697KB2"},{"$id":"10","consumer_Name":"UNKNOWN,UNKNOWN","consumer_BusinessName":"","consumer_Address1":"6304 THOMPSON  RD","consumer_Address2":"","consumer_City":"E. SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"8669892524","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 THOMPSON  RD","equip_Address2":"","equip_City":"E. SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"Refrigeration Sales Corporation, Valley View, HQ","dealerPhone":"216-525-8100","mfgAcctNum":"31196","serviceBenchID":"493878798","hvacpId":"2202","model":"GAPAAXBB1625-A08","serial":"0911V00187","equip_Description":"PERFECT AIR PURIFIER 8-PER SKID 16\"X25\"","confirmationNumber":"","registrationNumber":"R166251171","source":"W","comments":"","installationDate":"09/29/2014","registrationDate":"09/29/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"GAPAA","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"CAR","consumer_MarketingOptIn":"N","equip_FirstName":"UNKNOWN","equip_LastName":"UNKNOWN","equip_BusinessName":"","equip_Email":"","registeredBy":"H","installingDealer":"31196","servicingDealer":"","distributor":"31196","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"Refrigeration Sales Corporation, Valley View, HQ","internalComments":"1-697KB2"},{"$id":"11","consumer_Name":"Unknown,Unknown","consumer_BusinessName":"","consumer_Address1":"6304 Thompson Road","consumer_Address2":"","consumer_City":"East Syracuse","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 Thompson Road","equip_Address2":"","equip_City":"East Syracuse","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"North East Distribution, Pittsburgh Dwntwn","dealerPhone":"4124711419","mfgAcctNum":"10014","serviceBenchID":"","hvacpId":"9005799","model":"925SA42060E17","serial":"3114A51177","equip_Description":"G/F,4-WAY 95 AFUE 1S/ECM","confirmationNumber":"","registrationNumber":"R222182310","source":"W","comments":"","installationDate":"08/28/2014","registrationDate":"09/04/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"925S","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"BRY","consumer_MarketingOptIn":"N","equip_FirstName":"Unknown","equip_LastName":"Unknown","equip_BusinessName":"","equip_Email":"","registeredBy":"H","installingDealer":"10014","servicingDealer":"","distributor":"10014","modelUsage":"","application":"R","installationType":"A","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"North East Distribution, West Caldwell, LE","internalComments":"1-68HLIW"}]}';
   // body = '[{"$id":"2","consumer_Name":"UNKNOWN,UNKNOWN","consumer_BusinessName":"","consumer_Address1":"6304 THOMPSON RD","consumer_Address2":"","consumer_City":"E.SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"8669892524","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 THOMPSON RD","equip_Address2":"","equip_City":"E.SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"SOUTHERN REFRIGERATION CORP","dealerPhone":"+15403423493","mfgAcctNum":"571098","serviceBenchID":"565779239","hvacpId":"571098","model":"FXM4X3600AL","serial":"A141882870","equip_Description":"FANCOIL-ECM TXV 3.0T R410A AL","confirmationNumber":"","registrationNumber":"R217542661","source":"W","comments":"Dealer Name: GEORGE HALL                                        Dealer Phone: 3018844111           Dealer Email:                                                    Comments:                                                    Brand Replaced:                           Brand Installed: HEIL~ConsumerEmail:","installationDate":"06/04/2014","registrationDate":"06/04/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"FXM4X","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"ICP","consumer_MarketingOptIn":"N","equip_FirstName":"UNKNOWN","equip_LastName":"UNKNOWN","equip_BusinessName":"","equip_Email":"","registeredBy":"S","installingDealer":"571098","servicingDealer":"","distributor":"571098","modelUsage":"","application":"R","installationType":"A","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"SOUTHERN REFRIGERATION CORP","internalComments":"DLR REGISTERED WRONG SN. CHANGED HOMEOWNER INFO FROM \" MARK & ANNA JONES, 26300 MEADOW WOOD DRIVE, MECHANICSVILLE MD 20659, 301-884-8781, 06/03/2014, 1406002319E\" TO \" UNKNOWN\" PER INTERNAL REQUEST FROM MAX LYSIUS---1-667UKK"},{"$id":"3","consumer_Name":"UNKOWN,UNKOWN","consumer_BusinessName":"","consumer_Address1":"6304 THOMPSON RD","consumer_Address2":"","consumer_City":"E SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"8669892524","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 THOMPSON RD","equip_Address2":"","equip_City":"E SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"North East Distribution, Pittsburgh Dwntwn","dealerPhone":"4124711419","mfgAcctNum":"10014","serviceBenchID":"","hvacpId":"9005799","model":"CNPVP3621ALA","serial":"4112X32486","equip_Description":"CASED VERT N-ALUM","confirmationNumber":"","registrationNumber":"R195888646","source":"W","comments":"","installationDate":"10/03/2014","registrationDate":"10/03/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"CNPVP","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"BRY","consumer_MarketingOptIn":"N","equip_FirstName":"UNKOWN","equip_LastName":"UNKOWN","equip_BusinessName":"","equip_Email":"","registeredBy":"H","installingDealer":"10014","servicingDealer":"","distributor":"10014","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"North East Distribution, West Caldwell, LE","internalComments":"1-67U9ED"},{"$id":"4","consumer_Name":"GERARD,CARGES","consumer_BusinessName":"","consumer_Address1":"7312 SNOWBALL RUN","consumer_Address2":"","consumer_City":"EAST SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"3154392749","consumer_Phone2":"3154741177","consumer_Email":"dawnchard@yahoo.com","equip_Address1":"7312 SNOWBALL RUN","equip_Address2":"","equip_City":"EAST SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"Spencer Heating & Air Conditioning Inc","dealerPhone":"315-474-1177","mfgAcctNum":"207274-10014","serviceBenchID":"494175297","hvacpId":"110549","model":"987MA42080V17","serial":"4712A46605","equip_Description":"G/F,4-WAY 97 AFUE MOD VS EVOL Z","confirmationNumber":"1303018065b","registrationNumber":"R195889418","source":"W","comments":"~ConsumerEmail:dawnchard@yahoo.com","installationDate":"03/07/2013","registrationDate":"03/19/2013 12:00:00","transferDate":"","markAs":"","modelLocation":"BS","furnaceOrientation":"UP","furnaceFuel":"N","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"987M","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"BRY","consumer_MarketingOptIn":"Y","equip_FirstName":"GERARD","equip_LastName":"CARGES","equip_BusinessName":"","equip_Email":"dawnchard@yahoo.com","registeredBy":"H","installingDealer":"207274-10014","servicingDealer":"","distributor":"10014","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"North East Distribution, West Caldwell, LE","internalComments":""},{"$id":"5","consumer_Name":"GERARD,CARGES","consumer_BusinessName":"","consumer_Address1":"7312 SNOWBALL RUN","consumer_Address2":"","consumer_City":"EAST SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"3154392749","consumer_Phone2":"3154741177","consumer_Email":"dawnchard@yahoo.com","equip_Address1":"7312 SNOWBALL RUN","equip_Address2":"","equip_City":"EAST SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"","dealerPhone":"","mfgAcctNum":"","serviceBenchID":"","hvacpId":"","model":"SYSTXBBUIZ01-D","serial":"4712W002752","equip_Description":"OBS USE SYSTXBBECN01-A FOR WARRANTY","confirmationNumber":"1303018065b","registrationNumber":"R195889514","source":"W","comments":"~ConsumerEmail:dawnchard@yahoo.com","installationDate":"03/07/2013","registrationDate":"03/19/2013 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"SYST","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"","brand":"BRY","consumer_MarketingOptIn":"Y","equip_FirstName":"GERARD","equip_LastName":"CARGES","equip_BusinessName":"","equip_Email":"dawnchard@yahoo.com","registeredBy":"H","installingDealer":"","servicingDealer":"","distributor":"","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"","internalComments":""},{"$id":"6","consumer_Name":"GERARD,CARGES","consumer_BusinessName":"","consumer_Address1":"7312 SNOWBALL RUN","consumer_Address2":"","consumer_City":"EAST SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"3154392749","consumer_Phone2":"3154741177","consumer_Email":"dawnchard@yahoo.com","equip_Address1":"7312 SNOWBALL RUN","equip_Address2":"","equip_City":"EAST SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"","dealerPhone":"","mfgAcctNum":"","serviceBenchID":"","hvacpId":"","model":"SYSTXBB4ZC01","serial":"0713N175555","equip_Description":"1-PK/BRY EVOLUTION DAMPER CONTROL","confirmationNumber":"1303018065b","registrationNumber":"R195889515","source":"W","comments":"~ConsumerEmail:dawnchard@yahoo.com","installationDate":"03/07/2013","registrationDate":"03/19/2013 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"SYST","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"","brand":"BRY","consumer_MarketingOptIn":"Y","equip_FirstName":"GERARD","equip_LastName":"CARGES","equip_BusinessName":"","equip_Email":"dawnchard@yahoo.com","registeredBy":"H","installingDealer":"","servicingDealer":"","distributor":"","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"","internalComments":""},{"$id":"7","consumer_Name":"Unknown,Unknown","consumer_BusinessName":"","consumer_Address1":"6304 Thompson Rd.","consumer_Address2":"","consumer_City":"East Syracuse","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 Thompson Rd.","equip_Address2":"","equip_City":"East Syracuse","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"FLORIDA COOLING SUPPLY #272","dealerPhone":"+19413665804","mfgAcctNum":"110992","serviceBenchID":"565791582","hvacpId":"110992","model":"FXM4X3000AT","serial":"A143273701","equip_Description":"FANCOIL-ECM MULTI 2.5T R4 TIN","confirmationNumber":"","registrationNumber":"R222169171","source":"W","comments":"Dealer Name:Airrific ,Dealer Phone:9413713355,Dealer Email:,Brand Installed: Comfortmaker,Brand Replaced:~ConsumerEmail:","installationDate":"09/05/2014","registrationDate":"09/07/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"FXM4X","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"ICP","consumer_MarketingOptIn":"N","equip_FirstName":"Unknown","equip_LastName":"Unknown","equip_BusinessName":"","equip_Email":"","registeredBy":"S","installingDealer":"110992","servicingDealer":"","distributor":"110992","modelUsage":"","application":"R","installationType":"A","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"FLORIDA COOLING SUPPLY #272","internalComments":"1-695ZOQ"},{"$id":"8","consumer_Name":"UNKOWN,UNKOWN","consumer_BusinessName":"","consumer_Address1":"6304 THOMPSON RD","consumer_Address2":"","consumer_City":"E SYRACSUE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"8669892524","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 THOMPSON RD","equip_Address2":"","equip_City":"E SYRACSUE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"Mid-Atlantic Totaline, Beltsville","dealerPhone":"3014701703","mfgAcctNum":"11036","serviceBenchID":"","hvacpId":"1934","model":"213CNA030000","serial":"3414E24122","equip_Description":"13S,LEGACY, HP PURON DENSE GRILLE 2.5 T","confirmationNumber":"","registrationNumber":"R225219066","source":"W","comments":"","installationDate":"11/17/2014","registrationDate":"11/17/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"213C","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"CAR","consumer_MarketingOptIn":"N","equip_FirstName":"UNKOWN","equip_LastName":"UNKOWN","equip_BusinessName":"","equip_Email":"","registeredBy":"S","installingDealer":"11036","servicingDealer":"","distributor":"11036","modelUsage":"","application":"R","installationType":"A","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"Mid-Atlantic Distribution, Richmond, LE","internalComments":"1-6CD2E8"},{"$id":"9","consumer_Name":"UNKNOWN,UNKNOWN","consumer_BusinessName":"","consumer_Address1":"6304 THOMPSON  RD","consumer_Address2":"","consumer_City":"E. SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"8669892524","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 THOMPSON  RD","equip_Address2":"","equip_City":"E. SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"Refrigeration Sales Corporation, Valley View, HQ","dealerPhone":"216-525-8100","mfgAcctNum":"31196","serviceBenchID":"493878798","hvacpId":"2202","model":"GAPAAXBB1625-A08","serial":"0911V00187","equip_Description":"PERFECT AIR PURIFIER 8-PER SKID 16\"X25\"","confirmationNumber":"","registrationNumber":"R166251171","source":"W","comments":"","installationDate":"09/29/2014","registrationDate":"09/29/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"GAPAA","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"CAR","consumer_MarketingOptIn":"N","equip_FirstName":"UNKNOWN","equip_LastName":"UNKNOWN","equip_BusinessName":"","equip_Email":"","registeredBy":"H","installingDealer":"31196","servicingDealer":"","distributor":"31196","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"Refrigeration Sales Corporation, Valley View, HQ","internalComments":"1-697KB2"},{"$id":"10","consumer_Name":"UNKNOWN,UNKNOWN","consumer_BusinessName":"","consumer_Address1":"6304 THOMPSON  RD","consumer_Address2":"","consumer_City":"E. SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"8669892524","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 THOMPSON  RD","equip_Address2":"","equip_City":"E. SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"Refrigeration Sales Corporation, Valley View, HQ","dealerPhone":"216-525-8100","mfgAcctNum":"31196","serviceBenchID":"493878798","hvacpId":"2202","model":"GAPAAXBB1625-A08","serial":"0911V00187","equip_Description":"PERFECT AIR PURIFIER 8-PER SKID 16\"X25\"","confirmationNumber":"","registrationNumber":"R166251171","source":"W","comments":"","installationDate":"09/29/2014","registrationDate":"09/29/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"GAPAA","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"CAR","consumer_MarketingOptIn":"N","equip_FirstName":"UNKNOWN","equip_LastName":"UNKNOWN","equip_BusinessName":"","equip_Email":"","registeredBy":"H","installingDealer":"31196","servicingDealer":"","distributor":"31196","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"Refrigeration Sales Corporation, Valley View, HQ","internalComments":"1-697KB2"},{"$id":"11","consumer_Name":"Unknown,Unknown","consumer_BusinessName":"","consumer_Address1":"6304 Thompson Road","consumer_Address2":"","consumer_City":"East Syracuse","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"","consumer_Phone2":"","consumer_Email":"","equip_Address1":"6304 Thompson Road","equip_Address2":"","equip_City":"East Syracuse","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"North East Distribution, Pittsburgh Dwntwn","dealerPhone":"4124711419","mfgAcctNum":"10014","serviceBenchID":"","hvacpId":"9005799","model":"925SA42060E17","serial":"3114A51177","equip_Description":"G/F,4-WAY 95 AFUE 1S/ECM","confirmationNumber":"","registrationNumber":"R222182310","source":"W","comments":"","installationDate":"08/28/2014","registrationDate":"09/04/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"925S","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"BRY","consumer_MarketingOptIn":"N","equip_FirstName":"Unknown","equip_LastName":"Unknown","equip_BusinessName":"","equip_Email":"","registeredBy":"H","installingDealer":"10014","servicingDealer":"","distributor":"10014","modelUsage":"","application":"R","installationType":"A","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"North East Distribution, West Caldwell, LE","internalComments":"1-68HLIW"}]';        
    body = '[{"$id":"2","consumer_Name":"GERARD,CARGES","consumer_BusinessName":"","consumer_Address1":"7312 SNOWBALL RUN","consumer_Address2":"","consumer_City":"EAST SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"3154392749","consumer_Phone2":"3154741177","consumer_Email":"dawnchard@yahoo.com","equip_Address1":"7312 SNOWBALL RUN","equip_Address2":"","equip_City":"EAST SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"","dealerPhone":"","mfgAcctNum":"","serviceBenchID":"","hvacpId":"","model":"SYSTXBBUIZ01-D","serial":"4712W002752","equip_Description":"OBS USE SYSTXBBECN01-A FOR WARRANTY","confirmationNumber":"1303018065b","registrationNumber":"R195889514","source":"W","comments":"~ConsumerEmail:dawnchard@yahoo.com","installationDate":"03/07/2013","registrationDate":"03/19/2013 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"SYST","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"","brand":"BRY","consumer_MarketingOptIn":"Y","equip_FirstName":"GERARD","equip_LastName":"CARGES","equip_BusinessName":"","equip_Email":"dawnchard@yahoo.com","registeredBy":"H","installingDealer":"","servicingDealer":"","distributor":"","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"","internalComments":""},{"$id":"3","consumer_Name":"GERARD,CARGES","consumer_BusinessName":"","consumer_Address1":"7312 SNOWBALL RUN","consumer_Address2":"","consumer_City":"EAST SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"3154392749","consumer_Phone2":"3154741177","consumer_Email":"dawnchard@yahoo.com","equip_Address1":"7312 SNOWBALL RUN","equip_Address2":"","equip_City":"EAST SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"","dealerPhone":"","mfgAcctNum":"","serviceBenchID":"","hvacpId":"","model":"SYSTXBB4ZC01","serial":"0713N175555","equip_Description":"1-PK/BRY EVOLUTION DAMPER CONTROL","confirmationNumber":"1303018065b","registrationNumber":"R195889515","source":"W","comments":"~ConsumerEmail:dawnchard@yahoo.com","installationDate":"03/07/2013","registrationDate":"03/19/2013 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"SYST","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"","brand":"BRY","consumer_MarketingOptIn":"Y","equip_FirstName":"GERARD","equip_LastName":"CARGES","equip_BusinessName":"","equip_Email":"dawnchard@yahoo.com","registeredBy":"H","installingDealer":"","servicingDealer":"","distributor":"","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"","internalComments":""},{"$id":"4","consumer_Name":"GERARD,CARGES","consumer_BusinessName":"","consumer_Address1":"7312 SNOWBALL RUN","consumer_Address2":"","consumer_City":"EAST SYRACUSE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13057","consumer_Phone1":"3154392749","consumer_Phone2":"3154741177","consumer_Email":"dawnchard@yahoo.com","equip_Address1":"7312 SNOWBALL RUN","equip_Address2":"","equip_City":"EAST SYRACUSE","equip_State":"NY","equip_Country":"US","equip_Zip":"13057","dealerName":"Spencer Heating & Air Conditioning Inc","dealerPhone":"315-474-1177","mfgAcctNum":"207274-10014","serviceBenchID":"494175297","hvacpId":"110549","model":"987MA42080V17","serial":"4712A46605","equip_Description":"G/F,4-WAY 97 AFUE MOD VS EVOL Z","confirmationNumber":"1303018065b","registrationNumber":"R195889418","source":"W","comments":"~ConsumerEmail:dawnchard@yahoo.com","installationDate":"03/07/2013","registrationDate":"03/19/2013 12:00:00","transferDate":"","markAs":"","modelLocation":"BS","furnaceOrientation":"UP","furnaceFuel":"N","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"987M","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"BRY","consumer_MarketingOptIn":"Y","equip_FirstName":"GERARD","equip_LastName":"CARGES","equip_BusinessName":"","equip_Email":"dawnchard@yahoo.com","registeredBy":"H","installingDealer":"207274-10014","servicingDealer":"","distributor":"10014","modelUsage":"","application":"R","installationType":"R","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"North East Distribution, West Caldwell, LE","internalComments":""}]';        
            
            //String st4 = '[{"$id":"1","registrationDataResults":[{"$id":"2","consumer_Name":"SNIGDHA,SAHA","consumer_BusinessName":"","consumer_Address1":"3417 VANWIE DRIVE","consumer_Address2":"","consumer_City":"BALDWINSVILLE","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13","consumer_Phone1":"","consumer_Phone2":"","consumer_Email":"","equip_Address1":"3417 VANWIE DRIVE","equip_Address2":"","equip_City":"BALDWINSVILLE","equip_State":"NY","equip_Country":"US","equip_Zip":"13","dealerName":"Angelo Chiodo Heating & Air Cond.","dealerPhone":"315-471-7747","mfgAcctNum":"120464-10014","serviceBenchID":"494568904","hvacpId":"8038","model":"58CVA090---1--16","serial":"1503A30014","equip_Description":"PLUS 80V,2STGE,VARIBLE SPD 4-WAY MP 80%","confirmationNumber":"","registrationNumber":"R188333403","source":"H","comments":"","installationDate":"03/24/2004","registrationDate":"11/08/2012 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"False","alwaysReviewFlag":"False","registeredOnTimeFlag":"False","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"58CVA","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"","brand":"CAR","consumer_MarketingOptIn":"N","equip_FirstName":"SNIGDHA","equip_LastName":"SAHA","equip_BusinessName":"","equip_Email":"","registeredBy":"","installingDealer":"120464-10014","servicingDealer":"","distributor":"10014","modelUsage":"","application":"R","installationType":"","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"North East Distribution, West Caldwell, LE","internalComments":""},{"$id":"3","consumer_Name":"Legacy Bay Townhomes,Leasing Office","consumer_BusinessName":"Legacy Bay Townhomes","consumer_Address1":"436 Glenwood Road","consumer_Address2":"","consumer_City":"Binghamton","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13","consumer_Phone1":"6077292432","consumer_Phone2":"","consumer_Email":"ordering@stratford.com","equip_Address1":"436 Glenwood Road","equip_Address2":"","equip_City":"Binghamton","equip_State":"NY","equip_Country":"US","equip_Zip":"13","dealerName":",Dealer Phone:,Dealer Email:,Brand Installed: Airquest,Brand Replaced:","dealerPhone":"Dealer Name:,,Dealer Email:,Brand Installed: Airquest,Brand Replaced:","mfgAcctNum":"","serviceBenchID":"","hvacpId":"","model":"N4A318GKC","serial":"E141923523","equip_Description":"13 SEER AC  (Built 2014 or prior)","confirmationNumber":"Z001369319411","registrationNumber":"R222393818","source":"W","comments":"Dealer Name:,Dealer Phone:,Dealer Email:,Brand Installed: Airquest,Brand Replaced:~ConsumerEmail:ordering@stratford.com","installationDate":"09/04/2014","registrationDate":"09/11/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"N4A3","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"ICP","consumer_MarketingOptIn":"N","equip_FirstName":"Legacy Bay Townhomes","equip_LastName":"Leasing Office","equip_BusinessName":"Legacy Bay Townhomes","equip_Email":"ordering@stratford.com","registeredBy":"H","installingDealer":"","servicingDealer":"","distributor":"","modelUsage":"","application":"C","installationType":"A","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"HOMEOWNER FOR WARRANTY********","internalComments":""},{"$id":"4","consumer_Name":"Legacy Bay Townhomes,Leasing Office","consumer_BusinessName":"Legacy Bay Townhomes","consumer_Address1":"436 Glenwood Road","consumer_Address2":"","consumer_City":"Binghamton","consumer_State":"NY","consumer_Country":"US","consumer_Zip":"13","consumer_Phone1":"6077292432","consumer_Phone2":"","consumer_Email":"ordering@stratford.com","equip_Address1":"436 Glenwood Road","equip_Address2":"","equip_City":"Binghamton","equip_State":"NY","equip_Country":"US","equip_Zip":"13","dealerName":",Dealer Phone:,Dealer Email:,Brand Installed: Airquest,Brand Replaced:","dealerPhone":"Dealer Name:,,Dealer Email:,Brand Installed: Airquest,Brand Replaced:","mfgAcctNum":"","serviceBenchID":"","hvacpId":"","model":"END4X24L14A","serial":"X142258557","equip_Description":"\"COIL-N VERT 2T R4 14.2\"\"\"","confirmationNumber":"Z001369319411","registrationNumber":"R222393819","source":"W","comments":"Dealer Name:,Dealer Phone:,Dealer Email:,Brand Installed: Airquest,Brand Replaced:~ConsumerEmail:ordering@stratford.com","installationDate":"09/04/2014","registrationDate":"09/11/2014 12:00:00","transferDate":"","markAs":"","modelLocation":"","furnaceOrientation":"","furnaceFuel":"","enhancedWarrantyFlag":"True","alwaysReviewFlag":"False","registeredOnTimeFlag":"True","proofOfPurchaseFlag":"False","agreementNumber":"","tagNumber":"","productNumber":"END4","businessType":"","customerReferenceID":"","businessUnit":"","legacyConfirmationNum":"","isValidRegistration":"True","emailOptInFlag":"False","warrantyPolicyCode":"","isGeo":"N","registrationStatus":"SAV","brand":"ICP","consumer_MarketingOptIn":"N","equip_FirstName":"Legacy Bay Townhomes","equip_LastName":"Leasing Office","equip_BusinessName":"Legacy Bay Townhomes","equip_Email":"ordering@stratford.com","registeredBy":"H","installingDealer":"","servicingDealer":"","distributor":"","modelUsage":"","application":"C","installationType":"A","replacementModel":"","replacementSerial":"","propertyId":"","distributorName":"HOMEOWNER FOR WARRANTY********","internalComments":""}]}]';
            AddFindEquipment_Controller.CreateAssetForSS(testCase1.id,body);
            //PageReference result1=equipsearch3.CreateAssetForSS();
            //System.assertEquals(null,result1);
         }
       Test.stopTest();
    }//get
    
    
    
    // test for method getEquippmentInfo() which calls getEquipmentInfo()(test for web service callouts)
     public static testMethod void getEquippmentInfoTest()
    {
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
        {
          // call for the constructor   
          //ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
          //AddFindEquipment_Controller equipsearch =new AddFindEquipment_Controller (); 
          
           Test.setMock(HttpCalloutMock.class,new CCC_HttpResponseGeneratorEquipSearchTest());          
           try{        
             list<AddFindEquipment_Controller.FindRegisteredWrapper> lst3 = AddFindEquipment_Controller.getEquipmentInfo('abc','abc','123','asdf','6547','34567');
             list<AddFindEquipment_Controller.FindRegisteredWrapper> lst4 = AddFindEquipment_Controller.getEquipmentInfo(null,null,null,null,null,null);
           }
           catch(Exception e) 
           {

           }
        }
    }//getEquippmentInfoTest()
    
    
    
}//class CCC_EquipmentSearchControllerTest