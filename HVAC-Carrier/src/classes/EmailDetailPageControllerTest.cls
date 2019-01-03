@isTest(SeeAllData=true)
public class EmailDetailPageControllerTest {
    public static testmethod void EmailDetailPageControllerTest(){
        
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
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'rcdexpediting@carrier.utc.com';
            //email.Incoming = false;
            email.ToAddress= 'test@xyz.org';
            email.Subject = 'Test email';
            email.HtmlBody = 'Test email body';
            email.ParentId = c.Id; 
            email.MessageDate=system.today();
            email.Status='0';
            insert email;
            EmailMessage email2 = new EmailMessage();
            email2.FromAddress = 'rcdexpediting@carrier.utc.com';
            //email2.Incoming = false;
            email2.ToAddress= 'test@xyz.org';
            email2.Subject = 'Test email';
            email2.HtmlBody = 'Test email body';
            email2.ParentId = c.Id; 
            email2.MessageDate=system.today();
            email2.Status='1';
            insert email2;
            EmailMessage email3 = new EmailMessage();
            email3.FromAddress = 'rcdexpediting@carrier.utc.com';
            //email3.Incoming = false;
            email3.ToAddress= 'test@xyz.org';
            email3.Subject = 'Test email';
            email3.HtmlBody = 'Test email body';
            email3.ParentId = c.Id; 
            email3.MessageDate=system.today();
            email3.Status='2';
            insert email3;
            EmailMessage email4 = new EmailMessage();
            email4.FromAddress = 'rcdexpediting@carrier.utc.com';
            email4.Incoming = false;
            email4.ToAddress= 'test@xyz.org';
            email4.Subject = 'Test email';
            email4.HtmlBody = 'Test email body';
            email4.ParentId = c.Id; 
            email4.MessageDate=system.today();
            email4.Status='3';
            insert email4;
            EmailMessage email5 = new EmailMessage();
            email5.FromAddress = 'rcdexpediting@carrier.utc.com';
            email5.Incoming = false;
            email5.ToAddress= 'test@xyz.org';
            email5.Subject = 'Test email';
            email5.HtmlBody = 'Test email body';
            email5.ParentId = c.Id; 
            email5.MessageDate=system.today();
            email5.Status='4';
            insert email5;
            EmailMessage email6 = new EmailMessage();
            email6.FromAddress = 'rcdexpediting@carrier.utc.com';
            email6.Incoming = false;
            email6.ToAddress= 'test@xyz.org';
            email6.Subject = 'Test email';
            email6.HtmlBody = 'Test email body';
            email6.ParentId = c.Id; 
            email6.MessageDate=system.today();
            email6.Status='5';
            insert email6;
          
            
            Attachment attach = new Attachment();
            attach.Name = 'Test';
            attach.Body = Blob.valueOf('Testing');
            attach.ParentId = email6.Id;
            insert attach;
            
            test.startTest();
            EmailDetailPageController.getEmailMessageRecToBePassed(email.Id); 
            EmailDetailPageController.getEmailMessageRecToBePassed(email2.Id);  
            EmailDetailPageController.getEmailMessageRecToBePassed(email3.Id); 
            EmailDetailPageController.getEmailMessageRecToBePassed(email4.Id); 
            EmailDetailPageController.getEmailMessageRecToBePassed(email5.Id); 
            EmailDetailPageController.getEmailMessageRecToBePassed(email6.Id); 
            EmailDetailPageController.getAttachments(email6.Id);
            EmailDetailPageController.getEmailMessageRecToBePassedNew(email6.Id,'email');
            EmailDetailPageController.getReplyEmailMsg(email6,'email');
            EmailDetailPageController.checkIfCurrentLoggedInUserIsExpedite();
            test.stoptest();
        }
    }
}