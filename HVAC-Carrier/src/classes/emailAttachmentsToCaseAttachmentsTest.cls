@isTest
public class emailAttachmentsToCaseAttachmentsTest
{
    public static User testUsr;
    public static QueuesObject q1;
    public static Group g1;
     public static void setupData(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         
         testUsr=new User( email='test1.user@gmail.com',
                          profileid = p.id,
                          UserName='test1.user@gmail.com',
                          Alias = 'GDS1',
                          TimeZoneSidKey='America/New_York',
                          EmailEncodingKey='ISO-8859-1',
                          LocaleSidKey='en_US',
                          LanguageLocaleKey='en_US',
                          //   ContactId = testCon.id,
                          PortalRole = 'Manager',
                          FirstName = 'test1',
                          LastName = 'user1');
         
         insert testUsr; 
    
    }

public static  testMethod void test_Attachments(){
Test.startTest();
     setupData();
    Case testCase1= new Case();
    testCase1.Subject='ClassCase';
    testCase1.Origin='Email';
    testCase1.Status='Open';
    testCase1.OwnerId = testUsr.id;
    insert testCase1;
     
    EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId = testcase1.Id)); 
    insert newEmail;

    Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=newEmail[0].id;
        insert attach;
    List<Attachment> attachments=[select id, name from Attachment where parent.id=:newEmail[0].id];
    System.assertEquals(1, attachments.size());


            

Test.stopTest();
}
 
    public static  testMethod void test_Attachments1(){
    Test.startTest();
 //   setupData();
 	g1 = new Group(Name='test', type='Queue');
    insert g1;
 System.runAs(new User(Id=UserInfo.getUserId()))
{ 
    
    q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
    insert q1;
        system.debug('Queue id'+g1.id);
}
   Case testCase2= new Case();
    testCase2.Subject='ClassCase';
    testCase2.Origin='Email';
    testCase2.Status='Open';
    testCase2.OwnerId = g1.id;
    insert testCase2;
    
    EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId = testcase2.Id)); 
    insert newEmail;

    Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=newEmail[0].id;
        insert attach;
    List<Attachment> attachments=[select id, name from Attachment where parent.id=:newEmail[0].id];
    System.assertEquals(1, attachments.size());


            

Test.stopTest();
}
    
}