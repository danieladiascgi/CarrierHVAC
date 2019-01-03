global class TilesDashboard_RCContoller {
    @AuraEnabled
    public String value{get; set;}
    @AuraEnabled
    public String payload{get; set;}
    @AuraEnabled
    public String email{get; set;}
    @AuraEnabled 
    public static user fetchUser(){
        User u = [select id,Name,alias from User where id =: userInfo.getUserId()];
        System.debug('#userNew:'+u);
        
        return u;
    }
    @AuraEnabled
    global static string getparsePayloadAndGetValues(String payloadStr){
        
        System.debug('#payload:'+payloadStr);
        
        //payload = 'SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=';
        if(payloadStr.contains(' ')){
            payloadStr = payloadStr.replaceAll(' ', '+');
        }
        System.debug('#payload after:'+payloadStr);
        JWTDecryptFinal decrypt = new JWTDecryptFinal();
        string email = decrypt.getEmailDecrypt(payloadStr);
        system.debug('email'+email);
        return email;
    }
    @AuraEnabled
    global static string getparsePayloadAndGetName(String payloadStr){
        
        System.debug('#payload:'+payloadStr);
        
        //payload = 'SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=';
        if(payloadStr.contains(' ')){
            payloadStr = payloadStr.replaceAll(' ', '+');
        }
        System.debug('#payload after:'+payloadStr);
        JWTDecryptFinal decrypt = new JWTDecryptFinal();
        string email = decrypt.getEmailDecrypt(payloadStr);
        String firstName = decrypt.getFirstNameDecrypt(payloadStr);
        String lastName = decrypt.getLastNameDecrypt(payloadStr);
        String name = firstName+' '+lastName;
        system.debug('#name'+name);
        return name;
    }
    @AuraEnabled
    global static boolean checkBtnOnline(String email, String chatButtonId){
        boolean retVal = false;
        System.debug('#chatButtonId:'+chatButtonId);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        //req.setEndpoint('https://d.la1-c1cs-ord.salesforceliveagent.com/chat/rest/Visitor/Availability?org_id=00D0m000000Cs8f&deployment_id=5720m0000008OKH&Availability.ids=['+chatButtonId+']');
        req.setEndpoint(Label.ChatServiceURL+'['+chatButtonId+']');
        //System.debug('#strUrl:'+strUrl);
        req.setHeader('X-LIVEAGENT-API-VERSION', '42');
        req.setHeader('Content-Type','application/json');
        req.setHeader('X-LIVEAGENT-AFFINITY','');
        HTTPResponse res=new HTTPResponse();  
        
        // Create a new http object to send the request object
        Http http = new Http();
        if(!Test.isRunningTest())
        {
            res = http.send(req);
        }
        system.debug('#Response:'+res.getBody());
        system.debug('#Response:'+res.getBody().contains('true'));
        String resBodyStr = res.getBody();
        if(resBodyStr!=null && resBodyStr.length()>0 && resBodyStr.contains('true')){
            System.debug('#Condition Satisfied');
            retVal = true;
        }
        return retVal;
    }
    
    
}