@isTest(seeAlldata=true)
public class TestCaseCommentsDetailController {
public static testmethod void startTest(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test1812171.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test181297144',
                         LastName = 'user1812917144');
        insert u1;
         Case c= new Case();
         c.Subject='Test';
         c.Description='testDesc';
         c.Priority='Medium';
         c.New_Comment__c=true;
         c.CCC_Turn_Back_Code__c = 'Not Applicable';
         insert c;
    	CaseComment cmt = new CaseComment();
    	cmt.ParentId = c.Id;
    	cmt.CommentBody = 'Testing';
    	insert cmt;
        System.runAs(u1){
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
            exp.Case_Number__c=c.Id;
            exp.Buyer__c=c.CCC_Product_Buyer__c;
            exp.Planner__c=c.CCC_Planner__c;
            exp.Vendor_Code__c=c.CCC_Vendor_Code__c;
            exp.Vendor_Name__c=c.CCC_Vendor_Name__c;
        //insert exp;
        Turnback__c tb = new Turnback__c();
        tb.Title__c = c.CCC_Turn_Back_Code__c;
        tb.Is_ICP__c = true;
        tb.Status__c = 'Open';
        tb.Expedite__c=true;
         insert tb;
        test.startTest();
        CaseCommentsDetailController.eachcmt = cmt;
        CaseCommentsDetailController.getCaseCommentRecToBePassed(cmt.Id);
            
        test.stopTest();
}
     }
}