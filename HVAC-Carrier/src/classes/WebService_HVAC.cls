/********************************************************************************************************************** 
* Project      : Carrier Residential HVAC - Web Services  
* Description  : Utility for methods relating to integrations
* Methods      : getHVACdata(); Input parameters are sent by Lightning component and endpoint URL is created and
                 calls Utility_REST_Web_Service.makeCallout() to make callout to HVAC and returns response.
* Author       : Vamshi Takallapally
* Date         : 12/11/2018
**********************************************************************************************************************/
public class WebService_HVAC {
    
    @AuraEnabled
    public static List<Utility_REST_Web_Service.ResponseOutputParams> getHVACdata(String inputParams){
        Utility_REST_Web_Service.RequestInputParams params = (Utility_REST_Web_Service.RequestInputParams)System.JSON.deserialize(inputParams, Utility_REST_Web_Service.RequestInputParams.class);        
        HttpResponse res = Utility_REST_Web_Service.makeCallout('HVAC', Utility_REST_Web_Service.createUrlQueryString(params),null);
        List<Utility_REST_Web_Service.ResponseOutputParams> vals = (List<Utility_REST_Web_Service.ResponseOutputParams>)System.JSON.deserialize(res.getBody(), List<Utility_REST_Web_Service.ResponseOutputParams>.class);
        WebService_Resolve.CheckStatus(res.getStatusCode());        
        return vals;        
    }    
}