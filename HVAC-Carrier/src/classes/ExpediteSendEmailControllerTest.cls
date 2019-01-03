@isTest(SeeAllData=true)
public class ExpediteSendEmailControllerTest {
    public static testmethod void ExpediteSendEmailControllerTest(){
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
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
            Contact con= new contact();
            con.LastName='testUsrCon';
            con.Email='test@gmail.com';
            insert con;
            
            Case c= new Case();
            c.Subject='test';
            c.ContactId=con.Id;
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
            exp.Contact_Name__c=con.Id;
            exp.Case_Number__c=c.Id;
            insert exp;
            
            
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'rcdexpediting@carrier.utc.com';
            email.Incoming = false;
            email.ToAddress= 'test@xyz.org';
            email.Subject = 'Test email';
            email.HtmlBody = 'Test email body';
            email.ParentId = c.Id; 
            insert email;
            
            
            EmailTemplate validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'Expedite';
            validEmailTemplate.DeveloperName = 'test_EmailTemplate';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId='00l15000002CLo2';
            
            insert validEmailTemplate;
            Attachment attach=new Attachment();     
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=c.id;
            
            list<attachment>lst= new list<attachment>();
            lst.add(attach);
            insert attach;
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = exp.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            insert cdl;
            
            
            
            test.startTest();
            ExpediteSendEmailController.populateBodyWithTemplate(exp.Id,validEmailTemplate.Id,email) ;
            ExpediteSendEmailController.fetchUser();
            ExpediteSendEmailController.populateTemplate(exp.Id);
            ExpediteSendEmailController.getAttachments(exp.Id); 
            ExpediteSendEmailController.selectTemplatePopup();
            ExpediteSendEmailController.SelectedAttachs selAttach = new ExpediteSendEmailController.SelectedAttachs();
            selAttach.value='test';
            ExpediteSendEmailController.sendMailMethod('test@xyz.org', 'rcdexpediting@carrier.utc.com','test@xyz.org', 'Test email', 'Test email body', '[{"value":"attach.Id"}]', exp.Id);
            ExpediteSendEmailController.attachWrapper aw= new ExpediteSendEmailController.attachWrapper(true,attach.Id,'Unit Test Attachment');
            test.stoptest();
        }
    }
}