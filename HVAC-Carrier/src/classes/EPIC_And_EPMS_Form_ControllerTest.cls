@isTest
public class EPIC_And_EPMS_Form_ControllerTest {
public static testmethod void startWebToCaseFormWithNewContact(){
   Profile testProfile = [select id,UserLicenseId from profile where name='System Administrator'];
     
    //create user
    User testUser = new User(alias = 'userTest', email='developercto@carrier.com',emailencodingkey='UTF-8',
                        languagelocalekey='en_US', lastname='Testing', 
                        profileid = testProfile.Id, timezonesidkey='America/Los_Angeles',localesidkey='en_US',
                        username='developercto@carrier.com'); 
    insert testUser; 
    System.runAs(testUser){
        Account act = new Account();
        act.Name = 'Test';
        act.CCC_HVACPID__c = '1963';
        insert act;
        Contact ct = new Contact();
        ct.LastName = 'Test';
        ct.Email = 'test231235@gmail.com';
        ct.AccountId = act.Id;
        insert ct;
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ct.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        Case webToCase = new Case();
        Boolean displayNoBrowserIssue1 = true;
        Boolean displayWebBrowserIssue1 = true; 
        Boolean isInternalUser1 = true;
        Boolean verified1 = true;
        
      
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        EPIC_And_EPMS_Form_Controller ext = new EPIC_And_EPMS_Form_Controller(sc);
        List<SelectOption> WC = ext.getWebBrowserOptions();
       
      
        ext.displayNoBrowserIssue = displayNoBrowserIssue1;
        ext.displayWebBrowserIssue = displayWebBrowserIssue1;
        ext.selectedValue ='test';
        ext.contactLastName=null;
        ext.contactLastName='Ravi';
        ext.contactEmail = 'test768@gmail.com';
        ext.phoneNumber = '9877657454';
        ext.serialNumber = '54376';
        ext.modelNumber = '4563';
        ext.comments = 'test';
        ext.webBrowserVersion ='test';
        ext.isInternalUser= isInternalUser1;
        ext.keepDescription = 'testdesc';
        ext.hvacId='1441';
        ext.type='EPIC';
        ext.shipTo = 'test';
        ext.productAffected = 'Furnace Coils';
        ext.createAccountIfNotPresent = act;
        ext.createContactIfNotPresent = ct;
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
        ext.addMore();
        ext.save();
        ext.createCase();
        ext.renderSections();
        //ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
        
        webToCase.Status ='Open';
        webToCase.Origin ='Web';
        
        } 
}
    public static testmethod void startWebToCaseFormWithFirstName(){
   Profile testProfile = [select id,UserLicenseId from profile where name='System Administrator'];
     
    //create user
    User testUser = new User(alias = 'userTest', email='developercto@carrier.com',emailencodingkey='UTF-8',
                        languagelocalekey='en_US', lastname='Testing', 
                        profileid = testProfile.Id, timezonesidkey='America/Los_Angeles',localesidkey='en_US',
                        username='developercto@carrier.com'); 
    insert testUser; 
    System.runAs(testUser){
        Account act = new Account();
        act.Name = 'Test';
        act.CCC_HVACPID__c = '1963';
        insert act;
        Contact ct = new Contact();
        ct.LastName = 'Test';
        ct.Email = 'test231235@gmail.com';
        ct.AccountId = act.Id;
        insert ct;
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ct.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        Case webToCase = new Case();
         ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        EPIC_And_EPMS_Form_Controller ext = new EPIC_And_EPMS_Form_Controller(sc);
        
        ext.contactFirstName = null;
        ext.contactFirstName='manju';
        ext.createCase();
    }
    }
    public static testmethod void startWebToCaseFormWithLastName(){
   Profile testProfile = [select id,UserLicenseId from profile where name='System Administrator'];
     
    //create user
    User testUser = new User(alias = 'userTest', email='developercto@carrier.com',emailencodingkey='UTF-8',
                        languagelocalekey='en_US', lastname='Testing', 
                        profileid = testProfile.Id, timezonesidkey='America/Los_Angeles',localesidkey='en_US',
                        username='developercto@carrier.com'); 
    insert testUser; 
    System.runAs(testUser){
        Account act = new Account();
        act.Name = 'Test';
        act.CCC_HVACPID__c = '1963';
        insert act;
        Contact ct = new Contact();
        ct.LastName = 'Test';
        ct.Email = 'test231235@gmail.com';
        ct.AccountId = act.Id;
        insert ct;
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ct.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        Case webToCase = new Case();
         ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        EPIC_And_EPMS_Form_Controller ext = new EPIC_And_EPMS_Form_Controller(sc);
        
        ext.contactLastName = null;
        ext.contactLastName='manju';
        ext.createCase();
    }
    }
    
