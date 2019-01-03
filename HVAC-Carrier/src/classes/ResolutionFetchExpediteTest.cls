@isTest (SeeAllData=True)
public class ResolutionFetchExpediteTest {
    public static List<Turnback__c> lstTurnback;
    
    public static testmethod void startTest(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test1812171.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test181217144',
                         LastName = 'user181217144');
        insert u1;
        System.runAs(u1){
        Expedite__c exp= new Expedite__c();
            exp.Reason__c='Expdite';
            exp.C10_Order__c='test';
            exp.Part_Number__c='123';
            exp.Customer_PO__c='test';
            exp.Quantity__c=1;
            exp.Customer_Type__c='CBP';
            exp.RCD_PO__c='test';
            exp.Sender_s_Email__c='test@gmail.com';
            exp.Source__c='Email';
        insert exp;
        test.startTest();
        ResolutionFetchExpedite.getContactVal(exp.id);
        ResolutionFetchExpedite.getExpedite(exp.id);
      //  ResolutionFetchExpedite.getRecordType(exp.id);
        ResolutionFetchExpedite.getResolutionCode(exp.id);
        ResolutionFetchExpedite.getselectOptions(exp,'Expedite_Status__c');
        ResolutionFetchExpedite.getTurnback(exp.id);
        ResolutionFetchExpedite.saveCase(exp,'Provided Information', 'Dealer Error','Hold', system.today(), 'test', '2013-06-07 00:00:00');
        ResolutionFetchExpedite.saveCaseClose(exp, 'Not Applicable', 'Dealer Error', system.today(), 'test', '2013-06-07 00:00:00');
        createTurnbacks('Replacement Component', true);
        test.stopTest();     
            
        }
      }
    public static void createTurnbacks(String recordType, Boolean isICP){
        Turnback__c tb = new Turnback__c();
        tb.Title__c = 'Testing Please Ignore';
        tb.Is_ICP__c = isICP;
        tb.Status__c = 'Open';
        tb.Expedite__c= true;
           
        
        insert tb;
    }
}