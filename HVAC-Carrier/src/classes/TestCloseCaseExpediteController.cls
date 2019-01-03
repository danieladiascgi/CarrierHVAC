@isTest(SeeAllData=true)
public class TestCloseCaseExpediteController {
public static testmethod void CloseExpediteTest(){
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user18512171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test181521711.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test52181217144',
                         LastName = 'user21581217144');
        insert u1;
        System.runAs(u1){
            
            Case c= new Case();
            c.Subject='test';
            insert c;
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
           // exp.Contact_Name__c=con.Id;
            exp.Case_Number__c=c.Id;
            insert exp;
            
            
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'rcdexpediting@carrier.utc.com';
            email.Incoming = false;
            email.ToAddress= 'test@xyz.org';
            email.Subject = 'Test email';
            email.HtmlBody = 'Test email body';
            email.ParentId = c.Id; 
            email.MessageDate=system.today();
            insert email;
            
      test.startTest();
          
        System.currentPageReference().getParameters().put('emailRecordId', email.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(exp);
        CloseCaseExpediteController cont = new CloseCaseExpediteController(sc);
            cont.getStatusOptions();
            cont.getResolutionCodeOptions();
            cont.saveAndRedirect();
            cont.saveAndClose();
            cont.cancel();
      test.stoptest();
        }
    }
}