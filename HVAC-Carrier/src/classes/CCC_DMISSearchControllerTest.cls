@isTest

public class CCC_DMISSearchControllerTest
{
public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();

public static User testusr1,testusr2;
public static Contact testCon1,testCon2;
public static  Case testCase1,testcase2;
public static CCC_Suggested_Documents__c suggdoc;

public static Integer resultCount;
public static String DocumentType;
public static String contentType;

public static CCC_IntegrationEndPoint__c endpoint;
 
public static void setupData()
{

  testCon1=(Contact)utilClass.setUpData(new Contact());
           testCon1.FirstName='Suchita';
           testCon1.LastName='Tewari';
           testCon1=(Contact)utilClass.createTestRecord(testCon1);
           
 
           
  Profile testprof1=[SELECT Id FROM Profile WHERE Name='Partner Community Warranty Admin'];
  
  
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
                
   
    
     testCase1=(Case)utilClass.setUpData(new Case());
          testCase1.Subject='TestDIMSCase';
          testCase1.Origin='Email';
          testCase1.Status='Open';
          testCase1.CCC_Brand__c='Bryant';
          testCase1.CCC_Model_Number__c='561'; 
          testCase1.ContactId=testCon1.id;
          testCase1=(Case)utilClass.createTestRecord(testCase1);
          
   suggdoc= new CCC_Suggested_Documents__c();
        // suggdoc.Name='663A Heat Pump Unit';
         suggdoc.CCC_Document_Title__c='663A Heat Pump Unit';
         suggdoc.CCC_Size__c='17157';
         suggdoc.CCC_Document_URL__c='http://staging.dms.hvacpartners.com/docs/1009/Public/03/SP02-9.pdf';
         suggdoc.CCC_Access_Level__c='Public';
         suggdoc.CCC_Case__c=testCase1.id;
    
        insert suggdoc;
        
          //create new custom setting;
          endpoint= new CCC_IntegrationEndPoint__c();
          endpoint.Name='DMIS_Search';
          endpoint.UserName__c='app_salesforce';
          endpoint.Password__c='mypwd';
          endpoint.Token__c='b5563182-208c-4667-adc0-5592c75a8f89';
          endpoint.URL__c='http://sharedservices.carrier.com/BlackJackRestService/search?';  
           
          insert endpoint;
    
}//setupData()

static testMethod void testConstructor()
{
    setupData();
    Test.startTest();
    System.runAs(testusr1)
    {
        resultCount=20;
        DocumentType ='Brochures';
        
 //instantiating CCC_DMISSearchController using constructors       
        CCC_DMISSearchController dims1=new CCC_DMISSearchController();
    
        ApexPages.StandardController casecontroller = new ApexPages.standardController(testCase1);
        CCC_DMISSearchController dims2=new CCC_DMISSearchController(casecontroller);
        System.assertEquals(false,dims2.showDocumentResult);
       
 //creating object of DocumentDetail wrapper class and inserting record in it
        CCC_DMISSearchController.DocumentDetails wrapdims= new CCC_DMISSearchController.DocumentDetails();//call for the wrapper class
           wrapdims.DocumentTitle='663A Heat Pump Unit';
           wrapdims.DocumentSize='17157';
           wrapdims.DocumentBaseURL='http://staging.dms.hvacpartners.com/docs/1009/Public/03/SP02-9.pdf';
           wrapdims.AccessLevel='Public';
           wrapdims.isSelected=true;
           wrapdims.DocumentPath='public';
           wrapdims.id='';
         // wrapdims.Type='{}';
         //  wrapdims.Subtype='';
           wrapdims.BrandFamily='';
          // wrapdims.Brands='';
           wrapdims.DMSCategory='';
           wrapdims.DMSType='';
           wrapdims.CatalogueNumber='';
           wrapdims.Status='';
         //  wrapdims.ModelNumbers='';
           wrapdims.DocumentMIMEType='';
        //   wrapdims.Verticals='';
           wrapdims.Language='';
           wrapdims.Country='';
           wrapdims.PublishedDate='';
           wrapdims.Region='';
           wrapdims.PrintDate='';
           wrapdims.Author='';
           wrapdims.ModelCategory='';
           wrapdims.PartNumber='';
           wrapdims.Category='';
           wrapdims.SubCategory='';          
       
       
        list<CCC_DMISSearchController.DocumentDetails> wraplist =new list<CCC_DMISSearchController.DocumentDetails>();    
            wraplist.add(wrapdims);         
            
 // Set mock callout class for http callouts
        Test.setMock(HttpCalloutMock.class, new CCC_HttpResponseGeneratorDimsTest());

 // initiating variables for  getDocumentInformation()
        dims2.objCase=testCase1;
        dims2.docInfo_resultCount=resultCount;
        dims2.docInfo_DocumentType=DocumentType;
     
        dims2.CaseId=testCase1.id;//CaseId for getExitingRecords() which calls addSuggetedDocument()
        testcase2=dims2.getExitingRecords();
       
 //call for method showMoreDocuments() which calls getDocumentDetail()
         PageReference pgref3 = Page.CCC_DMISSearch;
         pgref3.getParameters().put('id',testCase1.id);
         Test.setCurrentPage(pgref3);
         PageReference result3=dims2.showMoreDocuments();
         System.assertEquals(null,result3);
                     
 //call for method getDocumentDetailCommunity() which calls addSuggetedDocumentCommunity() and showMoreDocumentsCommunity()
        dims2.getDocumentDetailCommunity();
        
 //call for method doCancelCommunity() 
         PageReference pgref2 = Page.CCC_CommunityDMISSearch;
         pgref2.getParameters().put('id',testCase1.id);
         Test.setCurrentPage(pgref2);      
         PageReference result2=dims2.doCancelCommunity();
         System.assertNotEquals(null, result2); 
     
         dims2.lstDocs = wraplist;
         dims2.suggDocs = wraplist;
         
//call for method SuggestedDocumentCommunity() 
         PageReference pgref4 = Page.CCC_CommunityDMISSearch;
         pgref4.getParameters().put('id',testCase1.id);
         Test.setCurrentPage(pgref4);
         System.debug('########'+dims2.lstDocs[0].AccessLevel);
         PageReference result4=dims2.SuggestedDocumentCommunity();
         System.assertNotEquals(null, result4);
       
 //call for method SuggestedDocument()   
         PageReference pgref = Page.CCC_DMISSearch;
         pgref.getParameters().put('id',testCase1.id);
         Test.setCurrentPage(pgref);
         dims2.lstDocs = wraplist;
         PageReference result=dims2.SuggestedDocument();
         System.assertEquals(null, result);
     
    }//user1
    
    
    Test.stopTest();

}//testConstructor()

}// class TestCCCDocumentInfromationController