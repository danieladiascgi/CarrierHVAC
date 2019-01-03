public without sharing class  C10_controller_cloned {

  public static String BearerToken = '';
    
   public class wrapperC10recs{
       @AuraEnabled
        public Double lineId;	
       @AuraEnabled
		public String lineType;	
       @AuraEnabled
        public Date actualShipDate;
       @AuraEnabled
        public String holdCode;
       @AuraEnabled
        public String holdCodesecPart;       
       @AuraEnabled
		public String priorityCode;	
       @AuraEnabled
		public String partId;	
       @AuraEnabled
		public String lastStatus;
       @AuraEnabled
		public String nextStatus;
       @AuraEnabled
		public String carrier;
       @AuraEnabled
		public String description;
       @AuraEnabled
		public Integer quantity;
       @AuraEnabled
		public Double unitPrice;	
       @AuraEnabled
		public Double extendedPrice;
       @AuraEnabled
		public Integer pickListId;	
       @AuraEnabled
		public String promiseShipDate;
       @AuraEnabled
		public Integer invoiceId;
       @AuraEnabled
		public String trackingId;
       @AuraEnabled
        public String documentType;
       @AuraEnabled
        public String relatedOrderNumber;
       @AuraEnabled
        public String relatedOrderType;
       @AuraEnabled
        public Integer purchaseOrderId;
       @AuraEnabled
        public String purchaseOrderNotes;
       @AuraEnabled
        public Integer quantityBackordered;
        @AuraEnabled
        public String shipDate;
       @AuraEnabled
		public String salesOrderNo;	
       @AuraEnabled
		public String customPoNo;
       @AuraEnabled
		public String orderDate;
   }
    
    public class wrapperC10recsPart{           
       @AuraEnabled
		public String id;
       @AuraEnabled
		public String compressedId;
       @AuraEnabled
		public String description;	
       @AuraEnabled
		public String stockingType; 
       @AuraEnabled
        public String orderType;
       @AuraEnabled
		public Integer customerId;
       @AuraEnabled
		public String customerPurchaseOrderId;
       @AuraEnabled
		public String creationDate;	
   }
    
    @AuraEnabled 
    public static user fetchUser(){
       User u = [select id,Name,alias from User where id =: userInfo.getUserId()];
        System.debug('#user:'+u);
        return u;
    }
    
   
        
   
    public static void testTokenGenerator(){
        CCC_IntegrationEndPoint__c  CustomSettingEndPoint = CCC_IntegrationEndPoint__c.getValues('PHDB_Auth');
        String username = CustomSettingEndPoint.UserName__c;          
        String password = CustomSettingEndPoint.Password__c;          
        String securityToken  = CustomSettingEndPoint.Token__c; 
        String strUrl = CustomSettingEndPoint.URL__c;     
        /*String username = 'app_salesforce';          
        String password = 'hy~jpmXm@2s6_@MM';          
        String securityToken  = 'b5563182-208c-4667-adc0-5592c75a8f89'; */
        //String strUrl = 'https://staging-services.ccs.utc.com/auth/realms/hvac/tokens/grants/access';
        

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
        if(!Test.isRunningTest())
        {
            res = http.send(req);
        }
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
    }
    
    @AuraEnabled
    public static List<wrapperC10recs> searchC10records(String custnum,String custByPO,String salesOrderNo){
        testTokenGenerator();
        String response = '';
        String token=BearerToken; 
        String endpoint;
        HttpRequest req1 = new HttpRequest();
        Http http = new Http();
        if(salesOrderNo==null)
          //endpoint= 'https://staging-services.ccs.utc.com/apps/erp/sales-orders/parts/by-customer-po/'+custnum+'/'+custByPO;
        endpoint= Label.C10ServicesURL+'sales-orders/parts/by-customer-po/'+custnum+'/'+custByPO;
        if(custByPO==null)           
          //endpoint = 'https://staging-services.ccs.utc.com/apps/erp/sales-orders/parts/'+custnum+'/'+salesOrderNo;  
        endpoint = Label.C10ServicesURL+'sales-orders/parts/'+custnum+'/'+salesOrderNo; 
        
       
        
        System.debug('#End Point:'+endpoint);
        req1.setEndpoint(endpoint);
        req1.setMethod('GET');
        req1.setTimeout(120000);
        String authorizationHeader1 = 'Bearer '+token;
        //String authorizationHeader1 = 'Bearer '+'8c8522f5-5777-445c-b397-2fb93e3eb46d//';
        req1.setHeader('Authorization', authorizationHeader1);
        HTTPResponse res1= http.send(req1);
        
        system.debug('res1.......'+res1+'res1.....status'+res1.getStatus());
        system.debug('res1.......'+res1.getBody());
        response = res1.getBody();
        
        C10_Wrapper jsacc = new C10_Wrapper();
		jsacc = (C10_Wrapper) System.JSON.deserialize(response, C10_Wrapper.class);
	    System.debug('nice..'+jsacc);
        
        List<wrapperC10recs> lst = new List<wrapperC10recs>();
        
        for(Integer i=0;i<jsacc.lines.size();i++){
            wrapperC10recs a = new wrapperC10recs();
             a.lineId = jsacc.lines[i].lineId;
             a.lineType = jsacc.lines[i].lineType;
             //a.priorityCode = jsacc.lines[i].priorityCode!='0'?jsacc.lines[i].priorityCode:'';
             a.priorityCode = jsacc.lines[i].priorityCode;
             a.partId = jsacc.lines[i].partId;
             a.description = jsacc.lines[i].description;
             a.quantity = jsacc.lines[i].quantity; 
             a.lastStatus = jsacc.lines[i].lastStatus.description +'-'+ jsacc.lines[i].lastStatus.code;
             a.nextStatus = jsacc.lines[i].nextStatus.description +'-'+ jsacc.lines[i].nextStatus.code;
            //System.debug('#Carrier:'+jsacc.lines[i].carrier);
            if(jsacc.lines[i].carrier!=null){
                a.carrier = ''+jsacc.lines[i].carrier.id +'-'+ jsacc.lines[i].carrier.name;
            }                                       
             a.unitPrice = jsacc.lines[i].unitPrice;
             a.extendedPrice = jsacc.lines[i].extendedPrice;
             a.pickListId = jsacc.lines[i].pickListId;
             a.promiseShipDate = jsacc.lines[i].promiseShipDate;
             a.trackingId = jsacc.lines[i].trackingId;
             a.invoiceId = jsacc.lines[i].invoiceId;
             a.documentType = jsacc.lines[i].documentType;
             a.relatedOrderNumber = jsacc.lines[i].relatedOrderNumber;
             a.relatedOrderType = jsacc.lines[i].relatedOrderType;
             a.purchaseOrderId = jsacc.lines[i].purchaseOrderId;
             a.purchaseOrderNotes = jsacc.lines[i].purchaseOrderNotes;
             a.quantityBackordered = jsacc.lines[i].quantityBackordered;
             a.shipDate = jsacc.lines[i].shipDate!=null || jsacc.lines[i].shipDate!='null'?jsacc.lines[i].shipDate:'';
             a.salesOrderNo =String.valueof(jsacc.id);
             a.customPoNo = jsacc.customerPurchaseOrderId;
             a.orderDate = jsacc.creationDate;
             lst.add(a);          
            
        }
       
        return lst;
    }
    
    @AuraEnabled
    public static List<wrapperC10recsPart> typeAheadforParts(String searchKeyWord){
        testTokenGenerator();
        String response = '';
        String token=BearerToken;                         
        HttpRequest req1 = new HttpRequest();
        Http http = new Http();
        //String endpoint= 'https://staging-services.ccs.utc.com/apps/erp/search/part/'+searchKeyWord;
        String endpoint= Label.C10ServicesURL+'search/part/'+searchKeyWord;
        System.debug('#End Point:'+endpoint);
        req1.setEndpoint(endpoint);
        req1.setMethod('GET');
        req1.setTimeout(120000);
        String authorizationHeader1 = 'Bearer '+token;
        //String authorizationHeader1 = 'Bearer '+'8c8522f5-5777-445c-b397-2fb93e3eb46d//';
        req1.setHeader('Authorization', authorizationHeader1);
        HTTPResponse res1= http.send(req1);
        
        system.debug('res2.......'+res1+'res1.....status'+res1.getStatus());
        system.debug('res2.......'+res1.getBody());
        response = res1.getBody();
        
        List<wrapperC10recsPart> lst = new List<wrapperC10recsPart>();
        
        List<C10_typeAheadWrapper> jsacc = new List<C10_typeAheadWrapper>();
		jsacc = (List<C10_typeAheadWrapper>) System.JSON.deserialize(response, List<C10_typeAheadWrapper>.class);
	    System.debug('nice..'+jsacc);
             
        
        if(lst!=null){
          for(Integer i=0;i<jsacc.size();i++){
            wrapperC10recsPart a = new wrapperC10recsPart();
             a.id = jsacc[i].id;
             a.compressedId = jsacc[i].compressedId;
             a.description = jsacc[i].description;
             a.stockingType = jsacc[i].stockingType;
                        
             lst.add(a);
          
          }
        }
       
        return lst;
    }
    
     @AuraEnabled
    public static List<wrapperC10recsPart> showPartRecord(String custnum,String partNo){
        testTokenGenerator();
        String response = '';
        String token=BearerToken;  
        System.debug('partNo..'+partNo);
        HttpRequest req1 = new HttpRequest();
        Http http = new Http();
        //partNo = 'EF18L241';
        //String endpoint = 'https://staging-services.ccs.utc.com/apps/erp/sales-orders/parts/by-part-id/'+custnum+'/'+partNo;
        String endpoint = Label.C10ServicesURL+'sales-orders/parts/by-part-id/'+custnum+'/'+partNo;
        System.debug('#End Point:'+endpoint);
        req1.setEndpoint(endpoint);
        req1.setMethod('GET');
        req1.setTimeout(120000);
        String authorizationHeader1 = 'Bearer '+token;
        //String authorizationHeader1 = 'Bearer '+'8c8522f5-5777-445c-b397-2fb93e3eb46d//';
        req1.setHeader('Authorization', authorizationHeader1);
        HTTPResponse res1= http.send(req1);
        
        system.debug('Part res3.......'+res1+'res1.....status'+res1.getStatus());
        system.debug('res3.......'+res1.getBody());
        response = res1.getBody();
        
        List<wrapperC10recsPart> lst = new List<wrapperC10recsPart>();
        
        List<C10_PartSearch_Wrapper> jsacc = new List<C10_PartSearch_Wrapper>();
        if(response!=null && response.length()>0){
            jsacc = (List<C10_PartSearch_Wrapper>) System.JSON.deserialize(response, List<C10_PartSearch_Wrapper>.class);
            System.debug('nice..'+jsacc);
            String b;     
            
            if(lst!=null){
              for(Integer i=0;i<jsacc.size();i++){
                wrapperC10recsPart a = new wrapperC10recsPart();
                // a.id = jsacc[i].id;
                 a.orderType = jsacc[i].orderType;
                 a.customerId = jsacc[i].customerId;
                 a.customerPurchaseOrderId = jsacc[i].customerPurchaseOrderId;
                 a.creationDate = jsacc[i].creationDate;
                 b = a.customerPurchaseOrderId;
                 System.debug('b..'+b);           
                 lst.add(a);
              
              }
            }
       }
        //List<wrapperC10recs> lstFirstTable = searchC10records(custnum,b,null);
        return lst;
    }   
    
    /*@AuraEnabled
    public static List<wrapperC10recs> searchPartsData(String custnum,String partNo){
        testTokenGenerator();
        String response = '';
        String token=BearerToken;  
        System.debug('partNo..'+partNo);
        HttpRequest req1 = new HttpRequest();
        Http http = new Http();
        //String endpoint = 'https://staging-services.ccs.utc.com/apps/erp/sales-orders/parts/by-part-id/'+custnum+'/'+partNo;
        String endpoint = 'https://services.ccs.utc.com/apps/erp/sales-orders/parts/by-part-id/'+custnum+'/'+partNo;
        System.debug('#End Point:'+endpoint);
        req1.setEndpoint(endpoint);
        req1.setMethod('GET');
        req1.setTimeout(120000);
        String authorizationHeader1 = 'Bearer '+token;
        //String authorizationHeader1 = 'Bearer '+'8c8522f5-5777-445c-b397-2fb93e3eb46d//';
        req1.setHeader('Authorization', authorizationHeader1);
        HTTPResponse res1= http.send(req1);
        
        system.debug('Part res3.......'+res1+'res1.....status'+res1.getStatus());
        system.debug('res3.......'+res1.getBody());
        response = res1.getBody();
        
        List<wrapperC10recsPart> lst = new List<wrapperC10recsPart>();
        
        List<C10_PartSearch_Wrapper> jsacc = new List<C10_PartSearch_Wrapper>();
		jsacc = (List<C10_PartSearch_Wrapper>) System.JSON.deserialize(response, List<C10_PartSearch_Wrapper>.class);
	    System.debug('nice..'+jsacc);
        String b;     
        
        if(lst!=null){
          for(Integer i=0;i<jsacc.size();i++){
            wrapperC10recsPart a = new wrapperC10recsPart();
            // a.id = jsacc[i].id;
             a.orderType = jsacc[i].orderType;
             a.customerId = jsacc[i].customerId;
             a.customerPurchaseOrderId = jsacc[i].customerPurchaseOrderId;
             a.creationDate = jsacc[i].creationDate;
             b = a.customerPurchaseOrderId;
             System.debug('b..'+b);           
             lst.add(a);
          
          }
        }
       
        List<wrapperC10recs> lstFirstTable = searchC10records(custnum,b,null);
        return lstFirstTable;
    }*/
    
    @AuraEnabled
    public static List<Account> typeAheadforCustNum(String searchKeyWord){
        String s='%'+searchKeyWord+'%';
        String findStr = searchKeyWord+'*';
        List<List<SObject>> searchList = [FIND :findStr IN ALL FIELDS RETURNING Account (Name,CCC_Account_Display_Name__c,CCC_C10_Parent__c,CCC_C10_Child__c WHERE CCC_C10_Child__c LIKE :s OR CCC_C10_Parent__c LIKE :s OR CCC_Account_Display_Name__c LIKE :s)];
       // List<Account> lst = [Select Name,CCC_Account_Display_Name__c,CCC_C10_Parent__c,CCC_C10_Child__c from Account where CCC_C10_Child__c like :s or CCC_C10_Parent__c like :s or CCC_Account_Display_Name__c like :s];
        Account [] accList = ((List<Account>)searchList[0]);
        return accList;
    }
    
    @AuraEnabled
    public static string getparsePayloadAndGetValues(String payloadStr){
        string value=null;
        if(payloadStr!=null){
        System.debug('#payload:'+payloadStr);
        //payload = 'SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=';
        if(payloadStr.contains(' ')){
            payloadStr = payloadStr.replaceAll(' ', '+');
        }
        System.debug('#payload after:'+payloadStr);
        JWTDecryptFinal decrypt = new JWTDecryptFinal();
        value = decrypt.getEmailDecrypt(payloadStr);
        system.debug('email'+value);
        }
        else{
            value='communityuser';
        }
        return value;
        }
    
    @AuraEnabled
    public static String getC10ParentVal(Id recId,string value){
        //Case cs;
        Id contid;
        User u = [select id,Name,alias,email from User where id =: userInfo.getUserId()];
       system.debug('Loggedinuseremail*************'+u.Email);
        system.debug('publicvalue*************'+value);
       
       string LoggedInEmail=value;
       system.debug('*********Loggedinemail*************'+LoggedInEmail);
       List<List<Contact>> findContact= [FIND :LoggedInEmail IN Email Fields RETURNING Contact(Id)];
       system.debug('LoggedinuseremailID*************'+findContact);
       Contact [] contactList = ((List<Contact>)findContact[0]);
       contactList=[Select Id, Email, AccountId, Account.CCC_C10_Parent__c from Contact where Id in:contactList];
       system.debug('-------------->querying and assigning the contacts to list'+contactList);
       system.debug('-------------->querying and assigning the contacts to list'+contactList.size());
        //system.debug('*********Contact********'+cs.ContactId); 
        String customerNumber = '';
        if(contactList!=null && contactList.size()>0){
            for(Contact eachCont : contactList){
                if(eachCont.Account!=null && eachCont.Account.CCC_C10_Parent__c!=null && eachCont.Account.CCC_C10_Parent__c.length()>0){
                    customerNumber = eachCont.Account.CCC_C10_Parent__c;
                    break;
                }
            }
        }
        return customerNumber;
    }
    
    
    
    
}