    public static testmethod void startWebToCaseFormWithEmail(){
   Profile testProfile = [select id,UserLicenseId from profile where name='System Administrator'];
     
    //create user
    User testUser = new User(alias = 'userTest', email='developercto@carrier.com',emailencodingkey='UTF-8',
                        languagelocalekey='en_US', lastname='Testing', 
                        profileid = testProfile.Id, timezonesidkey='America/Los_Angeles',localesidkey='en_US',
                        username='developercto@carrier.com'); 
    insert testUser; 
    System.runAs(testUser){
        Account act = new Account();
        act.Name = 'Test';
        act.CCC_HVACPID__c = '1963';
        insert act;
        Contact ct = new Contact();
        ct.LastName = 'Test';
        ct.Email = 'test231235@gmail.com';
        ct.AccountId = act.Id;
        insert ct;
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = ct.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        Case webToCase = new Case();
         ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        EPIC_And_EPMS_Form_Controller ext = new EPIC_And_EPMS_Form_Controller(sc);
        
       /* ext.contactFirstName = null;
        ext.contactFirstName = 'manju';
        ext.contactLastName=null;
        ext.contactLastName='ravi';
        ext.comments=null;
        ext.comments='test';*/
      //  ext.contactEmail='test@gmail.com';
        webToCase.Subject='Test';
        webToCase.Status ='Open';
        webToCase.Origin ='Web';
        
        ext.createCase();
        
        Attachment attach = new Attachment();
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=act.id;
        insert attach;

        List<Attachment> attlist = new List<Attachment>();
        attlist.add(attach);
        
        ext.newAttachments = attlist;
        ext.sobjId = act.id;
        try{
        ext.save();
        }catch(exception e){}
    }
    }
    
     public static testmethod void startWebToCaseFormWithEmail2(){
   Profile testProfile = [select id,UserLicenseId from profile where name='System Administrator'];
     
    //create user
    User testUser = new User(alias = 'userTest', email='developercto@carrier.com',emailencodingkey='UTF-8',
                        languagelocalekey='en_US', lastname='Testing', 
                        profileid = testProfile.Id, timezonesidkey='America/Los_Angeles',localesidkey='en_US',
                        username='developercto@carrier.com'); 
    insert testUser; 
    System.runAs(testUser){
       
        Case webToCase = new Case(comments__c='test');
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        EPIC_And_EPMS_Form_Controller ext = new EPIC_And_EPMS_Form_Controller(sc);
     
        ext.newCase = webToCase;
        ext.contactFirstName = 'abc';
        ext.contactLastName = 'def';
        ext.contactEmail='abc@gmail.com';
        ext.productAffected = 'Furnace Coils';
        ext.createCase();
    }
    }
    
    public static testmethod void startWebToCaseFormWithEmail3(){
   Profile testProfile = [select id,UserLicenseId from profile where name='System Administrator'];
     
    //create user
    User testUser = new User(alias = 'userTest', email='developercto@carrier.com',emailencodingkey='UTF-8',
                        languagelocalekey='en_US', lastname='Testing', 
                        profileid = testProfile.Id, timezonesidkey='America/Los_Angeles',localesidkey='en_US',
                        username='developercto@carrier.com'); 
    insert testUser; 
    System.runAs(testUser){
       
        Case webToCase = new Case(comments__c='test');
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        EPIC_And_EPMS_Form_Controller ext = new EPIC_And_EPMS_Form_Controller(sc);
     
        ext.newCase = webToCase;
        ext.contactFirstName = 'abc';
        ext.contactLastName = 'def';
        ext.contactEmail='abc@gmail.com';
        ext.productAffected = 'Furnace Coils';
        ext.displayNoBrowserIssue =false;
        ext.createCase();
    }
    }
    
    
    
}