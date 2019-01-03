@isTest

public class CCC_KnowledgeSrchControllerTestNew{
public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();

public static User testusrknow,testusrknow2;
public static Contact testCont;
public static Account testAcc;
public static  Case testCase1;


public static void setupData()
{

                //create new account
           testAcc=(Account)utilClass.setUpData(new Account());
           testAcc.BillingPostalCode='1234567';
           insert testAcc;
           //testAcc=(Account)utilClass.createTestRecord(testAcc);

                //create new contact
           testCont=(Contact)utilClass.setUpData(new Contact());
           testCont.FirstName='Diksha';
           testCont.LastName='Tewari';
           testCont.AccountId=testAcc.id;
           insert testCont;
          // testCont=(Contact)utilClass.createTestRecord(testCont); 
           
                   //create new user      
                Profile testprof1=[SELECT Id FROM Profile WHERE Name='Partner Community DSM'];
  
                testusrknow=new User( email='knowledge.user@gmail.com',
                profileid = testprof1.id,  
                UserName='knowledge.user@wipro.com', 
                Alias = 'GDS',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = testCont.id,
                PortalRole = 'Manager',
                FirstName = 'test1',
                LastName = 'user1');       
                insert testusrknow;
                
                 //Create a case
                testCase1=(Case)utilClass.setUpData(new Case());
                testCase1.Subject='TestDealerCase';
                testCase1.Origin='Email';
                testCase1.Status='Open';
                testCase1.CCC_Brand__c='Bryant';
                testCase1.CCC_Model_Number__c='561'; 
                testCase1.AccountId=testAcc.id;
                testCase1.ContactId=testCont.id;
                insert testCase1;
                //testCase1=(Case)utilClass.createTestRecord(testCase1);
                  
                CategoryTypes__c cType = new CategoryTypes__c();
                cType.name = 'test';
                cType.Display_Name__c = 'test';
                insert cType;
                
  }
    public static testMethod void testConstructor()
    {  
        CCC_KnowledgeSrchController objCls = new CCC_KnowledgeSrchController();       
          objCls.titles = 'test';
          objCls.createNewCase();
          CCC_KnowledgeSrchController.knowledgeWrapper wrp = new CCC_KnowledgeSrchController.knowledgeWrapper();
          wrp.selected = true;
          List<CCC_KnowledgeSrchController.knowledgeWrapper> lst = new List<CCC_KnowledgeSrchController.knowledgeWrapper>();
         lst.add(wrp);
          objCls.knowledgeList = lst;
          objCls.showField();
          objCls.runSearch();
          objCls.getSelected();
          objCls.cancelSearch();
        //  objCls.GetselectedKnowledge();
          objCls.createCase();
          objCls.getCaseType();
          objCls.getCategoryType();
          objCls.getknowledgeList();
          objCls.setknowledgeList();             
    } 
    
    public static testMethod void Coverage()
    {
         setupData();
        //CCC_Knowledge__kav a = new CCC_Knowledge__kav ();
        Test.startTest();
        System.runAs(testusrknow){
         CCC_KnowledgeSrchController objCls1 = new CCC_KnowledgeSrchController();
         List<CCC_KnowledgeSrchController.knowledgeWrapper> knowledgeList1 = new List<CCC_KnowledgeSrchController.knowledgeWrapper>();
         //CCC_KnowledgeSrchController.knowledgeWrapper kw = new CCC_KnowledgeSrchController.knowledgeWrapper(a);
        // kw.selected = true;
         //knowledgeList1.add(kw);
          objCls1.selectedCategoryType = 'ICP';
          objCls1.knowledgeList=knowledgeList1;
          objCls1.createNewCase();
            CCC_KnowledgeSrchController.knowledgeWrapper wrp = new CCC_KnowledgeSrchController.knowledgeWrapper();
          wrp.selected = true;
          List<CCC_KnowledgeSrchController.knowledgeWrapper> lst = new List<CCC_KnowledgeSrchController.knowledgeWrapper>();
         lst.add(wrp);
          objCls1.knowledgeList = lst;
          objCls1.showField();
          objCls1.runSearch();
          objCls1.getSelected();
          objCls1.cancelSearch();
         // objCls1.GetselectedKnowledge();
          objCls1.createCase();
          objCls1.getCaseType();
          objCls1.getCategoryType();
          objCls1.getknowledgeList();
          objCls1.setknowledgeList();
        }
      Test.stopTest();
    }
    public static testMethod void Coverage2()
    {
         setupData();
        //CCC_Knowledge__kav a = new CCC_Knowledge__kav ();
        Test.startTest();
        System.runAs(testusrknow){
         CCC_KnowledgeSrchController objCls1 = new CCC_KnowledgeSrchController();
         List<CCC_KnowledgeSrchController.knowledgeWrapper> knowledgeList1 = new List<CCC_KnowledgeSrchController.knowledgeWrapper>();
        // CCC_KnowledgeSrchController.knowledgeWrapper kw = new CCC_KnowledgeSrchController.knowledgeWrapper(a);
         //kw.selected = true;
         //knowledgeList1.add(kw);
          objCls1.selectedCategoryType = 'ICP';
          
          objCls1.knowledgeList=knowledgeList1;
          objCls1.createNewCase();
            CCC_KnowledgeSrchController.knowledgeWrapper wrp = new CCC_KnowledgeSrchController.knowledgeWrapper();
          wrp.selected = true;
          List<CCC_KnowledgeSrchController.knowledgeWrapper> lst = new List<CCC_KnowledgeSrchController.knowledgeWrapper>();
         lst.add(wrp);
          objCls1.knowledgeList = lst;
          objCls1.showField();
          objCls1.runSearch();
          objCls1.getSelected();
          objCls1.cancelSearch();
          //objCls1.GetselectedKnowledge();
          objCls1.createCase();
          objCls1.getCaseType();
          objCls1.getCategoryType();
          objCls1.getknowledgeList();
          objCls1.setknowledgeList();
        }
      Test.stopTest();
   }
   
