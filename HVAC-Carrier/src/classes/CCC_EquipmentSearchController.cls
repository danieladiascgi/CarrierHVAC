/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Organization: UTC
Partner/Vendor: Wipro Technologies
Developer: Bhupendra Chauhan
Description: This Class is used to Serch Equipment from PHDB and Smart serch webservice.User can add Asset/Equipemnt from this page with Case.

Changes to the Code:
Bhupendra[18-Feb]:  1. Add Instalation Address and Name in serch reslut of Smart serch.
2. Add 'No Record Found' Error Message.
3. Error Logging.
@Date Modified : 3/14/2016 Reason: Remove unwanted commented code and debug statements Developer :Ankita Rambole 
@Date Modified : 3/15/2016 Reason: Endpoint values should be stored in custom setting and retrive from it. Developer :Ankita Rambole 
@Date Modified : 3/16/2016 Reason: Added method and statement level comments Developer :Ankita Rambole 
@Date Modified : 3/17/2016 Reason: Changed getEquipmentInfo , used  reusable component CCC_Integration_Helper for PHDB service ,to send and receive response 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
*/
Public Class CCC_EquipmentSearchController {
    public String responseStr{get;set;}
    public Boolean CaseHide {get; set;}
    public Boolean detailHide {get;set;}
    public boolean IsAssetShow{get;set;}
    public list <Asset> asstList {get ; set;}
    public list <AllAsset> lstAsset {get ; set;}
    Public List<DiscreteModelNumbersWrapper> lstDisNum {get;set;}
    Public List<FindRegisteredWrapper>lstRegEq { get; set;}
    Public string delId {get;set;}
    // Discrete Model Number service variable
    public String dModelNo_ModelNo {get;set;}
    public String dModelNo_SerialNo {get;set;}
    public String dModelNo_Brand {get;set;}
    public String dModelNo_ProductHierarchy {get;set;}
    public String dModelNo_DiscModelNo {get; set;}
    public String dModelNo_TossCode {get; set;}
    public String dModelNo_PhNo {get;set;}
    public String dModelNo_InstAddres {get;set;}
    public String dModelNo_RegisNo {get;set;}
    public String dModelNo_LstName {get;set;}
    public String dModelNo_Zipcde {get;set;}
    public String dModelNo_ConfNo {get;set;}
    public string selectedValue { get;set; }
    public List<SelectOption> brandOptions { get;set; }
    public Case objCase{get;set;}
    public Account acc{get;set;}
    public boolean isInternalUser{get;set;}
    public boolean BrandOnCasepresent{get;set;}
    CCC_ErrorLog errlog= new CCC_ErrorLog();
    //
    public boolean isValidate = true;
    public List<Asset> updateAssetTosCode{get; set;}
    public List<Asset> updateAssetbrand{get; set;}
    
    /*Added below vairable for Primary Asset logic - Start*/
    public String selectedPrimaryAssetId{get; set;}
    /*Added below variable for Primary Asset logic - End*/
    public Map<Id, CCC_junctionCaseAsset__c> junctionIdKeyObjMap{get; set;}
    public Map<Id, Id> assetIdKeyJuncIdValue{get; set;}
    public String responseGlobalCapture{get; set;}
    public Map<String, DiscreteModelNumbersWrapper> mapSerialKeyAndAssetWrpVal{get; set;}
    public string dModelNo_PlantName{get;set;}
    public Boolean primary{get;set;}
    
    /**
* @description :constructor call
**/
    public CCC_EquipmentSearchController(ApexPages.StandardController stdController){
        System.debug('#Inside Constructor');
        System.debug('#Before Constructor');
        junctionIdKeyObjMap = new Map<Id, CCC_junctionCaseAsset__c>();
        assetIdKeyJuncIdValue = new Map<Id, Id>();
        updateAssetTosCode = new List<Asset>();
        updateAssetbrand = new List<Asset>();
        isInternalUser = false;
        User user1 = [select Id,Profile.UserLicense.Name from User where Id = :userinfo.getUserId() limit 1];
        if(user1.Profile.UserLicense.Name =='Partner Community'){
            isInternalUser = true;
        } 
        objCase = (Case)stdController.getRecord();
        objCase = [Select Id,AccountId,CCC_Brand__c,Current_Servicing_Dealer__c from Case where id=:objCase.Id limit 1];
        
        
        responseStr = 'Request is yet to be raised'+objCase;
        CaseHide=True;
        detailHide=false;
        IsAssetShow = false;
        isValidate = true;
        // Discrete Model Number REST API initialization
        dModelNo_ModelNo = '';
        dModelNo_SerialNo = '';
        //ishita added on 10 mar
        lstAsset = getAllAssets();
        /* if(objCase.CCC_Brand__c!=null){
dModelNo_Brand= objCase.CCC_Brand__c;
}
*/       
        
        
        
    }
    public CCC_EquipmentSearchController (){
        junctionIdKeyObjMap = new Map<Id, CCC_junctionCaseAsset__c>();
        assetIdKeyJuncIdValue = new Map<Id, Id>();
    }
    
    public list<AllAsset> getAllAssets(){
        list<AllAsset> lstAssetTemp = new list<AllAsset>();
        set<Id> AssetIds = new set<Id>();
        
        //insert junction asset in list
        for(CCC_junctionCaseAsset__c objJunction:[select Id,Asset__c, primary__c from CCC_junctionCaseAsset__c where Case__c =:objCase.Id]){
            AssetIds.add(objJunction.Asset__c);
            System.debug('#junctionIdKeyObjMap:'+junctionIdKeyObjMap);
            System.debug('#objJunction:'+objJunction);
            System.debug('#objJunction.Id:'+objJunction.Id);
            
            junctionIdKeyObjMap.put(objJunction.Id, objJunction);
            assetIdKeyJuncIdValue.put(objJunction.Asset__c, objJunction.Id);
        }
        
        //maps to Asset object and redirects to CCC_EquipmentDetail page with parameters Serial Number, Model Number, Brand and Discrete Model Number
        for(Asset objAsset:[Select Id,Brand__c,Toss_Code__c,Product_Hierarchy__c,CCC_Disc_Model_Number__c,CCC_Model_Number__c,SerialNumber,CCC_Validation_status__c,CCC_Installing_Dealer__c,Ship_Date__c,Plant_Name__c from Asset where Id = :AssetIds]){
            CCC_junctionCaseAsset__c junctionobj=[select id,primary__c,Asset__c from CCC_junctionCaseAsset__c where Case__c =:objCase.Id AND Asset__c=:objAsset.Id ];
            primary=junctionobj.Primary__c;  
            String strUrl = '/apex/CCC_EquipmentDetail?sn='+objAsset.SerialNumber+'&mn='+objAsset.CCC_Model_Number__c+'&br='+objAsset.Brand__c+'decmn='+objAsset.CCC_Disc_Model_Number__c;
            lstAssetTemp.add(new AllAsset(objAsset,strUrl, assetIdKeyJuncIdValue.get(objAsset.Id),primary));
            IsAssetShow = true;
            
        }
        return lstAssetTemp;
    }
    
    /**
* @description :method for Save and Validate from webservice, if empty throws an error to enter serial number
**/
    public void getDiscreteModelNo(){
        
        if(dModelNo_SerialNo =='' ){ 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter the Serial Number');//
            ApexPages.addMessage(myMsg); 
        }
        
        
        else{ 
            getDiscreteModelNumbers(dModelNo_ModelNo,dModelNo_SerialNo,dModelNo_DiscModelNo,dModelNo_Brand);
            
        }
    }
    /**
* @description : This method is used foe web service call, which will get the Model Registratipn Number, Last Name, phone Number, Install Address and Zip Code
**/
    
    public void getEquippmentInfo () {
        
        getEquipmentInfo(dModelNo_LstName,
                         dModelNo_ConfNo,
                         dModelNo_Zipcde,
                         dModelNo_InstAddres, 
                         dModelNo_PhNo,dModelNo_RegisNo);
        
        
    }
    /**
* @description : It deletes the selected record, when user clicks on delete command link
**/
    public void delRecord (){
        String rId = Apexpages.currentpage().getparameters().get('delrId');
        list<CCC_junctionCaseAsset__c>  lstdel = [select Id from CCC_junctionCaseAsset__c where Asset__c = :rId and Case__c=:ObjCase.Id] ;
        lstAsset = new list<AllAsset>();
        delete lstdel;
        lstAsset = getAllAssets();
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Deleted successfully');//and Model Number
        ApexPages.addMessage(myMsg); 
        
    }
    
    /**
* @parameters: Serial Number,Model Number, Disc Model No,Brand 
* @description :It will get all credentials from Custom setting object CCC_IntegrationEndPoint__c, from the body received
* by http response it will parse the token number. The Received json response is parsed and result is stored in wrapper class  DiscreteModelNumbersWrapper  
**/
    @TestVisible private void getDiscreteModelNumbers(String modelNumner, String serialNumber,String DiscModelNo, String Brand ) { 
        
        Access_Token__c tokenValue=Access_Token__c.getValues('PHDB Smart Search');
        String token=tokenValue.PHDB_Access_Token__c;  
        lstDisNum=new List<DiscreteModelNumbersWrapper>(); 
        
        
        
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
        HTTPResponse res1 = http.send(req1);
        System.debug('------response--------'+res1.getBody());
        responseGlobalCapture = res1.getBody();
        JSONParser parser1 = JSON.createParser(res1.getBody());
        try{
            DiscreteModelNumbersWrapper ob1=(DiscreteModelNumbersWrapper)JSON.deserialize(res1.getBody(),DiscreteModelNumbersWrapper.class);
            system.debug('--------ob1------' + ob1);
            if(ob1 == null ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB -No Matching Records Found  '));
            }
            while (parser1.nextToken() != null) {
                if (parser1.getText() == 'discreetNo') {
                    // Get the value.
                    parser1.nextToken();
                    ob1.discreetNo= parser1.getText();
                    break;
                }
            }
            lstDisNum.add(ob1);
            // System.debug('#lstDisNum123:'+lstDisNum);
            // System.debug('#lstDisNum123.suggestedResults[0]:'+lstDisNum[0]);
            System.debug('#lstDisNum123.suggestedResults:'+lstDisNum[0].suggestedResults);
            isValidate = true;
            if(lstDisNum[0].suggestedResults.size() == 0){
                if(dModelNo_SerialNo != '' && dModelNo_ModelNo != '' && dModelNo_SerialNo != null && dModelNo_ModelNo != null){ //if Agent insert Serial# and Model# then record should insert in Asset.
                    DiscreteModelNumbersWrapper wrp2 = new DiscreteModelNumbersWrapper();
                    wrp2.Model = dModelNo_ModelNo;
                    wrp2.Serial = dModelNo_SerialNo;
                    wrp2.discreetNo = dModelNo_DiscModelNo;
                    wrp2.brand = dModelNo_Brand;
                    wrp2.selected = true;
                    ob1.suggestedResults.add(wrp2);
                    System.debug('ob1'+ob1);
                    isValidate = false;
                    CreateAsset();
                    detailHide=false;
                }else{
                    apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'PHDB-No Record Found.');
                    apexpages.addmessage(msg);
                }
            }else{
                if(lstDisNum[0].suggestedResults.size() == 1){
                    lstDisNum[0].suggestedResults[0].selected = true;
                    CreateAsset();
                    detailHide=false;
                }else{
                    detailHide=true;
                }
            }
        }
        catch(System.CalloutException e){
            errlog.ErrorLogCalloutException(e,'PHDB WebService','CCC_EquipmentDetailController');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - No Record Found'));
        }
        Catch(Exception e){
            //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
            errlog.ErrorLogException(e,'PHDB WebService','CCC_EquipmentDetailController');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - An unexpected error has occurred ,Please contact your Administrator. '));
        }
        
        
        
    }
    
    /**
* @parameters: Last Name, Phone Number, Registration Number, zip code, Conf No, Install Address
* @description :It will get all credentials from Custom setting object CCC_IntegrationEndPoint__c, from the body received
* by http response it will parse the token number. The Received json response is parsed and result is mapped to wrapper class FindRegisteredWrapper  
* Used CCC_IntegrationHelper class to send token and get response from PHDB service
**/
    @TestVisible  private void getEquipmentInfo(String lstName, String ConfNo,String Zipcode, String instalAddress, String PhNo,String RegisNo ){
        lstRegEq = new List<FindRegisteredWrapper>();
        
        try{
            String response = new CCC_IntegrationHelper().getPHDBInformation( null,null,null,null,null,null,null, lstName,  ConfNo, Zipcode,  instalAddress,  PhNo, RegisNo, null,null,null);
            FindRegisteredWrapper wrp2=(FindRegisteredWrapper)JSON.deserialize(response,FindRegisteredWrapper.class);
            if(wrp2==null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'No Record Found.');
                ApexPages.addMessage(myMsg); 
            }
            if(wrp2.registrationDataResults==null || wrp2.registrationDataResults.size() ==0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'No Record Found.');
                ApexPages.addMessage(myMsg); 
            }
            lstRegEq.addAll(wrp2.registrationDataResults);
        }catch(exception e){
            errlog.ErrorLogException(e,'Equipment Search','CCC_EquipmentSearchController ');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'PHDB - No Record Found. ');
            ApexPages.addMessage(myMsg); 
        }
        
        
        detailHide=True;
    }
    /**
* @description :cancels the asset 
**/
    public void CancelAsset() {
        detailHide = False;
        
    }
    /**
* @description :it redirects to CCC_EquipmentDetail page
**/
    public PageReference Detailpage(){
        PageReference pr = new PageReference('/apex/CCC_EquipmentDetail?sn='+dModelNo_SerialNo+'&mn='+dModelNo_ModelNo+'&br='+dModelNo_Brand+'decmn='+dModelNo_DiscModelNo);//
        return pr;
    }
    
    
    /**
* @description :method to Save Asset and Junction object
**/
    
    public PageReference createJunctionObject(set<String> setSerialModel,List<Asset> lstAllSelectedAsset){
        list<CCC_junctionCaseAsset__c>  lstNewJunction = new list<CCC_junctionCaseAsset__c>();
        set<String> setExistingSerialModel = new set<String>();
        set<Id> setAssetId = new Set<Id>();
        list<Asset> lstNewAsset = new list<Asset>();
        
        set<Id> setAllSelectedAssetId = new set<Id>();
        
        list<Asset> lstExistingAsset = [select Id,CCC_SerialModelNumber__c, Ship_Date__c from Asset where CCC_SerialModelNumber__c in: setSerialModel];
        for(Asset objAss:lstExistingAsset){
            setExistingSerialModel.add(objAss.CCC_SerialModelNumber__c);
            setAllSelectedAssetId.add(objAss.Id);
        }
        /*Added new code for Shipped Date - Start*/
        for(Asset objAss:lstExistingAsset){
            objAss.Ship_Date__c = this.getShippedDate(); 
        }
        update lstExistingAsset;
        /*Added new code for Shipped Date - End*/
        set<Id> setAsset = new set<Id>();
        
        for(CCC_junctionCaseAsset__c obj:[select Id,Case__c,Asset__c from CCC_junctionCaseAsset__c where Asset__c in:lstExistingAsset]){
            if(obj.Case__c == objCase.Id){//If Asset is Exist on corrent Case
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The asset with Model no# and Serial no# is already added to this case');
                ApexPages.addMessage(myMsg); 
                setAllSelectedAssetId.remove(obj.Asset__c);
                return null;
            }else{ //If Asset is Exist but not in corrent Case
                if(!setAsset.contains(obj.Asset__c)){
                    
                    CCC_junctionCaseAsset__c objJunction = new CCC_junctionCaseAsset__c();
                    objJunction.Asset__c = obj.Asset__c;
                    objJunction.Case__c = objCase.Id;
                    lstNewJunction.add(objJunction) ;
                    setAsset.add(obj.Asset__c);
                    setAllSelectedAssetId.remove(obj.Asset__c);
                }
            }
        }
        
        //Record where junction object is zero but Asset is exist 
        for(Asset a :[select Id,CCC_SerialModelNumber__c,Ship_Date__c from Asset where Id in:setAllSelectedAssetId]){
            CCC_junctionCaseAsset__c objJunction = new CCC_junctionCaseAsset__c();
            objJunction.Asset__c = a.Id;
            objJunction.Case__c = objCase.Id;
            lstNewJunction.add(objJunction) ;
            
        }
        
        for(Asset SelectedAsset: lstAllSelectedAsset){
            if(!setExistingSerialModel.contains(SelectedAsset.CCC_SerialModelNumber__c)){
                lstNewAsset.add(SelectedAsset);
            }
            if(SelectedAsset.SerialNumber == '' || SelectedAsset.CCC_Model_Number__c == '' ||SelectedAsset.SerialNumber ==null ||SelectedAsset.CCC_Model_Number__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Serial# and Model# both are mandatory.');
                ApexPages.addMessage(myMsg); 
                return null;
            }
        }
        insert lstNewAsset;
        for(Asset tempAss:lstNewAsset){
            CCC_junctionCaseAsset__c objJunction = new CCC_junctionCaseAsset__c();
            objJunction.Asset__c = tempAss.Id;
            objJunction.Case__c = objCase.Id;
            lstNewJunction.add(objJunction) ; 
        }
        
        insert lstNewJunction;
        return null;
    }
    
    /**
* @description :method to Create Asset for PHDB Serial# search
**/
    
    public PageReference CreateAsset(){
        
        asstList= new list<asset>();
        boolean isRecordSelect = false;
        set<String> setSerialModel = new set<String>();
        List<Asset> lstAllSelectedAsset = new List<Asset>();
        
        
        if(lstDisNum != null) {
            for (DiscreteModelNumbersWrapper wrapper :lstDisNum) {
                for(DiscreteModelNumbersWrapper a :  wrapper.suggestedResults){
                    
                    
                    if(a.selected==true){ //only selected Asset will insert 
                        dModelNo_SerialNo = (a.Serial=='') ? dModelNo_SerialNo : a.Serial;
                        
                        
                        dModelNo_ModelNo = (a.Model=='') ? dModelNo_ModelNo : a.Model;
                        dModelNo_DiscModelNo = a.discreetNo;
                        dModelNo_TossCode = a.toscode;
                        dModelNo_Brand = a.brand;
                        dModelNo_PlantName=a.mfgplant;
                        dModelNo_Brand = this.getbrandFromSerialNumber(dModelNo_SerialNo, dModelNo_ModelNo);
                        dModelNo_ProductHierarchy = a.productHierarchy;
                        dModelNo_ProductHierarchy = this.getprodHierarchyFromSerialNumber(dModelNo_SerialNo, dModelNo_ModelNo)==null?'':this.getprodHierarchyFromSerialNumber(dModelNo_SerialNo, dModelNo_ModelNo);
                        //System.debug('#Brand:'+a.brand);    
                        System.debug('#Brand New:'+this.getbrandFromSerialNumber(dModelNo_SerialNo, dModelNo_ModelNo));
                        isRecordSelect = true;
                        String str = dModelNo_SerialNo + dModelNo_ModelNo;
                        str= str.replaceAll( '\\s+', '');
                        setSerialModel.add(str);
                        String shippedDate = a.shippedDate;
                        Date ShippedDateConv = FormatDate(shippedDate);
                        
                        
                        lstAllSelectedAsset.add(new Asset(accountId=objCase.AccountId,
                                                          Name=dModelNo_SerialNo, 
                                                          //  Brand__c = objCase.CCC_Brand__c,
                                                          Brand__c = dModelNo_Brand,
                                                          Product_Hierarchy__c = dModelNo_ProductHierarchy,
                                                          SerialNumber = dModelNo_SerialNo,
                                                          CCC_Model_Number__c=dModelNo_ModelNo,
                                                          CCC_Disc_Model_Number__c= dModelNo_DiscModelNo,
                                                          Toss_Code__c=dModelNo_TossCode,
                                                          CCC_Validation_status__c =isValidate,
                                                          CCC_SerialModelNumber__c = str,
                                                          Ship_Date__c =ShippedDateConv,
                                                          Plant_Name__c=dModelNo_PlantName
                                                         ));
                    } 
                }
            }
            if(!isRecordSelect){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Asset');
                ApexPages.addMessage(myMsg); 
                return null;
            }
            
            //Create Junction object and Asset
            createJunctionObject(setSerialModel,lstAllSelectedAsset);
            
            
            lstAsset = getAllAssets();
            if(lstAsset!=null && lstAsset.size()==1){
                if(lstAsset.get(0)!=null && lstAsset.get(0).objAsset!=null && lstAsset.get(0).objAsset.Id!=null){
                    SelectedAsset(lstAsset.get(0).objAsset.Id);
                    
                    
                }            
            }
            detailHide=False;
            return null;
        }
        detailHide=False; 
        return null;
        
    }
    
    
    /**
* @description :method to Create Asset for Smart Search
**/
    public PageReference CreateAssetForSS(){
        
        CCC_EquipmentSearchController ds = new CCC_EquipmentSearchController();
        asstList= new list<asset>();
        boolean isRecordSelect=false;
        set<String> setSerialModel = new set<String>();
        List<Asset> lstAllSelectedAsset = new List<Asset>();
        
        if(lstRegEq!= null) {
            for (FindRegisteredWrapper a :lstRegEq) {				               
                if(a.selected==true){ //only selected Asset will insert 
                    isRecordSelect = true;
                    String str = a.Serial + a.Model;
                    str= str.replaceAll( '\\s+', '');
                    setSerialModel.add(str);
                    
                    
                    lstAllSelectedAsset.add(new Asset(accountId=objCase.AccountId,
                                                      Name=a.Serial,
                                                      // Brand__c = objCase.CCC_Brand__c,
                                                      
                                                      SerialNumber = a.Serial,
                                                      CCC_Model_Number__c=a.Model,
                                                      CCC_Validation_status__c =isValidate,
                                                      CCC_SerialModelNumber__c = str,
                                                      CCC_Installing_Dealer__c =a.dealerName));
                } 
                if(lstAllSelectedAsset.size()>0){
                    objCase.Current_Servicing_Dealer__c =lstAllSelectedAsset[0].CCC_Installing_Dealer__c;
                    update objCase;
                }
                if(objCase.AccountId!=null){
                    acc=[Select id,CCC_Current_Servicing_Dealer__c from Account where id=:objCase.AccountId];
                    // acc.Id = objCase.AccountId;
                    acc.CCC_Current_Servicing_Dealer__c = objCase.Current_Servicing_Dealer__c;
                    update acc;
                }
                
            }
            if(!isRecordSelect){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Asset');
                ApexPages.addMessage(myMsg); 
                return null;
            }
            
            //Create Junction objet and Asset
            createJunctionObject(setSerialModel,lstAllSelectedAsset);
            
            
            lstAsset = getAllAssets();
            detailHide=False;
            return null;
        }
        detailHide=False; 
        
        return null;
        
    }
    
    
    //wrapper Class for reponse
    public class DiscreteModelNumbersWrapper {
        public integer dataQualityIndicator{get;set;}
        public string discreetNo{get;set;}
        public String model {get;set;}
        public string serial{get;set;}
        public string toscode {get;set;}
        public String productHierarchy{get; set;}
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
        public string mfgplant {get;set;}
        
        
    }
    public Class AllAsset{
        public Asset objAsset{get;set;}
        public String strURL{get;set;}
        public String junctionAssetId{get;set;}
        public  Boolean primary{get;set;}
        public AllAsset(Asset objAsset, String strURL, String junctionAssetId,boolean primary){
            this.objAsset = objAsset;
            this.strURL = strURL;
            this.junctionAssetId = junctionAssetId;
            this.primary=primary;
        }
    }
    public class FindRegisteredWrapper {
        Public String consumer_Name { get; set;}
        Public String consumer_BusinessName { get; set;}
        Public String consumer_Address1 { get; set;}
        Public String consumer_Address2 { get; set;}
        Public String consumer_City { get; set;}
        Public String consumer_State { get; set;}
        Public String consumer_Country { get; set;}
        Public String consumer_Zip { get; set;}
        Public String consumer_Phone1 { get; set;}
        Public String consumer_Phone2 { get; set;}
        Public String equip_Address1 { get; set;}
        Public String equip_Address2 { get; set;}
        Public String equip_City { get; set;}
        Public String equip_State { get; set;}
        Public String equip_Country { get; set;}
        Public String equip_Zip { get; set;}
        Public String dealerName { get; set;}
        Public String dealerPhone { get; set;}
        Public String mfgAcctNum { get; set;}
        Public String serviceBenchID { get; set;}
        Public String hvacpId { get; set;}
        Public String model { get; set;}
        Public String serial { get; set;}
        Public String equip_Description { get; set;}
        Public String confirmationNumber { get; set;}
        Public String registrationNumber { get; set;}
        Public String source { get; set;}
        Public String comments { get; set;}
        Public String installationDate{ get; set;}
        Public String registrationDate{ get; set;}
        Public String transferDate{ get; set;}
        Public String markAs{ get; set;}
        Public String registrationDataInput{ get; set;} 
        Public String  Id { get; set;}
        Public String  modelLocation { get; set;}
        Public String  furnaceOrientation { get; set;}
        Public String  furnaceFuel { get; set;}
        Public String  enhancedWarrantyFlag { get; set;}
        Public String  alwaysReviewFlag { get; set;}
        Public String  registeredOnTimeFlag { get; set;}
        Public String  proofOfPurchaseFlag { get; set;}
        Public String  agreementNumber { get; set;}
        Public String  tagNumber { get; set;}
        public boolean selected {get;set;}
        Public List<FindRegisteredWrapper> registrationDataResults { get; set;}        
    }
    public void UpdateTosCodeOnExistingAssets(List<Asset> toUpdateTosCodeAssets){
        //List<Asset> toUpdateAst = new List<Asset>();
        System.debug('##toUpdateTosCodeAssets:'+toUpdateTosCodeAssets);
        for(Asset ast : toUpdateTosCodeAssets){
            String tosCode = getTosCodeFromSerialNumber(ast.SerialNumber);
            //String brand  =  getbrandFromSerialNumber(ast.SerialNumber);
            ast.Toss_Code__c = tosCode;
            //  ast.Brand__c = brand;
            updateAssetTosCode.add(ast);
            //  updateAssetbrand.add(ast);
        }
        
        
    }
    
    public String getTosCodeFromSerialNumber(String serialNnumber){
        String toReturn = '';
        if(serialNnumber!=null && serialNnumber.length()>0){
            Access_Token__c tokenValue=Access_Token__c.getValues('PHDB Smart Search');
            String token=tokenValue.PHDB_Access_Token__c;  
            lstDisNum=new List<DiscreteModelNumbersWrapper>(); 
            CCC_IntegrationEndPoint__c  CustomSettingEndPointPHDB = CCC_IntegrationEndPoint__c.getValues('PHDB');
            
            Http http = new Http();
            HttpRequest req1 = new HttpRequest();                
            String baseURL = CustomSettingEndPointPHDB.URL__c; 
            
            String endpoint = baseURL + 'serial/' + serialNnumber;
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
                    if(a.toscode!=null && a.toscode.length()>0){
                        return a.toscode;
                    }
                }
            }catch(System.CalloutException e){
                errlog.ErrorLogCalloutException(e,'PHDB WebService','CCC_EquipmentDetailController');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - No Record Found'));
            }
            Catch(Exception e){
                //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
                errlog.ErrorLogException(e,'PHDB WebService','CCC_EquipmentDetailController');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - An unexpected error has occurred ,Please contact your Administrator. '));
            }
        }
        return toReturn;
    }
    
            /*public void UpdatebrandOnExistingAssets(List<Asset> toUpdatebrandAssets){
        //List<Asset> toUpdateAst = new List<Asset>();
        System.debug('##toUpdateTosCodeAssets:'+toUpdatebrandAssets);
        for(Asset ast : toUpdatebrandAssets){
        
        String brand  =  getbrandFromSerialNumber(ast.SerialNumber);
        
        ast.Brand__c = brand;
        
        updateAssetbrand.add(ast);
        }
        
        }*/
    
    public String getbrandFromSerialNumber(String serialNnumber, String modelNumber){
        String toReturn = '';
        try{
            if(serialNnumber!=null && serialNnumber.length()>0){
                Access_Token__c tokenValue=Access_Token__c.getValues('PHDB Smart Search');
                String token=tokenValue.PHDB_Access_Token__c;  
                lstRegEq = new List<FindRegisteredWrapper>();
                String response = new CCC_IntegrationHelper().getPHDBInformation(null,null,null,null,null,null,null,null,null,null, null,null,null,null,serialNnumber,modelNumber);
                JSONParser parser = JSON.createParser(response);
                RegistrationDataList regResult = (RegistrationDataList)parser.readValueAs(RegistrationDataList.class);
                for(RegistrationDataObj reg: regResult.registrationDataResults){
                    return reg.brand;
                }
            }
        }catch(Exception e){
            System.debug('#Cannot get brand value for serial['+serialNnumber+']');
        }
        return toReturn;
    }
    public String getprodHierarchyFromSerialNumber(String serialNnumber, String modelNumber){
        String toReturn = '';
        try{
            if(serialNnumber!=null && serialNnumber.length()>0){
                Access_Token__c tokenValue=Access_Token__c.getValues('PHDB Smart Search');
                String token=tokenValue.PHDB_Access_Token__c;  
                lstRegEq = new List<FindRegisteredWrapper>();
                String response = new CCC_IntegrationHelper().getPHDBInformation(null,null,null,null,null,null,null,null,null,null, null,null,null,null,serialNnumber,modelNumber);
                JSONParser parser = JSON.createParser(response);
                RegistrationDataList regResult = (RegistrationDataList)parser.readValueAs(RegistrationDataList.class);
                for(RegistrationDataObj reg: regResult.registrationDataResults){
                    return reg.productHierarchy;
                }
            }
        }catch(Exception e){
            System.debug('#Cannot get prod hierarchy value for serial['+serialNnumber+']');
        }
        return toReturn;
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
        public String brand{get; set;}
        public String productHierarchy{get; set;}
    }
    
    public PageReference getSelected()
    {
        
        Case cse = [Select Id, CCC_Product_Group_Code__c from Case where Id=:objCase.Id];
        selectedPrimaryAssetId = ApexPages.currentPage().getParameters().get('primaryAssetId');
        //List<Asset> updateAssetsWithPrimary = new List<Asset>();
        List<CCC_junctionCaseAsset__c> updateJuncAssetWithPrimary = new List<CCC_junctionCaseAsset__c>();
        System.debug('Entered Primary Asset Id selection block:'+selectedPrimaryAssetId);
        if(lstAsset!=null && lstAsset.size()>0){
            for(AllAsset eachAst : lstAsset){
                
                CCC_junctionCaseAsset__c juncAst = junctionIdKeyObjMap.get(eachAst.junctionAssetId);
                
                if(selectedPrimaryAssetId.equals(eachAst.objAsset.Id)){
                    //eachAst.objAsset.Primary__c=true;
                    //updateAssetsWithPrimary.add(eachAst.objAsset);
                    
                    juncAst.Primary__c = true;
                    
                    updateJuncAssetWithPrimary.add(juncAst);
                    cse.TOS_Code__c = eachAst.objAsset.TOSS_Code__c;
                    cse.CCC_Serial_Number__c = eachAst.objAsset.SerialNumber;
                    cse.CCC_Model_Number__c = eachAst.objAsset.CCC_Model_Number__c;
                    cse.Ship_Date__c = eachAst.objAsset.Ship_Date__c;
                    cse.Plant_Name__c=eachAst.objAsset.Plant_Name__c;
                    
                    System.debug('#assetDate:'+eachAst.objAsset.Ship_Date__c);
                }else{
                    //eachAst.objAsset.Primary__c=false;
                    //updateAssetsWithPrimary.add(eachAst.objAsset);
                    juncAst.Primary__c = false;
                    updateJuncAssetWithPrimary.add(juncAst);
                }
            }
        }
        //update updateAssetsWithPrimary;
        update updateJuncAssetWithPrimary;
        update cse;
        //update lstAsset;
        for(AllAsset eachAsst : lstAsset){
            if(eachAsst.objAsset.Id!=selectedPrimaryAssetId){
                eachAsst.primary = false;
            }else{
                System.debug('#Primary is present!');
            }
        }
        System.debug('#lstAsset:'+lstAsset);
        return null;
    }
    public Date getShippedDate(){
        DAte dateToReturn = null;
        System.debug('#responseGlobalCapture:'+responseGlobalCapture);
        if(responseGlobalCapture!=null && responseGlobalCapture.length()>0){
            JSONParser parser1 = JSON.createParser(responseGlobalCapture);
            try{
                DiscreteModelNumbersWrapper ob1=(DiscreteModelNumbersWrapper)JSON.deserialize(responseGlobalCapture,DiscreteModelNumbersWrapper.class);
                system.debug('--------ob1------' + ob1);
                System.debug('#ob1.suggestedResults:'+ob1.suggestedResults);
                if(ob1!=null && ob1.suggestedResults!=null && ob1.suggestedResults.size()>0){
                    DiscreteModelNumbersWrapper a = ob1.suggestedResults.get(0);
                    if(a.shippedDate!=null && a.shippedDate.length()>0){
                        dateToReturn = FormatDate(a.shippedDate);
                    }
                }
            }catch(System.CalloutException e){
                errlog.ErrorLogCalloutException(e,'PHDB WebService','CCC_EquipmentDetailController');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - No Record Found'));
            }
            Catch(Exception e){
                //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
                errlog.ErrorLogException(e,'PHDB WebService','CCC_EquipmentDetailController');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - An unexpected error has occurred ,Please contact your Administrator. '));
            }
        }    
        return dateToReturn;
    }
    public static date  FormatDate(string dateString){
        /*if(dateString.length() >= 10){
        string year = dateString.substring(6,10);
        string day = dateString.substring(3,5);
        string month = dateString.substring(0,2);
        string fullDate = year+'-'+month+'-'+day;
        date FormatedDate = date.ValueOf(fullDate);         
        return FormatedDate;
        }  */
        Date toReturnDate = null;
        if(dateString!=null && dateString.length()>0 && dateString.contains('-')){
            String[] dateTimeSplit = dateString.split('-');
            
            if(dateTimeSplit!=null && dateTimeSplit.size()>0 && dateTimeSplit.size()>2){
                String year = dateTimeSplit.get(0);
                String month = dateTimeSplit.get(1);
                String tempDay = dateTimeSplit.get(2);
                String day = tempDay.substring(0,2);
                toReturnDate = Date.parse(''+month+'/'+day+'/'+year);
                System.debug('#Date:'+toReturnDate);
                
                
            }
        }
        return toReturnDate;
    }
    public void selectedAsset(String selectedPrimaryAssetId){
        Case cse = [Select Id, CCC_Product_Group_Code__c from Case where Id=:objCase.Id];
        List<CCC_junctionCaseAsset__c> updateJuncAssetWithPrimary = new List<CCC_junctionCaseAsset__c>();
        System.debug('Entered Primary Asset Id selection block:'+selectedPrimaryAssetId);
        System.debug('lstAsset:'+lstAsset);
        if(lstAsset!=null && lstAsset.size()>0){
            for(AllAsset eachAst : lstAsset){
                CCC_junctionCaseAsset__c juncAst = junctionIdKeyObjMap.get(eachAst.junctionAssetId);
                if(selectedPrimaryAssetId.equals(eachAst.objAsset.Id)){
                    //eachAst.objAsset.Primary__c=true;
                    //updateAssetsWithPrimary.add(eachAst.objAsset);
                    
                    juncAst.Primary__c = true;
                    updateJuncAssetWithPrimary.add(juncAst);
                    cse.TOS_Code__c = eachAst.objAsset.TOSS_Code__c;
                    cse.CCC_Serial_Number__c = eachAst.objAsset.SerialNumber;
                    cse.CCC_Model_Number__c = eachAst.objAsset.CCC_Model_Number__c;
                    cse.Ship_Date__c = eachAst.objAsset.Ship_Date__c;
                    cse.Plant_Name__c=eachAst.objAsset.Plant_Name__c;
                    System.debug('#assetDate:'+eachAst.objAsset.Ship_Date__c);
                }else{
                    //eachAst.objAsset.Primary__c=false;
                    //updateAssetsWithPrimary.add(eachAst.objAsset);
                    juncAst.Primary__c = false;
                    updateJuncAssetWithPrimary.add(juncAst);
                }
            }
        }
        //update updateAssetsWithPrimary;
        update updateJuncAssetWithPrimary;
        update cse;
        System.debug('#Update Successful!');
    }
}