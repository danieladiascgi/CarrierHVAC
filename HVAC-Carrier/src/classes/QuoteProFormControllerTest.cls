@isTest
public class QuoteProFormControllerTest {
   public static testmethod void startQuoteProForm()
   {
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
           
              Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=act.id;
        insert attach;
            Id [] fixedSearchResults= new Id[1];
            fixedSearchResults[0] = ct.Id;
            Test.setFixedSearchResults(fixedSearchResults);
            Case webToCase = new Case();
            ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
            QuoteProFormController ext = new QuoteProFormController(sc);
          
            ext.save();
            ext.addMore();
            ext.getpriority();
            ext.createCase();
            ext.getoptions();
            ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
            webToCase = ext.newCase;
            webToCase.Subject = 'Test';
            webToCase.ContactId=null;
            ext.hvacId='1963';
            ext.myAttachments=null;
            ext.keepDescription=null;
            ext.cntLastName=null;
            ext.contactLastName=null;
            webToCase.ContactId=null;
            webToCase.Description = 'null';
            List<Case> caselist1 = new List<Case>();
            caselist1.add(webToCase);
            ext.payload='123';
            ext.shipTo='Test';
            ext.fileName = 'Test.txt';
            ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
            ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
            ext.createCase();
           
         }
}
    
    public static testmethod void startQuoteProFormWithoutNewContact(){
       
        try{
            
            Case webToCase = new Case();
            ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
            QuoteProFormController ext = new QuoteProFormController(sc);
            webToCase = ext.newCase;
            webToCase.Subject = 'Test';
            webToCase.Description = '';
            ext.contactFirstName = null;
            ext.contactLastName = null;  
            ext.contactEmail = 'test23123@gmail.com';
            ext.hvacId='1234';
            ext.shipTo='Test';
            ext.fileName = 'Test.txt';
            ext.QPUserID='1234';
            ext.type='';
            ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
            ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
            ext.addMore();
            ext.save();
            ext.createCase();
          
      }catch(Exception e){}
         
    }
    
     public static testmethod void startQuoteProFormWithoutNewContactNewCase(){
        
        Case webToCase = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        QuoteProFormController ext = new QuoteProFormController(sc);
        webToCase = ext.newCase;
        webToCase.Subject = 'Test';
        webToCase.Description = 'Test';
        ext.hvacId='1234';
        ext.cntFirstName='test';
        ext.cntLastName='test';
        ext.cntEmail='';
        ext.shipTo='Test';
        ext.Phone='98745976948';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
        ext.addMore();
        ext.save();
        ext.createCase();
        
    }
    public static testmethod void startQuoteProFormWithoutEmail(){
        
        Case webToCase = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        QuoteProFormController ext = new QuoteProFormController(sc);
        webToCase = ext.newCase;
       // webToCase.Subject = '';
        webToCase.Description = 'Test';
        ext.hvacId='1234';
        ext.cntFirstName='test';
        ext.cntLastName='test';
        ext.cntEmail='';
        
        ext.createCase();
        ext.cntLastName='';
        webToCase.Subject = 'test';
        ext.selected='--None--';
        ext.createCase();
        
    }
     public static testmethod void testmethodQuoteProFormController(){
     
     }
    
}