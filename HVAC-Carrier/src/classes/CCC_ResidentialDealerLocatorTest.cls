@isTest
public class CCC_ResidentialDealerLocatorTest
{
    public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
    
    public static User testusr1;
    public static Contact testCon1;
    public static Case testCase1;
    public static Account testAcc;
    public static CCC_Suggested_Dealers__c suggdeal,suggdeal2;
    public static CCC_IntegrationEndPoint__c obj;
    
    public static String siteType='Consumer';
    public static String brand='CA';
    public static String searchType='territory';
    public static String zip='13206';
    public static Integer dealerCount=20; 
    public static Integer radius=25;
    public static String country='USA';
    public static String filters='All Dealers';
    public static List<SelectOption> list1,list2;
    
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
        
        
        /*     Profile testprof1=[SELECT Id FROM Profile WHERE Name='Partner Community Warranty Admin'];


// create new user with Partner Community Warranty Admin profile
testusr1=new User( email='testdealer.user@gmail.com',
profileid = testprof1.id,  
UserName='test9.user@gmail.com', 
Alias = 'GDS',
TimeZoneSidKey='America/New_York',
EmailEncodingKey='ISO-8859-1',
LocaleSidKey='en_US', 
LanguageLocaleKey='en_US',
ContactId = testCon1.id,
PortalRole = 'Manager',
FirstName = 'test1',
LastName = 'user1');

insert testusr1;*/
        
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
        
        // set webservice endpoint settings in custom settings      
        obj = new CCC_IntegrationEndPoint__c();
        obj.UserName__c = 'test';
        obj.Name = 'Dealer_Locator';
        obj.Password__c='mypwd';
        obj.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
        obj.URL__c='http://www.services.hvacpartners.com/RDLWebService/ResidentialDealerLocator.asmx/GetDealers';
        insert obj;
        
        // create new case
        testCase1=(Case)utilClass.setUpData(new Case());
        testCase1.Subject='TestDealerCase';
        testCase1.Origin='Email';
        testCase1.Status='Open'; 
        testCase1.AccountId=testAcc.id;
        testCase1.ContactId=testCon1.id;
        RecordType rt= [select id,Name from RecordType where SobjectType='Case' and Name='Consumer Relations' Limit 1];
        testCase1.recordTypeId=rt.id;
        testCase1=(Case)utilClass.createTestRecord(testCase1);
        
        // create new suggested dealer record
        suggdeal= new CCC_Suggested_Dealers__c();
        suggdeal.Name='Irish Air Now';
        suggdeal.CCC_Dealer_City__c='Indianapolis';
        suggdeal.CCC_Dealer_Phone__c='877-891-0327';
        suggdeal.CCC_DealerPostal_Address__c='36 S. Main Street';
        //  suggdeal.CCC_Distance_In_Miles__c='20';
        suggdeal.CCC_Case__c=testCase1.id;
        
