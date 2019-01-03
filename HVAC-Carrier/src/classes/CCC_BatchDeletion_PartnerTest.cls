@isTest
public class CCC_BatchDeletion_PartnerTest{
    static testMethod void testUpdateProductDetails()
    {
    String query ='Select id from CCC_Partner__c'+ 'where CCC_Integration_field__c=Modify';
    String CRON_EXP = '0 0 0 15 3 ? 2022';
    List<Account> accList= new List<Account>();
    Account MyAccount = new Account(Name='Test');
        insert MyAccount;
        accList.add(MyAccount);
    
    Test.StartTest();
    CCC_BatchDeletion_Partner deleteCS = new CCC_BatchDeletion_Partner();
    ID batchprocessid =Database.executeBatch(deleteCS,2);
    String jobId = System.schedule('CCC_BatchDeletion_PartnerTest',CRON_EXP,new CCC_BatchDeletion_Partner());
    Database.executeBatch(new CCC_BatchDeletion_Partner());
    deleteCS.execute( (Database.BatchableContext) null, new List<Account>{MyAccount});
    Test.StopTest();
    }


}