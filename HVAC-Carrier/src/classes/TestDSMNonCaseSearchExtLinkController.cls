@isTest(SeeAllData=true)
public class TestDSMNonCaseSearchExtLinkController {
    public static testMethod void testNonCaseSearchSmartSearchCarrier(){
        System.currentPageReference().getParameters().put('valPassed', 'NY');
        System.currentPageReference().getParameters().put('brandname', 'Carrier');
        System.currentPageReference().getParameters().put('brandSelected', 'Carrier');
        System.currentPageReference().getParameters().put('dealerName', 'Test dealer');
        System.currentPageReference().getParameters().put('dealerPhone', '4567890324');
        System.currentPageReference().getParameters().put('selectedDealerId', '');
        System.currentPageReference().getParameters().put('source', 'SmartSearch');
        Case cse = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        DSMNonCaseSearchExtLinkController cont = new DSMNonCaseSearchExtLinkController(sc);
        cont.brandSelected = 'Carrier';
        cont.searchDist();
    }
    public static testMethod void testNonCaseSearchSmartSearchBryant(){
        System.currentPageReference().getParameters().put('valPassed', 'NY');
        System.currentPageReference().getParameters().put('brandname', 'Bryant');
        System.currentPageReference().getParameters().put('brandSelected', 'Bryant');
        System.currentPageReference().getParameters().put('dealerName', 'Test dealer');
        System.currentPageReference().getParameters().put('dealerPhone', '4567890324');
        System.currentPageReference().getParameters().put('selectedDealerId', '');
        System.currentPageReference().getParameters().put('source', 'SmartSearch');
        Case cse = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        DSMNonCaseSearchExtLinkController cont = new DSMNonCaseSearchExtLinkController(sc);
        cont.brandSelected = 'Bryant';
        cont.searchDist();
    }
    public static testMethod void testNonCaseSearchSmartSearchPayne(){
        System.currentPageReference().getParameters().put('valPassed', 'NY');
        System.currentPageReference().getParameters().put('brandname', 'Payne');
        System.currentPageReference().getParameters().put('brandSelected', 'Payne');
        System.currentPageReference().getParameters().put('dealerName', 'Test dealer');
        System.currentPageReference().getParameters().put('dealerPhone', '4567890324');
        System.currentPageReference().getParameters().put('selectedDealerId', '');
        System.currentPageReference().getParameters().put('source', 'SmartSearch');
        Case cse = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        DSMNonCaseSearchExtLinkController cont = new DSMNonCaseSearchExtLinkController(sc);
        cont.brandSelected = 'Payne';
        cont.searchDist();
        DSM_Distributor_Directory__c direct = [Select Id from DSM_Distributor_Directory__c where State__c='NY' and Brand__c='Carrier' and County_Name__c='Onondaga County' limit 1];
        cont.selectedDistIdForCaseCreation = direct.Id;
        cont.createCase();
        
    }
    public static testMethod void testNonCaseSearchSmartSearchCommandLinkClick(){
        System.currentPageReference().getParameters().put('valPassed', 'NY');
        System.currentPageReference().getParameters().put('brandname', 'Payne');
        System.currentPageReference().getParameters().put('brandSelected', 'Payne');
        System.currentPageReference().getParameters().put('dealerName', 'Test dealer');
        System.currentPageReference().getParameters().put('dealerPhone', '4567890324');
        System.currentPageReference().getParameters().put('selectedDealerId', '');
        System.currentPageReference().getParameters().put('source', 'SmartSearch');
        Case cse = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        DSMNonCaseSearchExtLinkController cont = new DSMNonCaseSearchExtLinkController(sc);
        cont.brandSelected = 'Payne';        
        cont.searchDist();
        cont.AlphaFilter = 'A';
        cont.BuildQuery();
        cont.AlphaFilter = 'All';
        cont.BuildQuery();
        cont.SortToggle();
        
    }
    public static testMethod void testNonCaseSearchUpdateCase(){
        DSM_Distributor_Directory__c direct = [Select Id from DSM_Distributor_Directory__c where State__c='NY' and Brand__c='Carrier' and County_Name__c='Onondaga County' limit 1];
        Account acct = new Account();
        acct.name='TestAcc';
        insert acct;
        Contact con = new Contact();
        con.Lastname='test';
        con.email='test@gmail.com';
        con.AccountId = acct.id;
        con.Enrichment_Payload__c='test';
        con.MailingState='NY';
        con.Phone='23423245343';
        con.MailingPostalCode='27244';
        insert con;
        Case cse = new Case();
        cse.Subject='test';
        cse.CCC_Purpose__c='Referral';
        cse.CCC_Sub_Purpose__c='';
        cse.AccountId = acct.id;
        cse.ContactId=con.id;
        cse.Status='';
        cse.Reason='';
        cse.Origin='';
        cse.Current_Servicing_Dealer__c='';
        cse.CCC_Dealer_s_Phone_No__c=''; 
        cse.CCC_Brand__c='Payne';
        cse.CCC_Turn_Back_Code__c='Not Applicable';
        insert cse;
        
        System.currentPageReference().getParameters().put('valPassed', 'NY');
        System.currentPageReference().getParameters().put('brandname', 'Payne');
        System.currentPageReference().getParameters().put('brandSelected', 'Payne');
        System.currentPageReference().getParameters().put('dealerName', 'Test dealer');
        System.currentPageReference().getParameters().put('dealerPhone', '4567890324');
        System.currentPageReference().getParameters().put('selectedDealerId', acct.Id);
        System.currentPageReference().getParameters().put('source', 'DistLoctBtn');
        System.currentPageReference().getParameters().put('CaseId', cse.Id);
        System.currentPageReference().getParameters().put('caseId2', cse.Id); 
        System.currentPageReference().getParameters().put('param','Payne'); 
        System.currentPageReference().getParameters().put('id',cse.Id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        DSMNonCaseSearchExtLinkController cont = new DSMNonCaseSearchExtLinkController(sc);
        cont.brandSelected = 'Payne';
        cont.searchDist();
       // DSM_Distributor_Directory__c direct = [Select Id from DSM_Distributor_Directory__c where State__c='NY' and Brand__c='Carrier' and County_Name__c='Onondaga County' limit 1];
        cont.selectedDistIdForCaseCreation = direct.Id;
        cont.createCase();
        cont.createDealerAccount('test');
        cont.createDealerContact('test','test','test@gmail.com','5671231242');
        cont.updateCase();
        cont.init();
     }
     public static testMethod void testNonCaseSearchUpdateVerifiedContact(){
        DSM_Distributor_Directory__c direct = [Select Id from DSM_Distributor_Directory__c where State__c='NY' and Brand__c='Carrier' and County_Name__c='Onondaga County' limit 1];
        Account acct = new Account();
        acct.name='TestAcc';
        insert acct;
        Contact con = new Contact();
        con.Lastname='test';
        con.email='test@gmail.com';
        con.AccountId = acct.id;
        con.Enrichment_Payload__c='test';
        con.MailingState='NY';
        con.Phone='23423245343';
       // con.MailingPostalCode='27244';
        insert con;
        Case cse = new Case();
        cse.Subject='test';
        cse.CCC_Purpose__c='Referral';
        cse.CCC_Sub_Purpose__c='';
        cse.AccountId = acct.id;
        cse.ContactId=con.id;
        cse.Status='';
        cse.Reason='';
        cse.Origin='';
        cse.Current_Servicing_Dealer__c='';
        cse.CCC_Dealer_s_Phone_No__c=''; 
        cse.CCC_Brand__c='Payne';
        cse.CCC_Turn_Back_Code__c='Not Applicable';
        insert cse;
        
        System.currentPageReference().getParameters().put('valPassed', 'NY');
        System.currentPageReference().getParameters().put('brandname', 'Payne');
        System.currentPageReference().getParameters().put('brandSelected', 'Payne');
        System.currentPageReference().getParameters().put('dealerName', 'Test dealer');
        System.currentPageReference().getParameters().put('dealerPhone', '4567890324');
        System.currentPageReference().getParameters().put('selectedDealerId', acct.Id);
        System.currentPageReference().getParameters().put('source', 'DistLoctBtn');
        System.currentPageReference().getParameters().put('CaseId', cse.Id);
        System.currentPageReference().getParameters().put('caseId2', cse.Id); 
        System.currentPageReference().getParameters().put('param','Payne'); 
        System.currentPageReference().getParameters().put('id',cse.Id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        DSMNonCaseSearchExtLinkController cont = new DSMNonCaseSearchExtLinkController(sc);
        cont.brandSelected = 'Payne';
        cont.searchDist();
       // DSM_Distributor_Directory__c direct = [Select Id from DSM_Distributor_Directory__c where State__c='NY' and Brand__c='Carrier' and County_Name__c='Onondaga County' limit 1];
        cont.selectedDistIdForCaseCreation = direct.Id;
        cont.createCase();
        cont.createDealerAccount('test');
        cont.createDealerContact('test','test','test@gmail.com','5671231242');
        cont.updateCase();
        cont.init();
     }
}