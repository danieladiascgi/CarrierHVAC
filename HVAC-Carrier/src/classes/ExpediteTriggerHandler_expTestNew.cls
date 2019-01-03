@isTest(SeeAllData=true)
public class ExpediteTriggerHandler_expTestNew {
    public static testmethod void ExpediteTriggerHandler_expTest(){
        Contact con= new contact();
            con.LastName='testUsrCon';
            con.Email='test@gmail.com';
            insert con;
            
            Case c= new Case();
            c.Subject='test';
            c.ContactId=con.Id;
            insert c;
        test.startTest();
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
          exp.Part__c = '01t15000005RCHB';
            insert exp;
        test.stopTest();
    }
    public static testmethod void ExpediteTriggerHandler_expTestEmails(){
        Contact con= new contact();
            con.LastName='testUsrCon';
            con.Email='tejas.jambekar@lntinfotech.com';
            insert con;
            
            Case c= new Case();
            c.Subject='test';
            c.ContactId=con.Id;
            insert c;
        test.startTest();
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
            exp.Expedite_Status__c='Expedite';
          exp.Part__c = '01t15000005RCHB';
            insert exp;
        exp.Expedite_Status__c = 'Supplier #1';
        update exp;
        test.stopTest();
    }
    public static testmethod void ExpediteTriggerHandler_expTestEmailsSup2(){
        Contact con= new contact();
            con.LastName='testUsrCon';
            con.Email='tejas.jambekar@lntinfotech.com';
            insert con;
            
            Case c= new Case();
            c.Subject='test';
            c.ContactId=con.Id;
            insert c;
        test.startTest();
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
            exp.Expedite_Status__c='Expedite';
          exp.Part__c = '01t15000005RCHB';
            insert exp;
        exp.Expedite_Status__c = 'Supplier #2';
        update exp;
        test.stopTest();
    }
    /*public static testmethod void ExpediteTriggerHandler_expTestEmailsSup3(){
        Contact con= new contact();
            con.LastName='testUsrCon';
            con.Email='tejas.jambekar@lntinfotech.com';
            insert con;
            
            Case c= new Case();
            c.Subject='test';
            c.ContactId=con.Id;
            insert c;
        test.startTest();
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
            exp.Expedite_Status__c='Expedite';
          exp.Part__c = '01t15000005RCHB';
            insert exp;
        exp.Expedite_Status__c = 'Supplier #3';
        update exp;
        test.stopTest();
    }*/
    public static testmethod void ExpediteTriggerHandler_expTestEmailsSup3DNE(){
        Contact con= new contact();
            con.LastName='testUsrCon';
            con.Email='tejas.jambekar@lntinfotech.com';
            insert con;
            
            Case c= new Case();
            c.Subject='test';
            c.ContactId=con.Id;
            insert c;
        test.startTest();
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
            exp.Expedite_Status__c='Supplier #3';
          exp.Part__c = '01t15000005RCHB';
            insert exp;
        exp.Expedite_Status__c = 'Supplier #1';
        exp.Do_not_send_Email__c = true;
        update exp;
        test.stopTest();
    }
}