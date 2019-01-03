@isTest
public class NA_CaseTriggerHandlerTest {
public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
    
    public static Account testAcc;
    public static case testcase,testCase1;
    public static User testUsr; 
    public static void setUpData()
 
     {
          //insert new account     
          // testAcc=(Account) utilClass.createTestRecord(utilClass.setupdata(new Account()));
          testAcc=(Account)utilClass.setUpData(new Account());
          testAcc.Type='Distributor';
          testAcc.CCC_Email_Address__c='test@testing.com';
          testAcc.Phone='1111111111';
          testAcc.NxTrend_Customer_Distributor__c = '1111';
          //testAcc=(Account)utilClass.createTestRecord(testAcc);
 	      insert testAcc;	
        //insert in contact
      
        Account acc = new Account();
             acc.name='1815700 ONTARIO INC. O/A MAZZA HEATING & AIR COND.';
             acc.Type='Distributor';
            // insert acc;
            
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner Community DSM'];
        
         testUsr=new User( email='test.user@gmail.com',
                    profileid = p.id,
                    UserName='test1.user@gmail.com',
                    Alias = 'GDS',
                    TimeZoneSidKey='America/New_York',
                    EmailEncodingKey='ISO-8859-1',
                    LocaleSidKey='en_US',
                    LanguageLocaleKey='en_US',
      //              ContactId = testCon.id,
                    PortalRole = 'Manager',
                    FirstName = 'test',
                    LastName = 'user');
            
            // insert testUsr;
            
             testCase1=(Case)utilClass.setUpData(new Case());
             testCase1.Subject='ClassCase';
             testCase1.Origin='Email';
             testCase1.Status='Open';
        //     testCase1.Contactid=testCon.id;
          //   testCase1.CCC_Distributor_Name__c=testCon.CCC_Distributor__c;
             //testCase1=(Case)utilClass.createTestRecord(testCase1);
         testCase1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('National Accounts').getRecordTypeId();
            insert testCase1;
             
    }
   
 	 public static testMethod void populateByDstrNumAndNxtrnd()
     {
         	setUpData();
			testCase1.Distributor_Number__c = '1111';	
         	testCase1.NxtTrend__c = '1111';
         	testCase1.CCC_Purpose__c = 'Order Processing';
         	Entitlement entl = new Entitlement (Name='National Accounts',AccountId = testAcc.Id);
         	insert entl;
           	update testCase1;
     }
    public static testMethod void populateByDstrNameAndaccName()
     {
         	setUpData();
			testCase1.CCC_Distributor_s_Name__c =testAcc.id ;	
         	testCase1.AccountId = testAcc.id ;
           	update testCase1;
     }
}