@isTest 
public class Test_DuplicateContact {

    public static testmethod void startTest(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812175@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test18121711.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test2181217144',
                         LastName = 'user2181217144');
        
        insert u1;
        System.runAs(u1){
             Case c= new Case();
            c.Subject='test';
            c.Description='testDesc';
            c.Priority='Medium';
            c.New_Comment__c=true;
            c.CCC_Turn_Back_Code__c ='Not Applicable';
            c.CCC_Part_Number__c='56756';
            c.SuppliedEmail='ian.sfdc@gmail.com';
            insert c; 
            List<Id> ids = new List<Id>();
            ids.add(c.Id);
            DuplicateContact.DuplicateContact(ids);
        }
    }
}