@isTest(SeeAllData=True)
public class RC_CCSControllerTest {
    public static List<Product2> parts;
    public static testmethod void startTest(){ 
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user166776@gmail.com',
                         profileid = testprof1.id, 
                         UserName='test7666677666.user@gmail.com',
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US',
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test166776',
                         LastName = 'user166886');
        
        insert u1;
        
        System.runAs(u1){
            Contact con = new Contact();
            con.LastName='testcon';
            con.Email='test@gmail.com';
            con.HVAC_Contact_Id__c='1234';
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
            
            Attachment attach=new Attachment(); 
            attach.Name='Unit Test Attachment'; 
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
            attach.body=bodyBlob; attach.parentId=rcCase.id;
            insert attach;
            
            WrapperCls__c wrp = new WrapperCls__c();
            wrp.name = 'test';
            wrp.failedPrt__c=true;
            wrp.prtNo__c='test';
            List<WrapperCls__c> wrplist = new List<WrapperCls__c>();
            wrplist.add(wrp);
            insert wrplist;
            
            WrapperCls__c wrp2 = new WrapperCls__c();
            wrp2.name = 'test';
            wrp2.failedPrt__c=false;
            wrp2.prtNo__c='test';
            List<WrapperCls__c> wrplist2 = new List<WrapperCls__c>();
            wrplist2.add(wrp2);
            insert wrplist2;
            
            Picklists_Control__c pc = new Picklists_Control__c();
            pc.name='testing';
            pc.Record_Type__c='CCC_Replacement_Component';
            pc.Picklist_Field_Name__c='test';
            pc.Picklist_Field_Value__c='Quote';
            pc.Controlling_Field_Value__c='Pricing/Quoting';
            pc.Is_Dependent__c=true;
            pc.Is_Controlling__c=true;
            insert pc;
            
            Product2 prod = new Product2();
            prod.Name=wrp.Name;
            insert prod;
            
            test.StartTest();
            RC_CCSController.fetchUser();
            RC_CCSController.getCase(rcCase.id);
            String payloadStr='SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=';
            RC_CCSController.getparsePayloadAndGetValues(payloadStr);
            RC_CCSController.getDependentOptionsImpl('Case', 'test', 'test');
            RC_CCSController.getPicklistOptionsImpl('Case', 'test', 'test');
            List<String> contLst = new List<String>();
            contLst.add('Hema');
            contLst.add('Mannidi');
            contLst.add('hema.mannidi@carrier.utc.com');
            contLst.add('123456');
            //  RC_CCSController.saveCase(description, subject, conPurpose, conSubPurpose, serial, model, ListPart, CustomerPO, value)
            RC_CCSController.saveCase('test','DISTCUST', 'test', 'Expedite', 'Expedite', 'test', 'test', wrplist,'test',contLst,'test','test','test','After Nov 2004');
            RC_CCSController.saveCase('test','DISTCUST', 'test', 'Expedite', 'Expedite', 'test', 'test', wrplist2,'test',contLst,'test','test','test','After Nov 2004');
             
            
            RC_CCSController.saveChunk(rcCase.id, 'Midea2.png', 'iVBORw0KGgoAAAANSUhE', 'image/png', '');
            RC_CCSController.saveTheFile(rcCase.id, 'Midea2.png', 'iVBORw0KGgoAAAANSUhE', 'image/png');
            RC_CCSController.appendToFile(attach.Id,'test');
            String fileId = attach.id;
            RC_CCSController.saveChunk(rcCase.id, 'Midea2.png', 'iVBORw0KGgoAAAANSUhE', 'image/png', fileId);
            RC_CCSController.getDependentOptionsImpl('Case', 'CCC_Purpose__c', 'CCC_Sub_Purpose__c');
            RC_CCSController.getPicklistOptionsImpl('Case', 'CCC_Purpose__c', 'CCC_Sub_Purpose__c');
            test.stopTest();
        }
    }
    
}