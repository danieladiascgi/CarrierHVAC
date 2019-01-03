public class AddFindEquipment_Controller {
    @AuraEnabled
    public static List<AllAsset> lstAssetTemp{get;set;}
    //public static String responseStr{get;set;}
   // public static Boolean CaseHide {get; set;}
    //public static Boolean detailHide {get;set;}
    public static boolean IsAssetShow{get;set;}
    public static list <Asset> asstList {get ; set;}
    public static list <AllAsset> lstAsset {get ; set;}
    @AuraEnabled
    Public static List<DiscreteModelNumbersWrapper> lstDisNum {get;set;}
    Public static List<FindRegisteredWrapper>lstRegEq { get; set;}
    //Public static string delId {get;set;}
    // Discrete Model Number service variable
    /*public static String dModelNo_ModelNo {get;set;}
    public static String dModelNo_SerialNo {get;set;}
    public static String dModelNo_Brand {get;set;}
    public static String dModelNo_ProductHierarchy {get;set;}
    public static String dModelNo_DiscModelNo {get; set;}
    public static String dModelNo_TossCode {get; set;}
    public static String dModelNo_PhNo {get;set;}
    public static String dModelNo_InstAddres {get;set;}
    public static String dModelNo_RegisNo {get;set;}
    public static String dModelNo_LstName {get;set;}
    public static String dModelNo_Zipcde {get;set;}
    public static String dModelNo_ConfNo {get;set;}*/
   // public static string selectedValue { get;set; }
    //public static List<SelectOption> brandOptions { get;set; }
    public static List<CCC_junctionCaseAsset__c> lstjnc {get;set;}
    public static List<AllAsset> lstSelectedAssetTemp {get;set;}
    //public static Case objCase{get;set;}
    public static Account acc{get;set;}
    //public static boolean isInternalUser{get;set;}
    //public static boolean BrandOnCasepresent{get;set;}
    public static CCC_ErrorLog errlog;
    //
    public static boolean isValidate = true;
    
    //public static List<Asset> updateAssetTosCode{get; set;}
    //public static List<Asset> updateAssetbrand{get; set;}
    
    /*Added below vairable for Primary Asset logic - Start*/
    public static String selectedPrimaryAssetId{get; set;}
    /*Added below variable for Primary Asset logic - End*/
    public static Map<Id, CCC_junctionCaseAsset__c> junctionIdKeyObjMap{get; set;}
    public static Map<Id, Id> assetIdKeyJuncIdValue{get; set;}
    public static String responseGlobalCapture{get; set;}
    //public static Map<String, DiscreteModelNumbersWrapper> mapSerialKeyAndAssetWrpVal{get; set;}
    /**
* @description :constructor call
**/
   /* public AddFindEquipment_Controller(ApexPages.StandardController stdController){
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
        //dModelNo_ModelNo = '';
        //dModelNo_SerialNo = '';
        
       // lstAsset = getAllAssets();             
    }*/
    
    @AuraEnabled
    public static list<AllAsset> getAllAssets(Id idOfCase){
        lstAssetTemp = new list<AllAsset>();
        junctionIdKeyObjMap = new Map<Id, CCC_junctionCaseAsset__c>();
        assetIdKeyJuncIdValue = new Map<Id, Id>();
        
        set<Id> AssetIds = new set<Id>();
        //insert junction asset in list
        for(CCC_junctionCaseAsset__c objJunction:[select Id,Asset__c, primary__c from CCC_junctionCaseAsset__c where Case__c =:idOfCase]){
            AssetIds.add(objJunction.Asset__c);
            System.debug('#junctionIdKeyObjMap:'+junctionIdKeyObjMap);
            System.debug('#objJunction:'+objJunction);
            System.debug('#objJunction.Id:'+objJunction.Id);
            
            // Start Added by Supriya
             System.debug('objJunction.primary__c value: before'+objJunction.primary__c);
            
             
            junctionIdKeyObjMap.put(objJunction.Id, objJunction);
            assetIdKeyJuncIdValue.put(objJunction.Asset__c, objJunction.Id);
        }
        
        system.debug('junctionIdKeyObjMap'+junctionIdKeyObjMap);
        system.debug('assetIdKeyJuncIdValue'+assetIdKeyJuncIdValue);
        
        //maps to Asset object and redirects to CCC_EquipmentDetail page with parameters Serial Number, Model Number, Brand and Discrete Model Number
        for(Asset objAsset:[Select Id,Brand__c,Toss_Code__c,Product_Hierarchy__c,CCC_Disc_Model_Number__c,CCC_Model_Number__c,SerialNumber,CCC_Validation_status__c,CCC_Installing_Dealer__c,Ship_Date__c  from Asset where Id = :AssetIds])
        {
            
            String strUrl = '/apex/CCC_EquipmentDetail?sn='+objAsset.SerialNumber+'&mn='+objAsset.CCC_Model_Number__c+'&br='+objAsset.Brand__c+'decmn='+objAsset.CCC_Disc_Model_Number__c;
            lstAssetTemp.add(new AllAsset(objAsset,strUrl, assetIdKeyJuncIdValue.get(objAsset.Id)));
            IsAssetShow = true;
            
        }
        System.debug('#lstAssetTemp'+lstAssetTemp);
        return lstAssetTemp;
    }
    

    /**
* @description : It deletes the selected record, when user clicks on delete command link
**/
    @AuraEnabled
    public static List<AllAsset> delRecord (Id recordToDelete, Id caseId){
        //String rId = Apexpages.currentpage().getparameters().get('delrId');
        list<CCC_junctionCaseAsset__c>  lstdel = [select Id from CCC_junctionCaseAsset__c where Asset__c = :recordToDelete and Case__c=:caseId] ;
        List<AllAsset> lstAssets = new List<AllAsset>();
        delete lstdel;
        lstAssets = getAllAssets(caseId);
        return lstAssets;
       // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Deleted successfully');//and Model Number
       // ApexPages.addMessage(myMsg);                
    }
    
    /**
* @parameters: Serial Number,Model Number, Disc Model No,Brand 
* @description :It will get all credentials from Custom setting object CCC_IntegrationEndPoint__c, from the body received
* by http response it will parse the token number. The Received json response is parsed and result is stored in wrapper class  DiscreteModelNumbersWrapper  
**/
    
    @AuraEnabled
    public static List<DiscreteModelNumbersWrapper> getDiscreteModelNumbers(Id idOfCase,String dModelNo_ModelNo, String dModelNo_SerialNo,String dModelNo_DiscModelNo, String dModelNo_Brand ) { 
        
        Access_Token__c tokenValue=Access_Token__c.getValues('PHDB Smart Search');
        String token=tokenValue.PHDB_Access_Token__c;  
        lstDisNum=new List<DiscreteModelNumbersWrapper>(); 
        errlog = new CCC_ErrorLog();
               
               
                CCC_IntegrationEndPoint__c  CustomSettingEndPointPHDB = CCC_IntegrationEndPoint__c.getValues('PHDB');
                
                 Http http = new Http();
                HttpRequest req1 = new HttpRequest();                
                String baseURL = CustomSettingEndPointPHDB.URL__c; 
                                   
                String endpoint = baseURL + 'serial/' + dModelNo_SerialNo;
                req1.setEndpoint(endpoint);
                req1.setMethod('GET');
                req1.setTimeout(120000);       
                String authorizationHeader1 = 'Bearer '+token;
                system.debug('--------endpoint----------' + endpoint);
                
                req1.setHeader('Authorization', authorizationHeader1);
               System.debug('------request--------'+req1);
          System.debug('------token--------'+token);
                HTTPResponse res1 = http.send(req1);
                System.debug('------response--------'+res1.getBody());
            responseGlobalCapture = res1.getBody();
                JSONParser parser1 = JSON.createParser(res1.getBody());
                try{
                    DiscreteModelNumbersWrapper ob1=(DiscreteModelNumbersWrapper)JSON.deserialize(res1.getBody(),DiscreteModelNumbersWrapper.class);
                    system.debug('--------ob1------' + ob1);
                    if(ob1 == null ){
                       // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB -No Matching Records Found  '));
                       throw new AuraHandledException('PHDB-No Matching Records Found.');
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
                    System.debug('dModelNo_SerialNo..'+dModelNo_SerialNo);
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
                            CreateAsset(idOfCase,lstDisNum[0].suggestedResults, null);
                            //detailHide=false;
                        }else{
                            //apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'PHDB-No Record Found.');
                            //apexpages.addmessage(msg);
                            throw new AuraHandledException('PHDB-No Record Found.');
                        }
                    }else{
                        if(lstDisNum[0].suggestedResults.size() == 1){
                            lstDisNum[0].suggestedResults[0].selected = true;
                            CreateAsset(idOfCase,lstDisNum[0].suggestedResults, null);
                            //detailHide=false;
                        }else{
                            //detailHide=true;
                        }
                    }
                }
                catch(System.CalloutException e){
                   errlog.ErrorLogCalloutException(e,'PHDB WebService','AddFindEquipment_Controller');
                    throw new AuraHandledException('PHDB - No Record Found.');
                   //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - No Record Found'));
                }
                Catch(Exception e){
                    //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
                   errlog.ErrorLogException(e,'PHDB WebService','AddFindEquipment_Controller');
                   throw new AuraHandledException('PHDB - An unexpected error has occurred ,Please contact your Administrator. ');
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - An unexpected error has occurred ,Please contact your Administrator. '));
                }
         System.debug('#lstDisNum12344.suggestedResults:'+lstDisNum[0].suggestedResults);
           return lstDisNum[0].suggestedResults;
        
      
    }
    
    /**
* @parameters: Last Name, Phone Number, Registration Number, zip code, Conf No, Install Address
* @description :It will get all credentials from Custom setting object CCC_IntegrationEndPoint__c, from the body received
* by http response it will parse the token number. The Received json response is parsed and result is mapped to wrapper class FindRegisteredWrapper  
* Used CCC_IntegrationHelper class to send token and get response from PHDB service
**/
       @AuraEnabled  
        public static List<FindRegisteredWrapper> getEquipmentInfo(String lstName, String ConfNo,String Zipcode, String instalAddress, String PhNo,String RegisNo ){
        lstRegEq = new List<FindRegisteredWrapper>();
        
            try{
                 String response = new CCC_IntegrationHelper().getPHDBInformation( null,null,null,null,null,null,null, lstName,  ConfNo, Zipcode,  instalAddress,  PhNo, RegisNo, null,null,null);
                 System.debug('response...'+response);
                 FindRegisteredWrapper wrp2=(FindRegisteredWrapper)JSON.deserialize(response,FindRegisteredWrapper.class);
                 if(wrp2==null){
                     //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'No Record Found.');
                     //ApexPages.addMessage(myMsg); 
                     throw new AuraHandledException('No Record Found.');
                 }
                 if(wrp2.registrationDataResults==null || wrp2.registrationDataResults.size() ==0){
                     //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'No Record Found.');
                     //ApexPages.addMessage(myMsg);
                     throw new AuraHandledException('No Record Found.'); 
                 }
                 lstRegEq.addAll(wrp2.registrationDataResults);
            }catch(exception e){
                //errlog.ErrorLogException(e,'Equipment Search','AddFindEquipment_Controller ');
                // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'PHDB - No Record Found. ');
                // ApexPages.addMessage(myMsg); 
                /*AuraHandledException ex = new AuraHandledException('PHDB - No Record Found.');
                ex.setMessage('PHDB - No Record Found.');
                system.debug(ex);
                throw ex;*/
                throw new AuraHandledException('PHDB - No Record Found.');
            }
                    
        //detailHide=True;
        return lstRegEq;
    }
    /**
* @description :cancels the asset 
**/
   /* public void CancelAsset() {
        detailHide = False;
        
    } */
    
    
    /**
* @description :method to Save Asset and Junction object
**/
    
    public static List<CCC_junctionCaseAsset__c> createJunctionObject(set<String> setSerialModel,List<Asset> lstAllSelectedAsset, Id idOfCase){
        list<CCC_junctionCaseAsset__c>  lstNewJunction = new list<CCC_junctionCaseAsset__c>();
        set<String> setExistingSerialModel = new set<String>();
        set<Id> setAssetId = new Set<Id>();
        list<Asset> lstNewAsset = new list<Asset>();
        
        set<Id> setAllSelectedAssetId = new set<Id>();
        
        list<Asset> lstExistingAsset = [select Id,CCC_SerialModelNumber__c, Ship_Date__c from Asset where CCC_SerialModelNumber__c in: setSerialModel];
        System.debug('lstExistingAsset.....'+lstExistingAsset);
        for(Asset objAss:lstExistingAsset){
            setExistingSerialModel.add(objAss.CCC_SerialModelNumber__c);
            setAllSelectedAssetId.add(objAss.Id);
        }
        /*Added new code for Shipped Date - Start*/
        for(Asset objAss:lstExistingAsset){
            objAss.Ship_Date__c = getShippedDate(); 
        }
        update lstExistingAsset;
        /*Added new code for Shipped Date - End*/
        set<Id> setAsset = new set<Id>();
        
        for(CCC_junctionCaseAsset__c obj:[select Id,Case__c,Asset__c from CCC_junctionCaseAsset__c where Asset__c in:lstExistingAsset]){
            if(obj.Case__c == idOfCase){//If Asset is Exist on corrent Case
                //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The asset with Model no# and Serial no# is already added to this case');
                //ApexPages.addMessage(myMsg); 
                //throw new AuraHandledException('The asset with Model no# and Serial no# is already added to this case');
                System.debug('Asset Present'+obj+'case id..'+idOfCase);
                setAllSelectedAssetId.remove(obj.Asset__c);
                //return null;
            }else{ //If Asset is Exist but not in current Case
                if(!setAsset.contains(obj.Asset__c)){
                    
                    CCC_junctionCaseAsset__c objJunction = new CCC_junctionCaseAsset__c();
                    objJunction.Asset__c = obj.Asset__c;
                    objJunction.Case__c = idOfCase;
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
            objJunction.Case__c = idOfCase;
            lstNewJunction.add(objJunction) ;
            
        }
        System.debug('lstNewJunction...'+lstNewJunction);
        System.debug('lstAllSelectedAssetHere...'+lstAllSelectedAsset);
        System.debug('setExistingSerialModelHere...'+setExistingSerialModel);
        
        for(Asset SelectedAsset: lstAllSelectedAsset){
            System.debug('setExistingSerialModelHere22...'+setExistingSerialModel.contains(SelectedAsset.CCC_SerialModelNumber__c)); 
            if(!setExistingSerialModel.contains(SelectedAsset.CCC_SerialModelNumber__c)){
                lstNewAsset.add(SelectedAsset);
            }
            if(SelectedAsset.SerialNumber == '' || SelectedAsset.CCC_Model_Number__c == '' ||SelectedAsset.SerialNumber ==null ||SelectedAsset.CCC_Model_Number__c == null ){
                //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Serial# and Model# both are mandatory.');
                //ApexPages.addMessage(myMsg); 
                throw new AuraHandledException('Serial# and Model# both are mandatory.');
                //return null;
            }
        }
        System.debug('lstNewAsset'+lstNewAsset);
        insert lstNewAsset;
        for(Asset tempAss:lstNewAsset){
            CCC_junctionCaseAsset__c objJunction = new CCC_junctionCaseAsset__c();
            objJunction.Asset__c = tempAss.Id;
            objJunction.Case__c = idOfCase;
            lstNewJunction.add(objJunction) ; 
        }
        System.debug('lstNewJunction1..'+lstNewJunction);
        insert lstNewJunction;
        System.debug('lstNewJunction2..'+lstNewJunction);
        return lstNewJunction;
    }
    
    /**
* @description :method to Create Asset for PHDB Serial# search
**/
    @AuraEnabled
    public static void CreateAsset(Id idOfCase,List<DiscreteModelNumbersWrapper> selRecs, String selRecsStr){
        System.debug('check..'+selRecsStr);
        //DiscreteModelNumbersWrapper wrpRaw = selRecs.get(0);
        //System.debug('wrpRaw..'+wrpRaw);
        asstList= new list<asset>();
        boolean isRecordSelect = false;
        set<String> setSerialModel = new set<String>();
        List<Asset> lstAllSelectedAsset = new List<Asset>();
        lstjnc = new list<CCC_junctionCaseAsset__c>();
       // DiscreteModelNumbersWrapper wrapperCheck = (DiscreteModelNumbersWrapper)JSON.deserialize(String.valueOf(selRecs.get(0)), DiscreteModelNumbersWrapper.class);
        if(selRecsStr!=null && selRecsStr.length()>0){
            selRecs = (List<DiscreteModelNumbersWrapper>)JSON.deserialize(selRecsStr, List<DiscreteModelNumbersWrapper>.class);
        }
        Case cse = [Select AccountId from Case where Id=:idOfCase];
        System.debug('check2..'+cse);
        System.debug('check4..'+selRecs);
        System.debug('check5..'+selRecs.size());
        if(selRecs != null) {
            System.debug('check3..'+selRecs);
            for (DiscreteModelNumbersWrapper wrapper :selRecs) {
                        System.debug('check6..'+wrapper);                              
                        isRecordSelect = true;
                        String str = wrapper.serial + wrapper.model;
                        str= str.replaceAll( '\\s+', '');
                        setSerialModel.add(str);
                 System.debug('check7..'+setSerialModel);
                        String shippedDate = wrapper.shippedDate;
                     System.debug('dhippedDate'+shippedDate);
                        Date ShippedDateConv = FormatDate(shippedDate);
                     System.debug('ShippedDateConv'+ShippedDateConv);   
                        
                        lstAllSelectedAsset.add(new Asset(accountId=cse.AccountId,
                                                          Name=wrapper.serial, 
                                                        //  Brand__c = objCase.CCC_Brand__c,
                                                          Brand__c = wrapper.brand,
                                                          Product_Hierarchy__c = wrapper.productHierarchy,
                                                          SerialNumber = wrapper.serial,
                                                          CCC_Model_Number__c=wrapper.model,
                                                          CCC_Disc_Model_Number__c= wrapper.discreetNo,
                                                          Toss_Code__c=wrapper.toscode,
                                                          //CCC_Validation_status__c =isValidate,
                                                          CCC_SerialModelNumber__c = str,
                                                          Ship_Date__c =ShippedDateConv
                                                         ));
                    //} 
                //}
                
               
            }
            System.debug('lstAllSelectedAsset..'+lstAllSelectedAsset);
           /* if(!isRecordSelect){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Asset');
                ApexPages.addMessage(myMsg); 
                return null;
            } */                                   
            
            
            for(CCC_junctionCaseAsset__c objJunction:[select Id,Asset__c, primary__c from CCC_junctionCaseAsset__c where Case__c =:idOfCase]){
               if(objJunction.primary__c = true){
                  objJunction.primary__c = false;
                   System.debug('lstjnc..'+lstjnc);
                  lstjnc.add(objJunction);
                  //update objJunction;
                  System.debug('objJunction.primary__c value: after'+objJunction.primary__c);
                  
               } 
            }
            System.debug('beforeUpdate..'+lstjnc);
            Database.update(lstjnc);
             
            //Create Junction objet and Asset
            System.debug('setSerialModel..'+setSerialModel);
            System.debug('lstAllSelectedAsset..'+lstAllSelectedAsset);
            List<CCC_junctionCaseAsset__c> lstjncObj = new List<CCC_junctionCaseAsset__c>();
            lstjncObj = createJunctionObject(setSerialModel,lstAllSelectedAsset,idOfCase);
            lstAsset = getAllAssets(idOfCase);
            System.debug('lstAsset1.....'+lstAsset);
             
            
            lstSelectedAssetTemp = new List<AllAsset>();
            for(Asset at : lstAllSelectedAsset){
              String strUrl1 = '/apex/CCC_EquipmentDetail?sn='+at.SerialNumber+'&mn='+at.CCC_Model_Number__c+'&br='+at.Brand__c+'decmn='+at.CCC_Disc_Model_Number__c;
              lstSelectedAssetTemp.add(new AllAsset(at,strUrl1, assetIdKeyJuncIdValue.get(at.Id)));
            }
            //Added for first asset - Start
            System.debug('#getting first asset'+lstSelectedAssetTemp.get(0).objAsset);
            if(lstAsset!=null && lstAsset.size()>0){
               //for(Integer i = lstAsset.size() - 1; i >= 0; i--)
               //{
                //AllAsset firstAst = lstSelectedAssetTemp.get(0);
                CCC_junctionCaseAsset__c firstjncAst = lstjncObj.get(0);
                String idOfFirstAsset = firstjncAst.Asset__c;
                
                System.debug('idOfFirstAsset.....'+idOfFirstAsset);
                
                selectedPrimaryAssetId = idOfFirstAsset;
                system.debug('selectedPrimaryAssetId'+selectedPrimaryAssetId);
                //System.debug('#getting first asset+'+);
                //ApexPages.currentPage().getParameters().put('primaryAssetId', selectedPrimaryAssetId);
                getSelected(idOfCase,selectedPrimaryAssetId,lstAsset);
               //}
            }
            //Added for first asset - End
            //detailHide=False;
            //return null;
        }
        //detailHide=False; 
        //return null;
        
    }
    
    
    /**
* @description :method to Cerate Asset for Smart Search
**/
    @AuraEnabled
    public static void CreateAssetForSS(Id idOfCase,String selRecsString){
        System.debug('testing...'+selRecsString);
       // CCC_EquipmentSearchController ds = new CCC_EquipmentSearchController();
       List<FindRegisteredWrapper> selRecs = new List<FindRegisteredWrapper>();
        asstList= new list<asset>();
        boolean isRecordSelect = false;
      
        set<String> setSerialModel = new set<String>();
        List<Asset> lstAllSelectedAsset = new List<Asset>();
        
        if(selRecsString!=null && selRecsString.length()>0){
            selRecs = (List<FindRegisteredWrapper>)JSON.deserialize(selRecsString, List<FindRegisteredWrapper>.class);
        }
        
        Case cse = [Select AccountId,Current_Servicing_Dealer__c from Case where Id=:idOfCase];
        
        if(selRecs!= null) {
            for (FindRegisteredWrapper a :selRecs) {
                
                 
                    isRecordSelect = true;
                    String str = a.serial + a.model;
                    str= str.replaceAll( '\\s+', '');
                    setSerialModel.add(str);
                    
                    
                    lstAllSelectedAsset.add(new Asset(accountId=cse.AccountId,
                                                      Name=a.serial,
                                                     // Brand__c = objCase.CCC_Brand__c,
                                                     
                                                      SerialNumber = a.serial,
                                                      CCC_Model_Number__c=a.model,
                                                      //CCC_Validation_status__c =isValidate,
                                                      CCC_SerialModelNumber__c = str,
                                                      CCC_Installing_Dealer__c =a.dealerName));
                //} 
                system.debug('lstAllSelectedAsset'+lstAllSelectedAsset);
                if(lstAllSelectedAsset.size()>0){
                cse.Current_Servicing_Dealer__c =lstAllSelectedAsset[0].CCC_Installing_Dealer__c;
                update cse;
                }
                if(cse.AccountId!=null){
                    acc=[Select id,CCC_Current_Servicing_Dealer__c from Account where id=:cse.AccountId];
                   // acc.Id = objCase.AccountId;
                    acc.CCC_Current_Servicing_Dealer__c = cse.Current_Servicing_Dealer__c;
                    update acc;
                }
                    
            }
         /* if(!isRecordSelect){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Asset');
                ApexPages.addMessage(myMsg);                 
            }*/
            
            //Create Junction objet and Asset
            List<CCC_junctionCaseAsset__c> lstjncObjSS = new List<CCC_junctionCaseAsset__c>();
            lstjncObjSS = createJunctionObject(setSerialModel,lstAllSelectedAsset,idOfCase);
            
            
            lstAsset = getAllAssets(idOfCase);
            
             if(lstAsset!=null && lstAsset.size()>0){             		
	                CCC_junctionCaseAsset__c firstjncAst = lstjncObjSS.get(0);		
	                String idOfFirstAssetSS = firstjncAst.Asset__c;               		
	                System.debug('idOfFirstAssetSS.....'+idOfFirstAssetSS);		
	                		
	                selectedPrimaryAssetId = idOfFirstAssetSS;		
	                system.debug('selectedPrimaryAssetIdSS'+selectedPrimaryAssetId);                		
	                getSelected(idOfCase,selectedPrimaryAssetId,lstAsset);              		
             }
            
            //detailHide=False;
            //return null;
        }
        //detailHide=False; 
        
        //return null;
        
    }
    
    
    //wrapper Class for reponse
    public class DiscreteModelNumbersWrapper {
        @AuraEnabled
        public integer dataQualityIndicator{get;set;}
        @AuraEnabled
        public string discreetNo{get;set;}
        @AuraEnabled
        public String model {get;set;}
        @AuraEnabled
        public string serial{get;set;}
        @AuraEnabled
        public string toscode {get;set;}
        @AuraEnabled
        public String productHierarchy{get; set;}
        @AuraEnabled
        public string brand {get;set;}
        @AuraEnabled
        public String mfgDate {get ; set;}
        @AuraEnabled
        public String derivedMfgDate {get ; set;}
        @AuraEnabled
        public integer mfgWeek{get;set;}
        @AuraEnabled
        public integer mfgYear{get;set;}
        @AuraEnabled
        public String msg{get;set;}
        @AuraEnabled
        public boolean serialVerified{get;set;}
        @AuraEnabled
        public string shippedDate{get;set;}
        @AuraEnabled
        public string suGuid{get;set;}
        @AuraEnabled
        public string shipTo{get;set;} 
        @AuraEnabled
        public boolean selected {get;set;}
        @AuraEnabled
        public list<DiscreteModelNumbersWrapper> suggestedResults{get;set;}
        
        
    }
    public Class AllAsset{
        @AuraEnabled
        public Asset objAsset{get;set;}
        @AuraEnabled
        public String strURL{get;set;}
        @AuraEnabled
        public String junctionAssetId{get;set;}
        
        public AllAsset(Asset objAsset, String strURL, String junctionAssetId){
            this.objAsset = objAsset;
            this.strURL = strURL;
            this.junctionAssetId = junctionAssetId;
        }
    }
    public class FindRegisteredWrapper {
        @AuraEnabled
        Public String consumer_Name { get; set;}
        @AuraEnabled
        Public String consumer_BusinessName { get; set;}
        @AuraEnabled
        Public String consumer_Address1 { get; set;}
        @AuraEnabled
        Public String consumer_Address2 { get; set;}
        @AuraEnabled
        Public String consumer_City { get; set;}
        @AuraEnabled
        Public String consumer_State { get; set;}
        @AuraEnabled
        Public String consumer_Country { get; set;}
        @AuraEnabled
        Public String consumer_Zip { get; set;}
        @AuraEnabled
        Public String consumer_Phone1 { get; set;}
        @AuraEnabled
        Public String consumer_Phone2 { get; set;}
        @AuraEnabled
        Public String equip_Address1 { get; set;}
        @AuraEnabled
        Public String equip_Address2 { get; set;}
        @AuraEnabled
        Public String equip_City { get; set;}
        @AuraEnabled
        Public String equip_State { get; set;}
        @AuraEnabled
        Public String equip_Country { get; set;}
        @AuraEnabled
        Public String equip_Zip { get; set;}
        @AuraEnabled
        Public String dealerName { get; set;}
        @AuraEnabled
        Public String dealerPhone { get; set;}
        @AuraEnabled
        Public String mfgAcctNum { get; set;}
        @AuraEnabled
        Public String serviceBenchID { get; set;}
        @AuraEnabled
        Public String hvacpId { get; set;}
        @AuraEnabled
        Public String model { get; set;}
        @AuraEnabled
        Public String serial { get; set;}
        @AuraEnabled
        Public String equip_Description { get; set;}
        @AuraEnabled
        Public String confirmationNumber { get; set;}
        @AuraEnabled
        Public String registrationNumber { get; set;}
        @AuraEnabled
        Public String source { get; set;}
        @AuraEnabled
        Public String comments { get; set;}
        @AuraEnabled
        Public String installationDate{ get; set;}
        @AuraEnabled
        Public String registrationDate{ get; set;}
        @AuraEnabled
        Public String transferDate{ get; set;}
        @AuraEnabled
        Public String markAs{ get; set;}
        @AuraEnabled
        Public String registrationDataInput{ get; set;} 
        @AuraEnabled
        Public String  Id { get; set;}
        @AuraEnabled
        Public String  modelLocation { get; set;}
        @AuraEnabled
        Public String  furnaceOrientation { get; set;}
        @AuraEnabled
        Public String  furnaceFuel { get; set;}
        @AuraEnabled
        Public String  enhancedWarrantyFlag { get; set;}
        @AuraEnabled
        Public String  alwaysReviewFlag { get; set;}
        @AuraEnabled
        Public String  registeredOnTimeFlag { get; set;}
        @AuraEnabled
        Public String  proofOfPurchaseFlag { get; set;}
        @AuraEnabled
        Public String  agreementNumber { get; set;}
        @AuraEnabled
        Public String  tagNumber { get; set;}
        @AuraEnabled
        public boolean selected {get;set;}
        @AuraEnabled
        Public List<FindRegisteredWrapper> registrationDataResults { get; set;}        
    }
  /* public void UpdateTosCodeOnExistingAssets(List<Asset> toUpdateTosCodeAssets){
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
        
    }*/
    
   /* public String getTosCodeFromSerialNumber(String serialNnumber){
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
                      // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - No Record Found'));
                }
                Catch(Exception e){
                    //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
                   errlog.ErrorLogException(e,'PHDB WebService','CCC_EquipmentDetailController');
                  // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - An unexpected error has occurred ,Please contact your Administrator. '));
                }
        }
        return toReturn;
    }*/
    
    /*public void UpdatebrandOnExistingAssets(List<Asset> toUpdatebrandAssets){
        //List<Asset> toUpdateAst = new List<Asset>();
        System.debug('##toUpdateTosCodeAssets:'+toUpdatebrandAssets);
        for(Asset ast : toUpdatebrandAssets){
          
            String brand  =  getbrandFromSerialNumber(ast.SerialNumber);
           
            ast.Brand__c = brand;
           
            updateAssetbrand.add(ast);
        }
         
    }*/
    
    /* public static String getbrandFromSerialNumber(String serialNnumber, String modelNumber){
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
    }*/
   /* public static String getprodHierarchyFromSerialNumber(String serialNnumber, String modelNumber){
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
                        if(a.productHierarchy!=null && a.productHierarchy.length()>0){
                            return a.productHierarchy;
                        }
                    }
                }catch(System.CalloutException e){
                       errlog.ErrorLogCalloutException(e,'PHDB WebService','CCC_EquipmentDetailController');
                      // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - No Record Found'));
                }
                Catch(Exception e){
                    //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
                   errlog.ErrorLogException(e,'PHDB WebService','CCC_EquipmentDetailController');
                  // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - An unexpected error has occurred ,Please contact your Administrator. '));
                }
        }
        return toReturn;
    }*/
  /*  public class RegistrationDataList{
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
    } */
    
    public static void getSelected(Id caseId, Id selectedPrimaryAssetId, List<AllAsset> lstAsset)
    {
        Case cse = [Select Id, CCC_Product_Group_Code__c from Case where Id=:caseId];
       // selectedPrimaryAssetId = ApexPages.currentPage().getParameters().get('primaryAssetId');
        //List<Asset> updateAssetsWithPrimary = new List<Asset>();
        List<CCC_junctionCaseAsset__c> updateJuncAssetWithPrimary = new List<CCC_junctionCaseAsset__c>();
        System.debug('Entered Primary Asset Id selection block:'+selectedPrimaryAssetId);
        System.debug('lstAsset2.....'+lstAsset);
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
        //return null;
    }
    public static Date getShippedDate(){
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
                      // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - No Record Found'));
                }
                Catch(Exception e){
                    //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
                   errlog.ErrorLogException(e,'PHDB WebService','CCC_EquipmentDetailController');
                  // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PHDB - An unexpected error has occurred ,Please contact your Administrator. '));
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
}