   public static testMethod void CoverageSample()
    {
         setupData();
        //CCC_Knowledge__kav a = new CCC_Knowledge__kav ();
        Test.startTest();
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> caseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = caseRecordTypeInfo.get('Post Sale Support').getRecordTypeId();
        //Apexpages.currentPage().getParameters().put('selectedCaseType',rtId);
         //CCC_Knowledge__kav knwldge = new CCC_Knowledge__kav ();
            ///knwldge.Title = 'Test FAQ';
            //knwldge.Summary = 'KB Summary';
            //knwldge.URLName = 'SampleURLtest';
            //knwldge.PublishStatus = 'online';
            //knwldge.Language='en_US';
            //knwldge.IsVisibleInPrm = true;
            //insert knwldge ;
            //CCC_Knowledge__DataCategorySelection knwldgDataCtgrySelectn2 = new CCC_Knowledge__DataCategorySelection(DataCategoryGroupName='Visible To',parentId=knwldge.Id,Datacategoryname='ICP');
         // insert knwldgDataCtgrySelectn2 ;
            //CCC_Knowledge__kav insertedTestFaq = [Select title,Summary,UrlName,VersionNumber,Language, IsVisibleInPrm from CCC_Knowledge__kav where ID = :knwldge.Id];
         CCC_KnowledgeSrchController objCls1 = new CCC_KnowledgeSrchController();
         Apexpages.currentPage().getParameters().put('title','Sample Subject');
         objCls1.titles='Sample Subject';
         objCls1.selectedCategoryType = 'ICP';
         objCls1.selectedCaseType = rtId;
         List<CCC_KnowledgeSrchController.knowledgeWrapper> knowledgeList1 = new List<CCC_KnowledgeSrchController.knowledgeWrapper>();
        // CCC_KnowledgeSrchController.knowledgeWrapper kw = new CCC_KnowledgeSrchController.knowledgeWrapper(a);
         //kw.selected = true;
         //knowledgeList1.add(kw);
         System.runAs(testusrknow){
          //kw.knwlg = insertedTestFaq;
          objCls1.knowledgeList=knowledgeList1;
          objCls1.createNewCase();
             CCC_KnowledgeSrchController.knowledgeWrapper wrp = new CCC_KnowledgeSrchController.knowledgeWrapper();
          wrp.selected = true;
          List<CCC_KnowledgeSrchController.knowledgeWrapper> lst = new List<CCC_KnowledgeSrchController.knowledgeWrapper>();
         lst.add(wrp);
          objCls1.knowledgeList = lst;
          objCls1.showField();
          objCls1.runSearch();
          objCls1.getSelected();
          objCls1.cancelSearch();
          //objCls1.GetselectedKnowledge();
          objCls1.createCase();
          objCls1.getCaseType();
          objCls1.getCategoryType();
          objCls1.getknowledgeList();
          objCls1.setknowledgeList();
        }
      Test.stopTest();
   }
}