@isTest
public class CCC_CTIContactPageControllerTestNew {
//object of wrapper class
    public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
    public static User testUser;
    public static Account testAccount;
    public static Contact testContact,testContact2;
    public static Case testCase;
    public static String Lastname='Roy';
    public static String Street='hillvalley';
    public static String Phone='76549';
    public static String PostalCode='1234';
    public static String firstName='Raj';
    public static String email='Raj@example.com';
    public static String City='WC';
    public static string ConfirmationNo='345678';
    public static CCC_IntegrationEndPoint__c endpoint;
    
    public static list<CCC_CTIContactPageController.ContactWrapper>conwrapperlist;
    public static CCC_CTIContactPageController.ContactWrapper conwrapper;
  
    public static void setData()
    {
    //create profile
    Profile testProfile = [select id from profile where name='System Administrator'];
    
    //create user
    testUser = new User(alias = 'userTest', email='developercto@carrier.com',emailencodingkey='UTF-8',
                        languagelocalekey='en_US', lastname='Testing', 
                        profileid = testProfile.Id, timezonesidkey='America/Los_Angeles',localesidkey='en_US',
                        username='developercto@carrier.com'); 
    insert testUser; 
    
    //create new Account
    testAccount=(Account)utilClass.setUpData(new Account());
    RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Residential Address' Limit 1];
    testAccount.recordTypeId=rt2.id;
    testAccount.Phone='123';
    testAccount.BillingCountry='USA';
    testAccount.Name='Test Account';
    testAccount=(Account)utilClass.createTestRecord(testAccount);
   
   //create new Contact 
    testContact=(Contact)utilClass.setUpData(new Contact());
    testContact.Accountid=testAccount.id;
    testContact.Lastname='Niel';
    testContact.FirstName='nitin';
   
    RecordType rt = [select id,Name from RecordType where SobjectType='Contact' and Name='Residential Contact' Limit 1];
    testContact.recordTypeId=rt.id;
    testContact.Phone='123';
    testContact.MailingCountry='USA'; 
    testContact.MailingPostalcode='1234'; 
    testContact.Email='abc@gmail.com';  
    testContact=(Contact)utilClass.createTestRecord(testContact);
    
    //create new case
     testCase=(Case)utilClass.setUpData(new Case());
     testCase.Subject='TestCTICase';
     testCase.Origin='Email';
     testCase.Status='Open'; 
     testCase.AccountId=testAccount.id;
     testCase.ContactId=testContact.id;
     RecordType rt3= [select id,Name from RecordType where SobjectType='Case' and Name='Consumer Relations' Limit 1];
     testCase.recordTypeId=rt3.id;
     testCase=(Case)utilClass.createTestRecord(testCase);
     
      //create new custom setting;
     endpoint= new CCC_IntegrationEndPoint__c();
     endpoint.UserName__c='app_salesforce';
     endpoint.Password__c='hy~jpmXm@2s6_@MM';
     endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
     endpoint.URL__c='https://staging.ws.utcbis.com/auth/realms/hvac/tokens/grants/access';
     endpoint.Name='PHDB_Token';
     //insert endpoint;
    
    
    }//setData()
    
    
    //test for the constructor
    public static TestMethod void ConstructorTest()
    {
        setData();
        Test.startTest();
        System.runAs(testUser)
        {
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
          // testController.Lastname='';
           testController.PHDBRecord=true;
           testController.strUrl='';
           testController.responseStr='';
         //  testController.lstName='';
           testController.phoneFromURL='';
        }
         Test.stopTest();
        
    }//ConstructorTest
    
    
       
    // test GetrecordtypeId()
    public static TestMethod void GetrecordtypeIdTest()
    {
        setData();
        Test.startTest();
        System.runAs(testUser)
        {
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           RecordType rt=testController.GetrecordtypeId('Residential Contact','Contact');
        }
        Test.stopTest();
        
    }//GetrecordtypeIdTest
    
    
       
