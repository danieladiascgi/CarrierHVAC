@isTest
public class EmailMessageTriggerMethodsTest {
    
    public static testMethod void runTests() {
        //Account
        Account a = new Account(Name='Test Account');
        insert a;
        
        //National Accounts Case
        Id rtId = [Select Id from RecordType where SobjectType='Case' and Name='National Accounts'].Id;
        Id qId = [Select Id from Group where Name='National Accounts' and Type='Queue'].Id;
        Case c = new Case(accountId=a.Id, recordtypeId=rtId, ownerId=qId);
        insert c;
        
        //Email Message
        String quoteTxt = 'A new Quote (3091266-00) has been entered by customer# 1000 and is waiting for your review. Customer PO # 853967 Reference 853967   JONES/BOBETI';
        EmailMessage em = new EmailMessage(parentId=c.Id, Incoming=true, TextBody=quoteTxt);
        insert em;
    }
}