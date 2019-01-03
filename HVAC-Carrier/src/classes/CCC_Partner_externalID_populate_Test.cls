@isTest
public class CCC_Partner_externalID_populate_Test{
private static  testMethod void test_Partner(){
CCC_Partner__c obj=new CCC_Partner__c();
obj.Partner_External_ID__c='1234';
insert obj;
}
}