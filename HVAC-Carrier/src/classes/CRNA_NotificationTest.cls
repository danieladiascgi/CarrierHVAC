@isTest
public class CRNA_NotificationTest {
    
    public static testMethod void runTests() {
        Account gpa = new Account(Name='Grand Parent Account');
        insert gpa;
        Contact pcon = new Contact(AccountId=gpa.Id, LastName='Thomas', Email='gpthomas@test.devna123');
        insert pcon;
        Notification_Subscription__c nsp = new Notification_Subscription__c(Notification_Type__c='Order Acknowledgement', IsNotify__c=true, Contact__c=pcon.Id, Include_Child_Accounts__c=true);
        insert nsp;
        
        Account a = new Account(Name='Test Account', ParentId=gpa.Id);
        insert a;
        Contact con = new Contact(AccountId=a.Id, LastName='Thomas', Email='thomas@test.devna123');
        insert con;
        Notification_Subscription__c ns = new Notification_Subscription__c(Notification_Type__c='Order Acknowledgement', IsNotify__c=true, Contact__c=con.Id, Account__c=a.Id, Include_Child_Accounts__c=true);
        insert ns;
        
        Account ca = new Account(Name='Child Account', parentId=a.Id);
        insert ca;
        Contact ccon = new Contact(AccountId=ca.Id, LastName='Thomas', Email='cthomas@test.devna123');
        insert ccon;
        Notification_Subscription__c nsc = new Notification_Subscription__c(Notification_Type__c='Order Acknowledgement', IsNotify__c=true, Contact__c=ccon.Id);
        insert nsc;

        Case cas = new Case(AccountId=a.Id, Subject='Test Case', contactId=con.Id);
        insert cas;
        
        EmailMessage em = new EmailMessage(ParentId=cas.Id, Subject='Test Email', Incoming=false);
        insert em;
        
        CRNA_Notification.NotificationRequest nr = new CRNA_Notification.NotificationRequest();
        nr.notificationType='Order Acknowledgement';
        nr.emailTemplateName='Order Processing - Ack';
        nr.caseRecord=cas;
        
        List<CRNA_Notification.NotificationRequest> nrs = new List<CRNA_Notification.NotificationRequest>();
        nrs.add(nr);
        
        CRNA_Notification.sendOrderEmail(nrs);
    }
    
    public static testMethod void testContactOnlySubscriptions() {
        Account a = new Account(Name='Test Account');
        insert a;
        
        Contact ccon = new Contact(AccountId=a.Id, LastName='Thomas', Email='cthomas@test.devna123');
        insert ccon;
        
        Notification_Subscription__c nsc = new Notification_Subscription__c(Notification_Type__c='Order Acknowledgement', IsNotify__c=true, Contact__c=ccon.Id);
        insert nsc;        
        
        Case cas = new Case(Subject='Test Case', contactId=ccon.Id, accountId=a.id);
        insert cas;
        
        EmailMessage em = new EmailMessage(ParentId=cas.Id, Subject='Test Email', Incoming=false);
        insert em;
        
        CRNA_Notification.NotificationRequest nr = new CRNA_Notification.NotificationRequest();
        nr.notificationType='Order Acknowledgement';
        nr.emailTemplateName='Order Processing - Ack';
        nr.caseRecord=cas;
        
        List<CRNA_Notification.NotificationRequest> nrs = new List<CRNA_Notification.NotificationRequest>();
        nrs.add(nr);
        
        CRNA_Notification.sendOrderEmail(nrs);
    }
}