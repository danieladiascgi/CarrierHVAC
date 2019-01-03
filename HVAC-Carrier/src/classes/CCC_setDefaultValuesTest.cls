@isTest
public class CCC_setDefaultValuesTest
{
public static  testMethod void test_Partner(){
Test.startTest();
Defect_Tracker__c observationobj=new Defect_Tracker__c ();
observationobj.Type__c = 'Defect';
observationobj.Triaged_Type__c= 'Defect';
observationobj.Functionality__c= 'Coding Error';
observationobj.Triaged_Functionality__c= 'Coding Error';
insert observationobj;
observationobj.Type__c = 'Training Issue';
observationobj.Triaged_Type__c= 'Training Issue';
observationobj.Functionality__c= 'Training Issue';
observationobj.Triaged_Functionality__c= 'Training Issue';
update observationobj;
Test.stopTest();
}
 
}