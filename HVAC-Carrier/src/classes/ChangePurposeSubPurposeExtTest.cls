@isTest
public class ChangePurposeSubPurposeExtTest {
    public static Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
   
    public static testmethod void startTest(){
        //Set up user
        User u1 = [SELECT Id FROM User WHERE Alias='wgordon'];
        
        System.runAs(u1){
            Case rcCase = new Case();
            rcCase.RecordTypeId = recordTypeId;
            rcCase.Origin = 'Phone';
            rcCase.Status = 'Open';
            rcCase.CCC_Purpose__c = 'PTAC';
            rcCase.CCC_Sub_Purpose__c = 'Parts';
            insert rcCase;
            ApexPages.StandardController sc = new ApexPages.StandardController(rcCase);
            ChangePurposeSubPurposeExt ext = new ChangePurposeSubPurposeExt(sc);
            ext.SaveCustom();
        }
        
    }

}