@isTest
public class CCC_ViewCaseControllerTest{

    public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
    Public static User testusr1,testusr2,testusr3,testusr4;

    public static void setupData()
    {
        RecordType rt1 = [select id,Name from RecordType where SobjectType='Account' and Name='Partner' Limit 1];

        Account acc=new Account(Name='TestClassAcc1',recordTypeId=rt1.id);
        insert acc;
     
        Contact con =new Contact(FirstName='Vandan',LastName='Tewari',AccountId= acc.id);
        insert con;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner Community DSM'];
        
        testusr1= new User( email='test3.user@gmail.com',profileid = p.id, UserName='test3.user@gmail.com', 
                    Alias = 'GDS',  TimeZoneSidKey='America/New_York',EmailEncodingKey='ISO-8859-1',    LocaleSidKey='en_US', LanguageLocaleKey='en_US',    ContactId = con.id,
                    PortalRole = 'Executive',   FirstName = 'test3',LastName = 'user3', isActive=true);
                    
                    insert testusr1;

                           
    }//method  setupData()

    static testMethod void testConstructor()
    {
        setupData();
        Test.startTest();

        System.runAs(testusr1)
        {
           System.debug('current user account id=' + testusr1.contact.AccountId);
           CCC_ViewCaseController vcc= new CCC_ViewCaseController();
           vcc.getSortedListToDisplay();
         
           System.assertEquals(true,vcc.isShowCreateCaseButton);
        }

        Test.stopTest();

    }// testConstructor()
    
     public static void setupData2()
    {
        RecordType rt1 = [select id,Name from RecordType where SobjectType='Account' and Name='Partner' Limit 1];

        Account acc=new Account(Name='TestClassAcc1',recordTypeId=rt1.id);
        insert acc;
     
        Contact con =new Contact(FirstName='Vandan',LastName='Tewari',AccountId= acc.id);
        insert con;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Wipro Community'];
        
        testusr1= new User( email='test23.user@gmail.com',profileid = p.id, UserName='test23.user@gmail.com', 
                    Alias = 'GDS',  TimeZoneSidKey='America/New_York',EmailEncodingKey='ISO-8859-1',    LocaleSidKey='en_US', LanguageLocaleKey='en_US',    ContactId = con.id,
                    PortalRole = 'Executive',   FirstName = 'test3',LastName = 'user3', isActive=true);
                    
                    insert testusr1;

                           
    }//method  setupData()

    static testMethod void testConstructor2()
    {
        setupData2();
        Test.startTest();

        System.runAs(testusr1)
        {
           System.debug('current user account id=' + testusr1.contact.AccountId);
           CCC_ViewCaseController vcc= new CCC_ViewCaseController();
           vcc.getSortedListToDisplay();
         
           System.assertEquals(false,vcc.isShowCreateCaseButton);
        }

        Test.stopTest();

    }// testConstructor()
    
         public static void setupData3()
    {
        RecordType rt1 = [select id,Name from RecordType where SobjectType='Account' and Name='Partner' Limit 1];

        Account acc=new Account(Name='TestClassAcc1',recordTypeId=rt1.id);
        insert acc;
     
        Contact con =new Contact(FirstName='Vandan',LastName='Tewari',AccountId= acc.id);
        insert con;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Ecobee Community'];
        
        testusr1= new User( email='test123.user@gmail.com',profileid = p.id, UserName='test123456.user@gmail.com', 
                    Alias = 'GDS',  TimeZoneSidKey='America/New_York',EmailEncodingKey='ISO-8859-1',    LocaleSidKey='en_US', LanguageLocaleKey='en_US',    ContactId = con.id,
                    PortalRole = 'Executive',   FirstName = 'test3',LastName = 'user3', isActive=true);
                    
                    insert testusr1;

                           
    }//method  setupData()

    static testMethod void testConstructor3()
    {
        setupData3();
        Test.startTest();

        System.runAs(testusr1)
        {
           System.debug('current user account id=' + testusr1.contact.AccountId);
           CCC_ViewCaseController vcc= new CCC_ViewCaseController();
           vcc.getSortedListToDisplay();
          // vcc.displayMyAccountCaseList();
         
           System.assertEquals(false,vcc.isShowCreateCaseButton);
        }

        Test.stopTest();

    }// testConstructor()

}//class TestViewCaseController