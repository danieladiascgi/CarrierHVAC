public class MaterialSearchDemoController {
    public static String jsonResponse {get;set;}
    //public static JSONWrapper wrp {get;set;}
    public static List<Case> lstCase {get;set;}
    public static String s {get;set;}
    
    public class JSONWrapper{
       @AuraEnabled public String quantity {get;set;}
       @AuraEnabled public String leadTimeDays{get;set;}
       @AuraEnabled public String recoveryDate{get;set;} 
    }
    
    public class onHoverWrapper{
       @AuraEnabled public String listPrice {get;set;}
       @AuraEnabled public String multiplier{get;set;}
       @AuraEnabled public String netPrice{get;set;}
       @AuraEnabled public String currencyCode{get;set;}
    }
    
    @AuraEnabled
    public static String getValOfSapShipTo(String recId){
       lstCase = new List<Case>();
       lstCase = [Select Account.Sap_Ship_To__c from Case where Id = :recId];
       s = lstCase[0].Account.Sap_Ship_To__c;
       System.debug('s..'+s);
       return s;       
    }
    
   // Fields from SAP on search   
    @AuraEnabled
    public static JSONWrapper getMaterialAvailability(String materialNumber, boolean isCannada){
                
       
       
        System.debug('#Availablity 1:'+isCannada);
        System.debug('#Availablity 2:'+materialNumber);
       jsonResponse = callAvailService(materialNumber);
        System.debug('#Availablity 3:'+jsonResponse);
       
       JSONWrapper wrp = (JSONWrapper)System.JSON.deserialize(jsonResponse, JSONWrapper.class);
       System.debug('#Wrp:'+wrp);
       return wrp;
    }
    
    // Fields from SAP on hover
    @AuraEnabled
    public static onHoverWrapper onHoverCall(String materialNumber,String custNumber, boolean isCannada){
        System.debug('woww:'+materialNumber);
                
       
       
        
       jsonResponse = callPricesService(materialNumber,custNumber, isCannada);
       
       onHoverWrapper wrpHov = (onHoverWrapper)System.JSON.deserialize(jsonResponse, onHoverWrapper.class);
       return wrpHov;
    }
    
   /* @AuraEnabled
    public static void doSave(String lstOfPriceStr,String materialNumber,Id recId,String recMatQty,String recMatDt){
        System.debug('#listOfPriceStr:'+lstOfPriceStr);
      System.debug('wwww'+recMatQty);
        onHoverWrapper priceRecord = (onHoverWrapper)JSON.deserialize(lstOfPriceStr, onHoverWrapper.class);
      //Id csNo = [Select Id,CaseNumber from Case where Id =:recId].CaseNumber;
      //for(JSONWrapper js : listTosave){                   
        Material__c m = new Material__c();
        m.Name = materialNumber;
        m.Case__c = recId;
        m.Quantity__c = recMatQty;        
        m.Lead_Time_Days__c = recMatDt;
        m.ListPrice__c = priceRecord.listPrice;
        m.Multiplier__c = priceRecord.multiplier;
        m.NetPrice__c = priceRecord.netPrice;
        m.CurrencyCode__c = priceRecord.currencyCode;
        //m.Status__c = ms.Status__c;
        insert m;
      //}
    }*/
    @AuraEnabled
    public static void SaveMaterial(String materialNumber,String custNumber, boolean isCannada, String recId){
       
        jsonResponse = callAvailService(materialNumber);
        System.debug('#Availablity 3:'+jsonResponse);       
       JSONWrapper wrp = (JSONWrapper)System.JSON.deserialize(jsonResponse, JSONWrapper.class);
       System.debug('#Wrp:'+wrp);     
        jsonResponse = callPricesService(materialNumber,custNumber, isCannada);       
       onHoverWrapper wrpHov = (onHoverWrapper)System.JSON.deserialize(jsonResponse, onHoverWrapper.class);
        Material__c m = new Material__c();
        m.Name = materialNumber;
        m.Case__c = recId;
        m.Quantity__c = wrp.quantity;        
        m.Lead_Time_Days__c = wrp.leadTimeDays;
        m.ListPrice__c = wrpHov.listPrice;
        m.Multiplier__c = wrpHov.multiplier;
        m.NetPrice__c = wrpHov.netPrice;
        m.CurrencyCode__c = wrpHov.currencyCode;
        if(wrp.recoveryDate!=null && wrp.recoveryDate.length()>0){
            m.Recovery_Date__c = Date.valueOf(wrp.recoveryDate);
        }
        //m.Status__c = ms.Status__c;
        insert m;
      //}
    }
    public static String callAvailService(String partNo){
        String response = '';
        String token=testTokenGenerator();                         
        HttpRequest req1 = new HttpRequest();
        Http http = new Http();
        //CCC_IntegrationEndPoint__c  CustomSettingEndPoint2 = CCC_IntegrationEndPoint__c.getValues('PHDB');
        //String baseURL=CustomSettingEndPoint2.URL__c;
        //String baseURL = ' http://staging.phdbws.carrier.com/api/'; 
        //String productModel = '38AP';
        //partNo = '1170003';
        String endpoint= Label.C10ServicesURL+'availability/part/'+partNo;
        System.debug('#End Point:'+endpoint);
        req1.setEndpoint(endpoint);
        req1.setMethod('GET');
        req1.setTimeout(120000);
        //system.debug('req--'+requestParam); 
        //req1.setBody(requestParam);
        String authorizationHeader1 = 'Bearer '+token;
        //String authorizationHeader1 = 'Bearer '+'8c8522f5-5777-445c-b397-2fb93e3eb46d//';
        req1.setHeader('Authorization', authorizationHeader1);
        HTTPResponse res1= http.send(req1);
        
        system.debug('res1.......'+res1+'res1.....status'+res1.getStatus());
        system.debug('res1.......'+res1.getBody());
        response = res1.getBody();
        return response;
    }
    public static String callPricesService(String partNo,String custNumber, Boolean isCannada){
        String response = '';
        String token=testTokenGenerator();                         
        HttpRequest req1 = new HttpRequest();
        Http http = new Http();
        //CCC_IntegrationEndPoint__c  CustomSettingEndPoint2 = CCC_IntegrationEndPoint__c.getValues('PHDB');
        //String baseURL=CustomSettingEndPoint2.URL__c;
        //String baseURL = ' http://staging.phdbws.carrier.com/api/'; 
        //String productModel = '38AP';
        //partNo = '1170003';
        if(!partNo.isNumeric() && !partNo.endsWith('/U')){
            partNo = partNo + '/U';
        }
        String endpoint= Label.C10ServicesURL+'prices/part/'+custNumber+'/'+partNo;
        if(isCannada){
            endpoint = endpoint + '?countryCode=CA';
        }
        System.debug('#End Point:'+endpoint);
        req1.setEndpoint(endpoint);
        req1.setMethod('GET');
        req1.setTimeout(120000);
        //system.debug('req--'+requestParam); 
        //req1.setBody(requestParam);
        String authorizationHeader1 = 'Bearer '+token;
        //String authorizationHeader1 = 'Bearer '+'8c8522f5-5777-445c-b397-2fb93e3eb46d//';
        req1.setHeader('Authorization', authorizationHeader1);
        HTTPResponse res1= http.send(req1);
        
        system.debug('res1.......'+res1+'res1.....status'+res1.getStatus());
        system.debug('res1.......'+res1.getBody());
        response = res1.getBody();
        return response;
    }
    public static String testTokenGenerator(){
        String BearerToken = '';
        CCC_IntegrationEndPoint__c  CustomSettingEndPoint = CCC_IntegrationEndPoint__c.getValues('PHDB_Auth');
        String username = CustomSettingEndPoint.UserName__c;          
        String password = CustomSettingEndPoint.Password__c;          
        String securityToken  = CustomSettingEndPoint.Token__c; 
        String strUrl = CustomSettingEndPoint.URL__c;      
        /*String username = 'app_salesforce';          
        String password = 'hy~jpmXm@2s6_@MM';          
        String securityToken  = 'b5563182-208c-4667-adc0-5592c75a8f89'; 
        String strUrl = 'https://staging-services.ccs.utc.com/auth/realms/hvac/tokens/grants/access';   */

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(strUrl);
        System.debug('#strUrl:'+strUrl);
        HTTPResponse res=new HTTPResponse();
        Blob headerValue = Blob.valueOf(username +':'+securityToken);
        String authorizationHeader = 'BASIC '+EncodingUtil.base64Encode(headerValue);
        req.setTimeout(120000);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
        req.setBody('grant_type=password&username='+username+'&password='+password);
        
        // Create a new http object to send the request object
        Http http = new Http();
        /*if(!Test.isRunningTest())
        {*/
            res = http.send(req);
        /*}*/
        system.debug('#Response:'+res);
        // Parse JSON response .
        JSONParser parser = JSON.createParser(res.getBody());
        string token;
        while (parser.nextToken() != null) {
            if (parser.getText() == 'access_token') {
                // Get the value.
                parser.nextToken();
                token= parser.getText();
                system.debug('token......'+token);
                BearerToken = token;
                break;
            }
        }
        
        return BearerToken;
    }
}