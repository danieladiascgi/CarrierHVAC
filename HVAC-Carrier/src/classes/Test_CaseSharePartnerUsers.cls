@isTest(seeAlldata=true)
public class Test_CaseSharePartnerUsers {
    public static testmethod void testCaseSharePartnerUsers(){
    Case cse = Test_CaseSharePartnerUsers.createCase();
    List<String> caseLst = new List<String>();
    caseLst.add(cse.Id);
    CaseSharePartnerUsers.giveAccessToPartnerUsersProcessBuilder(caseLst);
	CaseRemovePartnerUsers.removeAccessToPartnerUsersProcessBuilder(caseLst);
   
   }
   
    public static Case createCase(){
        Case testCase1=new Case();
            testCase1.Subject='TestNAFOCase';
            testCase1.Origin='Email';
            testCase1.Status='Open'; 
            //testCase1.AccountId=testAcc.id;
            //testCase1.ContactId=testCon1.id;
            RecordType rt= [select id,Name from RecordType where SobjectType='Case' and Name='Post Sale Support' Limit 1];
            testCase1.recordTypeId=rt.id;
            //testCase1=(Case)utilClass.createTestRecord(testCase1);
            insert testCase1;
        return testCase1;
    }
}