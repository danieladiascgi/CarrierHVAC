@istest(seeAlldata=true)
public class TestHideEmailsFromExternalVisiblity {
    public static testmethod void testExternalVisiblityFalse(){
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
        exp.Case_Number__c = c.Id;
        insert exp;
        String expediteName = [Select Id, Name from Expedite__c where Id=:exp.Id].Name;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = expediteName+' Testing Subject';
        msg.TextBody = 'testing';
        msg.ToAddress = 'tejas.jambekar@lntinfotech.com; tejassalesforce@gmail.com';
        msg.CcAddress = 'tejas@gmail.com';
        msg.ParentId = c.Id;
        insert msg;
        System.debug('#Message Inserted');
        List<String> emailIds = new List<String>();
        emailIds.add(msg.Id);
        HideEmailsFromExternalVisiblity.hideVednorEmailsFromExternalVisiblity(emailIds);
        List<Id> expediteLst = new List<Id>();
        expediteLst.add(exp.Id);
        HideEmailsFromExternalVisiblity.postToExpediteGroup(expediteLst, emailIds);
    }

}