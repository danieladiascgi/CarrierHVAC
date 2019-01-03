/********************************************************************************************************************** 
* Project      : Carrier - HVAC & SAP Web Services  
* Description  : Utility for methods relating to integrations
* Methods      : returnServiceParams(); returns the endpoint and parameters necessary for an integration relative to 
				 which environment code is running(Sandbox vs production).
* Author       : Vamshi Takallapally
* Date         : 12/11/2018
**********************************************************************************************************************/
public class KQuotesWebServiceIntegration_Util {
    
    Public static Map<String,String> returnServiceParams(){
        
        Map<String,String> intParamMap = new Map<String,String>();
        
        Web_Services_Parameters__mdt intParam = [SELECT DeveloperName, Auth_Mechanism__c, Certificate__c, Consumer_Key__c, 
                                                 End_Point_URL__c, Password__c, Record_Type__c, Secret_Key__c, Service_Consumer__c, 
                                                 Service_Method__c, Service_Provider__c, Service_Type__c, Timeout__c, Username__c
                                                 FROM Web_Services_Parameters__mdt];
        
        intParamMap.put('DeveloperName', intParam.DeveloperName);
        intParamMap.put('AuthMechanism', intParam.Auth_Mechanism__c);
        intParamMap.put('ServiceConsumer', intParam.Service_Consumer__c);
        intParamMap.put('ServiceMethod', intParam.Service_Method__c);
        intParamMap.put('ServiceProvider', intParam.Service_Provider__c);
        intParamMap.put('ServiceType', intParam.Service_Type__c);
        intParamMap.put('Timeout', intParam.Timeout__c);
        intParamMap.put('EndPointURL', intParam.End_Point_URL__c);                
        intParamMap.put('SecretKey', intParam.Secret_Key__c);
        intParamMap.put('Certificate', intParam.Certificate__c);
        intParamMap.put('ConsumerKey', intParam.Consumer_Key__c);
        intParamMap.put('Password', intParam.Password__c);
        intParamMap.put('Username', intParam.Username__c); 
        
        return intParamMap;
    }
}