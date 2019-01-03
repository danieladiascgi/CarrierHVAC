@isTest(seeAllData=true)
public class CloseCaseTurnbackControllerTest
{
    public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
    
    public static User testusr1;
    public static Contact testCon1;
    public static Case testCase1;
    public static Account testAcc;
    public static List<SelectOption> list1,list2;
    public static Case caseRec ,caserec2;
    public static Turnback__c testturnback;
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
        testturnback=new turnback__c();
        testturnback.Title__c = 'Not Applicable';
        testturnback.Description__c = 'Test';
        testturnback.Type__c='Systems';
        testturnback.Sub_Type__c='SAP';
        insert testturnback;
        }
        
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
            CloseCaseTurnbackController  tt =new CloseCaseTurnbackController(casecontroller1);
            
             list1= tt.getStatusOptions();
             list2=tt.getResolutionCodeOptions();
         }
             
       }
       public static testMethod void cancelTest()
    {
       setupData();
       Test.startTest();
        
        System.runAs(testusr1)
        {
          ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
         CloseCaseTurnbackController ttt =new  CloseCaseTurnbackController(casecontroller1);
          ttt.cancel();
          
          PageReference pgref1 = Page.CloseCaseTurnback;
            pgref1.getParameters().put('id',testCase1.id);
            Test.setCurrentPage(pgref1);
           // PageReference result1=ttt.Detailpage();
           // System.assertNotEquals(null,result1);
            
              
         }
        
      } 
      
     
        /* public static testMethod void testsaveAndRedirect()
         {
        
        setupData();
        Test.startTest();
        System.runAs(testusr1){
                
            System.currentPageReference().getParameters().put('id',testCase1.id);
         }
           
       }*/
       
        public static testMethod void testsaveAndClose(){
        
        setupData();
        Test.startTest();
        System.runAs(testusr1){
        System.currentPageReference().getParameters().put('id',testCase1.id);
           
            System.debug('#Case in Test cls:'+caseRec);
           testCase1.status='Closed';
           caserec2 = new case();
            caserec2.Description='Test';
           
            
            //call for the constructors 
            ApexPages.StandardController casecontroller1 = new ApexPages.standardController(testCase1);
            CloseCaseTurnbackController tt =new CloseCaseTurnbackController(casecontroller1);
            tt.selectedId = testturnback.Id;
            tt.mapTbkIdKeyTbkTitleValue = new Map<String, String>();
            tt.mapTbIdKeyTbkValue = new Map<String, Turnback__c>();
            tt.mapTbkIdKeyTbkTitleValue.put(testturnback.Id, 'Not Applicable');
            tt.mapTbIdKeyTbkValue.put(testturnback.Id, testturnback);
            
            tt.saveAndClose();
           	tt.saveAndRedirect();
            tt.getResolutionCodeOptions();
            tt.tbk = testturnback;
            tt.getTurnbackOptions();
            
          
           
            PageReference pgref2 = Page.CloseCaseTurnback;
            pgref2.getParameters().put('id',testCase1.id);
            Test.setCurrentPage(pgref2);
           // PageReference result1=tt.saveAndClose();
           // System.assertEquals(null,result1);
            
            
        }//runAs(user)
       }
       }