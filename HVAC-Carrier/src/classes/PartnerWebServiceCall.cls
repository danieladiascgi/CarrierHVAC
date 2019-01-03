@RestResource(urlMapping='/Partner/*')
global class PartnerWebServiceCall {
    
    global static String Sample = '{ "Partner": [ { "CCC_Relationship": "Brand", "HVP": "12345", "CCC_Distributor": "0010m00000GmaTc", "CCC_Dealer": "0010m00000GlGEG", "CIN": "569876tfguh", "Partner_External_ID": "Prod569876tfguh1" }, { "CCC_Relationship": "Brand", "HVP": "12345", "CCC_Distributor": "0010m00000GmaTc", "CCC_Dealer": "0010m00000GlGEG", "CIN": "569876tfguh", "Partner_External_ID": "Prod569876tfguh2" } ] }';
      
    @HttpPut
    global static PartnerResponseWrapper upsertPartner() { 
        
        PartnerResponseWrapper responseJSON = new PartnerResponseWrapper();
        responseJSON.status = 'Success';
        responseJSON.message = 'Records are updated';
        List<CCC_Partner__c> partnerLst = new List<CCC_Partner__c>();
        
        try{
            RestRequest request = RestContext.request;            
            WebServicePartnerReq params = WebServicePartnerReq.parse(request.requestBody.toString());
            List<WebServicePartnerReq.Partner> Partner = params.Partner;
            set<String> accountNames = new set<String>();
            map<String,Id> accountNamesVsaccountNames = new map<String,Id>();
            for(WebServicePartnerReq.Partner pt:Partner){
                accountNames.add(pt.CCC_Dealer);
                accountNames.add(pt.CCC_Distributor);
            }
            for(Account act:[SELECT Id, Name FROM Account Limit 4500]){
                accountNamesVsaccountNames.put(act.Name,act.Id);
            }
            
            for(WebServicePartnerReq.Partner pt:Partner){
                CCC_Partner__c carrierPartner  			=   new CCC_Partner__c();
                carrierPartner.CCC_Relationship__c      =   pt.CCC_Relationship;
                carrierPartner.HVP__c            		=   pt.HVP;
                carrierPartner.CIN__c       			=   pt.CIN;
                carrierPartner.Partner_External_ID__c   =   pt.Partner_External_ID;
                if(accountNamesVsaccountNames.containsKey(pt.CCC_Distributor)){
                    carrierPartner.CCC_Distributor__c   =   accountNamesVsaccountNames.get(pt.CCC_Distributor);
                }
                if(accountNamesVsaccountNames.containsKey(pt.CCC_Dealer)){
                    carrierPartner.CCC_Dealer__c        =   accountNamesVsaccountNames.get(pt.CCC_Dealer);
                }
                
                partnerLst.add(carrierPartner);
            }
            system.debug('partnerLst: '+partnerLst);
            if(partnerLst.size()>0){
                Database.UpsertResult [] cr = Database.upsert(partnerLst,CCC_Partner__c.fields.Partner_External_ID__c,false);                    
            }
        }
        catch(exception ex){
            system.debug('ExMsg: '+ex.getMessage());
            if(ex == null){
                
            }else{
                responseJSON.status = 'Failed';
                responseJSON.message = ex.getMessage();
            }
        }
        return responseJSON;
    }
    
    global class PartnerResponseWrapper {        
        global String status {get;set;} 
        global String message {get;set;}
    }
}