        insert suggdeal;
        
    }//setupData()
    
    // This method will test the controller's constructor functionality
    public static testMethod void testConstructor()
    {   
        setupData();
        Test.startTest();
        
        System.runAs(testusr1)
        {
            
            //set the caseid of controller      
            System.currentPageReference().getParameters().put('id',testCase1.id);
            
            //call for the constructors 
            ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
            CCC_ResidentialDealerLocatorController dlc =new CCC_ResidentialDealerLocatorController(casecontroller1);      
            
            // Set mock callout class for http callouts
            Test.setMock(HttpCalloutMock.class, new  CCC_HttpRespGeneratorDealerLocatorTest());
            
            dlc.radiusValue();
            
            
            // call method getDealerDetails() which will call getDealerInformation()
            dlc.rdl_SiteType=siteType;
            dlc.SelectedBrands=brand;
            dlc.rdl_SearchType=searchType;
            dlc.zip=zip;
            dlc.rdl_DealerCount=dealerCount;
            dlc.rdl_Country=country; 
            dlc.rdl_iSearchRadius=radius;
            dlc.SelectedSearchFilter=filters;
            
            list1= dlc.getrdl_Brands();
            list2=dlc.getrdl_SearchFilters();
            
            
            dlc.getDealerDetails();
            dlc.populateSelected();
            
            CCC_ResidentialDealerLocatorController.DealerDetails dealerdet =new CCC_ResidentialDealerLocatorController.DealerDetails();
            dealerdet.dealer='abc';
            dealerdet.ZipCode='123';
            dealerdet.Country='india';
            dealerdet.TollFree='123';
            dealerdet.Fax='123';
            dealerdet.Email='abc@gmail.com';
            dealerdet.Website='abc';
            dealerdet.MarketingMessage='abc';
            dealerdet.RetailStore='abc';
            dealerdet.HoursOfOperation='2';
            dealerdet.YearsInBusiness='3';
            dealerdet.LeadEligible ='abc' ;  
            dealerdet.DistanceInKM='';
            dealerdet.Latitude='';
            dealerdet.Longitude='';
            dealerdet.MapURL='';
            dealerdet.ContactFormURL='';
            dealerdet.iconSet3='';
            dealerdet.iconSet4='';
            dealerdet.iconSet5='';
            dealerdet.iconSet6='';
            dealerdet.iconSet7='';
            dealerdet.iconSet8='';
            dealerdet.iconSet9='';
            
            dealerdet.iconSet10='';
            dealerdet.iconSet11='';
            dealerdet.iconSet12='';
        }
        
        
        
        Test.stopTest();
        
    } //method testcontroller()
    
    public static testMethod void testConstructor1(){ 
        
        setupData();
        Test.startTest();
        System.runAs(testusr1){
            //set the caseid of controller      
            System.currentPageReference().getParameters().put('id',testCase1.id);
            
            //call for the constructors 
            CCC_ResidentialEmailTemplateController dealloc = new CCC_ResidentialEmailTemplateController();
            
            // Set mock callout class for http callouts
            Test.setMock(HttpCalloutMock.class, new  CCC_HttpRespGeneratorDealerLocatorTest());
            
            // call method getDealerDetails() which will call getDealerInformation()
            dealloc.rdl_SiteType=siteType;
            dealloc.rdl_Brand=brand;
            dealloc.rdl_SearchType=searchType;
            dealloc.zip=zip;
            dealloc.rdl_DealerCount=dealerCount;
            dealloc.rdl_Country=country; 
            dealloc.rdl_iSearchRadius=radius;
            dealloc.rdl_SearchFilter=filters;
            dealloc.getDealerDetails();
            dealloc.populateSelected();
            dealloc.getExitDealerRecords();
            
            CCC_ResidentialEmailTemplateController.DealerDetails dealerdet =new CCC_ResidentialEmailTemplateController.DealerDetails();
            dealerdet.dealerId='abc';
            dealerdet.ZipCode='123';
            dealerdet.Country='india';
            dealerdet.TollFree='123';
            dealerdet.Fax='123';
            dealerdet.Email='abc@wipro.com';
            dealerdet.Website='abc';
            dealerdet.MarketingMessage='abc';
            dealerdet.RetailStore='abc';
            dealerdet.HoursOfOperation='2';
            dealerdet.YearsInBusiness='3';
            dealerdet.LeadEligible ='abc' ;  
            dealerdet.DistanceInKM='';
            dealerdet.Latitude='';
            dealerdet.Longitude='';
            dealerdet.MapURL='';
            dealerdet.ContactFormURL='';
        }
        
        Test.stopTest();
    } 
    
    public static testMethod void testExitDealerRecords(){
        
        setupData();
        Test.startTest();
        System.runAs(testusr1){
            CCC_ResidentialEmailTemplateController existDeal =new CCC_ResidentialEmailTemplateController();
            System.currentPageReference().getParameters().put('id',testCase1.id);
            existDeal.getExitDealerRecords(); 
            Test.stopTest();
            
        }
    }
    //testing save method 
    public static testMethod void testSave(){
        
        setupData();
        Test.startTest();
        System.runAs(testusr1){
            //set the caseid of controller      
            System.currentPageReference().getParameters().put('id',testCase1.id);
            //call for save()
            suggdeal2= new CCC_Suggested_Dealers__c();
            suggdeal2.Name='Irish Air Now2';
            suggdeal2.CCC_Dealer_City__c='Indianapolis';
            suggdeal2.CCC_Dealer_Phone__c='877-890-0327';
            suggdeal2.CCC_DealerPostal_Address__c='36 S. Main Street';
            // suggdeal2.CCC_Distance_In_Miles__c='20';
            suggdeal2.CCC_Case__c=testCase1.id;
            
            //call for the constructors 
            ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
            CCC_ResidentialDealerLocatorController dlc2 =new CCC_ResidentialDealerLocatorController(casecontroller1);
            
            CCC_ResidentialDealerLocatorController.DealerWrapper dealrewrap =new CCC_ResidentialDealerLocatorController.DealerWrapper(suggdeal2,true);
            dealrewrap.selected=true;
            List<CCC_ResidentialDealerLocatorController.DealerWrapper> dealrewraplist =new List<CCC_ResidentialDealerLocatorController.DealerWrapper>();
            dealrewraplist.add( dealrewrap);
            dlc2.DealerList=dealrewraplist;
            
            
            //insert suggdeal2;
            
            List<CCC_Suggested_Dealers__c> deallist2= new List<CCC_Suggested_Dealers__c>();
            deallist2.add(suggdeal2);
            
            dlc2.SelectedDealerList=deallist2;
            PageReference pgref1 = Page.CCC_ResidentialDealerLocatorSearch;
            pgref1.getParameters().put('id',testCase1.id);
            Test.setCurrentPage(pgref1);
            PageReference result1=dlc2.save();
            System.assertEquals(null,result1);
            
            
        }//runAs(user)
        
        Test.stopTest();
        
    } //method testSave()   
}//class TestCCCDealerLocationsController