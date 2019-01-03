@isTest (SeeAllData=True)
public class MideaCaseTriggerTest {
    public static testMethod void testMideaTrigger() {
        
        Case cse = new Case();
        cse.RecordTypeId = [SELECT Id, Name, SobjectType FROM RecordType where SobjectType ='Case' and Name='Consumer Relations'].Id;
        cse.SuppliedCompany = 'Test Company';
        cse.SuppliedEmail = 'test@gmail.com';
        cse.SuppliedName = 'TestFN TestLN';
        cse.SuppliedPhone = '8765432178';
        cse.Origin = 'Midea';
        cse.CCC_Brand__c = 'Midea';
        insert cse;
        Contact cont = new Contact();
        cont.FirstName = 'Test FN';
        cont.LastName = 'Test LN';
        cont.Email = 'test@gmail.com';
        cont.Phone = '8765432178';
        cont.MailingStreet = '300 Deerfield Road';
        cont.MailingCity = 'East Syracuse';
        cont.MailingState = 'NY';
        cont.MailingPostalCode = '13057';
        cont.MailingCountry = 'US';
        insert cont;
        Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = cont.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
        Case cseNew = new Case();
        cseNew.RecordTypeId = [SELECT Id, Name, SobjectType FROM RecordType where SobjectType ='Case' and Name='Consumer Relations'].Id;
        cseNew.SuppliedCompany = 'Test Company';
        cseNew.SuppliedEmail = 'test@gmail.com';
        cseNew.SuppliedName = 'TestFN TestLN';
        cseNew.SuppliedPhone = '8765432178';
        cseNew.Origin = 'Midea';
        cseNew.CCC_Brand__c = 'Midea';
        insert cseNew;
        Case cseWithoutFN = new Case();
        cseWithoutFN.RecordTypeId = [SELECT Id, Name, SobjectType FROM RecordType where SobjectType ='Case' and Name='Consumer Relations'].Id;
        cseWithoutFN.SuppliedCompany = 'Test Company';
        cseWithoutFN.SuppliedEmail = 'test1@gmail.com';
        cseWithoutFN.SuppliedName = 'Test';
        cseWithoutFN.SuppliedPhone = '8765432178';
        cseWithoutFN.Origin = 'Midea';
        cseWithoutFN.CCC_Brand__c = 'Midea';
        insert cseWithoutFN;
    }
}