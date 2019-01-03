@isTest(SeeAllData=True)
public class MyOpenCasesControllerTest {
    public static testmethod void startTest(){
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
        Profile testprof1= [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u=new User( email='test.user112171@gmail.com',
                        profileid = testprof1.id,  
                        UserName='test1812171.user@gmail.com', 
                        Alias = 'GDS',
                        TimeZoneSidKey='America/New_York',
                        EmailEncodingKey='ISO-8859-1',
                        LocaleSidKey='en_US', 
                        LanguageLocaleKey='en_US',
                        PortalRole = 'Manager',
                        FirstName = 'test11217144',
                        LastName = 'user18217144');
        
        insert u;
        System.runAs(u){ 
            
            Contact con = new Contact();
            con.LastName='testcon';
            con.Email='hemanjana.mannidi@utc.com';
            insert con;
            Id [] fixedSearchResultsFirst= new Id[1];
           fixedSearchResultsFirst[0] = con.Id;
           Test.setFixedSearchResults(fixedSearchResultsFirst);
            Case rcCase = new Case();
            rcCase.New_Msg__c = true;
            rcCase.CCC_Turn_Back_Code__c='Not Applicable';
            rcCase.ContactId=con.Id;
            rcCase.Status='Closed';
            rcCase.RecordTypeId=recordTypeId;
            List<Case> casesLst = new List<Case> ();
            casesLst.add(rcCase);
            insert casesLst;
            
            //  List<CaseWrapper> wrprLst = new List<CaseWrapper>();
            CaseWrapper wrp = new CaseWrapper();
            wrp.CaseId=rcCase.Id;
            
            // wrprLst.add(wrp);
            
            
            test.startTest();
            
            MyOpenCasesController.fetchCases('hemanjana.mannidi@utc.com');
            MyOpenCasesController.fetchClosedCases('hemanjana.mannidi@utc.com');
            //MyOpenCasesController.getClosedCases('hemanjana.mannidi@utc.com');
            MyOpenCasesController.getDateFormatted(system.today());
            //MyOpenCasesController.getOpenCases('hemanjana.mannidi@utc.com');
            
            
            /** New **/
            contact con2 = new contact();
            con2.lastname = 'test';
            con2.Email='manju@gmail.com';
            insert con2;
            Id [] fixedSearchResults= new Id[1];
            fixedSearchResults[0] = con2.Id;
            Test.setFixedSearchResults(fixedSearchResults);
            
            Case rcCase2 = new Case();
            rcCase2.New_Msg__c = true;
            rcCase2.CCC_Turn_Back_Code__c='Not Applicable';
            rcCase2.ContactId=con2.Id;
            rcCase2.Status='Open';
            rcCase2.RecordTypeId=recordTypeId;
            insert rcCase2;
			Expedite__c exp= new Expedite__c();
            exp.Contact_Name__c = con2.Id;
            exp.Reason__c='Expdite';
            exp.C10_Order__c='test';
            exp.Part_Number__c='123';
            exp.Customer_PO__c='test';
            exp.Quantity__c=1;
            exp.Customer_Type__c='CBP';
            exp.RCD_PO__c='test';
            exp.Sender_s_Email__c='test@gmail.com';
            exp.Source__c='Email';
            exp.Case_Number__c = rcCase2.Id;
            insert exp;            
            MyOpenCasesController.getOpenCases('manju@gmail.com');
            
            rcCase.status = 'Closed';
            rcCase.ContactId=con2.Id;
            update rcCase;
            MyOpenCasesController.getClosedCases('manjula.r@lntinfotech.com');
            MyOpenCasesController.getOpenExpedites('manju@gmail.com');
            test.stopTest();
            
        }
    }
}