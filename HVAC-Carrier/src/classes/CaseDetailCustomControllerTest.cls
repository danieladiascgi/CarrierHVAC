@IsTest 
public class CaseDetailCustomControllerTest {
     public static testmethod void startTest(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1818171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test1862171.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test191217144',
                         LastName = 'user171217144');
        insert u1;
        System.runAs(u1){
            Contact con = new Contact();
            con.LastName='testcon';
            con.Email='test@gmail.com';
            insert con;
            
            Case rcCase = new Case();
            rcCase.New_Msg__c = true;
            rcCase.CCC_Turn_Back_Code__c='Not Applicable';
            rcCase.ContactId=con.id;
            insert rcCase;
            Expedite__c exp= new Expedite__c();
            exp.Contact_Name__c = con.Id;
            exp.Reason__c='Expdite';
            exp.C10_Order__c='test';
            exp.Part_Number__c='123';
            exp.Customer_PO__c='test';
            exp.Quantity__c=1;
            exp.Customer_Type__c='CBP';
            exp.RCD_PO__c='test';
            exp.Sender_s_Email__c='test@gmail.com';
            exp.Source__c='Email';
            exp.Case_Number__c = rcCase.Id;
            insert exp;        
            CaseComment caseCmt = new CaseComment();
            caseCmt.CommentBody='test';
            caseCmt.IsPublished=true;
            caseCmt.ParentId=rcCase.id;
            insert caseCmt;
            
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'rcdexpediting@carrier.utc.com';
            email.Incoming = false;
            email.ToAddress= 'test@xyz.org';
            email.Subject = 'Test email';
            email.HtmlBody = 'Test email body';
            email.ParentId = rcCase.Id; 
            email.MessageDate=system.today();
            insert email;
            test.startTest();
            CaseDetailCustomController.checkStatus(rcCase.Id);
            CaseDetailCustomController.DisplayAttachments(rcCase.Id);
            CaseDetailCustomController.DisplayComments(rcCase.Id);
            CaseDetailCustomController.fetchCase(rcCase.Id);
            CaseDetailCustomController.getEmailMessageRec(rcCase.Id);
            CaseDetailCustomController.getEmailMessageRecToBePassed(email.Id);
            CaseDetailCustomController.SaveComments('test', true, rcCase.Id);
            test.stopTest();
            
        }
            
     }
}