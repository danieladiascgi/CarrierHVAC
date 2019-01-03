@isTest (SeeAllData=true)
public class LiveChatButtonController_Test {
    public static testmethod void startTest(){
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
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
            test.startTest();
            Contact con = new Contact();
            con.LastName='testcon';
            con.Email='test@gmail.com';
            insert con;
            Id [] fixedSearchResults= new Id[1];
           fixedSearchResults[0] = con.Id;
           Test.setFixedSearchResults(fixedSearchResults);
            
            Case rcCase = new Case();
            rcCase.RecordTypeId = recordTypeId;
            rcCase.New_Msg__c = true;
            rcCase.CCC_Turn_Back_Code__c='Not Applicable';
            rcCase.ContactId=con.id;
            rcCase.Description='test';
            insert rcCase;
            String payloadStr='SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=';
            Test.setCurrentPageReference(new PageReference('Page.LiveChatButton')); 
			System.currentPageReference().getParameters().put('value', payloadStr);
            System.currentPageReference().getParameters().put('caseNumber', rcCase.CaseNumber);
            System.currentPageReference().getParameters().put('purpose', 'Expedite');
            System.currentPageReference().getParameters().put('subPurpose', 'Expedite');
            System.currentPageReference().getParameters().put('partNumber', '18-32334');
            System.currentPageReference().getParameters().put('orderNumber', '345345');
            LiveChatButtonController cont = new LiveChatButtonController();
            cont.parsePayloadAndGetValues(payloadStr);
            test.stopTest();
        }
        
    }
}