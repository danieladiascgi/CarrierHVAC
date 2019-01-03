@isTest (SeeAllData=True)
public class CCC_CaseTriggerHandlerTest1
{
    public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
 
    public static CCC_CaseTriggerHandler testclass = new CCC_CaseTriggerHandler();
 
    public static case testcase,testCase1;
    public static boolean flag=true;
    public static Account testAcc;
    public static Contact testCon;
    public static Contact testCon1;
    public static Contact testCon2,testCont;
    public static List<Contact> testConList;
    public static User testUsr1,testUsr2,testUsrwarranty,testUsr,wrnty1user,tier1user;
    public static void setUpData()
 
     {
          //insert new account     
          // testAcc=(Account) utilClass.createTestRecord(utilClass.setupdata(new Account()));
          testAcc=(Account)utilClass.setUpData(new Account());
          testAcc.Type='Distributor';
          testAcc.CCC_Email_Address__c='test@testing.com';
          testAcc.Phone='1111111111';
          testAcc=(Account)utilClass.createTestRecord(testAcc);
 
        //insert in contact
        testCon=(Contact)utilClass.setUpData(new Contact());
               testCon.FirstName='Testclass';
               testCon.LastName='Contact';
              testCon.AccountId=testAcc.id;
               testCon.Title='DSM';
               testCon.CCC_Distributor__c=testCon.AccountId;
        testCon=(Contact)utilClass.createTestRecord(testCon);
       
        Account acc = new Account();
             acc.name='1815700 ONTARIO INC. O/A MAZZA HEATING & AIR COND.';
             acc.Type='Distributor';
             insert acc;
            
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner Community DSM'];
        
         testUsr=new User( email='test.user@gmail.com',
                    profileid = p.id,
                    UserName='test1.user@gmail.com',
                    Alias = 'GDS',
                    TimeZoneSidKey='America/New_York',
                    EmailEncodingKey='ISO-8859-1',
                    LocaleSidKey='en_US',
                    LanguageLocaleKey='en_US',
                    ContactId = testCon.id,
                    PortalRole = 'Manager',
                    FirstName = 'test',
                    LastName = 'user');
            
             insert testUsr;
            
             testCase1=(Case)utilClass.setUpData(new Case());
             testCase1.Subject='ClassCase';
             testCase1.Origin='Email';
             testCase1.Status='Open';
             testCase1.Contactid=testCon.id;
             testCase1.CCC_Distributor_Name__c=testCon.CCC_Distributor__c;
             testCase1=(Case)utilClass.createTestRecord(testCase1);
            
             
    }
 
 
    public static void setupData2()
{

                //create new account
           testAcc=(Account)utilClass.setUpData(new Account());
           testAcc.BillingPostalCode='1234567';
           insert testAcc;

                //create new contact
           testCont=(Contact)utilClass.setUpData(new Contact());
           testCont.FirstName='Diksha';
           testCont.LastName='Tewari';
           testCont.AccountId=testAcc.id;
           insert testCont;
           
                   //create new user      
                Profile testprof1=[SELECT Id FROM Profile WHERE Name='Partner Community-Warranty/DSM'];
  
                wrnty1user=new User( email='knowledge11.user@gmail.com',
                profileid = testprof1.id,  
                UserName='knowledge11.user@wipro.com', 
                Alias = 'GDS1',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = testCont.id,
                PortalRole = 'Manager',
                FirstName = 'test1',
                LastName = 'user1');       
                insert wrnty1user;
                
                 //Create a case
                testCase1=(Case)utilClass.setUpData(new Case());
                testCase1.CCC_Purpose__c='Programs';
                testCase1.CCC_Purpose_Tier1_CR__c='Programs';
                testCase1.CCC_Equipment_Purpose__c='Programs';
                testCase1.CCC_WarrantyCommunity_Purpose__c='Programs';
                testCase1.CCC_Sub_Purpose_Tier1_CR__c='Programs';
                testCase1.CCC_WarrantyCommunity_Sub_Purpose__c='Programs'; 
                testCase1.Subject='TestDealerCase';
                testCase1.Origin='Email';
                testCase1.Status='Open';
                testCase1.CCC_Brand__c='Bryant';
                testCase1.CCC_Model_Number__c='561'; 
                testCase1.AccountId=testAcc.id;
                testCase1.ContactId=testCont.id;
                insert testCase1;
                
                Email_To_Case_Source__c e2cSrc = new Email_To_Case_Source__c();
                e2cSrc.Email_Address__c = 'test@test.com';
                e2cSrc.Name = 'test';
                e2cSrc.Source_Value__c = 'Email';
                insert e2cSrc;
                
                CaseShare caseShare = new CaseShare();
                 Case_Share__c caseShareRecord=new Case_Share__c(); 
                caseShare.CaseId = testCase1.id;
                caseShareRecord.Case_ID__c=testCase1.id;
                caseShare.UserOrGroupId = wrnty1user.Id;
                caseShareRecord.Name__c=wrnty1user.Id;
                caseShare.CaseAccessLevel = 'Edit';
                caseShareRecord.Case_Access__c= 'Edit';
                caseShare.RowCause='Manual';
                caseShareRecord.Reason__c='Manual';
                insert caseShare;
                insert caseShareRecord;
                
                AccountTeamMember accTeamMmbr = new AccountTeamMember();
                accTeamMmbr.UserId = wrnty1user.id;
                accTeamMmbr.TeamMemberRole = 'TSM';
                accTeamMmbr.AccountId = testAcc.id;
                insert accTeamMmbr;

  }
  
