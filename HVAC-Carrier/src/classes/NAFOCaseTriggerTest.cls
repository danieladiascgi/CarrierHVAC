@isTest(SeeAllData=true) 

public class NAFOCaseTriggerTest{
    
    public static testmethod void startTesting(){
        
        Contact cont = new Contact();
        cont.LastName = 'rr';
        cont.FirstName = 'Tejas';
        cont.MailingStreet = '507 Tilden Dr';
        cont.MailingCity = 'Syracuse';
        cont.MailingPostalCode = '13057';
        cont.MailingState = 'NY';
        cont.MailingCountry='United States';
        cont.Email='manjula.r@ltinfotech.com';
        cont.MailingCountry = 'United States';
        cont.AccountId = Label.Warranty_Account_Id;
        insert cont;
        System.debug('#id:'+cont.id);
        Profile testprof1=[SELECT Id FROM Profile WHERE Name ='NAFO WA Profile' limit 1];
        User testusr1=new User( email='manjula.r@ltinfotech.com',
                               profileid = testprof1.id,  
                               UserName='manjula.r@ltinfotech.com.prod.devpro1', 
                               
                               Alias = 'GDS',
                               TimeZoneSidKey='America/New_York',
                               EmailEncodingKey='ISO-8859-1',
                               LocaleSidKey='en_US', 
                               LanguageLocaleKey='en_US',
                               
                               FirstName = 'Meghan',
                               LastName = 'Blake');
        insert testusr1;
        System.runAs(testusr1)
        {
            Id [] fixedSearchResults= new Id[1];
            fixedSearchResults[0] = cont.Id;
            Test.setFixedSearchResults(fixedSearchResults);
            Case testCase1=new Case();
            testCase1.Subject='TestNAFOCase';
            testCase1.Origin='Email';
            testCase1.Status='Open'; 
            //testCase1.AccountId=testAcc.id;
            //testCase1.ContactId=testCon1.id;
            RecordType rt= [select id,Name from RecordType where SobjectType='Case' and Name='Warranty' Limit 1];
            testCase1.recordTypeId=rt.id;
            //testCase1=(Case)utilClass.createTestRecord(testCase1);
            insert testCase1;
        }
    }    
    
    
}