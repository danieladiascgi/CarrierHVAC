Public Class AddSerialNumberPageController {
    public String responseStr{get;set;}
    public Boolean CaseHide {get; set;}
    public Boolean detailHide {get;set;}
    public boolean IsAssetShow{get;set;}
    public list <Asset> asstList {get ; set;}
    public list <AllAsset> lstAsset {get ; set;}
    Public List<DiscreteModelNumbersWrapper> lstDisNum {get;set;}
    Public List<DiscreteModelNumbersWrapper> lstDisNum2 {get;set;}
    Public List<FindRegisteredWrapper>lstRegEq { get; set;}
    Public string delId {get;set;}
    // Discrete Model Number service variable
    public String dModelNo_ModelNo {get;set;}
    public String dModelNo_SerialNo {get;set;}
    public String dModelNo_Brand {get;set;}
    public String dModelNo_TossCode {get; set;}
    public String dModelNo_DiscModelNo {get; set;}
    public String dModelNo_PhNo {get;set;}
    public String dModelNo_InstAddres {get;set;}
    public String dModelNo_RegisNo {get;set;}
    public String dModelNo_LstName {get;set;}
    public String dModelNo_Zipcde {get;set;}
    public String dModelNo_ConfNo {get;set;}
    public string selectedValue { get;set; }
    public List<SelectOption> brandOptions { get;set; }
    //public Case objCase{get;set;}
    public Account acc{get;set;}
    public boolean isInternalUser{get;set;}
    public boolean BrandOnCasepresent{get;set;}
    CCC_ErrorLog errlog= new CCC_ErrorLog();
    //public List<Case> partNumberList {get;set;}
    public List<PartNumbersWrapper> partNumberAddList {get;set;} 
    public Case newCase{get;set;}
    public String contactFirstName{get; set;}
    public String contactLastName{get; set;}
    public String contactEmail{get; set;}
    public String phoneNumber{get; set;}
    public String hvacId{get; set;}
    public String shipTo{get; set;}
    public String payload{get; set;}
    public String distributorName{get; set;}
    public String partNumber{get;set;}
    public String Comments{get;set;}
    
    public Contact createContactIfNotPresent{get; set;}
    public Account createAccountIfNotPresent{get; set;}
    public String enteredName{get;set;}
    List<List<SObject>> findContact=new List<List<SObject>>();
    //List<List<SObject>> findAccount=new List<List<SObject>>();
    //List<Account> findAccount = new List<Account>();
    public Integer i=0;
    public String keepDescription;
    public Boolean verified { get; private set;}
    public List<Asset> updateAssetTosCode{get; set;}
    public transient string fileName 
    {    get;set;    }
    
    public Blob fileBody 
    {    get;set;    }
    Public transient List<Attachment> myAttachments{get;set;}
    
    // the parent object it
    public transient Id sobjId {get; set;}
    
    // list of existing attachments - populated on demand
    public transient List<Attachment> attachments;
    
    // list of new attachments to add
    public List<Attachment> newAttachments {get; set;}
    
    // the number of new attachments to add to the list when the user clicks 'Add More'
    public static final Integer NUM_ATTACHMENTS_TO_ADD=3;
    
    public boolean isValidate = true;
    
    public List<SelectOption> getDefectCodeOptions() {
        
        List<SelectOption> DefectCodeOptions = new List<SelectOption>();
        
        DefectCodeOptions.add(new SelectOption('','-None-'));  
        DefectCodeOptions.add(new SelectOption('41-ADJUSTED MECH','41-ADJUSTED MECH'));
        DefectCodeOptions.add(new SelectOption('43-CLEANED MECH','43-CLEANED MECH'));
        DefectCodeOptions.add(new SelectOption('45-AIR LEAK/CRACKED MECH','45-AIR LEAK/CRACKED MECH'));
        DefectCodeOptions.add(new SelectOption('47-GAS LEAK MECH','47-GAS LEAK MECH'));
        DefectCodeOptions.add(new SelectOption('49-OIL LEAK MECH','43-OIL LEAK MECH'));
        DefectCodeOptions.add(new SelectOption('50-WATER LEAK MECH','50-WATER LEAK MECH'));
        DefectCodeOptions.add(new SelectOption('51-CLEANED MECH','51-CLEANED MECH'));
        DefectCodeOptions.add(new SelectOption('53-STUCK/LOCKED ROTOR MECH','53-STUCK/LOCKED ROTOR MECH'));
        DefectCodeOptions.add(new SelectOption('54-RUNS WONT PUMP MECH','54-RUNS WONT PUMP MECH'));
        DefectCodeOptions.add(new SelectOption('55-VIBRATION NOISE MECH','55-VIBRATION NOISE MECH'));
        DefectCodeOptions.add(new SelectOption('57-IMPROPER FLAME MECH','57-IMPROPER FLAME MECH'));
        DefectCodeOptions.add(new SelectOption('60-MISC','60-MISC'));
        DefectCodeOptions.add(new SelectOption('61-CRACKED MECH','61-CRACKED MECH'));
        DefectCodeOptions.add(new SelectOption('65-CORROSION MECH','65-CORROSION MECH'));
        DefectCodeOptions.add(new SelectOption('66-RINGS POPPING MECH','66-RINGS POPPING MECH'));
        DefectCodeOptions.add(new SelectOption('69-HEAT EXCHANGER(NOHASSLE)','69-HEAT EXCHANGER(NOHASSLE)'));
        DefectCodeOptions.add(new SelectOption('70-COIL(NOHASSLE)','70-COIL(NOHASSLE)'));
        DefectCodeOptions.add(new SelectOption('71-COMPRESSOR ELEC(NOHASSLE)','71-COMPRESSOR ELEC(NOHASSLE)'));
        DefectCodeOptions.add(new SelectOption('72-COMPRESSOR MECH(NOHASSLE)','72-COMPRESSOR MECH(NOHASSLE)'));
        
        
        return DefectCodeOptions;
    }
    
    
    
    
    
    /**
* @description :constructor call
**/
    public AddSerialNumberPageController(ApexPages.StandardController stdController){
        updateAssetTosCode = new List<Asset>();
        System.debug('#Inside Constructor');
        isInternalUser = false;
        User user1 = [select Id,Profile.UserLicense.Name from User where Id = :userinfo.getUserId() limit 1];
        if(user1.Profile.UserLicense.Name =='Partner Community'){
            isInternalUser = true;
        } 
        //@for displaying part number dynamically   
        /*String sql = 'SELECT CCC_Part_Number__c FROM Case limit 100';
partNumberList = Database.Query(sql);*/
        partNumberAddList = new List<PartNumbersWrapper>();
        partNumberAddList.add(new PartNumbersWrapper());
        //lstDisNum=new List<DiscreteModelNumbersWrapper>(); 
        newCase=new case();
        
        if(contactFirstName==null)
        {
            
            contactFirstName = ApexPages.currentPage().getParameters().get('fname');
            contactLastName = ApexPages.currentPage().getParameters().get('lname');
            contactEmail = ApexPages.currentPage().getParameters().get('email');      
            hvacId =  ApexPages.currentPage().getParameters().get('hvacid');  
			//payload = ApexPages.currentPage().getParameters().get('PL');
			payload = ApexPages.currentPage().getParameters().get('value');
            if(payload!=null && payload.length()>0){
            	parsePayloadAndGetValues(payload);    
            }
            
        }
        
        responseStr = 'Request is yet to be raised';
        CaseHide=True;
        detailHide=false;
        IsAssetShow = false;
        isValidate = true;
        // Discrete Model Number REST API initialization
        dModelNo_ModelNo = '';
        dModelNo_SerialNo = '';
        //ishita added on 10 mar
        lstAsset = getAllAssets();
        /*if(objCase.CCC_Brand__c!=null){
dModelNo_Brand= objCase.CCC_Brand__c;
}*/
        newAttachments=new List<Attachment>{new Attachment()};
            System.debug('#Const newAttachments:'+newAttachments);
        //List<Account> acctLst = [Select Id, Name from Account where CCC_HVACPID__c =:hvacId limit 1]; 
        List<Account> acctLst = [Select Id, Name from Account where Sap_Ship_To__c =:shipTo limit 1]; 
        Account acct = (acctLst!=null && acctLst.size()>0)? acctLst.get(0) : null;
        if(acct!=null && acct.Name!=null && acct.Name!=''){
            distributorName = acct.Name;
        }
    }
    public PageReference AddRow()
    {
        System.debug('#Before partNumberAddList:'+partNumberAddList);
        partNumberAddList.add(new PartNumbersWrapper());
        System.debug('#partNumberAddList:'+partNumberAddList);
        return null;
    }  
    
    
    public AddSerialNumberPageController (){
        
    }
    
    
    
    
    public list<AllAsset> getAllAssets(){
        list<AllAsset> lstAssetTemp = new list<AllAsset>();
        set<Id> AssetIds = new set<Id>();
        //insert junction asset in list
        
        
        //maps to Asset object and redirects to CCC_EquipmentDetail page with parameters Serial Number, Model Number, Brand and Discrete Model Number
        for(Asset objAsset:[Select Id,Brand__c,CCC_Disc_Model_Number__c,CCC_Model_Number__c,SerialNumber,CCC_Validation_status__c,Toss_Code__c,CCC_Installing_Dealer__c  from Asset where Id = :AssetIds]){
            
            String strUrl = '/apex/CCC_EquipmentDetail?sn='+objAsset.SerialNumber+'&mn='+objAsset.CCC_Model_Number__c+'&br='+objAsset.Brand__c+'decmn='+objAsset.CCC_Disc_Model_Number__c;
            lstAssetTemp.add(new AllAsset(objAsset,strUrl));
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
            //getDiscreteModelNumbers(dModelNo_ModelNo,dModelNo_SerialNo,dModelNo_DiscModelNo,dModelNo_Brand);
            getDiscreteModelNumbers(dModelNo_SerialNo);
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
    /*public void delRecord (){
String rId = Apexpages.currentpage().getparameters().get('delrId');
list<CCC_junctionCaseAsset__c>  lstdel = [select Id from CCC_junctionCaseAsset__c where Asset__c = :rId and Case__c=:ObjCase.Id] ;
lstAsset = new list<AllAsset>();
delete lstdel;
lstAsset = getAllAssets();
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Deleted successfully');//and Model Number
ApexPages.addMessage(myMsg); 

}*/
    
    /**
* @parameters: Serial Number,Model Number, Disc Model No,Brand 
* @description :It will get all credentials from Custom setting object CCC_IntegrationEndPoint__c, from the body received
* by http response it will parse the token number. The Received json response is parsed and result is stored in wrapper class  DiscreteModelNumbersWrapper  
**/
    // @TestVisible private void getDiscreteModelNumbers(String modelNumner, String serialNumber,String DiscModelNo, String Brand ) { 
    @TestVisible public void getDiscreteModelNumbers(String serialNumber) {   
        //Access_Token__c tokenValue=Access_Token__c.getValues('PHDB Smart Search');
        //String token=tokenValue.PHDB_Access_Token__c;  
        System.debug('#TokenValue:'+Access_Token__c.getValues('PHDB Smart Search'));
        Access_Token__c tokenValue=Access_Token__c.getValues('PHDB Smart Search');
        String token=tokenValue.PHDB_Access_Token__c;  
        system.debug('--------token----------' +token); 
        if(lstDisNum==null){
            lstDisNum=new List<DiscreteModelNumbersWrapper>(); 
            lstDisNum2=new List<DiscreteModelNumbersWrapper>(); 
        }
        
        
        
        
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
        System.debug('#Resp:'+res1.getBody());
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
                    system.debug('***************1'+parser1.getText());
                    ob1.discreetNo= parser1.getText();
                    break;
                }
                
                
            }
            lstDisNum.add(ob1);
            lstDisNum2.addAll(ob1.suggestedResults);
            System.debug('#lstDisNum2:'+lstDisNum2);
            for(DiscreteModelNumbersWrapper updateValStatusEachRec : lstDisNum2){
                updateValStatusEachRec.validationStatus = true;
            }
            System.debug('#lstDisNum123:'+lstDisNum);
            if(ob1.suggestedResults.size()==0){
                if(dModelNo_SerialNo != '' && dModelNo_SerialNo != null){
                    DiscreteModelNumbersWrapper wrp2 = new DiscreteModelNumbersWrapper();
                    //wrp2.Model = dModelNo_ModelNo;
                    wrp2.Serial = dModelNo_SerialNo;
                    wrp2.model = serialNumber;
                    wrp2.discreetNo = serialNumber;
                    wrp2.selected = true;
                    wrp2.serial = serialNumber;
                    wrp2.validationStatus = false;
                    lstDisNum2.add(wrp2);
                    ob1.suggestedResults.add(wrp2);
                    System.debug('After add:'+ob1.suggestedResults);
                    isValidate = false;
                    // lstDisNum2.addAll(lstDisNum);
                    //CreateAsset();
                    detailHide=false;
                }else{
                    apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'PHDB-No Record Found.');
                    apexpages.addmessage(msg);
                }
            }
            System.debug('#lstDisNum123.suggestedResults[0]:'+lstDisNum[0]);
            System.debug('#lstDisNum123.suggestedResults:'+lstDisNum[0].suggestedResults);
            isValidate = true;
            if(lstDisNum[0].suggestedResults.size() == 0){
                /*if(dModelNo_SerialNo != '' && dModelNo_SerialNo != null){
                    DiscreteModelNumbersWrapper wrp2 = new DiscreteModelNumbersWrapper();
                    //wrp2.Model = dModelNo_ModelNo;
                    wrp2.Serial = dModelNo_SerialNo;
                    wrp2.discreetNo = dModelNo_DiscModelNo;
                    wrp2.selected = true;
                    wrp2.serial = serialNumber;
                    wrp2.validationStatus = false;
                    lstDisNum2.add(wrp2);
                    ob1.suggestedResults.add(wrp2);
                    System.debug('After add:'+ob1.suggestedResults);
                    isValidate = false;
                    // lstDisNum2.addAll(lstDisNum);
                    CreateAsset();
                    detailHide=false;
                }else{
                    apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'PHDB-No Record Found.');
                    apexpages.addmessage(msg);
                }*/
            }
            else{
                if(lstDisNum[0].suggestedResults.size() == 1){
                    lstDisNum[0].suggestedResults[0].selected = true;
                    CreateAsset();
                    detailHide=false;
                }else{
                    detailHide=true;
                }
            }
            System.debug('#lstDisNum:'+lstDisNum);
            
            
            
        }
        catch(System.CalloutException e){
            errlog.ErrorLogCalloutException(e,'PHDB WebService','AddSerialNumberPageController');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - No Record Found'));
        }
        Catch(Exception e){
            //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
            errlog.ErrorLogException(e,'PHDB WebService','AddSerialNumberPageController');
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
            errlog.ErrorLogException(e,'Serial Search','AddSerialNumberPageController ');
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
        System.debug('#createJunctionObject setSerialModel:'+setSerialModel);
        System.debug('#createJunctionObject lstAllSelectedAsset:'+lstAllSelectedAsset);
        list<CCC_junctionCaseAsset__c>  lstNewJunction = new list<CCC_junctionCaseAsset__c>();
        set<String> setExistingSerialModel = new set<String>();
        list<Asset> lstNewAsset = new list<Asset>();
        set<Id> setAllSelectedAssetId = new set<Id>();
        list<Asset> lstExistingAsset = [select Id,CCC_SerialModelNumber__c from Asset where CCC_SerialModelNumber__c in: setSerialModel];
        for(Asset objAss:lstExistingAsset){
            setExistingSerialModel.add(objAss.CCC_SerialModelNumber__c);
            setAllSelectedAssetId.add(objAss.Id);
        }
        System.debug('#lstExistingAsset:'+lstExistingAsset);
        System.debug('#setExistingSerialModel:'+setExistingSerialModel);
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
        System.debug('#lstNewAsset:'+lstNewAsset);
        insert lstNewAsset;
        
        //Record where junction object is zero but Asset is exist 
        for(Asset a :[select Id,CCC_SerialModelNumber__c from Asset where Id in:setAllSelectedAssetId]){
            CCC_junctionCaseAsset__c objJunction = new CCC_junctionCaseAsset__c();
            objJunction.Asset__c = a.Id;
            objJunction.Case__c = newCase.Id;
            lstNewJunction.add(objJunction) ;
            
        }
        for(Asset tempAss:lstNewAsset){
            CCC_junctionCaseAsset__c objJunction = new CCC_junctionCaseAsset__c();
            objJunction.Asset__c = tempAss.Id;
            objJunction.Case__c = newCase.Id;
            lstNewJunction.add(objJunction) ; 
        }
        System.debug('#lstNewJunction:'+lstNewJunction);
        insert lstNewJunction;
        return null;
    }
    //}
    
    //Record where junction object is zero but Asset is exist 
    /*for(Asset a :[select Id,CCC_SerialModelNumber__c from Asset where Id in:setAllSelectedAssetId]){
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

insert lstNewJunction;*/
    //return null;
    //}
    
    /**
* @description :method to Create Asset for PHDB Serial# search
**/
    
    public PageReference CreateAsset(){
        System.debug('#Inside Method CreateAsset');
        asstList= new list<asset>();
        boolean isRecordSelect = false;
        set<String> setSerialModel = new set<String>();
        List<Asset> lstAllSelectedAsset = new List<Asset>();
        
        
        if(lstDisNum2 != null) {
            
            for (DiscreteModelNumbersWrapper a :lstDisNum2) {
                //for(DiscreteModelNumbersWrapper a :  wrapper.suggestedResults){
                
                System.debug('#AAAAA:'+a);
                if(a.selected==true){ //only selected Asset will insert 
                    dModelNo_SerialNo = (a.Serial=='') ? dModelNo_SerialNo : a.Serial;
                    
                    
                    dModelNo_ModelNo = (a.Model=='') ? dModelNo_ModelNo : a.Model;
                    dModelNo_DiscModelNo = a.discreetNo;
                    dModelNo_TossCode = a.toscode;
                    isRecordSelect = true;
                    String str = dModelNo_SerialNo + dModelNo_ModelNo;
                    str= str.replaceAll( '\\s+', '');
                    setSerialModel.add(str);
                    
                    System.debug('#AAAA:'+a);
                    /*  lstAllSelectedAsset.add(new Asset(accountId=objCase.AccountId,*/
                    lstAllSelectedAsset.add(new Asset( AccountId=newCase.AccountId,
                                                      Name=dModelNo_SerialNo, 
                                                      //Brand__c = objCase.CCC_Brand__c,
                                                      SerialNumber = dModelNo_SerialNo,
                                                      CCC_Model_Number__c=dModelNo_ModelNo,
                                                      CCC_Disc_Model_Number__c= dModelNo_DiscModelNo,
                                                      Toss_Code__c=dModelNo_TossCode,
                                                      CCC_Validation_status__c =a.validationStatus,
                                                      CCC_SerialModelNumber__c = str
                                                     ));
                    
                } 
                //}
            }
            if(!isRecordSelect){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Asset');
                ApexPages.addMessage(myMsg); 
                return null;
            }
            System.debug('#setSerialModel:'+setSerialModel);
            System.debug('#lstAllSelectedAsset:'+lstAllSelectedAsset);
            //Create Junction objet and Asset
            createJunctionObject(setSerialModel,lstAllSelectedAsset);
            
            
            
            // lstAsset = getAllAssets();
            detailHide=False;
            return null;   
        }
        detailHide=False; 
        return null;
        
    }
    /*public void UpdateTosCodeOnExistingAssets(List<Asset> toUpdateTosCodeAssets){
        //List<Asset> toUpdateAst = new List<Asset>();
        System.debug('##toUpdateTosCodeAssets:'+toUpdateTosCodeAssets);
        for(Asset ast : toUpdateTosCodeAssets){
            String tosCode = getTosCodeFromSerialNumber(ast.SerialNumber);
            ast.Toss_Code__c = tosCode;
            updateAssetTosCode.add(ast);
        }
        
        
    }*/
    
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
    
    
    
    
    
    
    public PageReference createCase()
    {
        System.debug('#contactFirstName:'+contactFirstName);
        System.debug('#contactLastName:'+contactLastName);
        System.debug('Email'+contactEmail);
        System.debug('#Inside Cont partNumberAddList:'+partNumberAddList);
        /* Added for re-Captcha Start*/
        
        if((contactFirstName!=null && contactFirstName!='') || (contactLastName!=null && contactLastName!='')){
            enteredName = contactFirstName + ' '+ contactLastName;
        }
        
        if(contactFirstName==null || contactFirstName==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Contact First Name'));
            this.verified = false;
            return null;
        }
        if(contactLastName==null || contactLastName==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Contact Last Name'));
            this.verified = false;
            return null;
        }
        
        if (newCase.Subject == null || newCase.Subject =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Subject'));
            this.verified = false;
            return null;
        }
        
        if (contactEmail == null || contactEmail =='')
        {
            system.debug('Email'+contactEmail);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Contact Email'));
            this.verified = false;
            return null;
        }
        
        if (hvacId == null || hvacId =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the hvacId'));
            this.verified = false;
            return null;
        }
        
        
        if ( newCase.Description == null ||  newCase.Description =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Description'));
            this.verified = false;
            return null;
        }
        /*if ( dModelNo_SerialNo == null ||  dModelNo_SerialNo =='')
{
/ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Serial Number'));
this.verified = false;
return null;
}
if ( lstDisNum2 == null ||  lstDisNum2.size()==0)
{
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Serial'));
this.verified = false;
return null;
}*/
        System.debug('#Cerate Case inside lstDisNum2:'+lstDisNum2);
        if(lstDisNum2!=null && lstDisNum2.size()>0){
            boolean atleastOneSerialSelected = false;
            for(DiscreteModelNumbersWrapper eachRec : lstDisNum2){
                if(eachRec.selected){
                    atleastOneSerialSelected = true;
                    break;
                }
            }
            if(!atleastOneSerialSelected){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Serial'));
                this.verified = false;
                return null;
            }
        }
        if ( partNumberAddList== null || partNumberAddList.size()==0)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Part Number'));
            this.verified = false;
            return null;
        }
        
        
        else
        { 
            
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Post Sale Support').getRecordTypeId();
            newcase.RecordTypeId=recordTypeId;
            
            newCase.Status='Open';
            newCase.Origin='Web';
            keepDescription=newCase.Description;
            
            
            if(newCase.Subject != null && newCase.Subject !='')
            {
                newCase.Subject=newCase.Subject+'- '+ '"Web Case"';
            }
            try{
                
                System.debug('#Contact Email:'+contactEmail);
                findContact= [FIND :contactEmail IN Email Fields RETURNING Contact(Id)];
                system.debug('---------------> SOQL Value'+findContact);
                
                Contact [] contactList = ((List<Contact>)findContact[0]);
                contactList=[Select Id, Email, AccountId from Contact where Id in:contactList];
                system.debug('-------------->querying and assigning the contacts to list'+contactList);
                
                if(contactList.size() == 1)
                {
                    newCase.ContactId=contactList[0].Id;
                    if(newCase.Description == null)
                    {
                        newCase.Description='';
                    }
                    
                    //newCase.Description=newCase.Description+' '+ 'Name:'+ contactFirstName+' '+contactLastName;
                }
                else if(contactList.size()>1)
                {
                    system.debug('---------------> inside the Else if condition where contactlist is more than 1 value');
                    for(Contact getEmail:contactList)
                    {
                        system.debug('------------->Enetered in to for loop which is inside the else if condition');
                        if(getEmail.Email==contactEmail && i<2)
                        {
                            
                            newCase.ContactId=getEmail.Id;
                            if(getEmail.AccountId!=null && getEmail.AccountId!=''){
                                newCase.AccountId = getEmail.AccountId;
                            }
                            i++;
                            system.debug('---------------> inside the Email Match if condition'+ i);
                            if(newCase.Description == null)
                            {
                                newCase.Description='';
                            }
                            
                            if(i==1)
                            {
                                newCase.Description=newCase.Description+' '+ 'Name:'+ contactFirstName+' '+contactLastName;
                            }
                            
                            
                            
                        }  
                    }
                }
                else
                {
                    system.debug('---------------->Entered into else condition');
                    if(newCase.Description == null)
                    {
                        newCase.Description='';
                    }
                    newCase.Description=newCase.Description+' '+ 'Name:'+ enteredName+' '+ 'Email:'+' '+contactEmail+' '+'No contacts were found with the provided Email Address so creating a contact';
                    createAccountIfNotPresent = new Account();
                    createAccountIfNotPresent.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
                    createAccountIfNotPresent.Name = newCase.Subject;
                    //insert createAccountIfNotPresent;
                    
                    createContactIfNotPresent = new Contact();
                    //createContactIfNotPresent.AccountId = createAccountIfNotPresent.Id;
                    Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Non-Residential Contact').getRecordTypeId();
                    createContactIfNotPresent.RecordTypeId = contactRecordTypeId;
                    createContactIfNotPresent.LastName = contactLastName;
                    createContactIfNotPresent.FirstName = contactFirstName;
                    createContactIfNotPresent.Phone = phoneNumber;
                    createContactIfNotPresent.Email = contactEmail;
                    insert createContactIfNotPresent;
                    System.debug('#Contact Inserted Successfully:'+createContactIfNotPresent);
                    newCase.ContactId = createContactIfNotPresent.Id;
                    
                }
                
                if(i==2)
                {
                    newCase.ContactId=null;
                    newCase.Description=keepDescription+' '+ 'Name:'+ enteredName+' '+ 'Email:'+' '+contactEmail+' '+'Multiple Contacts were found with the provided Email Address';
                    system.debug('---------------> Inside the i==2 if condition');
                }
                
            }
            
            Catch(Exception E)
            {
                system.debug(E.getMessage());
            }
            
            
            try{
                
                //  System.debug('#Contact Email:'+contactEmail);
                // findAccount= [select CCC_HVACPID__c from Account];
                // system.debug('---------------> SOQL Value'+findAccount);
                //findAccount= [FIND :hvacId IN ALL Fields RETURNING Account(Id)];
                
                // List<Account> accountList = new List<Account>();
                //Account [] accountList = ((List<Account>)findAccount[0]);
                //accountList=[Select Id,CCC_HVACPID__c from Account where Id in:accountList];
                List<Account> accountList = [Select Id from Account where CCC_HVACPID__c =:hvacId];
                system.debug('-------------->querying and assigning the contacts to list'+accountList);
                
                if(accountList.size() == 1)
                {
                    newCase.AccountId=accountList[0].Id;
                    /* if(newCase.Description == null)
{
newCase.Description='';
}*/
                    
                    //newCase.Description=newCase.Description+' '+ 'Name:'+ contactFirstName+' '+contactLastName;
                }
                else if(accountList.size()>1)
                {
                    system.debug('---------------> inside the Else if condition where accountlist is more than 1 value');
                    for(Account getHvac:accountList)
                    {
                        system.debug('------------->Enetered in to for loop which is inside the else if condition');
                        if(getHvac.CCC_HVACPID__c==hvacId && i<2)
                        {
                            
                            newCase.AccountId=getHvac.Id;
                            if(getHvac.Id!=null && getHvac.Id!=''){
                                newCase.AccountId = getHvac.Id;
                            }
                            i++;
                            system.debug('---------------> inside the Email Match if condition'+ i);
                            
                            
                            
                            
                        }  
                    }
                }
                else
                {
                    system.debug('---------------->Entered into else condition');
                    if(newCase.Description == null)
                    {
                        newCase.Description='';
                    }
                    newCase.Description=newCase.Description+' '+ 'Name:'+enteredName+' '+ 'HVACPID:'+' '+hvacId+' '+'No Accounts were found with the provided HVAC ID so creating a case without account';
                    createAccountIfNotPresent = new Account();
                    Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
                    createAccountIfNotPresent.RecordTypeId = AccountRecordTypeId;
                    // createAccountIfNotPresent.Name = hvacId;
                    createAccountIfNotPresent.Name = newCase.Subject;
                    createAccountIfNotPresent.CCC_HVACPID__c= hvacId;
                    insert createAccountIfNotPresent;
                    newCase.AccountId = createAccountIfNotPresent.Id;
                    
                    
                    createContactIfNotPresent = new Contact();
                    //createContactIfNotPresent.AccountId = createAccountIfNotPresent.Id;
                    Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Non-Residential Contact').getRecordTypeId();
                    createContactIfNotPresent.RecordTypeId = contactRecordTypeId;
                    createContactIfNotPresent.LastName = contactLastName;
                    createContactIfNotPresent.FirstName = contactFirstName;
                    createContactIfNotPresent.Phone = phoneNumber;
                    createContactIfNotPresent.Email = contactEmail;
                    insert createContactIfNotPresent;
                    System.debug('#Contact Inserted Successfully:'+createContactIfNotPresent);
                    newCase.ContactId = createContactIfNotPresent.Id;
                    
                }
                
                if(i==2)
                {
                    newCase.ContactId=null;
                    newCase.Description=keepDescription+' '+ 'Name:'+ enteredName+' '+ 'Email:'+' '+contactEmail+' '+'Multiple Contacts were found with the provided Email Address';
                    system.debug('---------------> Inside the i==2 if condition');
                }
                
            }
            
            Catch(Exception E)
            {
                system.debug(E.getMessage());
            }
            newCase.OwnerId = [select Id from Group where Name='ICP Post Sales Support Tier 2' and Type = 'Queue'].Id;
            
            System.debug('#partNumberAddList:'+partNumberAddList);
            String partNumbersAppended = '';
            try{
                for(PartNumbersWrapper eachPart : partNumberAddList){
                    if(eachPart.isFailedPart){
                        if(eachPart.partNumber!=null && eachPart.partNumber!=''){
                            newCase.CCC_Part_Number__c = eachPart.partNumber;
                            List<Product2> parts = [Select Id, Name from Product2 where Name=:eachPart.partNumber];
                            if(parts!=null && parts.size()>0){
                                if(parts.size()==1){
                                    newCase.CCC_Part__c = parts.get(0).Id;
                                }    
                                if(parts.size()>1){
                                    newCase.Description=keepDescription+' '+ 'Part Number:'+ eachPart.partNumber+' Multiple Parts were found with the provided Part Number';
                                }
                            }
                            
                            
                        }
                        //break;
                    }else{
                        if(eachPart.partNumber!=null && eachPart.partNumber!=''){
                            partNumbersAppended = partNumbersAppended+','+eachPart.partNumber;
                        }    
                    }
                }
                if(partNumbersAppended!=null && partNumbersAppended.length()>0){
                    newCase.Description=keepDescription+' '+ 'Part Numbers:'+partNumbersAppended;
                }
            }Catch(Exception E){
                system.debug('#Part Number:'+E.getMessage());
            }
            if(lstDisNum2!=null && lstDisNum2.size()>0){
                //DiscreteModelNumbersWrapper primary = lstDisNum2.get(0);
                DiscreteModelNumbersWrapper primary = null;
                for(DiscreteModelNumbersWrapper wrpr : lstDisNum2){
                    if(wrpr.selected){
                        primary = wrpr;
                        break;
                    }
                }
                newCase.CCC_Serial_Number__c = primary.serial;
                newCase.CCC_Model_Number__c = primary.Model;
            }    
            insert newCase;
            System.debug('#newCase Id:'+newCase.Id);
            sobjId = newCase.Id;
            System.debug('#Attachments:'+newAttachments);
            
            Save();
            CreateAsset();
            createComments();
            
            
            
            
            /* String descData = descriptionWithAllDetails();
newCase.Description = (newCase.Description==null? ''+ '\n' + descData:newCase.Description+ '\n' + descData) ;   
System.debug('#Before Insert');
String webServResp = getSerialSearch();
newCase.Description = webServResp;
System.debug('#After Search');   */ 
            
            
            /*   if(fileBody != null && fileName != null)
{
Attachment myAttachment  = new Attachment();
myAttachment.Body = fileBody;
myAttachment.Name = fileName;
myAttachment.ParentId = newCase.Id;
insert myAttachment;

}
            if(fileName != null)
            {
                Attachment myAttachment  = new Attachment();
                myAttachments = new List<Attachment>();
                //  myAttachment.Body = fileBody;
                myAttachment.Name = fileName;
                myAttachment.ParentId = newCase.Id;
                myAttachments.add(myAttachment);
                insert myAttachments;
            }*/
            String url = '/apex/ICP_FormMsg?fname='+contactFirstName+'&lname='+contactLastName+'&email='+contactEmail+'&hvacid='+hvacid+'&value='+payload;
            PageReference pr = new PageReference(url);
            return pr;
            //return Page.ICP_FormMsg;
        }
        
        return null;  
        
        
    }
    
    
    /**
* @description :method to Cerate Asset for Smart Search
**/
    /*public PageReference CreateAssetForSS(){

AddSerialNumberPageController ds = new AddSerialNumberPageController();
asstList= new list<asset>();
boolean isRecordSelect = false;
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
Brand__c = objCase.CCC_Brand__c,
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

}*/
    
    
    
    
    //wrapper Class for reponse
    public class DiscreteModelNumbersWrapper {
        public integer dataQualityIndicator{get;set;}
        public string discreetNo{get;set;}
        public String model {get;set;}
        public string serial{get;set;}
        public string toscode {get;set;}
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
        public boolean validationStatus{get; set;}
        public list<DiscreteModelNumbersWrapper> suggestedResults{get;set;}
        
        
    }
    public Class AllAsset{
        public Asset objAsset{get;set;}
        public String strURL{get;set;}
        public AllAsset(Asset objAsset, String strURL){
            this.objAsset = objAsset;
            this.strURL = strURL;
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
    // Add more attachments action method
    public void addMore()
    {
        List<Attachment> tempAttachments = new List<Attachment>();
        System.debug('#newAttachments:'+newAttachments);
        if(newAttachments==null){
            newAttachments = new List<Attachment>{new Attachment()};
                }
        // append NUM_ATTACHMENTS_TO_ADD to the new attachments list
        for (Integer idx=0; idx<NUM_ATTACHMENTS_TO_ADD; idx++)
        {
            newAttachments.add(new Attachment());
        }
        tempAttachments.addAll(newAttachments);
        for(Attachment eachAttachment : newAttachments){
            eachAttachment.Body = null;
        }
    }
    
    // Save action method
    public void save()
    {
        List<Attachment> toInsert=new List<Attachment>();
        for (Attachment newAtt : newAttachments)
        {
            if (newAtt.Body!=null)
            {
                newAtt.parentId=sobjId;
                // newAtt.parentId=newCase.id;
                toInsert.add(newAtt);
            }
        }
        insert toInsert;
        newAttachments.clear();
        newAttachments.add(new Attachment());
        
        // null the list of existing attachments - this will be rebuilt when the page is refreshed
        attachments=null;
    }
    public class PartNumbersWrapper {
        public string partNumber{get;set;}  
        public boolean isFailedPart {get;set;}
        
        
    }
    public void createComments(){
        CaseComment cc = new CaseComment(ParentId = newCase.Id,CommentBody = Comments);
        insert cc;
    }
    public void parsePayloadAndGetValues(String payload){
        System.debug('#payload:'+payload);
        //payload = 'SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=';
        if(payload.contains(' ')){
            payload = payload.replaceAll(' ', '+');
        }
        System.debug('#payload after:'+payload);
        JWTDecryptFinal decrypt = new JWTDecryptFinal();
        //this.contactFirstName = decrypt.getFirstName(payload);
        this.contactFirstName = decrypt.getFirstNameDecrypt(payload);
        
        System.debug('#contactFN:'+contactFirstName);
        //this.contactLastName = decrypt.getLastName(payload);
        this.contactLastName = decrypt.getLastNameDecrypt(payload);
        
        //this.contactEmail = decrypt.getEmail(payload);
        this.contactEmail = decrypt.getEmailDecrypt(payload);
        
        this.hvacId = decrypt.getHVACIDDecrypt(payload);
        this.shipTo = decrypt.getSHIPTODecrypt(payload);
        
    }
}