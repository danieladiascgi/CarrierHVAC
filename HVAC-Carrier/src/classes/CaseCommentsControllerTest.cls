@isTest (SeeAllData=True)
public class CaseCommentsControllerTest {
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
            Case cc = new Case();
            cc.Subject='testcase';
            insert cc;
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
            CaseComment caseCmt = new CaseComment();
            caseCmt.CommentBody='test';
            caseCmt.IsPublished=true;
            // caseCmt.CreatedDate=system.Date();
            // caseCmt.CreatedBy.Name='test';
            caseCmt.ParentId=cc.id;
            insert caseCmt; 
            test.startTest();
            CaseCommentsController.DisplayComments(exp.Id);
            CaseCommentsController.checkIfPlannerIsEmpty(exp.Id);
            test.stopTest();    
            
        }
    }
}