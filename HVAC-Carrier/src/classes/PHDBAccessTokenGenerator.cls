global class PHDBAccessTokenGenerator implements Schedulable
{
            
           
 global void execute(SchedulableContext SC)
 {   
 
       
        calloutMethod();  
        String day = string.valueOf(system.now().day());
        String month = string.valueOf(system.now().month());
        String hour = string.valueOf(system.now().hour());
        if(system.now().minute()>49)
        {
        system.debug('No Schedule');
        }
        else
        {
        String minute = string.valueOf(system.now().minute() + 25);
        String second = string.valueOf(system.now().second());
        String year = string.valueOf(system.now().year());
        String strJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        System.schedule(strJobName, strSchedule, new PHDBAccessTokenGenerator());
        }

       
   

}
  @future(callout=true)                
 public static void calloutMethod()
 {
                 // Specify the required user name and security token to access the endpoint
            CCC_IntegrationEndPoint__c  CustomSettingEndPoint = CCC_IntegrationEndPoint__c.getValues('PHDB_Auth');
            String username = CustomSettingEndPoint.UserName__c;          
            String password = CustomSettingEndPoint.Password__c;          
            String securityToken  = CustomSettingEndPoint.Token__c; 
            String strUrl = CustomSettingEndPoint.URL__c;               
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(strUrl);
            HTTPResponse res=new HTTPResponse();
            Blob headerValue = Blob.valueOf(username +':'+securityToken);
            String authorizationHeader = 'BASIC '+EncodingUtil.base64Encode(headerValue);
            req.setTimeout(120000);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
            req.setBody('grant_type=password&username='+username+'&password='+password);
            
            // Create a new http object to send the request object
            Http http = new Http();
            if(!Test.isRunningTest())
            {
            res = http.send(req);
            }
            
            
            
            if(STring.valueOf(res).contains('StatusCode=500')){
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Service Currently not available.');
                apexpages.addmessage(msg); 
                
            }
            else{
                // Parse JSON response .
                JSONParser parser = JSON.createParser(res.getBody());
                string token;
                while (parser.nextToken() != null) {
                    if (parser.getText() == 'access_token') {
                        // Get the value.
                        parser.nextToken();
                        token= parser.getText();
                        system.debug('token......'+token);
                        break;
                    }
                }
                
                Access_Token__c  tokenValue = Access_Token__c.getValues('PHDB Smart Search');
                if(token != null )
                {
                tokenValue.PHDB_Access_Token__c=token;
                update tokenValue;
                }

                }
 }
                }