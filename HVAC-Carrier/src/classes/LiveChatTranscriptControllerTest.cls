@IsTest (SeeAllData=true)

public class LiveChatTranscriptControllerTest {
    public static testmethod void startTest(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test18121711.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test2181217144',
                         LastName = 'user2181217144');
        
        insert u1;
        System.runAs(u1){
            Case c= new Case();
            c.Subject='test';
            c.Description='testDesc';
            c.Priority='Medium';
            c.New_Comment__c=true;
            c.CCC_Turn_Back_Code__c ='Not Applicable';
            c.CCC_Part_Number__c='56756';
            insert c; 
            Product2 prod= new Product2();
            prod.CCC_Parts_Quantity__c=88;
            prod.CCC_Vendor_Name__c='test';
            prod.name='56756';
            prod.CCC_Parts_Quantity__c=5;
            prod.CCC_Buyer__c='test';
            prod.CCC_ItemType__c='cooler';
            prod.CCC_Planner__c='test1';
            prod.Description='testDesc';
            prod.CCC_CasePack__c=1234.4;
            prod.CCC_Vendor_Code__c='12456';
            prod.ProductCode='456';
            prod.CCC_Vendor_Name__c='tester';
           
            insert prod;
            test.startTest();
            LiveChatVisitor lcv= new LiveChatVisitor();
            lcv.LastModifiedById=u1.id;
           // lcv.CreatedById='00515000006pfAnAAI';
            insert lcv;
            LiveChatTranscript lct = new LiveChatTranscript();
            lct.OwnerId=u1.id;
            lct.LiveChatVisitorId=lcv.Id;
            lct.CaseId=c.Id;
            insert lct;
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(c);
            LiveChatTranscriptController ltc = new LiveChatTranscriptController(sc);
            ltc.LiveChatId= lct.id;
            ltc.caseId1=lct.CaseId;
            c.Id= ltc.caseId1;
            prod.Name=ltc.partNumber;
            c.CCC_Part__c=prod.Id;
            ltc.getcase();
            test.stopTest(); 
            
        }
    }
    
}