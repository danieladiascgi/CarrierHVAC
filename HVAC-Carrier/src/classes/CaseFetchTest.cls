@isTest
public class CaseFetchTest {
    
    public static testmethod void startTest(){
        //Set up user
        // User u1 = [SELECT Id FROM User WHERE Alias='mr' limit 1];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Equipment').getRecordTypeId();
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        
        User u1=new User( email='test.user166666666@gmail.com',
                         profileid = testprof1.id, 
                         UserName='test76666666.user@gmail.com',
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US',
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test166666',
                         LastName = 'user166666');
        
        insert u1;
        
        System.runAs(u1){
            Contact con = new Contact();
            con.LastName='testcon';
            con.Email='test@gmail.com';
            insert con;
            
            Case rcCase = new Case();
            rcCase.RecordTypeId = recordTypeId;
            rcCase.New_Msg__c = true;
            rcCase.CCC_Turn_Back_Code__c='Not Applicable';
            rcCase.ContactId=con.id;
            insert rcCase;
            
            Picklists_Control__c pc = new Picklists_Control__c();
            pc.Picklist_Field_Value__c= 'Testing Please Ignore';
            pc.Name='1500';           
            pc.Picklist_Field_Name__c = 'test';
            pc.Record_Type__c ='Equipment';           
            insert pc;
            
           
            
            
            Map<String, Picklists_Control__c> map1 = new Map<String, Picklists_Control__c>();
            map1.put('test',pc);
            
            Map<String,String> map2 = new Map<string,String>();
            map2.put('test1','test2');
            
            test.StartTest();
            Boolean flag1 = true;
            CaseFetch.flag = flag1;
            CaseFetch.purposePicklistForEquipment = map1;
            CaseFetch.subPurposePicklistForEquipment = map1;
            CaseFetch.customerType = map2;
            CaseFetch.updateNewMsgFieldOnRead(rcCase.Id);
            CaseFetch.getDependentOptionsImpl('case','test', 'test');
            CaseFetch.getPicklistOptionsImpl('case','test', 'test');
            CaseFetch.getCase(rcCase.Id);
            CaseFetch.saveCase(rcCase);
            CaseFetch.saveCase5(rcCase);
            CaseFetch.ChangeOwner(rcCase.id);
            CaseFetch.ChangeOwner2(rcCase.id);
            CaseFetch.updateNewMsgFieldOnRead(rcCase.Id);
            CaseFetch.getRT(rcCase.id);
            test.stopTest();
            
        }
    }
}