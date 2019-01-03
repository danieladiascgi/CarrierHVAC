public with Sharing class CCC_EquipmentDetailController{ 
    public CCC_EquipmentDetailController() {

    }


    public String reg { get; set; }
   
    public String strURL{get;set;}
    public list<wrapperResponse> lstResponse{get;set;}
    public list<wrapperResponseWarrantyInfo> WarrantyInfoTableList {get;set;}
    @TestVisible private String strModelNumber{get;set;}
   @TestVisible private String strSerialNumber{get;set;}
    private String strFirstName{get;set;}
    private String strLastName{get;set;}
    private String strPhone{get;set;}
    public String strServiceContactNumber{get;set;}
    private Date dtPurchaseDate{get;set;}
    private String strPurchaseDate{get;set;}
    private String strPurchasedFrom{get;set;}
    public list<wrapperResponseClaim> lstwrapperResponse {get;set;}
    private String responseStr{get;set;}
    public String dModelNo_ModelNo {get;set;}
    public String dModelNo_SerialNo {get;set;}
    public Profile currentUserProfile;
    public boolean isShowServiceHistoryTab{get;set;}
    
        /*Variable Declarations*/
    public Registration_Correction__c regCorrection { get; set; }
    Public Equipment__c equipRec{get;set;}
    public List<Equipment__c> RegcorrecList {get; set;}
    public List<Registration_Correction__c> selectedContacts {get;set;}
    public boolean flag{get;set;}
    Public boolean EquipFlag{get;set;}
    public case objCase;
    public List<Equipment__c> lstAllSelectedRecords = new List<Equipment__c>();
    public List<Equipment__c> reggCorrection = new List<Equipment__c>();
    public Id uniqueEquipmentId {get;set;}
    public list<RegistrationDataObj> registrationDataReslts;
    public List<Equipment__c> lstEquipRecords {get; set;}
    public List<Equipment__c> delequipList {get;set;}
    public Integer rowIndex {get;set;}
    Public Equipment__c del;
    public Registration_Correction__c correct{get;set;}  
    public Registration_Correction__c objRegCorrectiom {get; set;}
    Public List<String> warrantyList{get;set;}
    public CCC_EquipmentDetailController(ApexPages.StandardController controller){
    
        
        //Initializing the request parameters with null values to avoid null pointer exception
        strModelNumber ='';strSerialNumber='';strFirstName='';strLastName='';strPhone='';strServiceContactNumber='';strPurchasedFrom='';
       
          
    }
    
    /*
Init() method executes when user click on Detail button on equipment Search page
This method fetches the Serial Number, Model Number from URL.
Executes the  RestRegistrationModelSerial, Service History and Entitlement Methods in synchronous Mode.

*/    
    public void init(){                
       strSerialNumber = ApexPages.currentPage().getParameters().get('sn');
        strModelNumber = (ApexPages.currentPage().getParameters().get('mn') ==null)?'':ApexPages.currentPage().getParameters().get('mn');       
         
        try
        {   
            PageReference pr =  EntitlementDetail();
        }
        catch(exception e){
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Service Entitlement Service is Currently not available.');
            apexpages.addmessage(msg);
        }
        try
        {
            getRegisteredEquipments(strSerialNumber,strModelNumber);
            //ApexPages.StandardController sc = new ApexPages.StandardController(opp);

        }
        catch(Exception e)
        {
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Registration Data Search Service is Currently not available.');
            apexpages.addmessage(msg);
        }
        // Below query retrieve the Current user profile
  currentUserProfile = [select id, name from Profile  where Id=: UserInfo.getProfileId()];
        isShowServiceHistoryTab=false;
         if(currentUserProfile.Name != 'Tier 1 Agent Profile'){
         isShowServiceHistoryTab=true;
         try
        {
            ServiceHistoryWebService();
        }
        catch(exception e){
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Service History Service is Currently not available.');
            apexpages.addmessage(msg);
        }
         }
         
         /*
         //Below code is display the product information page based on the Model Number
           strModelNumber=strModelNumber.substring(0,6);
           strURL='https://ws.carrier.utc.com/catalog/products/'+'24ANB1';
*/
        
    }     
    // ServiceHistoryWebService() executes from Init()
    public void ServiceHistoryWebService(){      
        lstwrapperResponse = new list<wrapperResponseClaim>();
        try{
        SBEntitlementProductService.ProductEntitlementServicePort port = New SBEntitlementProductService.ProductEntitlementServicePort();
        SBEntitlementProductService.ServiceHistoryResponse_element response  = port.getServiceHistory('92',strModelNumber,strSerialNumber);
        //If Service History Method response is null then below condition executes and msg will be displayed on the page. 
        if(response==null ){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'ServiceHistory - No Records Found. '));
          }
          
          if(response.serviceData==null || response.serviceData.claim==null){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'ServiceHistory - No Records Found. '));
          }
        
        // Below for loop iterates the Response of Service history and displays under Service History Tab on Equipment Details page.
        for (SBEntitlementProductService.claim obj :response.serviceData.claim){
            string CN = (obj.claimNumber == null)?'':obj.claimNumber;
            string CC = (obj.customerComplaint == null)?'':obj.customerComplaint;
            string SD = (obj.serviceDate== null)?'':String.valueof(obj.serviceDate);
            string SE = (obj.serviceExplanation== null)?'':obj.serviceExplanation;
            map<String,String> mapService = new map<String,String>();
            list<Service> lstService = new list<service>();
            //Add Service Details in the list
            for(SBEntitlementProductService.service objService:  obj.service){
                for(SBEntitlementProductService.serviceDetail objSDetail: objService.serviceDetail) {
                    string DK = (objSDetail.dataKey== null)?'':objSDetail.dataKey;
                    string DD = (objSDetail.dataDescription== null)?'':objSDetail.dataDescription;
                    lstService.add(new Service(DK,DD) );
                }
            }   
            //Add PService Details in the list
            list<partsDetail> lstPart = new list<partsDetail>();
            for(SBEntitlementProductService.parts objPart:  obj.parts){
                for(SBEntitlementProductService.partDetail objPartsDetail: objPart.partDetail) {
                    string PN = (objPartsDetail.partNumber== null)?'':objPartsDetail.partNumber;
                    string PM = (objPartsDetail.partName== null)?'':objPartsDetail.partName;
                    string PQ = (objPartsDetail.partQuantity== null)?'':String.valueOf(objPartsDetail.partQuantity);
                    lstPart.add(new partsDetail(PN,PM,PQ)); 
                }
            }
            lstwrapperResponse.add(new wrapperResponseClaim(CN,SD,CC,SE,lstService,lstPart));
        }
        }
        Catch(System.CalloutException e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'ServiceHistory - No Records Found.'));          
        }
        Catch(Exception e){
            //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'ServiceHistory WebService - 2. An unexpected error has occurred ,Please contact your Administrator. '));
        } 
         
        
    }
    // EntitlementDetail() executes from Init()
    public pagereference EntitlementDetail(){
        try{
        SBEntitlementProductService.ProductEntitlementServicePort port = New SBEntitlementProductService.ProductEntitlementServicePort();
        SBEntitlementProductService.entitlementInfo[] lstEnt = port.getEntitlementDetail('92',strModelNumber,strSerialNumber,strFirstName,strLastName,strPhone,strServiceContactNumber,strPurchaseDate,strPurchasedFrom);
        //SBEntitlementProductService.detail
        if(lstEnt == null || lstEnt.size()==0){          
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Entitlement Detail - No Records Found'));
         }
        lstResponse = new list<wrapperResponse>();
        WarrantyInfoTableList =new list<wrapperResponseWarrantyInfo>();
        List<serviceEntitlement> EntitleInfo=new List<serviceEntitlement>();
        List<warrantyInfoTable> WarrInfo=new List<warrantyInfoTable>();
        // Below for loop iterates the Response of Entitlement and displays under Entitlement Information Tab on Equipment Details page.
         for(SBEntitlementProductService.entitlementInfo obj :lstEnt){
            if(obj.detail != null){
                for(SBEntitlementProductService.detail objDetail:obj.detail){
                
                String temp=(objDetail.dataKey== null)?'':objDetail.dataKey;
                 string EDK = String.join(temp.split('(?=[A-Z])'),' ').toUpperCase();
                // string EDK =temp.toUpperCase();
                string EDD = (objDetail.dataDescription== null)?'':objDetail.dataDescription;
                
               if(EDK!='LINE NO')
               {
                EntitleInfo.add(new serviceEntitlement(EDK,EDD) );
               } 
                             
                
                
                   if(objDetail.detailExt != null)
                 { 
                 try
                 {            

                String BRAND=objDetail.detailExt[0].extDataDescription;
                String APPLICATIONTYPE=objDetail.detailExt[1].extDataDescription;
                String ORIGINALEQUIPMENTOWNER=objDetail.detailExt[2].extDataDescription;
                String COMPONENTCODE=objDetail.detailExt[3].extDataDescription;
                String WARRANTYLENGTH=objDetail.detailExt[4].extDataDescription;
                String INSTALLEDAFTER=objDetail.detailExt[5].extDataDescription;
                String WARRANTYSTART=objDetail.detailExt[6].extDataDescription;
                String WARRANTYSTOP=objDetail.detailExt[7].extDataDescription;
             

                WarrInfo.add(new warrantyInfoTable(BRAND,APPLICATIONTYPE,ORIGINALEQUIPMENTOWNER,COMPONENTCODE,WARRANTYLENGTH,INSTALLEDAFTER,WARRANTYSTART,WARRANTYSTOP));
                
                
                }
                 catch(exception e)
                {
                system.debug('--------->'+e);
                }
                }
                }
                }
                
                
                
            
        } 
        lstResponse.add(new wrapperResponse(EntitleInfo));
        
        WarrantyInfoTableList.add(new wrapperResponseWarrantyInfo(WarrInfo));
        
        
        
        
        
        }
        catch(System.CalloutException e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Entitlement Detail- No Records Found.'));
        }        
        Catch(Exception e){
           //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Entitlement Detail - 2. An unexpected error has occurred ,Please contact your Administrator. '));
        }
       return null;      
    }
    
  
    //This method is used to fetch the registered equipments from PHDB based on Serial Number.
    public pagereference getRegisteredEquipments(String strSerialNumber, String strModelNumber){
        
        string response = '';
        String serialNumber;
        String modelNumber;
                
        if(strSerialNumber != null)
        {
        serialNumber= strSerialNumber;  
        }
        if(strModelNumber!= null)
        {
        modelNumber= strModelNumber;  
        }
              
        if((serialNumber!= null && serialNumber!= '') && (modelNumber!= null && modelNumber!= '') ){
             
            response = new CCC_IntegrationHelper().getPHDBInformation(null,null,null,null,null,null,null,null,null,null, null,null,null,null,serialNumber,modelNumber);
                     
        }
        
        try{
       
        JSONParser parser = JSON.createParser(response);
        if(parser != null){
            RegistrationDataList regResult = (RegistrationDataList)parser.readValueAs(RegistrationDataList.class);
            regCorrection= new Registration_Correction__c();
            RegcorrecList = new List<Equipment__c>(); 
                system.debug('---------regResult----------'+regResult);
              system.debug('---------registrationDataResults ----------'+regResult.registrationDataResults );
            if(regResult != null && regResult.registrationDataResults != null && 
                ((serialNumber  == null || serialNumber == '') || (serialNumber != null && serialNumber != '' && regResult.registrationDataResults.size() == 1))){
                for(RegistrationDataObj reg: regResult.registrationDataResults){  
                             
                    string firstname = '';
                    string lastName = '';
                    if(reg.consumer_Name != null && reg.consumer_Name.contains(',')){
                        firstname = reg.consumer_Name.split(',')[0];
                        lastName = reg.consumer_Name.split(',')[1];
                        regCorrection.FirstName__c = firstname;
                        regCorrection.Last_Name__c = lastName;
                        
                    }else{
                        regCorrection.FirstName__c = reg.consumer_Name; 
                    }
                    regCorrection.Business_Name__c = reg.consumer_Name; 
                    regCorrection.AddressStreet__c = reg.consumer_Address1 + ' ' +reg.consumer_Address2;    
                    regCorrection.City__c = reg.consumer_City;  
                    regCorrection.State__c = reg.consumer_State;    
                    regCorrection.Zip1__c = reg.consumer_Zip;   
                    regCorrection.Country__c = reg.consumer_Country;    
                    regCorrection.Homeowner_Emai1__c = reg.consumer_Email;  
                    regCorrection.Homeowner_Phone_NumberHome__c = reg.consumer_Phone1;  
                    regCorrection.Homeowner_Phone_NumbeWorkr__c = reg.consumer_Phone2;  
                    regCorrection.Installation_Date__c = FormatDate(reg.installationDate);  
                    regCorrection.Transfer_Date1__c = FormatDate(reg.transferDate); 
                    regCorrection.Dealer_Name1__c = reg.dealerName; 
                    regCorrection.Dealer_Number1__c = reg.dealerPhone;  
                    regCorrection.Registration_Date__c = FormatDate(reg.registrationDate);
                    regCorrection.Enhanced__c=reg.enhancedWarrantyFlag;
                    regCorrection.Registered_On_Time__c=reg.registeredOnTimeFlag;
                    Equipment__c equip = new Equipment__c();
                    equip.Model__c = reg.model;
                    equip.Serial__c = reg.serial;
                    equip.SB_Reg__c = reg.registrationNumber;
                    equip.Mark_As__c = reg.markAs;
                    equip.Source__c = reg.source;
                                                
                    RegcorrecList.add(equip);
                                
                }
                
            }                                  
        }
        
        }Catch(Exception e){
            
        }
          return null;                                      
    }   
  
    
    public static date  FormatDate(string dateString){
        if(dateString.length() >= 10){
            string year = dateString.substring(6,10);
            string day = dateString.substring(3,5);
            string month = dateString.substring(0,2);
            string fullDate = year+'-'+month+'-'+day;
            date FormatedDate = date.ValueOf(fullDate);         
            return FormatedDate;
        }       
        return null;
    }

    public class RegistrationDataList{
        public list<RegistrationDataObj> registrationDataResults;
        public string id;
    }
    
        
  
    public class RegistrationDataObj {
        public String consumer_Name { get; set;}
        public String consumer_BusinessName { get; set;}
        public String consumer_Address1 { get; set;}
        public String consumer_Address2 { get; set;}
        public String consumer_City { get; set;}
        public String consumer_State { get; set;}
        public String consumer_Country { get; set;}
        public String consumer_Zip { get; set;}
        public String consumer_Email { get; set;}
        public String consumer_Phone1 { get; set;}
        public String consumer_Phone2 { get; set;}
        public String equip_Address1 { get; set;}
        public String equip_Address2 { get; set;}
        public String equip_City { get; set;}
        public String equip_State { get; set;}
        public String equip_Country { get; set;}
        public String equip_Zip { get; set;}
        public String dealerName { get; set;}
        public String dealerPhone { get; set;}
        public String mfgAcctNum { get; set;}
        public String serviceBenchID { get; set;}
        public String hvacpId { get; set;}
        public String model { get; set;}
        public String serial { get; set;}
        public String equip_Description { get; set;}
        public String confirmationNumber { get; set;}
        public String registrationNumber { get; set;}
        public String source { get; set;}
        public String comments { get; set;}
        public String installationDate{ get; set;}
        public String registrationDate{ get; set;}
        public String transferDate{ get; set;}
        public String markAs{ get; set;}
        public String registrationDataInput{ get; set;} 
        public String  Id { get; set;}
        public String  modelLocation { get; set;}
        public String  furnaceOrientation { get; set;}
        public String  furnaceFuel { get; set;}
        public String  enhancedWarrantyFlag { get; set;}
        public String  alwaysReviewFlag { get; set;}
        public String  registeredOnTimeFlag { get; set;}
        public String  proofOfPurchaseFlag { get; set;}
        public String  agreementNumber { get; set;}
        public String  tagNumber { get; set;}
        public boolean selected {get;set;}  
    }   
   public class wrapperResponse{
        
        public List<serviceEntitlement> EntitleInfo {get;set;}
        public wrapperResponse(List<serviceEntitlement> EntitleInfo){
            this.EntitleInfo= EntitleInfo;
           
        }
    }  
    
   
    
    public class wrapperResponseWarrantyInfo{
       
        public List<warrantyInfoTable> WarrInfo {get;set;}
        
        public wrapperResponseWarrantyInfo(List<warrantyInfoTable> WarrInfo){
            this.WarrInfo = WarrInfo;
            system.debug('##############'+this.WarrInfo);
        }
    } 
        public class warrantyInfoTable{
        public String BRAND{get;set;}
        public String APPLICATIONTYPE{get;set;}
        public String ORIGINALEQUIPMENTOWNER{get;set;}
        public String COMPONENTCODE{get;set;}
        public String WARRANTYLENGTH{get;set;}
        public String INSTALLEDAFTER{get;set;}
        public String WARRANTYSTART{get;set;}
        public String WARRANTYSTOP{get;set;}
        public warrantyInfoTable(String BRAND,String APPLICATIONTYPE,String ORIGINALEQUIPMENTOWNER,String COMPONENTCODE,String WARRANTYLENGTH,String INSTALLEDAFTER,String WARRANTYSTART,String WARRANTYSTOP){
            system.debug('%%%%%%%%%%%%%%%%');
            this.BRAND=BRAND;
            this.APPLICATIONTYPE=APPLICATIONTYPE;
            this.ORIGINALEQUIPMENTOWNER=ORIGINALEQUIPMENTOWNER;
            this.COMPONENTCODE=COMPONENTCODE;
            this.WARRANTYLENGTH=WARRANTYLENGTH;
            this.INSTALLEDAFTER=INSTALLEDAFTER;
            this.WARRANTYSTART=WARRANTYSTART;
            this.WARRANTYSTOP=WARRANTYSTOP;
        }
    }  
     
    public class wrapperResponseClaim{
        public String strClaimNumber{get;set;}
        public String strServiceDate{get;set;}
        public String strCustomerComplaint{get;set;}
        public String strServiceExplanation{get;set;}
        public map<String,String> mapServices {get;set;}
        public list<service> lstService {get;set;}
        public list<partsDetail> lstPart {get;set;}
        public wrapperResponseClaim(String strClaimNumber, String strServiceDate, String strCustomerComplaint, String strServiceExplanation, list<service> lstService  ,list<partsDetail> lstPart ){
            this.strClaimNumber= strClaimNumber;
            this.strServiceDate = strServiceDate;
            this.strCustomerComplaint = strCustomerComplaint;
            this.strServiceExplanation= strServiceExplanation;
            this.mapServices = mapServices ;
            this.lstPart = lstPart ;
            this.lstService = lstService ;
        }
    }
    public class service{
        public String strDataKey{get;set;}
        public String strDataDiscription{get;set;} 
        public service(String strDataKey,String strDataDiscription){
            this.strDataKey = strDataKey;
            this.strDataDiscription = strDataDiscription;
        }
    }
    public class serviceEntitlement{
        public String strDataKey{get;set;}
        public String strDataDiscription{get;set;} 
        public serviceEntitlement(String strDataKey,String strDataDiscription){
            this.strDataKey = strDataKey;
            this.strDataDiscription = strDataDiscription;
        }
    }
   
    public class partsDetail{
        public String strPartNumber{get;set;}
        public String strPartName{get;set;} 
        public String strPartQuantity{get;set;}             
        public partsDetail(String strPartNumber,String strPartName,String strPartQuantity){
            this.strPartNumber= strPartNumber;
            this.strPartName= strPartName;
            this.strPartQuantity= strPartQuantity;                
        }
    }   
      
}