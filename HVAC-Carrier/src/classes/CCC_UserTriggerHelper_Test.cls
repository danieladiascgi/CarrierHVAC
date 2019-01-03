@isTest
private class CCC_UserTriggerHelper_Test {

    public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();          
    public static User testusr1,testusr2,testusr3,testusr4,testusr5;
    public static Contact testCon1,testCon2,testCon3,testCon4,testCon5;
    public static  Case testCase1;    
    public static void setupData(){ 
        
        testCon1=(Contact)utilClass.setUpData(new Contact());
        testCon1.FirstName='Suchita';
        testCon1.LastName='Tewari';
        testCon1=(Contact)utilClass.createTestRecord(testCon1);           
        
        /*testCon2=(Contact)utilClass.setUpData(new Contact());
        testCon2.FirstName='test2';
        testCon2.LastName='qwe';
        testCon2=(Contact)utilClass.createTestRecord(testCon2);  
        
        testCon3=(Contact)utilClass.setUpData(new Contact());
        testCon3.FirstName='tes3';
        testCon3.LastName='sdfg';
        testCon3=(Contact)utilClass.createTestRecord(testCon3);  
        
        testCon4=(Contact)utilClass.setUpData(new Contact());
        testCon4.FirstName='tes4';
        testCon4.LastName='ghj';
        testCon4=(Contact)utilClass.createTestRecord(testCon4);  
        
        testCon5=(Contact)utilClass.setUpData(new Contact());
        testCon5.FirstName='test5';
        testCon5.LastName='hkl';
        testCon5=(Contact)utilClass.createTestRecord(testCon5);*/  
           
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='Partner Community Warranty Admin'];
        Profile testprof2=[SELECT Id FROM Profile WHERE Name='Partner Community DSM'];
        Profile testprof3=[SELECT Id FROM Profile WHERE Name='Partner Community-Warranty/DSM'];
        Profile testprof4=[SELECT Id FROM Profile WHERE Name='Wipro Community'];
        Profile testprof5=[SELECT Id FROM Profile WHERE Name='Ecobee Community'];
        
        testusr1=new User( email='test.user1@gmail.com',
        profileid = testprof1.id,  
        UserName='test7.user@gmail.com', 
        Alias = 'GDS',
        TimeZoneSidKey='America/New_York',
        EmailEncodingKey='ISO-8859-1',
        LocaleSidKey='en_US', 
        LanguageLocaleKey='en_US',
        ContactId = testCon1.id,
        PortalRole = 'Manager',
        FirstName = 'test1',
        LastName = 'user1'); 
        insert testusr1;                           
        /*
        testusr2=new User( email='test.user2@gmail.com',
        profileid = testprof2.id,  
        UserName='test2.user@gmail.com', 
        Alias = 'GDS1',
        TimeZoneSidKey='America/New_York',
        EmailEncodingKey='ISO-8859-1',
        LocaleSidKey='en_US', 
        LanguageLocaleKey='en_US',
        ContactId = testCon2.id,
        PortalRole = 'Manager',
        FirstName = 'test2',
        LastName = 'user2'); 
        insert testusr2;   
        
        testusr3=new User( email='test.user3@gmail.com',
        profileid = testprof3.id,  
        UserName='test3.user@gmail.com', 
        Alias = 'GDS3',
        TimeZoneSidKey='America/New_York',
        EmailEncodingKey='ISO-8859-1',
        LocaleSidKey='en_US', 
        LanguageLocaleKey='en_US',
        ContactId = testCon3.id,
        PortalRole = 'Manager',
        FirstName = 'test3',
        LastName = 'user3'); 
        insert testusr3; 
        
        testusr4=new User( email='test.user4@gmail.com',
        profileid = testprof4.id,  
        UserName='test4.user@gmail.com', 
        Alias = 'GDS4',
        TimeZoneSidKey='America/New_York',
        EmailEncodingKey='ISO-8859-1',
        LocaleSidKey='en_US', 
        LanguageLocaleKey='en_US',
        ContactId = testCon4.id,
        PortalRole = 'Manager',
        FirstName = 'test4',
        LastName = 'user4'); 
        insert testusr4;
         
        testusr5=new User( email='test.user5@gmail.com',
        profileid = testprof5.id,  
        UserName='test5.user@gmail.com', 
        Alias = 'GDS5',
        TimeZoneSidKey='America/New_York',
        EmailEncodingKey='ISO-8859-1',
        LocaleSidKey='en_US', 
        LanguageLocaleKey='en_US',
        ContactId = testCon5.id,
        PortalRole = 'Manager',
        FirstName = 'test5',
        LastName = 'user5'); 
        insert testusr5;*/
        
        testCase1=(Case)utilClass.setUpData(new Case());
        testCase1.Subject='TestDIMSCase';
        testCase1.Origin='Email';
        testCase1.Status='Open';
        testCase1.CCC_Brand__c='Bryant';
        testCase1.CCC_Model_Number__c='561'; 
        testCase1.ContactId=testCon1.id;
        testCase1=(Case)utilClass.createTestRecord(testCase1);  
                
    }//setupData()
        
    static testMethod void sharewithCaseTest(){
        setupData();                        
        test.startTest();      
        System.runAs(testusr1){
            List<String> contactlist = new List<String>(); 
            contactlist.add(testCase1.Contactid);   
            List<ContactShare> contshares = new List<ContactShare>();    
            ContactShare conShare = new ContactShare(Contactid=contactlist[0],ContactAccessLevel = 'Edit',UserOrGroupId = testusr1.Id);
            contshares.add(conShare);
            string gCalJSONcon = JSON.serialize(contshares);      
            
            List<CaseShare> CAseshares = new List<CaseShare>();
            CaseShare casShare = new CaseShare(Caseid=testCase1.Id,CaseAccessLevel = 'Edit',UserOrGroupId = testusr1.Id,RowCause='Manual');
            CAseshares.add(casShare);
            string gCalJSONCase = JSON.serialize(CAseshares);
            
            /*AccountShare accShare = new AccountShare(Accountid=accobj,AccountAccessLevel = 'Edit',OpportunityAccessLevel = 'Edit',UserOrGroupId = testusr1.Id);
            string gCalJSONAcc = JSON.serialize(accShare);*/
    
            CCC_UserTriggerHelper cUTH = new CCC_UserTriggerHelper();
            //CCC_UserTriggerHelper.sharewithCase('test','account');
            CCC_UserTriggerHelper.sharewithCase(gCalJSONCase,'Case');
            CCC_UserTriggerHelper.sharewithCase(gCalJSONcon,'Contact');
        }   
        test.stopTest();        
    }
    static testMethod void AddToGroupsTest(){
        setupData();                        
        test.startTest();      
        System.runAs(testusr1){
            List<String> contactlist = new List<String>(); 
            contactlist.add(testCase1.Contactid);   
            List<ContactShare> contshares = new List<ContactShare>();    
            ContactShare conShare = new ContactShare(Contactid=contactlist[0],ContactAccessLevel = 'Edit',UserOrGroupId = testusr1.Id);
            contshares.add(conShare);
            string gCalJSONcon = JSON.serialize(contshares);
            CCC_UserTriggerHelper cUTH = new CCC_UserTriggerHelper();
            CCC_UserTriggerHelper.AddToGroups(gCalJSONcon);
        }   
        test.stopTest();        
    }
}