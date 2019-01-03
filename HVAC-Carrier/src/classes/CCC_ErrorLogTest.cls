@isTest
public class CCC_ErrorLogTest
{
   public static TestMethod void CCC_ErrorLog()
   {
       CCC_Error_log__c log=new CCC_Error_log__c ();
    
        Profile p = [select id from profile where name='CCC Base Profile'];
        User u = new User(alias = 'userTest', 
                          email='developercto@carrier.com',
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US', 
                          lastname='Testing', 
                          profileid = p.Id, 
                          timezonesidkey='America/Los_Angeles',
                          localesidkey='en_US',
                          username='developercto@carrier.com'); 
    insert u; 
   
     
        
    System.runAs(u)
    {
        System.CalloutException ce=new System.CalloutException();
        String strAddinfoTest='def';
        String strSourceTest='ghi';
        CCC_ErrorLog errorLog=new CCC_ErrorLog();
        Test.startTest();
        errorLog.ErrorLogCalloutException(ce,strAddinfoTest,strSourceTest);
        errorLog.ErrorLogException(ce,strAddinfoTest,strSourceTest);
        Test.stopTest();
     
     
    }

    
    }
    
}