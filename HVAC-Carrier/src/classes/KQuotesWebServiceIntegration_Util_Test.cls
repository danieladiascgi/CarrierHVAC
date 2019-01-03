@isTest
public class KQuotesWebServiceIntegration_Util_Test {
    
    // since custom metadat can not be inserted using apex, so query exitsing one.
    public static Web_Services_Parameters__mdt intParam = [SELECT DeveloperName, Auth_Mechanism__c, Certificate__c, Consumer_Key__c, 
                                                           End_Point_URL__c, Password__c, Record_Type__c, Secret_Key__c, Service_Consumer__c, 
                                                           Service_Method__c, Service_Provider__c, Service_Type__c, Timeout__c, Username__c
                                                           FROM Web_Services_Parameters__mdt LIMIT 1]; 
    
    // Basic test run with parameters from current environment
    static testMethod void myUnitTest() {
        
        KQuotesWebServiceIntegration_Util.returnServiceParams();
    } 
}