  /*public static testMethod void CoverPSPWarranty()
    {
         setupData2();
        Test.startTest();
        System.runAs(wrnty1user){
            Case cases = new Case();
            cases.CCC_Purpose__c='Programs';
            cases.CCC_Purpose_Tier1_CR__c='Programs';
            cases.CCC_Equipment_Purpose__c='Programs';
            cases.CCC_WarrantyCommunity_Purpose__c='Programs';
            cases.CCC_Sub_Purpose_Tier1_CR__c='Programs';
            cases.CCC_WarrantyCommunity_Sub_Purpose__c='Programs';    
            cases.CCC_Equipment_Category__c= 'Programs';       
            cases.Origin='Email';
            cases.Status='Open';
            cases.CCC_DSM__c='Diksha Batra';
            cases.CCC_Distributor_Name__c= testAcc.id;
            cases.CCC_Date_Time_Assigned__c =System.Now();
            insert cases;
            cases.CCC_Purpose__c='Programs1';
            cases.CCC_Purpose_Tier1_CR__c='Programs1';
            cases.CCC_Equipment_Purpose__c='Programs1';
            cases.CCC_WarrantyCommunity_Purpose__c='Programs1';
            cases.CCC_Sub_Purpose_Tier1_CR__c='Programs1';
            cases.CCC_WarrantyCommunity_Sub_Purpose__c='Programs1';    
            cases.CCC_Equipment_Category__c= 'Programs1';
            cases.CCC_Date_Time_Assigned__c =Datetime.Now();
            update cases;
        }
      Test.stopTest();
    }*/

