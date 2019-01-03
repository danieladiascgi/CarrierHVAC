@isTest
public class Send_To_Junk_ControllerTest {
   
   public static testmethod void sendToJunk(){
   Profile testProfile = [select id,UserLicenseId from profile where name='System Administrator'];
     
    //create user
    User testUser = new User(alias = 'userTest', email='developercto@carrier.com',emailencodingkey='UTF-8',
                        languagelocalekey='en_US', lastname='Testing', 
                        profileid = testProfile.Id, timezonesidkey='America/Los_Angeles',localesidkey='en_US',
                        username='developercto@carrier.com'); 
    insert testUser; 
       
        

       
       //Group grp = new Group(Name='Junk Email',Type = 'Queue');
       //insert grp;
       
        System.runAs(testUser){
            Boolean refreshPage1 = true;
                
             case c = new case();
            c.CCC_Customer_Type__c = 'Commercial';
            c.CCC_Brand__c = 'ICP';
          //  c.Status ='Open';
         
            c.OwnerId=testUser.id;
           // c.CCC_Turn_Back_Code__c = 'test';
            insert c;
            
            String id1;
            id1 = ApexPages.currentPage().getParameters().put('id',c.id);
            
           
            
            ApexPages.StandardController sc = new ApexPages.StandardController(c);
            Send_To_Junk_Controller ext = new Send_To_Junk_Controller(sc);
            ext.refreshPage = refreshPage1;
            ext.ChangeOwner();
        }
    
}
}