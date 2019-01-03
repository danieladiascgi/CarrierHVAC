/******************************************************************************* 
* Project      : Carrier Residential HVAC - Web Services  
* Description  : Utility for methods relating to integrations
* Methods      : requestData(); makes a callout and returns the returns the response.
* Author       : Vamshi Takallapally
* Date         : 12/11/2018
*******************************************************************************/

public with sharing class KQuotesWebServiceCall {
    
    // call Integration_Util to get the service parameters
    public static Map<String,String> serviceParameters = KQuotesWebServiceIntegration_Util.returnServiceParams();
    public static String clientId = serviceParameters.get('Service_Provider__c');
    public static String clientSecret = serviceParameters.get('Secret_Key__c');
    public static String userName = serviceParameters.get('Username');
    public static String password = serviceParameters.get('Password');    
    public static String endPoint = serviceParameters.get('EndPointURL');
    public static String serviceType = serviceParameters.get('ServiceType');
    public static String timeout = serviceParameters.get('Timeout');
    public static String accessToken {Set;Get;}
    public static String result {Set;Get;}
    
    // Request Access Token
    public static String reqAccessToken(){
        Http p= new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(serviceType);
        request.setTimeout(integer.ValueOf(timeout));
        String body = 'grant_type=password';
        body = body+'&client_id='+clientId;
        body = body+'&client_secret='+clientSecret;
        body = body+'&username='+userName;
        body = body+'&password='+password;
        request.setBody(body);
        HttpResponse response = p.send(request);
        result = response.getBody();
        system.JSONParser jp = JSON.createParser(result);
        while(jp.nextToken()!=null){
            if(jp.getText()=='access_token'){
                jp.nextToken();
                accessToken = jp.getText();
            }
        }
        return accessToken;
    }
    
    // Call to Request Response with Access Token
    public static HttpResponse requestData(String inputParams){           
        
        String accessToken = reqAccessToken();
        String endPoint = 'https://na85.salesforce.com/services/apexrest';
        string body = inputParams;
        Http p= new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(serviceType);
        request.setTimeout(integer.ValueOf(timeout));
        request.setBody(body);
        request.setheader('Authorization', 'OAuth '+accessToken);
        HttpResponse response = p.send(request);
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        return response;
    }
    
}