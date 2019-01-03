@isTest (SeeAllData=true)
public class TilesDashboard_RCControllerTest {
    public static string email;
    public static testmethod void startTest(){
        Profile testprof1= [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u=new User( email='test.user18812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test1812171.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         PortalRole = 'Manager',
                         FirstName = 'test1881217144',
                         LastName = 'user1818217144');
                     
        insert u;
        System.runAs(u){         
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('X-LIVEAGENT-API-VERSION', '42');
        req.setHeader('Content-Type','application/json');
        req.setHeader('X-LIVEAGENT-AFFINITY','');
        req.setEndpoint('https://d.la1-c1cs-ord.salesforceliveagent.com/chat/rest/Visitor/Availability?org_id=00D0m000000Cs8f&deployment_id=5720m0000008OKH');

      

          test.startTest();
            TilesDashboard_RCContoller.fetchUser();
             String payloadStr='SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=';
           
            TilesDashboard_RCContoller.getparsePayloadAndGetName(payloadStr);
            TilesDashboard_RCContoller.getparsePayloadAndGetValues(payloadStr);
            TilesDashboard_RCContoller.checkBtnOnline('hemanjana.mannidi@utc.com', '5730m0000008OLE');
            TilesDashboard_RCContoller cont = new TilesDashboard_RCContoller();
            cont.value = 'hemanjana.mannidi@utc.com';
            cont.email = 'hemanjana.mannidi@utc.com';
            cont.payload = payloadStr;
           
            test.stopTest();
        }
        
    }
}