     public static void setupData3()
{

                //create new account
           testAcc=(Account)utilClass.setUpData(new Account());
           testAcc.BillingPostalCode='1234567';
           insert testAcc;

                //create new contact
           testCont=(Contact)utilClass.setUpData(new Contact());
           testCont.FirstName='Diksha';
           testCont.LastName='Tewari';
           testCont.AccountId=testAcc.id;
           insert testCont;
           
                   //create new user      
                Profile testprof1=[SELECT Id FROM Profile WHERE Name='Tier 1 Agent Profile'];
  
                tier1user=new User( email='tier1user1.user@gmail.com',
                profileid = testprof1.id,  
                UserName='tier1user1.user@wipro.com', 
                Alias = 'GDS1',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                PortalRole = 'Manager',
                FirstName = 'test1',
                LastName = 'user1');       
                insert tier1user;
                
                 //Create a case
                testCase1=(Case)utilClass.setUpData(new Case());
                testCase1.CCC_Purpose__c='Programs';
                testCase1.CCC_Purpose_Tier1_CR__c='Programs';
                testCase1.CCC_Equipment_Purpose__c='Programs';
                testCase1.CCC_WarrantyCommunity_Purpose__c='Programs';
                testCase1.CCC_Sub_Purpose_Tier1_CR__c='Programs';
                testCase1.CCC_WarrantyCommunity_Sub_Purpose__c='Programs'; 
                testCase1.Subject='TestDealerCase';
                testCase1.Origin='Email';
                testCase1.Status='Open';
                testCase1.CCC_Brand__c='Bryant';
                testCase1.CCC_Model_Number__c='561'; 
                testCase1.AccountId=testAcc.id;
                testCase1.ContactId=testCont.id;
                insert testCase1;
  }
  
  public static testMethod void CoverPSPTier1()
    {
         setupData3();
        Test.startTest();
        System.runAs(tier1user){
            Case cases = new Case();
            cases.CCC_Purpose__c='Programs';
            cases.CCC_Purpose_Tier1_CR__c='Programs';
            cases.CCC_Equipment_Purpose__c='Programs';
            cases.CCC_WarrantyCommunity_Purpose__c='Programs';
            cases.CCC_Sub_Purpose_Tier1_CR__c='Programs';
            cases.CCC_WarrantyCommunity_Sub_Purpose__c='Programs';    
            cases.CCC_Equipment_Category__c= 'Programs';       
            cases.Origin='Email';
            cases.Status='Open';
            insert cases;
            cases.CCC_Purpose__c='Programs1';
            cases.CCC_Purpose_Tier1_CR__c='Programs1';
            cases.CCC_Equipment_Purpose__c='Programs1';
            cases.CCC_WarrantyCommunity_Purpose__c='Programs1';
            cases.CCC_Sub_Purpose_Tier1_CR__c='Programs1';
            cases.CCC_WarrantyCommunity_Sub_Purpose__c='Programs1';    
            cases.CCC_Equipment_Category__c= 'Programs1'; 
            update cases;
        }
      Test.stopTest();
    }
    
