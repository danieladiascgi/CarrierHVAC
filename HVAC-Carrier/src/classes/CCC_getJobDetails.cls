global class CCC_getJobDetails
{
public list<RegistrationDataObj> registrationDataReslts;
Public static List<DiscreteModelNumbersWrapper> lstDisNum {get;set;}

/*
This method is used to call the registratindatasearch method to fetch the Jobname,JobDescription and Product Family.
@Developer: Sudheer Reddy
*/
@Future(callout=true)
public Static void getJobDetails(Id caseRecordId)
{
system.debug('Entered in to future Method');
String response='';
JSONParser parser;
Case phdbCallCase =[Select Id,CCC_Job_Name__c,CCC_Job_Site_Address__c,CCC_Serial_Number__c,CCC_Model_Number__c from Case where Id =:caseRecordId];
                    String SerialNumber=phdbCallCase.CCC_Serial_Number__c;
                    String ModelNumber=phdbCallCase.CCC_Model_Number__c;
                    if(!Test.isRunningTest())
                    {
                    response = new CCC_IntegrationHelper().getPHDBInformation( null,null,null,null,null,null,null, null,null, null, null,null,null, null,SerialNumber,ModelNumber);
                     parser = JSON.createParser(response);
                    }
                    

       
        if(parser != null){
            RegistrationDataList regResult = (RegistrationDataList)parser.readValueAs(RegistrationDataList.class);

            if(regResult != null && regResult.registrationDataResults != null && regResult.registrationDataResults.size() == 1){
                for(RegistrationDataObj reg: regResult.registrationDataResults){                                    
                        phdbCallCase.CCC_Job_Name__c=reg.consumer_BusinessName;
                        phdbCallCase.CCC_Job_Site_Address__c=reg.equip_Address1 + reg.equip_Address2 ;
                        update phdbCallCase;
                        
                                
                }
            }                                  
        }


}
    @Future(callout=true)
    public static void getProductFamilyDetails(Id caseRecordId) { 
    
    Case phdbCallCase =[Select Id,CCC_Product_Group_Code__c,CCC_Date_Code__c,Plant_Name__c,CCC_Serial_Number__c,CCC_Model_Number__c from Case where Id =:caseRecordId];
                    String SerialNumber=phdbCallCase.CCC_Serial_Number__c;
                    String ModelNumber=phdbCallCase.CCC_Model_Number__c;
        
        Access_Token__c tokenValue=Access_Token__c.getValues('PHDB Smart Search');
        String token=tokenValue.PHDB_Access_Token__c;  
        lstDisNum=new List<DiscreteModelNumbersWrapper>(); 

               
               
                CCC_IntegrationEndPoint__c  CustomSettingEndPointPHDB = CCC_IntegrationEndPoint__c.getValues('PHDB');
                
                 Http http = new Http();
                HttpRequest req1 = new HttpRequest();                
                String baseURL = CustomSettingEndPointPHDB.URL__c;                              
                String endpoint = baseURL + 'model-serial/' + +modelNumber+ '/' +serialNumber;
                req1.setEndpoint(endpoint);
                req1.setMethod('GET');
                req1.setTimeout(120000);       
                String authorizationHeader1 = 'Bearer '+token;
                system.debug('--------endpoint----------' + endpoint);
                
                req1.setHeader('Authorization', authorizationHeader1);
                HTTPResponse res1 = http.send(req1);
                system.debug('--------->Callout Response'+res1);
                
                JSONParser parser1 = JSON.createParser(res1.getBody());
                try{
                    DiscreteModelNumbersWrapper ob1=(DiscreteModelNumbersWrapper)JSON.deserialize(res1.getBody(),DiscreteModelNumbersWrapper.class);
                    if(ob1 == null ){
                        system.debug('PHDB -No Response Received from Server');
                    }
                    else
                    {
                    lstDisNum.add(ob1);
                    if(lstDisNum[0].suggestedResults.size() == 0){
                            system.debug('PHDB -No Matching Records Found');
                    }
                    else if (lstDisNum[0].suggestedResults.size() == 1){

                    for (DiscreteModelNumbersWrapper wrapper :lstDisNum) {
                    for(DiscreteModelNumbersWrapper a :  wrapper.suggestedResults){

                        if(a.ProductFamily != null && a.ProductFamily != '')
                        {
                        /*phdbCallCase.CCC_Product_Group_Code__c = a.ProductFamily;*/
                        system.debug('ProductFamily'+phdbCallCase.CCC_Product_Group_Code__c);
                        }
                        if(a.mfgDate != null && a.mfgDate != '')
                        {
                        phdbCallCase.CCC_Date_Code__c= a.mfgDate;
                         system.debug('mfgDate'+phdbCallCase.CCC_Date_Code__c);
                        }
                        if(a.MfgPlant != null && a.MfgPlant != '')
                        {
                        phdbCallCase.Plant_Name__c= a.MfgPlant;
                        system.debug('mfgDate'+phdbCallCase.Plant_Name__c);
                         
                        }
                        
                        
                        
                    
                }
                        update phdbCallCase;
            }


                        
                    }
                    else
                    {
                     system.debug('PHDB -More Than one result received');
                    }
                    }
                }
                catch(System.CalloutException e){
                  system.debug(e.getMessage());
                }
                Catch(Exception e){
                system.debug(e.getMessage());
                     }
           
        
      
    }
    



     public class RegistrationDataList{
        public list<RegistrationDataObj> registrationDataResults;
        public string id;
    }
    
     public class RegistrationDataObj {
        public String consumer_BusinessName { get; set;}
        public String equip_Address1 { get; set;}
        public String equip_Address2 { get; set;}
        
    }  
    
//wrapper Class for reponse
    public class DiscreteModelNumbersWrapper {
        public integer dataQualityIndicator{get;set;}
        public string discreetNo{get;set;}
        public String model {get;set;}
        public string serial{get;set;}
        public String mfgDate {get ; set;}
        public String derivedMfgDate {get ; set;}
        public integer mfgWeek{get;set;}
        public integer mfgYear{get;set;}
        public String msg{get;set;}
        public boolean serialVerified{get;set;}
        public string shippedDate{get;set;}
        public string suGuid{get;set;}
        public string shipTo{get;set;}
        public String ProductFamily{get;set;}
        Public String MfgPlant{get;set;}  
        public boolean selected {get;set;}
        public list<DiscreteModelNumbersWrapper> suggestedResults{get;set;}
        
        
    }
}