@isTest
public class ClaimsExtensionTest {
        
    public static testmethod void startTest(){
    Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Equipment').getRecordTypeId();
    Profile testProfile = [select id,UserLicenseId from profile where name='System Administrator'];
     
    //create user
    User testUser = new User(alias = 'userTest', email='developerctooooop@carrier.com',emailencodingkey='UTF-8',
                        languagelocalekey='en_US', lastname='Testing', 
                        profileid = testProfile.Id, timezonesidkey='America/Los_Angeles',localesidkey='en_US',
                        username='developerctoooooopp@carrier.com'); 
    insert testUser; 
    System.runAs(testUser){
       Case currentCase = new Case();
       currentCase.RecordTypeId = recordTypeId;
       insert currentCase;
       ApexPages.StandardController sc = new ApexPages.StandardController(currentCase);
        ClaimsExtension ext = new ClaimsExtension(sc);
        ext.saveCase();
    }
  }
}