   public static testMethod void testUpdateProductDetails()
    {
        //Product2 testprod=new Product2();
        //testprod=[Select Id,Name,CCC_Compressed_Part__c,Description,CCC_CasePack__c,CCC_Buyer__c,CCC_Planner__c,CCC_WareHouse__c,CCC_ItemType__c,CCC_Vendor_Code__c,CCC_Vendor_Name__c from Product2 Limit 1];
        /*testprod.Name='Test Part';
        testprod.CCC_Compressed_Part__c='1234';
        testprod.Description='Test Description';
        testprod.CCC_CasePack__c=12;
        testprod.CCC_Buyer__c='Test Buyer';
        testprod.CCC_Planner__c='Test Planner';
        testprod.CCC_WareHouse__c='Test Warehouse';
        testprod.CCC_ItemType__c='Test Type';
        testprod.CCC_Vendor_Code__c='314';
        testprod.CCC_Vendor_Name__c='Test Name';
        testprod.CCC_Line_Type__c='Test Line';
        testprod.CCC_UnitPrice__c=120;
        insert testprod;
      */
        //testprod  = (Product2) utilClass.createTestRecord(utilClass.setupdata(new Product2()));
        //testcase = (Case)utilClass.setUpData(new Case());
        //testcase.CCC_Part__c=testprod.id;
        //testcase = (Case)utilClass.createTestRecord(testcase);
       testcase=[Select Id,CCC_Part__c,CCC_Vendor_Code__c,CCC_Part_Description__c FROM Case where CCC_Part__c != null Limit 1];
     update testcase;
       //System.assertEquals(testprod.CCC_Vendor_Code__c,testcase.CCC_Vendor_Code__c); 
       //System.assertEquals(testprod.Description,testcase.CCC_Part_Description__c);
       testcase.CCC_Part__c=null;
       update testcase;
    }
    
    
     static testMethod void testUpdateDistributorDetails()
    {     
        testacc= (Account) utilClass.createTestRecord(utilClass.setupdata(new Account()));
        testcase = (Case)utilClass.setUpData(new Case());
        testcase.CCC_Distributor_Name__c=testacc.id;
        testcase = (Case)utilClass.createTestRecord(testcase);
      
       System.debug('---------------'+testcase);
       testcase=[Select Id,CCC_Distributor_Name__c,CCC_Distributor_s_Phone_No__c ,CCC_Distributor_s_Email__c FROM Case WHERE ID =:testcase.id Limit 1];
     
       System.assertEquals(testacc.Phone,testcase.CCC_Distributor_s_Phone_No__c ); 
       System.assertEquals(testacc.CCC_Email_Address__c,testcase.CCC_Distributor_s_Email__c );
       testcase.CCC_Distributor_Name__c=null;
       update testcase;
    }
    
    
     static testMethod void AssigntodsmTest(){
         List<Contact> contactlist= new List<Contact>();
         List<case> caselist= new List<case>();
       
         Account acc = new Account();
             acc.name='1815700 ONTARIO INC. O/A MAZZA HEATING & AIR COND.';
             acc.Type='Distributor';
             insert acc;
        Account acc1 = new Account();
             acc1.name='O/A MAZZA HEATING & AIR COND.';
             acc1.Type='Dealer';
             insert acc1;
            
         Contact con= new Contact();
             con.accountId=acc1.id;
             con.lastname='Henderson';
             con.title='DSM';
         Contact con1= new Contact();
             con1.accountId=acc1.id;
             con1.lastname='Henderson';
             con1.title='DSM';
         Contact con2= new Contact();
             con2.accountId=acc1.id;
             con2.lastname='Henderson';
             con2.title='DSM';
           
             contactlist.add(con);
             contactlist.add(con1);
             contactlist.add(con2);
             insert contactlist;
       
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner Community DSM'];
            
        testUsr=new User( email='test.user@gmail.com',
                    profileid = p.id,
                    UserName='testCommunity.user@gmail.com',
                    Alias = 'tstcomm',
                    TimeZoneSidKey='America/New_York',
                    EmailEncodingKey='ISO-8859-1',
                    LocaleSidKey='en_US',
                    LanguageLocaleKey='en_US',
                    ContactId = con1.id,
                    PortalRole = 'Manager',
                    FirstName = 'test',
                    LastName = 'user');
            
             insert testUsr;
                 Case cases = new Case();
                 cases.CCC_Purpose__c='Programs';
                 cases.CCC_Sub_Purpose__c='Programs1';
                 cases.Origin='Email';
                 cases.OwnerID = testUsr.id;
                 cases.Status='Open';
                 cases.accountId=acc.Id;
                 cases.contactId=con.id;
                 cases.CCC_Distributor_Name__c=acc.id;
                 cases.CCC_Dealer_Name__c=acc.id;
                 insert cases;
                 caselist.add(cases);
                
             
        AccountTeamMember atm = new AccountTeamMember();
        atm.UserId  = testUsr.id;
        atm.AccountId = acc.id;
        atm.TeamMemberRole = 'TSM';
        insert atm;
        
    } 
    
        static testMethod void getLocalDateTimeTest()
    {
    test.StartTest();
    CCC_CaseTriggerHandler.getLocalDateTime(Datetime.Now());
    test.StopTest();
    
    }
}