@isTest

public class DMIS_Search_test
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
           
  Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
  
  
    testusr1=new User( email='test.user2712171@gmail.com',
                profileid = testprof1.id,  
                UserName='test2712171.user@gmail.com', 
                Alias = 'GDS',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                //ContactId = testCon1.id,
                //PortalRole = 'Manager',
                FirstName = 'test2712171',
                LastName = 'user2712171');
         
                insert testusr1;
                
   
  System.runAs(testusr1){  
     testCase1=(Case)utilClass.setUpData(new Case());
          testCase1.Subject='TestDIMSCase';
          testCase1.Origin='Email';
          testCase1.Status='Open';
          testCase1.CCC_Brand__c='Bryant';
          testCase1.CCC_Model_Number__c='561'; 
          //testCase1.ContactId=testCon1.id;
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
   }
    
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
        DMIS_Controller dims1 = new DMIS_Controller();
    
        //ApexPages.StandardController casecontroller = new ApexPages.standardController(testCase1);
        DMIS_Controller dims2=new DMIS_Controller();
        //System.assertEquals(false,DMIS_Controller.showDocumentResult);
       
 //creating object of DocumentDetail wrapper class and inserting record in it
        DMIS_Controller.DocumentDetails wrapdims= new DMIS_Controller.DocumentDetails();//call for the wrapper class
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
       
       
        list<DMIS_Controller.DocumentDetails> wraplist =new list<DMIS_Controller.DocumentDetails>();    
            wraplist.add(wrapdims);         
            
 // Set mock callout class for http callouts
        Test.setMock(HttpCalloutMock.class, new CCC_HttpResponseGeneratorDimsTest());

 // initiating variables for  getDocumentInformation()
        String body = '';
         body='[{"ResultCount":"20",';
     body+='"Documents":[{"ID":"37683","DocumentTitle":"TSTATCCPRH Thermostat and Thermidistat Product Data","Type":["TechLit"],';
     body+='"Subtype":["Product Data"],"Brands":["Carrier"],"CatalogueNumber":"02TS-TA6","Status":"Obsolete",';
     body+='"ModelNumbers":["tstat","tstatccprh01-b","tstatccpac01-b","tstatccphp01-b","tstatccp2s01-b","tstatccpdf01-b","tstatccprf01","tstatccrec01","tstatccpb501","tstatccp2w01","tstatccsac01",';
     body+='"tstatccshp01","tstatccpb101","tstatccnac01-b","tstatccnhp01-b","tstatccn2s01-b","tstatccntt01-b"],';
     body+='"DocumentMIMEType":"application\\/pdf","DocumentBaseURL":"http:\\/\\/www.utcccs-cdn.com\\/hvac\\/","DocumentPath":"\\/docs\\/1009\\/Public\\/02\\/TSTAT-6PD.pdf",';
     body+='"Verticals":[],"Language":"EN","Country":"","PublishedDate":"6\\/6\\/2008","DocumentSize":"303805","Region":"","ReleaseDate":"9\\/23\\/2004",';
     body+='"FormNumber":"TSTAT-6PD","ContentID":"TSTAT-6PD","Author":"aranney","PrintDate":"4\\/1\\/2003","SampleMail":"No","SourceDepartment":"RES Tech Writing",';
     body+='"Division":"RES","ModelCategory":"Controls; Thermostat","PartNumber":"","DocumentGroup":"","FileType":"Adobe Acrobat",';
     body+='"Category":"Thermostats","Comments":"","SubCategory":"","BrandFamily":"","DMSCategory":"","DMSType":"","SecurityGroup":"Public"}]}]';
        DMIS_Controller.objCase=testCase1;
        DMIS_Controller.docInfo_resultCount=resultCount;
        DMIS_Controller.docInfo_DocumentType=DocumentType;
        DMIS_Controller.getDocumentInformation(testCase1.id,testCase1,resultCount,DocumentType,'TestDIMSCase','Bryant','561');
        DMIS_Controller.getListDocs(testCase1.id,true,'TestDIMSCase','Bryant','561');       
     
        DMIS_Controller.CaseId=testCase1.id;//CaseId for getExitingRecords() which calls addSuggetedDocument()
        testcase2=DMIS_Controller.getExitingRecords(testCase1.id,false);
        list<DMIS_Controller.DocumentDetails> lst = DMIS_Controller.SuggestedDocument(body,testCase1.id);
        Case cs = DMIS_Controller.getCaseSubject(testCase1.id);
       
 //call for method showMoreDocuments() which calls getDocumentDetail()
         
         //System.assertEquals(null,result3);
                     
 //call for method getDocumentDetailCommunity() which calls addSuggetedDocumentCommunity() and showMoreDocumentsCommunity()
        //DMIS_Controller.getDocumentDetailCommunity();
        
     
    }//user1
    
    
    Test.stopTest();

}//testConstructor()
    
   static testMethod void testConstructor2()
   {
     setupData();
     Test.startTest();
       //Test.setMock(HttpCalloutMock.class, new CCC_HttpResponseGeneratorDimsTest());

        List<DMIS_Controller.DocumentDetails> result3=DMIS_Controller.showMoreDocs(testCase1.id,'TestDIMSCase','Bryant','561');
     Test.stopTest();
   }
}