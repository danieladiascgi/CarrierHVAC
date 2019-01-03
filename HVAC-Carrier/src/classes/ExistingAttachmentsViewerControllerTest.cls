@isTest
private class ExistingAttachmentsViewerControllerTest 
{
    
    //object of the helper class
    
    
    //public static List<Attachment> tstattachments;
    public static User testusr1;
    public static Contact testCon1;
    public static Case testCase1;
    public static Account testAcc;
    
    public static testMethod void testAttachments()
    {
        
        testCase1=new Case();
        testCase1.Subject='TestDIMSCase';
        testCase1.Origin='Email';
        testCase1.Status='Open'; 
        RecordType rt= [select id,Name from RecordType where SobjectType='Case' and Name='Consumer Relations' Limit 1];
        testCase1.recordTypeId=rt.id;
        insert testCase1;
        System.debug('#Case Id:'+testCase1.Id);
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment.txt';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=testCase1.id;
        insert attach;
        Attachment attach1=new Attachment();   	
    	attach1.Name='Unit Test Attachment.jpg';
    	Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
    	attach1.body=bodyBlob1;
        attach1.parentId=testCase1.id;
        insert attach1;
        List<Attachment> attachments=[select Id, Name, Description, BodyLength from Attachment where parentId=:testCase1.id];
        system.debug('#attachments:'+attachments.size());
        ApexPages.StandardController stdController = new ApexPages.standardController(testCase1);
        ExistingAttachmentsViewerController imgview =new ExistingAttachmentsViewerController(stdController);
        
        List<Attachment> tstattachments = new List<Attachment>();
       
        
        
        
    }
}