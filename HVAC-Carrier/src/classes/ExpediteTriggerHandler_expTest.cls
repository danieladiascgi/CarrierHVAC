@isTest(SeeAllData=true)
public class ExpediteTriggerHandler_expTest {
    public static testmethod void ExpediteTriggerHandler_expTest(){
        
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
            Contact con= new contact();
            con.LastName='testUsrCon';
            con.Email='test@gmail.com';
            insert con;
            
            Case c= new Case();
            c.Subject='test';
            c.ContactId=con.Id;
            insert c;
            
            EmailTemplate validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'Supplier 1';
            validEmailTemplate.DeveloperName = 'test_EmailTemplate';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId='00l15000002CLo2';
            
            test.startTest();
            
            //insert validEmailTemplate;
            //
            Expedite__c exp= new Expedite__c();
            exp.Reason__c='Expdite';
            exp.C10_Order__c='test';
            exp.Part_Number__c='123';
            exp.Customer_PO__c='test';
            exp.Quantity__c=1;
            exp.Customer_Type__c='CBP';
            exp.RCD_PO__c='test';
            exp.Sender_s_Email__c='test@gmail.com';
            exp.Source__c='Email';
            exp.Contact_Name__c=con.Id;
            exp.Case_Number__c=c.Id;
            exp.Expedite_Status__c='Supplier #1';
            insert exp;
            
            List<Expedite__c> explist = new  List<Expedite__c>();
            explist.add(exp);
            Product2 prod= new Product2();
            prod.CCC_Parts_Quantity__c=88;
            prod.CCC_Vendor_Name__c='test';
            prod.name='test';
            insert prod;
            
               
            
            
            ExpediteTriggerHandler_exp expobj = new ExpediteTriggerHandler_exp();
            expobj.UpdateEmailDetails(explist);
            expobj.updateProductDetails(explist);
            
            exp.Part__c=prod.Id;
            update exp;
            expobj.updateProductDetails(explist);
            
            test.stopTest();
        }
    }
}