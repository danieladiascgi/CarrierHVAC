@isTest
public class CCC_CaptureToAddressTest
{
 public static CCC_TestDataFactory  utilClass = new CCC_TestDataFactory();
 public static case testcase1;
 public static void setUpData()
 {
 testCase1=(Case)utilClass.setUpData(new Case());
             testCase1.Subject='ClassCase';
             testCase1.Origin='Email';
             testCase1.Status='Open';
             testCase1.To_Address__c='adc@sfdc.com';
             testCase1=(Case)utilClass.createTestRecord(testCase1);
 }

 static testMethod void testEmail()
 {
  Test.startTest();
  setUpData();
 EmailMessage[] newEmail = new EmailMessage[0];
 newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId = testcase1.Id)); 
 insert newEmail;
 Test.stopTest();
 }
 

}