       //save : Method creating Account ,Contact and case
     public static TestMethod void saveTest()
    {
        setData();
        Test.startTest();
      System.runAs(testUser)
       {
           ApexPages.currentPage().getParameters().put('ResidentialFromURL','false');
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           testController.selectedCaseType=testCase.recordTypeId;
           testController.save();
           Account testAccount1=new Account();
            RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Residential Address' Limit 1];
            testAccount1.recordTypeId=rt2.id;
            testAccount1.Phone='123';
            testAccount1.BillingCountry='USA';
            testAccount1.Name='Test Account';
            //testAccount=(Account)utilClass.createTestRecord(testAccount);
            insert testAccount1;
   
           Contact temp = new Contact();
            temp.Accountid=testAccount.id;
            temp.Lastname='Niel';
            temp.FirstName='nitin';
   
            RecordType rt = [select id,Name from RecordType where SobjectType='Contact' and Name='Residential Contact' Limit 1];
            temp.recordTypeId=rt.id;
            temp.Phone='123';
            temp.MailingCountry=''; 
            temp.MailingPostalcode='123'; 
            temp.Email='';
            insert temp;
           
          
           testController.contact=temp ;
           testController.isResidential=true;
           PageReference pgref = Page.CCC_CTIContactPage;
           pgref.getParameters().put('id',testCase.id);
           Test.setCurrentPage(pgref);
           PageReference ListConTest = testController.save();
           System.assertEquals(null,ListConTest);
           
       }
        Test.stopTest();
        
    }//saveTest()
       
       //save : Method creating Account ,Contact and case
     public static TestMethod void saveNewTest()
    {
        setData();
        Test.startTest();
      System.runAs(testUser)
       {
           ApexPages.currentPage().getParameters().put('ResidentialFromURL','false');
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           testController.selectedCaseType=testCase.recordTypeId;
           testController.save();
           Account testAccount1=new Account();
            RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Residential Address' Limit 1];
            testAccount1.recordTypeId=rt2.id;
            testAccount1.Phone='123';
            testAccount1.BillingCountry='USA';
            testAccount1.Name='Test Account';
            //testAccount=(Account)utilClass.createTestRecord(testAccount);
            insert testAccount1;
   
           Contact temp = new Contact();
            temp.Accountid=testAccount.id;
            temp.Lastname='Niel123';
            temp.FirstName='nitin123';
   
            RecordType rt = [select id,Name from RecordType where SobjectType='Contact' and Name='Residential Contact' Limit 1];
            temp.recordTypeId=rt.id;
            temp.Phone='123123';
            temp.MailingCountry=''; 
            temp.MailingPostalcode='123123'; 
            temp.Email='';
            //insert temp;
           
          
           testController.contact=temp ;
           testController.isResidential=true;
           PageReference pgref = Page.CCC_CTIContactPage;
           pgref.getParameters().put('id',testCase.id);
           Test.setCurrentPage(pgref);
           PageReference ListConTest = testController.save();
           System.assertEquals(null,ListConTest);
           
       }
        Test.stopTest();
        
    }
       
       //call for contactSearch which calls getPHDBContactInfo
       public static TestMethod void contactSearchTest()
    {
        setData();
        Test.startTest();
        System.runAs(testUser)
        {
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           
           list<Contact> conlist1 = new list <Contact>();
           conlist1.add(testContact);
           testController.contactResults=conlist1;
           
           apexpages.currentpage().getparameters().put('phoneFromURL1' ,testContact.Phone);
            testController.contact=testContact;

           list<Contact> conlist2 = new list <Contact>();
           conlist2=testController.contactSearch();
           
           
       }
        Test.stopTest();
        
     }//contactSearch()
       
       
       
       
      //test forgetAllResults()
        public static TestMethod void getAllResultsTest()
    {
        setData();
        Test.startTest();
        System.runAs(testUser)
        {
            CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
            conwrapper = new CCC_CTIContactPageController.ContactWrapper(testContact,true); 
            conwrapperlist = new list<CCC_CTIContactPageController.ContactWrapper>();
            list<CCC_CTIContactPageController.ContactWrapper>retwrapperlist = new list<CCC_CTIContactPageController.ContactWrapper>();

         //to enter value in contactResults
            list<Contact>conlist= new list<Contact>(); 
            conlist.add(testContact);   
            testController.contactResults=conlist;
         
         //to enter value in  contactWrapperList     
            conwrapperlist.add(conwrapper);
            testController.contactWrapperList=conwrapperlist;
            retwrapperlist=testController.getAllResults();
         //testController.clearContact();             
           
        }
        Test.stopTest();
        
     }//getAllResultsTest()
      
      
       
