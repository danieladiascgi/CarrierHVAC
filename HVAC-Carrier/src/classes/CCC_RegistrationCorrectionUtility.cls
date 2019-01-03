public class CCC_RegistrationCorrectionUtility {

    public static String getModelFromSerialSearch(String serialNumber){
        String modelNoToReturn = '';
        Access_Token__c tokenValue=Access_Token__c.getValues('PHDB Smart Search');
        String token=tokenValue.PHDB_Access_Token__c;  
        		CCC_IntegrationEndPoint__c  CustomSettingEndPointPHDB = CCC_IntegrationEndPoint__c.getValues('PHDB');                
                Http http = new Http();
                HttpRequest req1 = new HttpRequest();                
                String baseURL = CustomSettingEndPointPHDB.URL__c; 
                                   
                String endpoint = baseURL + 'serial/' + serialNumber;
                req1.setEndpoint(endpoint);
                req1.setMethod('GET');
                req1.setTimeout(120000);       
                String authorizationHeader1 = 'Bearer '+token;
                system.debug('--------endpoint----------' + endpoint);
                
                req1.setHeader('Authorization', authorizationHeader1);
                System.debug('#req1:'+req1);
                HTTPResponse res1 = http.send(req1);
                
                system.debug('#Rest:'+res1.getBody());
                JSONParser parser1 = JSON.createParser(res1.getBody());
				try{
                    DiscreteModelNumbersWrapper ob1=(DiscreteModelNumbersWrapper)JSON.deserialize(res1.getBody(),DiscreteModelNumbersWrapper.class);
                    system.debug('--------ob1------' + ob1);
                    System.debug('#ob1.suggestedResults:'+ob1.suggestedResults);
                    if(ob1!=null && ob1.suggestedResults!=null && ob1.suggestedResults.size()>0){
                        DiscreteModelNumbersWrapper a = ob1.suggestedResults.get(0);
                        if(a.model!=null && a.model.length()>0){
                            return a.model;
                        }
                    }
                }catch(System.CalloutException e){
                       //errlog.ErrorLogCalloutException(e,'PHDB WebService','CCC_EquipmentDetailController');
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - No Record Found'));
                }
                Catch(Exception e){
                    //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
                   //errlog.ErrorLogException(e,'PHDB WebService','CCC_EquipmentDetailController');
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - An unexpected error has occurred ,Please contact your Administrator. '));
                }
        return modelNoToReturn;
    }
    //wrapper Class for reponse
    public class DiscreteModelNumbersWrapper {
        public integer dataQualityIndicator{get;set;}
        public string discreetNo{get;set;}
        public String model {get;set;}
        public string serial{get;set;}
        public string toscode {get;set;}
        public string brand {get;set;}
        public String mfgDate {get ; set;}
        public String derivedMfgDate {get ; set;}
        public integer mfgWeek{get;set;}
        public integer mfgYear{get;set;}
        public String msg{get;set;}
        public boolean serialVerified{get;set;}
        public string shippedDate{get;set;}
        public string suGuid{get;set;}
        public string shipTo{get;set;}  
        public boolean selected {get;set;}
        public list<DiscreteModelNumbersWrapper> suggestedResults{get;set;}
        
        
    }
}