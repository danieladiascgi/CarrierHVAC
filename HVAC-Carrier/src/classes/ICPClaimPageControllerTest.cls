@isTest
public class ICPClaimPageControllerTest {
    
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
            ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
            ICPClaimPageController ext = new ICPClaimPageController(sc);
            ICPClaimPageController ext1 = new ICPClaimPageController();
            ext.save();
            ext.addMore();
            ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
            webToCase = ext.newCase;
            webToCase.Subject = 'Test';
            webToCase.ContactId=null;
            ext.hvacId='1963';
            ext.isInternalUser=true;
            ext.distributorName = act.Name;
            ext.myAttachments=null;
            ext.keepDescription=null;
            ext.contactLastName=null;
            webToCase.ContactId=null;
            webToCase.Description = 'null';
            webToCase.Claims_Order_Type__c ='Equipment';
            webToCase.CCC_Claim_Type__c = 'Commercial';
            ext.contactEmail = 'test23123@gmail.com';
            
            List<Case> caselist1 = new List<Case>();
            caselist1.add(webToCase);
            ext.payload='123';
            ext.claimSectionRender = true;
            ext.selectedValue1='c';
            ext.shipTo='Test';
            ext.fileName = 'Test.txt';
            ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
            ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
            ext.createCase();
            ext.renderSections();
            webToCase.Claims_Order_Type__c ='Pricing';
            ext.renderSections();
            
        }
    }
    
    public static testmethod void startWebToCaseFormWithoutNewContact(){
        try{
            
            Case webToCase = new Case();
            ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
            ICPClaimPageController ext = new ICPClaimPageController(sc);
            webToCase = ext.newCase;
            webToCase.Subject = 'Test';
            webToCase.Description = 'Test';
            webToCase.Claims_Purpose__c = 'Equipment Damage';
            webToCase.Claims_Sub_Purpose__c ='Claim Dispute';
            webToCase.Claims_Order_Type__c ='FAST Parts';
            webToCase.CCC_Claim_Type__c = '';
            ext.contactFirstName = null;
            ext.contactLastName = null;  
            ext.contactEmail = 'test23123@gmail.com';
            ext.hvacId='1234';
            ext.selectedValue1='pc';
            ext.claimSectionRender2 = true;
            webToCase.Claims_Order_Type__c ='Equipment';
            ext.Comments ='Test';
            ext.selectedValue1='c';
            ext.shipTo='Test';
            ext.fileName = 'Test.txt';
            ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
            ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
            ext.addMore();
            ext.save();
            ext.renderSections();
            ext.createCase();
            ext.selectedValue1='pc';
            ext.claimSectionRender3=true;
            webToCase.Claims_Order_Type__c ='PRICING';
            ext.renderSections();
            ext.createCase();
            
        }catch(Exception e){}
        
    }
    
    public static testmethod void startWebToCaseFormWithoutNewContactNewCase(){
        
        Case webToCase = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        ICPClaimPageController ext = new ICPClaimPageController(sc);
        webToCase = ext.newCase;
        webToCase.Subject = 'Test';
        webToCase.Description = 'Test';
        webToCase.Claims_Order_Type__c ='Equipment';
        webToCase.Claims_Purpose__c = 'Equipment Damage';
        webToCase.Claims_Sub_Purpose__c ='Claim Dispute';
        webToCase.CCC_Claim_Type__c = '';
        ext.contactEmail = 'test23123@gmail.com';
        ext.hvacId='1234';
        ext.claimSectionRender3 = true;
        ext.Comments ='Test';
        ext.selectedValue1='fpc';
        ext.shipTo='Test';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
        ext.addMore();
        ext.save();
        ext.renderSections();
        ext.createCase();
        
    }
    public static testmethod void startWebToCaseFormWithoutSubject(){
        
        Case webToCase = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        ICPClaimPageController ext = new ICPClaimPageController(sc);
        ext.save();
        ext.addMore();
        ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
        webToCase = ext.newCase;
        webToCase.Description = 'null';
        webToCase.Claims_Order_Type__c ='Pricing';
        webToCase.CCC_Claim_Type__c = 'Commercial';
        ext.contactEmail = 'test23123@gmail.com';
        List<Case> caselist1 = new List<Case>();
        caselist1.add(webToCase);
        ext.hvacId='1234';
        ext.payload='123';
        ext.claimSectionRender = true;
        ext.selectedValue1='c';
        ext.shipTo='Test';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
        ext.createCase();
        ext.renderSections();
        
    }
    public static testmethod void startWebToCaseFormWithoutDescription(){
        
        Case webToCase = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        ICPClaimPageController ext = new ICPClaimPageController(sc);
        ext.save();
        ext.addMore();
        ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
        webToCase = ext.newCase;
        webToCase.Subject = 'Test';
        webToCase.Claims_Order_Type__c ='Equipment';
        webToCase.CCC_Claim_Type__c = 'Commercial';
        ext.contactEmail = 'test23123@gmail.com';
        List<Case> caselist1 = new List<Case>();
        caselist1.add(webToCase);
        ext.hvacId='1234';
        ext.payload='123';
        ext.claimSectionRender = true;
        ext.selectedValue1='c';
        ext.shipTo='Test';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
        ext.createCase();
        ext.renderSections();
        webToCase.Claims_Order_Type__c ='PRICING';
        ext.renderSections();
        
    }
    public static testmethod void startWebToCaseFormWithoutEmail(){
        
        Case webToCase = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        ICPClaimPageController ext = new ICPClaimPageController(sc);
        webToCase = ext.newCase;
        ext.contactFirstName=null;
        ext.contactLastName=null;
        ext.createCase();
    }
    
    public static testmethod void startWebToCaseFormWithoutSubpurpose(){
        
        Case webToCase = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        ICPClaimPageController ext = new ICPClaimPageController(sc);
        webToCase = ext.newCase;
        webToCase.Subject = 'Test';
        
        webToCase.Description = 'Test';
        webToCase.Claims_Purpose__c = 'Equipment Damage';
        //   webToCase.Claims_Sub_Purpose__c ='Claim Dispute';
        webToCase.Claims_Order_Type__c ='FAST Parts';
        webToCase.CCC_Claim_Type__c = '';
        ext.contactFirstName = null;
        ext.contactLastName = null;  
        ext.contactEmail = 'test23123@gmail.com';
        ext.hvacId='1234';
        ext.selectedValue1='pc';
        ext.claimSectionRender2 = true;
        webToCase.Claims_Order_Type__c ='Equipment';
        ext.Comments ='Test';
        ext.selectedValue1='c';
        ext.shipTo='Test';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
        ext.addMore();
        ext.save();
        ext.renderSections();
        ext.createCase();
        ext.selectedValue1='pc';
        ext.claimSectionRender3=true;
        webToCase.Claims_Order_Type__c ='PRICING';
        ext.renderSections();
        ext.createCase();
        webToCase.Claims_Purpose__c = 'Parts Damage';
        ext.renderSections2();
        webToCase.Claims_Purpose__c = 'Parts Shortage';
        ext.renderSections2();
        webToCase.Claims_Purpose__c = 'Equipment Shortage';
        ext.renderSections2();
        webToCase.Claims_Purpose__c = 'Freight';
        ext.renderSections2(); 
        
    }
    public static testmethod void startWebToCaseFormWithoutlastname(){
        try{
            
            Case webToCase = new Case();
            ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
            ICPClaimPageController ext = new ICPClaimPageController(sc);
            webToCase = ext.newCase;
            ext.contactFirstName = null;
            webToCase.Subject = 'Test';
            webToCase.Description = 'Test';
            webToCase.Claims_Purpose__c = 'Parts Damage';
            webToCase.Claims_Sub_Purpose__c ='Claim Request';
            webToCase.Claims_Order_Type__c ='FAST Parts';
            webToCase.CCC_Claim_Type__c = '';
            ext.contactLastName = null;  
            ext.contactEmail = 'test23123@gmail.com';
            ext.hvacId='1234';
            ext.selectedValue1='pc';
            ext.claimSectionRender2 = true;
            webToCase.Claims_Order_Type__c ='Equipment';
            ext.Comments ='Test';
            ext.selectedValue1='c';
            ext.shipTo='Test';
            ext.fileName = 'Test.txt';
            ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
            ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
            ext.addMore();
            ext.save();
            ext.renderSections();
            ext.createCase();
            ext.selectedValue1='pc';
            ext.claimSectionRender3=true;
            webToCase.Claims_Order_Type__c ='PRICING';
            ext.renderSections();
            ext.createCase();
        }
        catch(exception e)
        {}
        
    }
    
}