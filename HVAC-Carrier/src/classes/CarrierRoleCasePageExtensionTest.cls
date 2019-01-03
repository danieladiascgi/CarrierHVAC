@isTest(seeAllData=true)
public class CarrierRoleCasePageExtensionTest {
    public static testmethod void startWebToCaseRoleForm(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierRoleCasePageExtension ext = new CarrierRoleCasePageExtension(sc);
        ext.enteredName='Tejas';
        ext.Options = null;
        ext.request_type = 'International Request';
        //ext.getPublicKey();
        webToCase.Call_back__c = '3159288246';
        ext.createCase();
        ext.enteredEmail = 'tejas.jambekar@carrier.utc.com';
        ext.selectedRequestType = 'International Request';
        ext.selectedEquipment = 'Applied Products';
        ext.selectedPurpose = 'TSM Support';
        webToCase.CCC_Job_Name__c = 'Testing';
        webToCase.CCC_Job_Site_Address__c = 'ABCD';
        webToCase.CCC_Model_Number__c = '123456';
        webToCase.CCC_Serial_Number__c = '123456';
        webToCase.Description='Testing';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.createCase();
        ext.getRequestType();
       // ext.getPickLstValue();
       // ext.getPurposePickLstValue();
    }
    public static testmethod void startWebToCaseRoleFormHeavyAppliedDesignData(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierRoleCasePageExtension ext = new CarrierRoleCasePageExtension(sc);
        ext.enteredName='Tejas';
        ext.Options = null;
        ext.request_type = 'Heavy Applied Design Data (16,17,19,23)';
        //ext.getPublicKey();
        webToCase.Call_back__c = '3159288246';
        ext.createCase();
        ext.enteredEmail = 'tejas.jambekar@carrier.utc.com';
        ext.selectedRequestType = 'International Request';
        ext.selectedEquipment = 'Applied Products';
        ext.selectedPurpose = 'TSM Support';
        webToCase.CCC_Job_Name__c = 'Testing';
        webToCase.CCC_Job_Site_Address__c = 'ABCD';
        webToCase.CCC_Model_Number__c = '123456';
        webToCase.CCC_Serial_Number__c = '123456';
        webToCase.Description='Testing';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.createCase();
        ext.getRequestType();
       // ext.getPickLstValue();
       // ext.getPurposePickLstValue();
    }
    public static testmethod void startWebToCaseRoleFormInternationRequest(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierRoleCasePageExtension ext = new CarrierRoleCasePageExtension(sc);
        ext.enteredName='Tejas';
        ext.Options = null;
        ext.request_type = 'International Request';
        //ext.getPublicKey();
        webToCase.Call_back__c = '3159288246';
        ext.createCase();
        ext.enteredEmail = 'tejas.jambekar@carrier.utc.com';
        ext.selectedRequestType = 'International Request';
        ext.selectedEquipment = 'Applied Products';
        ext.selectedPurpose = 'TSM Support';
        webToCase.CCC_Job_Name__c = 'Testing';
        webToCase.CCC_Job_Site_Address__c = 'ABCD';
        webToCase.CCC_Model_Number__c = '123456';
        webToCase.CCC_Serial_Number__c = '123456';
        webToCase.Description='Testing';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.createCase();
        ext.getRequestType();
       // ext.getPickLstValue();
       // ext.getPurposePickLstValue();
    }
    public static testmethod void startWebToCaseRoleFormCommercialLiterature(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierRoleCasePageExtension ext = new CarrierRoleCasePageExtension(sc);
        ext.enteredName='Tejas';
        ext.Options = null;
        ext.request_type = 'Commercial Literature (over 25 tons)';
        //ext.getPublicKey();
        webToCase.Call_back__c = '3159288246';
        ext.createCase();
        ext.enteredEmail = 'tejas.jambekar@carrier.utc.com';
        ext.selectedRequestType = 'Commercial Literature (over 25 tons)';
        ext.selectedEquipment = 'Applied Products';
        ext.selectedPurpose = 'TSM Support';
        webToCase.CCC_Job_Name__c = 'Testing';
        webToCase.CCC_Job_Site_Address__c = 'ABCD';
        webToCase.CCC_Model_Number__c = '123456';
        webToCase.CCC_Serial_Number__c = '123456';
        webToCase.Description='Testing';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.createCase();
        ext.getRequestType();
       // ext.getPickLstValue();
       // ext.getPurposePickLstValue();
    }
    public static testmethod void startWebToCaseRoleFormHeavyAppliedCCSSupport(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierRoleCasePageExtension ext = new CarrierRoleCasePageExtension(sc);
        ext.enteredName='Tejas';
        ext.Options = null;
        ext.request_type = 'Heavy Applied CCS Support /Re-Selections (16,17,19,23)';
        //ext.getPublicKey();
        webToCase.Call_back__c = '3159288246';
        ext.createCase();
        ext.enteredEmail = 'tejas.jambekar@carrier.utc.com';
        ext.selectedRequestType = 'Heavy Applied CCS Support /Re-Selections (16,17,19,23)';
        ext.selectedEquipment = 'Applied Products';
        ext.selectedPurpose = 'TSM Support';
        webToCase.CCC_Job_Name__c = 'Testing';
        webToCase.CCC_Job_Site_Address__c = 'ABCD';
        webToCase.CCC_Model_Number__c = '123456';
        webToCase.CCC_Serial_Number__c = '123456';
        webToCase.Description='Testing';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.createCase();
        ext.getRequestType();
       // ext.getPickLstValue();
       // ext.getPurposePickLstValue();
    }
    public static testmethod void startWebToCaseRoleFormHeavyAppliedStartup(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierRoleCasePageExtension ext = new CarrierRoleCasePageExtension(sc);
        ext.enteredName='Tejas';
        ext.Options = null;
        ext.request_type = 'Heavy Applied Start up/Warranty Support (16,17,19,23)';
        //ext.getPublicKey();
        webToCase.Call_back__c = '3159288246';
        ext.createCase();
        ext.enteredEmail = 'tejas.jambekar@carrier.utc.com';
        ext.selectedRequestType = 'Heavy Applied Start up/Warranty Support (16,17,19,23)';
        ext.selectedEquipment = 'Applied Products';
        ext.selectedPurpose = 'TSM Support';
        webToCase.CCC_Job_Name__c = 'Testing';
        webToCase.CCC_Job_Site_Address__c = 'ABCD';
        webToCase.CCC_Model_Number__c = '123456';
        webToCase.CCC_Serial_Number__c = '123456';
        webToCase.Description='Testing';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.createCase();
        ext.getRequestType();
       // ext.getPickLstValue();
       // ext.getPurposePickLstValue();
    }
    public static testmethod void startWebToCaseRoleFormCommercialUnitaryTechnicalSupport(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierRoleCasePageExtension ext = new CarrierRoleCasePageExtension(sc);
        ext.enteredName='Tejas';
        ext.Options = null;
        ext.request_type = 'Commercial Unitary Technical Support (over 25 tons)';
        //ext.getPublicKey();
        webToCase.Call_back__c = '3159288246';
        ext.createCase();
        ext.enteredEmail = 'tejas.jambekar@carrier.utc.com';
        ext.selectedRequestType = 'Commercial Unitary Technical Support (over 25 tons)';
        ext.selectedEquipment = 'Applied Products';
        ext.selectedPurpose = 'TSM Support';
        webToCase.CCC_Job_Name__c = 'Testing';
        webToCase.CCC_Job_Site_Address__c = 'ABCD';
        webToCase.CCC_Model_Number__c = '123456';
        webToCase.CCC_Serial_Number__c = '123456';
        webToCase.Description='Testing';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.createCase();
        ext.getRequestType();
       // ext.getPickLstValue();
       // ext.getPurposePickLstValue();
    }
    public static testmethod void startWebToCaseRoleFormCommercialUnitaryReportFieldQualityIssues(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierRoleCasePageExtension ext = new CarrierRoleCasePageExtension(sc);
        ext.enteredName='Tejas';
        ext.Options = null;
        ext.request_type = 'Commercial Unitary Report Field Quality Issues (over 25 tons)';
        //ext.getPublicKey();
        webToCase.Call_back__c = '3159288246';
        ext.createCase();
        ext.enteredEmail = 'tejas.jambekar@carrier.utc.com';
        ext.selectedRequestType = 'Commercial Unitary Report Field Quality Issues (over 25 tons)';
        ext.selectedEquipment = 'Applied Products';
        ext.selectedPurpose = 'TSM Support';
        webToCase.CCC_Job_Name__c = 'Testing';
        webToCase.CCC_Job_Site_Address__c = 'ABCD';
        webToCase.CCC_Model_Number__c = '123456';
        webToCase.CCC_Serial_Number__c = '123456';
        webToCase.Description='Testing';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.createCase();
        ext.getRequestType();
       // ext.getPickLstValue();
       // ext.getPurposePickLstValue();
    }
         public static testmethod void startWebToCaseRoleFormCommercialFactorySupportEngineer(){
        Case webToCase = new Case();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(webToCase);
        CarrierRoleCasePageExtension ext = new CarrierRoleCasePageExtension(sc);
        ext.enteredName='Tejas';
        ext.Options = null;
        ext.request_type = 'Commercial Factory Support Engineer (over 25 tons)';
        //ext.getPublicKey();
        webToCase.Call_back__c = '3159288246';
        ext.createCase();
        ext.enteredEmail = 'tejas.jambekar@carrier.utc.com';
        ext.selectedRequestType = 'Commercial Factory Support Engineer (over 25 tons)';
        ext.selectedEquipment = 'Applied Products';
        ext.selectedPurpose = 'TSM Support';
        webToCase.CCC_Job_Name__c = 'Testing';
        webToCase.CCC_Job_Site_Address__c = 'ABCD';
        webToCase.CCC_Model_Number__c = '123456';
        webToCase.CCC_Serial_Number__c = '123456';
        webToCase.Description='Testing';
        ext.fileName = 'Test.txt';
        ext.fileBody = Blob.valueOf('Unit Test Attachment Body');
        ext.createCase();
        ext.getRequestType();
       // ext.getPickLstValue();
       // ext.getPurposePickLstValue();
    }
}