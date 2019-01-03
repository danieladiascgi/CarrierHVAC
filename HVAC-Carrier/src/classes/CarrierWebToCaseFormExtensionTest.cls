@isTest(seeAllData=true)
public class CarrierWebToCaseFormExtensionTest {

    public static testmethod void startWebToCaseFormWithNewContact(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierWebToCaseFormExtension ext = new CarrierWebToCaseFormExtension(sc);
        webToCase = ext.newCase;
        webToCase.CCC_Purpose__c = 'Expedite';
        webToCase.CCC_Sub_Purpose__c = 'Expedite';
        webToCase.Priority = 'Medium';
        webToCase.Subject = 'Test';
        webToCase.Description = 'Test';
        webToCase.CCC_Part_Number__c = 'Test';
        ext.contactLastName = 'Test';
        ext.contactEmail = 'test23123@gmail.com';
        ext.purpose = 'Expedite';
        ext.subPurpose = 'Expedite';
        ext.createCase();
    }
    
   public static testmethod void startWebToCaseFormWithExistingContact(){
       Contact ct = new Contact();
       ct.LastName = 'Test';
       ct.Email = 'test23123@gmail.com';
       insert ct;
       Id [] fixedSearchResults= new Id[1];
       fixedSearchResults[0] = ct.Id;
       Test.setFixedSearchResults(fixedSearchResults);
       Product2 prod = [Select Id, Name from Product2 order by createddate desc limit 1];
         Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierWebToCaseFormExtension ext = new CarrierWebToCaseFormExtension(sc);
        webToCase = ext.newCase;
        webToCase.CCC_Purpose__c = 'PTAC';
        webToCase.CCC_Sub_Purpose__c = 'Parts';
        webToCase.Priority = 'Medium';
        webToCase.Subject = 'Test';
        webToCase.Description = 'Test';
        webToCase.CCC_Part_Number__c = prod.Name;
        ext.contactLastName = 'Test';
        ext.contactEmail = 'test23123@gmail.com';
       ext.purpose = 'Expedite';
        ext.subPurpose = 'Expedite';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.createCase();
        
    }
    public static testmethod void startWebToCaseFormWithoutLN(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierWebToCaseFormExtension ext = new CarrierWebToCaseFormExtension(sc);
        webToCase = ext.newCase;
        webToCase.CCC_Purpose__c = 'PTAC';
        webToCase.CCC_Sub_Purpose__c = 'Parts';
        webToCase.Priority = 'Medium';
        webToCase.Subject = 'Test';
        webToCase.Description = 'Test';
        webToCase.CCC_Part_Number__c = 'Test';
        ext.createCase();
        ext.contactLastName = 'Test LN';
        ext.createCase();
        ext.contactEmail = 'test23123@gmail.com';
        ext.purpose = 'Expedite';
        ext.subPurpose = 'Expedite';
        ext.getPurposes();
        ext.getSubPurposes();
        ext.createCase();
    }
    public static testmethod void startWebToCaseFormPurposeSubPurpose(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierWebToCaseFormExtension ext = new CarrierWebToCaseFormExtension(sc);
        ext.purpose = 'System Issues';
        ext.getSubPurposes();
        ext.purpose = 'New Account/Set Up/Changes';
        ext.getSubPurposes();
        ext.purpose = 'Technical/Part Info';
        ext.getSubPurposes();
        ext.purpose = 'Freight, Shipping, Tracking';
        ext.getSubPurposes();
        ext.purpose = 'Part Availability/Lead Time';
        ext.getSubPurposes();
        ext.purpose = 'Order Status and Maintenance';
        ext.getSubPurposes();
        ext.purpose = 'Pricing/Quoting';
        ext.getSubPurposes();
        ext.purpose = 'RM/Credit Issue';
        ext.getSubPurposes();
        ext.purpose = 'Document Reprints';
        ext.getSubPurposes();
        ext.purpose = 'Expedite ';
        ext.getSubPurposes();
    }
    public static testmethod void startWebToCaseFormWithNewContactEncryptedString(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierWebToCaseFormExtension ext = new CarrierWebToCaseFormExtension(sc);
        ext.parsePayloadAndGetValues('fjLASvN2cUbgfMxiUEjXSRA55eIeLz0zOBQTJYl07Rq1iFsCpSgil7+ipKmPMF9bjobdrvyJZx9zqerTv1lpyO/kGexOrifqZHvT+Nac/rbZlT5bFsgLOwccgTxADzgngZb1semAN0GSDbmr9CpElipAY2VQ7A7FLxu+3dv/8/s=');
        webToCase = ext.newCase;
        webToCase.CCC_Purpose__c = 'Expedite';
        webToCase.CCC_Sub_Purpose__c = 'Expedite';
        webToCase.Priority = 'Medium';
        webToCase.Subject = 'Test';
        webToCase.Description = 'Test';
        webToCase.CCC_Part_Number__c = 'Test';
        ext.contactLastName = 'Test';
        ext.contactEmail = 'test23123@gmail.com';
        ext.purpose = 'Expedite';
        ext.subPurpose = 'Expedite';
        ext.createCase();
    }
}