       //test for populateDetails() and clear details
         public static TestMethod void populateDetailsTest()
      {
        setData();
        Test.startTest();
        System.runAs(testUser)
        {
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           testController.uniqueContactId=testContact.id;
           
           testController.populateDetails();
           testController.clearDetails();  
           
        }
         Test.stopTest();
        
       }//populateDetailsTest()
       
       
       
       //test for getCaseTypeTest
      public static TestMethod void getCaseTypeTest()
      {
        setData();
        Test.startTest();
        System.runAs(testUser)
        {
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           testController.uniqueContactId=testContact.id;
           List<SelectOption> selOpts=testController.getCaseType();
        }
         Test.stopTest();
        
       }//getCaseTypeTest()
       
       
       
       
       //test clearContact
       public static TestMethod void clearContactTest()
        {
        setData();
        Test.startTest();
        System.runAs(testUser)
        {
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           conwrapper = new CCC_CTIContactPageController.ContactWrapper(testContact,true); 
           conwrapperlist = new list<CCC_CTIContactPageController.ContactWrapper>();
           
           conwrapperlist.add(conwrapper);
          testController.contactWrapperList=conwrapperlist;
          testController.Results=conwrapperlist;
          
           testController.clearContact();
           
        }
         Test.stopTest();
        
       }//clearContactTest
       
       
       
       
       //test for populateDetailsPHDB
        public static TestMethod void populateDetailsPHDBTest()
    {
        setData();
        Test.startTest();
        System.runAs(testUser)
        {
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           
           //enter value in lstDisNum, PHDBContactsInfo
           CCC_CTIContactPageController.PHDBInfoWrapper phdbwrap= new CCC_CTIContactPageController.PHDBInfoWrapper(testContact,true);
           phdbwrap.consumer_Address1='abc';
           phdbwrap.consumer_Name='Harry,Potter';
           phdbwrap.consumer_Zip='444606';
           phdbwrap.consumer_State='Maharashtra';
           phdbwrap.consumer_Country='India';
           phdbwrap.consumer_Phone1='897654';
           phdbwrap.consumer_City='Amravati';  
           
          list<CCC_CTIContactPageController.PHDBInfoWrapper>phdbwraplist= new list<CCC_CTIContactPageController.PHDBInfoWrapper>();
          phdbwraplist.add(phdbwrap);
          testController.lstDisNum=phdbwraplist;
          testController.PHDBContactsInfo=phdbwraplist;
          
          testController.populateDetailsPHDB();
          
          //coverage of PHDBInfoWrapper
          phdbwrap.serial='';
          phdbwrap.consumer_Phone2='';
          phdbwrap.model='';
          phdbwrap.consumer_BusinessName='';
          phdbwrap.consumer_Address2='';
          phdbwrap.equip_City='';
          phdbwrap.equip_Address1='';
          phdbwrap.equip_State='';
          phdbwrap.equip_Country='';
          phdbwrap.equip_Zip='';
          phdbwrap.dealerName='';
          phdbwrap.dealerPhone='';
          phdbwrap.mfgAcctNum='';
          phdbwrap.serviceBenchID='';
          phdbwrap.hvacpId='';
          phdbwrap.equip_Description='';
          phdbwrap.registrationNumber='';
          phdbwrap.confirmationNumber='';
          phdbwrap.source='';
          phdbwrap.comments='';
          
          
        }
         Test.stopTest();
        
       }//populateDetailsPHDBTest
       
       
       
       
    //test for http callouts, getPHDBContactInfo calls to web service method getPHDBInfo
    public static TestMethod void getPHDBContactInfoTest()
    {
        setData();
        Test.startTest();
        System.runAs(testUser)
        {
            
            CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           
           // Set mock callout class for http callouts
           Test.setMock(HttpCalloutMock.class, new  CCC_HttpResponseGeneratorCTITest());
           
           //insert null value in phdbwraplist
           CCC_CTIContactPageController.PHDBInfoWrapper phdbwrap= new CCC_CTIContactPageController.PHDBInfoWrapper(testContact,true);
        
           list<CCC_CTIContactPageController.PHDBInfoWrapper>phdbwraplist= new list<CCC_CTIContactPageController.PHDBInfoWrapper>();
           phdbwraplist.add(phdbwrap);
           testController.lstDisNum=phdbwraplist;
           phdbwrap.registrationDataResults=phdbwraplist;
           testController.PHDBContactsInfo=phdbwraplist;
           
           testController.getPHDBContactInfo(Lastname,Street,Phone,PostalCode,firstName,City,ConfirmationNo,email);
           Contact temp = new Contact();
            temp.Accountid=testAccount.id;
            temp.Lastname='neil';
            temp.FirstName='nitin';
   
            RecordType rt = [select id,Name from RecordType where SobjectType='Contact' and Name='Residential Contact' Limit 1];
            temp.recordTypeId=rt.id;
            temp.Phone='9876543210';
            temp.MailingCountry=''; 
            temp.MailingPostalcode=''; 
            temp.Email='';
            insert temp;
            
           testController.save();
        }
        Test.stopTest();
        
    }//getPHDBContactInfoTest()
     public static TestMethod void getPHDBContactInfoTestWithParam()
    {
        setData();
        Test.startTest();
        System.runAs(testUser)
        {
            Contact temp = new Contact();
            temp.Accountid=testAccount.id;
            temp.Lastname='neil';
            temp.FirstName='nitin';
   
            RecordType rt = [select id,Name from RecordType where SobjectType='Contact' and Name='Non-Residential Contact' Limit 1];
            temp.recordTypeId=rt.id;
            temp.Phone='9876543210';
            temp.MailingCountry=''; 
            temp.MailingPostalcode='';
            temp.mailingStreet='31,DSW Road'; 
            temp.Email='';
            insert temp;
            ApexPages.currentPage().getParameters().put('isResidential1','false');
            ApexPages.currentPage().getParameters().put('phoneFromURL1','9876543210');
            ApexPages.currentPage().getParameters().put('ResidentialFlagFromURL','true');
            ApexPages.currentPage().getParameters().put('ResidentialFromURL','true');
            
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           
           // Set mock callout class for http callouts
           Test.setMock(HttpCalloutMock.class, new  CCC_HttpResponseGeneratorCTITest());
           
           //insert null value in phdbwraplist
           CCC_CTIContactPageController.PHDBInfoWrapper phdbwrap= new CCC_CTIContactPageController.PHDBInfoWrapper(testContact,true);
        
           list<CCC_CTIContactPageController.PHDBInfoWrapper>phdbwraplist= new list<CCC_CTIContactPageController.PHDBInfoWrapper>();
           phdbwraplist.add(phdbwrap);
           testController.lstDisNum=phdbwraplist;
           phdbwrap.registrationDataResults=phdbwraplist;
           testController.PHDBContactsInfo=phdbwraplist;
           
           testController.getPHDBContactInfo(Lastname,Street,Phone,PostalCode,firstName,City,ConfirmationNo,email);
           testController.searchId='true';
           testController.contactSearch();
           testController.uniqueContactId=temp.id;
           
            testController.populateDetails();
           testController.save();
           testController.clearDetails();
           
          }
        Test.stopTest();
        
    }
    //save : Method creating Account ,Contact 
     public static TestMethod void saveTestContAndAcctOnly()
    {
        setData();
        Test.startTest();
      System.runAs(testUser)
       {
           ApexPages.currentPage().getParameters().put('ResidentialFromURL','false');
           CCC_CTIContactPageController testController=new CCC_CTIContactPageController();
           testController.selectedCaseType=testCase.recordTypeId;
           testController.SaveContactandAccount();
           Account testAccount1=new Account();
            RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Residential Address' Limit 1];
            testAccount1.recordTypeId=rt2.id;
            testAccount1.Phone='123';
            testAccount1.BillingCountry='USA';
            testAccount1.Name='Test Account';
            //testAccount=(Account)utilClass.createTestRecord(testAccount);
            insert testAccount1;
   
           Contact temp = new Contact();
            temp.Accountid=testAccount.id;
            temp.Lastname='Niel123';
            temp.FirstName='nitin123';
   
            RecordType rt = [select id,Name from RecordType where SobjectType='Contact' and Name='Residential Contact' Limit 1];
            temp.recordTypeId=rt.id;
            temp.Phone='123123';
            temp.MailingCountry=''; 
            temp.MailingPostalcode='123123'; 
            temp.Email='';
            //insert temp;
           
          
           testController.contact=temp ;
           testController.isResidential=true;
           PageReference pgref = Page.CCC_CTIContactPage;
           pgref.getParameters().put('id',testCase.id);
           Test.setCurrentPage(pgref);
           PageReference ListConTest = testController.SaveContactandAccount();
           //System.assertEquals(null,ListConTest);
           
       }
        Test.stopTest();
        
    }
}