@isTest
public class RCPurposesControllerTest {
    public static Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
    
    public static Id recordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Equipment').getRecordTypeId();
    public static Id recordTypeId2 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
    public static Id recordTypeId3 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Post Sale Support').getRecordTypeId();
    public static String s;
    public static Map<String, Picklists_Control__c> purposePicklistForEquipment;
    public static Map<String, Picklists_Control__c> subPurposePicklistForEquipment;
    public static Map<String, List<String>> contrlKeyLstOfDepend;
    public static List<Case> lstCase;
    public static List<Purpose__c> lstResCount;
    public static String Count;
    public static List<Turnback__c> lstTurnback;
    public static List<Picklists_Control__c> statusList;
    public static testmethod void startTest(){
        //Set up user
        // User u1 = [SELECT Id FROM User WHERE Alias='mr' limit 1];
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        
        User u1=new User( email='test.user110510182@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test110510182.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test110510182',
                         LastName = 'user110510182');
        
        insert u1;
        
        System.runAs(u1){
            Case rcCase = new Case();
            rcCase.RecordTypeId = recordTypeId;
            insert rcCase;
            Case rcCase1 = new Case();
            rcCase1.RecordTypeId = recordTypeId1;
            insert rcCase1;
            Case rcCase2 = new Case();
            rcCase2.RecordTypeId = recordTypeId2;
            insert rcCase2;
            Case rcCase3 = new Case();
            rcCase3.CCC_Solution__c ='test';
            rcCase3.RecordTypeId = recordTypeId3;
            insert rcCase3;
            Purpose__c p = new Purpose__c();
            p.Count__c=23;
            p.Case__c=rcCase.Id;
            insert p;
            
            List<Picklists_Control__c> reasonList = new List<Picklists_Control__c>();
            test.startTest();
            
            RCPurposesController.getCase(rcCase.id);
            
            test.stopTest();             
            
            
            
        }
        
    }
}