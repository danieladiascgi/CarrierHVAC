@isTest
public class CCC_BatchUpdat_TSMusersTest{
    static testMethod void testUpdateProductDetails()
    {
    List<Account> accList= new List<Account>();
    Account MyAccount = new Account(Name='Test');
        insert MyAccount;
        accList.add(MyAccount);
    
    CCC_BatchUpdat_TSMusers upc= new CCC_BatchUpdat_TSMusers();
    ID batchprocessid = Database.executeBatch(upc);

    }
}