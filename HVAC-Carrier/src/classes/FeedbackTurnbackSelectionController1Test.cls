@isTest
public class FeedbackTurnbackSelectionController1Test {

    public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
    
    public static User testusr1;
    public static Contact testCon1;
    public static Case testCase1;
    public static Account testAcc;
    public static Case[] newCase;
    public static String caseId;
    public static Turnback__c testturnback;
    //public static CaseTurnBackJunction__c junction;
    //public static List<CaseTurnBackJunction__c> listOfCaseTurnBackJunction;
    
    public static Case caseRec ,caserec2;
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
        //Case[] newCase = [select id,subject from Case];

        
        testturnback=new turnback__c();
        testturnback.Title__c = 'Test';
        testturnback.Description__c = 'Test';
        testturnback.Type__c='Systems';
        testturnback.Sub_Type__c='SAP';
        //insert testturnback;
        
        
        
        }
        
        
        
          // This method will test the controller's constructor functionality
    public static testMethod void FeedbackTurnbackSelectionController1Test()
    {   
        setupData();
        Test.startTest();
        
        System.runAs(testusr1)
        {
            
            //set the caseid of controller      
            System.currentPageReference().getParameters().put('id',testCase1.id);
            
            
            //listOfCaseTurnBackJunction = new  List<CaseTurnBackJunction__c>();
            
            //call for the constructors 
           ApexPages.StandardController casecontroller1 = new ApexPages.StandardController(testCase1);
          FeedbackTurnbackSelectionController1  ft =new FeedbackTurnbackSelectionController1(casecontroller1);
            ft.turnback = testturnback;
            ft.selectedTurnbackId = '';
            ft.saveTurnbackAndJunction();
            ft.cancelOrClose();
            ft.redirectToCaseDetail();
            
           //ft.getCurrentTurnbacklist();
           }
           Test.stopTest();
            


}
    public static testMethod void FeedbackTurnbackSelectionController1Test2()
    {   
        setupData();
        Test.startTest();
        
        System.runAs(testusr1)
        {
            
            //set the caseid of controller      
            System.currentPageReference().getParameters().put('id',testCase1.id);
            
            
            //listOfCaseTurnBackJunction = new  List<CaseTurnBackJunction__c>();
            
            //call for the constructors 
           ApexPages.StandardController casecontroller1 = new ApexPages.StandardController(testCase1);
          FeedbackTurnbackSelectionController1  ft =new FeedbackTurnbackSelectionController1(casecontroller1);
            testturnback.Type__c='';
            ft.turnback = testturnback;
            ft.selectedTurnbackId = '';
            ft.saveTurnbackAndJunction();
            ft.cancelOrClose();
            ft.redirectToCaseDetail();
            
           //ft.getCurrentTurnbacklist();
           }
           Test.stopTest();
            


}
    public static testMethod void FeedbackTurnbackSelectionController1SubTypeEmpty()
    {   
        setupData();
        Test.startTest();
        
        System.runAs(testusr1)
        {
            
            //set the caseid of controller      
            System.currentPageReference().getParameters().put('id',testCase1.id);
            
            
            //listOfCaseTurnBackJunction = new  List<CaseTurnBackJunction__c>();
            
            //call for the constructors 
           ApexPages.StandardController casecontroller1 = new ApexPages.StandardController(testCase1);
          FeedbackTurnbackSelectionController1  ft =new FeedbackTurnbackSelectionController1(casecontroller1);
            testturnback.Sub_Type__c='';
            ft.turnback = testturnback;
            ft.selectedTurnbackId = '';
            ft.saveTurnbackAndJunction();
            ft.cancelOrClose();
            ft.redirectToCaseDetail();
            
           //ft.getCurrentTurnbacklist();
           }
           Test.stopTest();
            


}
    public static testMethod void FeedbackTurnbackSelectionController1TitleEmpty()
    {   
        setupData();
        Test.startTest();
        
        System.runAs(testusr1)
        {
            
            //set the caseid of controller      
            System.currentPageReference().getParameters().put('id',testCase1.id);
            
            
            //listOfCaseTurnBackJunction = new  List<CaseTurnBackJunction__c>();
            
            //call for the constructors 
           ApexPages.StandardController casecontroller1 = new ApexPages.StandardController(testCase1);
          FeedbackTurnbackSelectionController1  ft =new FeedbackTurnbackSelectionController1(casecontroller1);
            testturnback.Title__c='';
            ft.turnback = testturnback;
            ft.selectedTurnbackId = '';
            ft.saveTurnbackAndJunction();
            ft.cancelOrClose();
            ft.redirectToCaseDetail();
            
           //ft.getCurrentTurnbacklist();
           }
           Test.stopTest();
            


}
}