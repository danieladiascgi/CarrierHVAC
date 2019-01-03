/**
* @ Developer     : Ishita Sharma
* @date_created   : 4/2/2016
* @functions      : 
*
***/

public class CCC_RegistrationCorrectionController {


    /*Variable Declarations*/ 
    public Registration_Correction__c regCorrection { get; set; }
    public List<cRegCorrection> RegcorrecList {get; set;}
    Public boolean EquipFlag{get;set;}
    public case objCase{get;set;}
    public List<Equipment__c> lstAllSelectedRecords = new List<Equipment__c>();
    public List<Equipment__c> reggCorrection = new List<Equipment__c>();
    public Id uniqueEquipmentId {get;set;}
    public list<RegistrationDataObj> registrationDataResults;
    public List<cRegCorrection> RegcorrecEquipList {get; set;}
    public List<Equipment__c> lstEquipRecords {get; set;}
    public List<Equipment__c> delequipList {get;set;}
    public Integer rowIndex {get;set;}
    Public Equipment__c del;
    public Registration_Correction__c correct{get;set;}  
    public list<SerialNumberResult> serialResults {get;set;}
   
    public boolean flag1=true;
    public boolean flag2=false;
    public Profile currentUserProfile;
    
    public string selectedConfNo;
    public string selectedRegeNo;
    
    public boolean isNewProdReg{get; set;}
    public boolean isInternalUser{get;set;}

    public Case setregoncasevalue(Case caseobject) {
        objCase=[Select id,RegCorrectionOncase__c,CCC_Purpose__c,CCC_Sub_Purpose__c,CCC_Purpose_Tier1_CR__c,CCC_Sub_Purpose_Tier1_CR__c,Description,Origin from Case where id=:caseobject.id];
        return objCase;
    }

    
    public CCC_RegistrationCorrectionController(ApexPages.StandardController controller) {  
        objCase =   (Case)controller.getRecord();    
        regCorrection= new Registration_Correction__c();
        correct = new Registration_Correction__c();
        delequipList= new List<Equipment__c>();
        serialResults = new list<SerialNumberResult>();
        isNewProdReg = false;
        
        
                          
        try{
            correct= [Select id,Case_Number__c from Registration_Correction__c where Case_Number__c!=null And Case_Number__c=:objcase.id limit 1];
        }
        Catch(exception e){
            system.debug('There are no records in RC Object');
            correct = new Registration_Correction__c();
        }
        RegcorrecEquipList  = new List<cRegCorrection>();
        lstEquipRecords = new List<Equipment__c>();
        objCase =setregoncasevalue(objCase);
        if(objCase.RegCorrectionOncase__c == true){
                this.regCorrection=getRegisCorrectionFields();
                if(this.regCorrection == null)
                {
                regCorrection= new Registration_Correction__c();
                }
                getRegisCorrection(); 
                
        }
        else{
            regCorrection= new Registration_Correction__c();
            getRegisCorrection();   
        }        
        
        //Below query to fetch the logged in user profile
        currentUserProfile = [select id, name from Profile  where Id=: UserInfo.getProfileId()];
         if(currentUserProfile.Name == 'Tier 1 Agent Profile'){
         objCase.CCC_Purpose__c=objCase.CCC_Purpose_Tier1_CR__c;
         objCase.CCC_Sub_Purpose__c=objCase.CCC_Sub_Purpose_Tier1_CR__c;
         }
        String confNo = ApexPages.currentPage().getParameters().get('confNo');
        String sbRegnNo = ApexPages.currentPage().getParameters().get('sbRegnNo');
        String serialNo = ApexPages.currentPage().getParameters().get('serialNo');
        regCorrection.Serial_Number_Search__c = '';
        if(confNo!=null && confNo.length()>0){
            System.debug('#regCorrection.Customer_Confirmation__c:'+regCorrection.Customer_Confirmation__c);
            regCorrection.Customer_Confirmation__c = confNo;            
 
        }
        if(sbRegnNo!=null && sbRegnNo.length()>0){
            System.debug('#regCorrection.SB_Registration_Number_Search__c:'+regCorrection.SB_Registration_Number_Search__c);
            regCorrection.SB_Registration_Number_Search__c = sbRegnNo;            
        }
        if(serialNo!=null && serialNo.length()>0){
           regCorrection.Serial_Number_Search__c = serialNo;
            System.debug('#regCorrection.Serial_Number_Search__c:'+regCorrection.Serial_Number_Search__c);            
        }
        if((confNo!=null && confNo.length()>0) || (sbRegnNo!=null && sbRegnNo.length()>0) || (serialNo!=null && serialNo.length()>0)){
            isNewProdReg = true;
            searchEquipments();
        }
        isInternalUser = false;
        User user1 = [select Id,Profile.UserLicense.Name from User where Id = :userinfo.getUserId() limit 1];
        if(user1.Profile.UserLicense.Name =='Partner Community'){
            isInternalUser = true;
        } 
    }    
    
    public void searchEquipments(){
        serialResults = new list<SerialNumberResult>();
        flag1=true;
        System.debug('#Before searchEquipments');
        getRegisteredEquipments();
        System.debug('#After searchEquipments');
    }

    //This method is used to fetch the registered equipments from PHDB based on serach criteria entered by an Agent.
    public Void  getRegisteredEquipments(){
        string response = '';
        string confirmNumber = '';
        string regNumber = '';
        string serialNumbr= '';        
        System.debug('inside getRegisteredEquipments:'+regCorrection.Customer_Confirmation__c+'#selectedConfNo:'+selectedConfNo+'#flag1:'+flag1);
        if(((regCorrection.Customer_Confirmation__c != null && regCorrection.Customer_Confirmation__c != '' ) ||
                selectedConfNo != null && selectedConfNo != '') && flag1==true){
            flag1=false;
            
            if(selectedConfNo != null && selectedConfNo != ''){
                confirmNumber =  selectedConfNo;
            } 
            else if(regCorrection.Customer_Confirmation__c != null && regCorrection.Customer_Confirmation__c != ''){
                confirmNumber =  regCorrection.Customer_Confirmation__c;    
            }           
                    
            response = new CCC_IntegrationHelper().getPHDBInformation( null,null,null,null,null,null,null, null,confirmNumber, null, null,null,null, null,null,null);
            System.debug('#Conf No:'+response);
    }else if( (regCorrection.SB_Registration_Number_Search__c != null && regCorrection.SB_Registration_Number_Search__c != '') ||
                (selectedRegeNo != null && selectedRegeNo != '') && flag1==true){
            //flag1=false;
           if(selectedRegeNo != null && selectedRegeNo != ''){
                regNumber =  selectedRegeNo;
            } 
            else if(regCorrection.SB_Registration_Number_Search__c != null && regCorrection.SB_Registration_Number_Search__c != ''){
                regNumber =  regCorrection.SB_Registration_Number_Search__c; 
            }        
                    
            response = new CCC_IntegrationHelper().getPHDBInformation( null,null,null,null,null,null,null, null,null, null, null,null,regNumber , null,null,null);
                    System.debug('#SB REg No:'+response);
        }else if(regCorrection.Serial_Number_Search__c != null && regCorrection.Serial_Number_Search__c != ''){
            system.debug('------------->first Entry');
            serialNumbr =  regCorrection.Serial_Number_Search__c; 
            response = new CCC_IntegrationHelper().getPHDBInformation(null,null,null,null,null,null,null,null,null,null, null,null,null,null,serialNumbr,null);
            system.debug('S--'+serialNumbr );           
        }
        
        try{
        JSONParser parser = JSON.createParser(response);
        System.debug('#1 response:'+response);
        if(parser != null){
            RegistrationDataList regResult = (RegistrationDataList)parser.readValueAs(RegistrationDataList.class);
            regCorrection= new Registration_Correction__c();
            RegcorrecList = new List<cRegCorrection>(); 
            system.debug('@#######--'+regResult.registrationDataResults);
            if(regResult != null && regResult.registrationDataResults != null && 
                ((serialNumbr  == null || serialNumbr == '') || (serialNumbr != null && serialNumbr != '' && regResult.registrationDataResults.size() == 1))){
                    /*Added new Code by Tejas 13 June - Start*/
                    for(RegistrationDataObj reg: regResult.registrationDataResults){
                        if(reg.serial!=null && reg.serial.length()>0 && reg.model!=null && reg.model.length()>0){
                            try{
                                SBEntitlementProductService.ProductEntitlementServicePort port = New SBEntitlementProductService.ProductEntitlementServicePort();
                                SBEntitlementProductService.entitlementInfo[] lstEnt  = port.getEntitlementDetail('92',reg.model,reg.serial, '', '', '', '', '','');
                                System.debug('#lstEnt:'+lstEnt);
                                list<wrapperResponse> lstResponse = new list<wrapperResponse>();
List<serviceEntitlement> EntitleInfo=new List<serviceEntitlement>();
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
                   System.debug('#EDK'+EDK);
                   System.debug('#EDD'+EDD);
                   if(EDK.equalsIgnoreCase('CONTRACT NUMBER')){
                       System.debug('#EDK:'+EDK);
                       System.debug('#EDD:'+EDD);
                       reg.contractNumber = EDD;
                       break;
                   }
                EntitleInfo.add(new serviceEntitlement(EDK,EDD) );
               } 
                             
                
                
                  
                }
                }
                
                
                
            
        } 
        //lstResponse.add(new wrapperResponse(EntitleInfo));
                                //System.debug('#lstResponse:'+lstResponse);
                            }catch(Exception e){
                                System.debug('#No Contract Found for Serial['+reg.serial+'] and Model['+reg.Model+']');
                            }
                        }
                    }
                    /*Added new Code by Tejas 13 June - End*/
                for(RegistrationDataObj reg: regResult.registrationDataResults){                
                    string firstname = '';
                    string lastName = '';
                    if(reg.consumer_Name != null && reg.consumer_Name.contains(',')){
                        firstname = reg.consumer_Name.split(',')[0];
                        lastName = reg.consumer_Name.split(',')[1];
                        regCorrection.FirstName_Owner__c = firstname;
                        regCorrection.LastName_Owner__c = lastName;
                    }else{
                        regCorrection.FirstName_Owner__c = reg.consumer_Name; 
                    }
                    System.debug('#equip_FirstName:'+reg.equip_FirstName);
                    System.debug('#equip_LastName:'+reg.equip_LastName);
                    if(reg.equip_FirstName != null){
                        /*firstname = reg.equip_FirstName;
                        lastName = reg.equip_LastName;*/
                        regCorrection.FirstName__c = reg.equip_FirstName;
                        regCorrection.LastName__c = reg.equip_LastName;
                    }else{
                        regCorrection.FirstName__c = reg.consumer_Name; 
                    }
                    regCorrection.BusinessName_Owner__c = reg.consumer_Name;
                    regCorrection.Business_Name__c = reg.equip_BusinessName;
                    regCorrection.AddressStreet_Owner__c = reg.consumer_Address1 + ' ' +reg.consumer_Address2;  
                    regCorrection.AddressStreet__c = reg.equip_Address1 + ' ' +reg.equip_Address2;    
                    regCorrection.CityOwner1__c = reg.consumer_City; 
                    regCorrection.City__c = reg.equip_City; 
                    regCorrection.StateOwner1__c = reg.consumer_State;    
                    regCorrection.State__c = reg.equip_State;    
                    regCorrection.ZipOwner1__c = reg.consumer_Zip;
                    regCorrection.Zip1__c = reg.equip_Zip;
                    regCorrection.CountryOwner1__c = reg.consumer_Country;
                    regCorrection.Country__c = reg.equip_Country;
                    regCorrection.Homeowner_EmailOwner__c = reg.consumer_Email;  
                    regCorrection.Homeowner_Emai1__c = reg.equip_Email;  
                    regCorrection.Homeowner_Phone_Number_HOwner__c = reg.consumer_Phone1; 
                    //regCorrection.Homeowner_Phone_NumberHome__c = reg.equip_Phone1; 
                    regCorrection.Homeowner_Phone_Number_WOwner__c = reg.consumer_Phone2;
                    //regCorrection.Homeowner_Phone_NumbeWorkr__c = reg.equip_Phone2;
                    regCorrection.InstallationDate__c = FormatDate(reg.installationDate);  
                    regCorrection.Transfer_Date1__c = FormatDate(reg.transferDate);
                    if(reg.dealerName.length() >255)
                    {
                    String dealerName=reg.dealerName;
                    dealerName=DealerName.subString(0,255);
                    regCorrection.Dealer_Name1__c=dealerName;
                    }
                    else
                    {
                    regCorrection.Dealer_Name1__c = reg.dealerName; 
                    }
                    
                    if(reg.dealerPhone.length()>255)
                    {
                    String dealerNumber=reg.dealerPhone;
                    dealerNumber=dealerNumber.subString(0,255);
                    regCorrection.Dealer_Number1__c =dealerNumber;
                    }
                    else
                    {
                    regCorrection.Dealer_Number1__c = reg.dealerPhone;
                    }
                    
                    regCorrection.Customer_Confirmation__c = reg.confirmationNumber;
                    system.debug('----------------->'+regCorrection.Customer_Confirmation__c);
                    regCorrection.Registration_Date__c = FormatDate(reg.registrationDate);
                    if(reg.enhancedWarrantyFlag=='True')
                    {
                    regCorrection.Enhanced__c='Yes';
                    }
                    else
                    {
                    regCorrection.Enhanced__c='No';
                    }
                    if(reg.registeredOnTimeFlag=='True')
                    {
                    regCorrection.Registered_On_Time__c= 'Yes';
                    }
                    else
                    {
                    regCorrection.Registered_On_Time__c= 'No';
                    }
                    regCorrection.Registered_By__c= reg.registeredBy;
                    regCorrection.Application__c= reg.application;
                    
                    
                    Equipment__c equip = new Equipment__c();
                    equip.Model__c = reg.model;
                    equip.Serial__c = reg.serial;
                    equip.SB_Reg__c = reg.registrationNumber;
                    equip.Mark_As__c = reg.markAs;
                    equip.Source__c = reg.source;
                    equip.Contract_Number__c = reg.contractNumber;
                    equip.Enhanced_Warranty__c = Boolean.valueof(reg.enhancedWarrantyFlag);
                    if(reg.registeredOnTimeFlag=='True')
                    {
                    equip.Registered_On_Time__c= 'Yes';
                    }
                    else
                    {
                    equip.Registered_On_Time__c= 'No';
                    }
                    equip.Transfer_Date__c = FormatDate(reg.transferDate);
                    equip.UTC_Property_Id__c = reg.propertyId;
                    equip.Brand__c = reg.brand;
                    //equip.Placeholder_for_Business_Unit__c = ;
                    equip.Override_Request__c = false;
                    equip.Confirmation_Number__c = reg.confirmationNumber;
                    
                    if(equip != null){
                        EquipFlag=true;
                    }                               
                    RegcorrecList.add(new cRegCorrection(equip,false));             
                }
                if(regCorrection.Customer_Confirmation__c != null && regCorrection.Customer_Confirmation__c != ''){    
                    System.debug('#Before Confirmation');
                    getRegisteredEquipments();
                    System.debug('#After searchEquipments');
                    selectedRegeNo = '';
                    selectedConfNo = '';
                }
            }else if(regResult != null && regResult.registrationDataResults != null && regResult.registrationDataResults.size() > 1){  
                serialResults = new list<SerialNumberResult>();
                for(RegistrationDataObj reg: regResult.registrationDataResults){                                                
                    if((serialNumbr  != null && serialNumbr != '')){
                        Registration_Correction__c regConf = new Registration_Correction__c();
                        //regConf = regCorrection;
                        regConf.Customer_Confirmation__c = reg.confirmationNumber;
                        regConf.SB_Registration_Number_Search__c = reg.registrationNumber;
                        regConf.Serial_Number_Search__c = reg.serial;
                        regConf.Model_No__c=reg.model;
                        regConf.Contact_Last_Name__c=reg.consumer_Name;               
                        serialResults.add(new SerialNumberResult(regConf,false));                                                    
                    }                                                     
                }
                system.debug('#############---'+serialResults);               
            }                                    
        }
        }Catch(Exception e){
            system.debug('SSSSSSSSSSSSSSSSSSS'+ e);
        }
                                                
    }   
    
    
    public void setSelectedCOnfirmation(){   
        regCorrection.Serial_Number_Search__c = '';
        for(SerialNumberResult seral: serialResults){
            if(seral.selected){
                selectedRegeNo = seral.regRec.SB_Registration_Number_Search__c;
                selectedConfNo= seral.regRec.Customer_Confirmation__c;
            }        
        }
        flag1=true;
        System.debug('#Before setSelectedCOnfirmation');
        getRegisteredEquipments(); 
        System.debug('#After setSelectedCOnfirmation');
        selectedRegeNo = '';
        selectedConfNo = '';
    }
    
    public List<cRegCorrection> getRegisCorrection() {                
        if(RegcorrecList == null) { 
            RegcorrecList = new List<cRegCorrection>();                           
        }
        
        /* Below list will get the existing records of Registration for selected Case on load of constructor */

         objcase=setregoncasevalue(objcase);
         List<Equipment__c>  ctNew= new List<Equipment__c>();
        if(objcase.RegCorrectionOncase__c == True){
            //correct= [Select id,Case_Number__c from Registration_Correction__c where Case_Number__c!=null And Case_Number__c=:objcase.id limit 1];
        
        if(correct!=null){
         ctNew =[select Id,Duplicate_Serial__c,Serial__c,Serial_Correction__c,Registration_Correction__c,Model__c,SB_Reg__c,Mark_As__c,Source__c,Model_Correction__c,Reasoning_for_Removing_Equipment__c,Confirmation_Number__c,Override_Request__c,Brand__c,UTC_Property_Id__c,Enhanced_Warranty__c,Contract_Number__c,Registered_On_Time__c,Transfer_Date__c,Placeholder_for_Business_Unit__c,Registration_Id__c,Picture_of_Nameplate_needed__c  from Equipment__c where Registration_Correction__c=:correct.id ];
                       
        }
        }
        if(ctNew.size() > 0){
        EquipFlag=true;
            for(Equipment__c reg :  ctNew){
                RegcorrecList.add(new cRegCorrection(reg,reg.Duplicate_Serial__c));
                }

        }
        /* If list does not contains records, then add empty instance to wrapper list used on page*/
        else{
            for(Integer i = 1 ; i< 2 ; i++){
                RegcorrecList.add(new cRegCorrection(new Equipment__c()));
            }
        }
           return RegcorrecList;
    } 

    /*Begin addMore*/
    public void addMore1()
    {
        System.debug('#Adding more:'+lstEquipRecords);
        
        if(lstEquipRecords!=null && lstEquipRecords.size()>0){
            Equipment__c latestEquip = lstEquipRecords.get(lstEquipRecords.size()-1);
            System.debug('#latestEquip:'+latestEquip);
            latestEquip.Manual_Add__c = true;
            if(latestEquip.Serial__c!=null && latestEquip.Serial__c.length()>0 && latestEquip.Model__c!=null && latestEquip.Model__c.length()>0 && (latestEquip.Registration_Id__c==null || latestEquip.Registration_Id__c.length()==0)){
                latestEquip.Picture_of_Nameplate_needed__c = false;
            }else{
            	latestEquip.Picture_of_Nameplate_needed__c = true;
            }
            try{
            if(latestEquip!=null && latestEquip.Serial__c!=null && latestEquip.Serial__c.length()>0 && (latestEquip.Model__c==null || latestEquip.Model__c.length()==0)){
                String response = new CCC_IntegrationHelper().getPHDBInformation(null,null,null,null,null,null,null,null,null,null, null,null,null,null,latestEquip.Serial__c,null);
                System.debug('#latest equip resp:'+response);
                JSONParser parser = JSON.createParser(response);
                if(parser != null){
                    RegistrationDataList regResult = (RegistrationDataList)parser.readValueAs(RegistrationDataList.class);
                    if(regResult != null && regResult.registrationDataResults != null){
                        for(RegistrationDataObj reg: regResult.registrationDataResults){
                            latestEquip.Model__c = reg.model;
                            latestEquip.Confirmation_Number__c = reg.confirmationNumber;
                            latestEquip.Registration_Id__c = reg.registrationNumber;
                            if(latestEquip.Serial__c!=null && latestEquip.Serial__c.length()>0 && latestEquip.Model__c!=null && latestEquip.Model__c.length()>0 && (latestEquip.Registration_Id__c==null || latestEquip.Registration_Id__c.length()==0)){
                				latestEquip.Picture_of_Nameplate_needed__c = false;
            				}else{
            					latestEquip.Picture_of_Nameplate_needed__c = true;
            				}
                        }
                    }
                }
            }
            }catch(Exception e){
            	System.debug('#Exception:'+e.getStackTraceString());
                String modelNo = CCC_RegistrationCorrectionUtility.getModelFromSerialSearch(latestEquip.Serial__c);
                if(modelNo!=null && modelNo.length()>0){
                	latestEquip.Model__c = modelNo;
                    if(latestEquip.Serial__c!=null && latestEquip.Serial__c.length()>0 && latestEquip.Model__c!=null && latestEquip.Model__c.length()>0 && (latestEquip.Registration_Id__c==null || latestEquip.Registration_Id__c.length()==0)){
                		latestEquip.Picture_of_Nameplate_needed__c = false;
            		}else{
            			latestEquip.Picture_of_Nameplate_needed__c = true;
            		}
                }
        	}
        }
            
            
        lstEquipRecords.add(new Equipment__c(Registration_Correction__c=correct.id));
    }
    
    public void Del()
    {
        rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
         del=lstEquipRecords.remove(rowIndex);
         delequipList.add(del);
 
        
    }
    
  
    public List<Schema.FieldSetMember> getFieldsRegistration() {
        return SObjectType.Registration_Correction__c.FieldSets.Registration_Details.getFields();
    }

    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Registration_Correction__c.FieldSets.Contact_Information.getFields();
    }
    
     public List<Schema.FieldSetMember> getFirstFields() {
        return SObjectType.Registration_Correction__c.FieldSets.First_Section.getFields();
    }
    
    public List<Schema.FieldSetMember> getFieldsAdministration() {
        return SObjectType.Registration_Correction__c.FieldSets.Administration_Section.getFields();
    }
    public List<Schema.FieldSetMember> getOwnerInformation() {
        return SObjectType.Registration_Correction__c.FieldSets.Owner_Information.getFields();
    }
 

    private Registration_Correction__c getRegisCorrectionFields() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ';

        }
        string whereClause='';
        whereClause += ' Case_Number__c = \'' + objCase.id + '\' ';
        query += 'Id, Customer_Confirmation__c , Contract_Number__c ,Name,Contact_Last_Name__c,Serial_No__c,Model_No__c,SB_Reg__c,Serial_No_correction__c,Model_No_Correction__c,Dealer_Email_Address__c,Dealer_Email_Address1__c,Dealer_Name__c,Dealer_Name1__c,'
                  +' Dealer_Number__c,Dealer_Number1__c ,Application_Type__c ,ApplicationType__c ,Transfer_Date1__c ,Transfer_Date__c,Reasoning_for_Exception_Override__c,Distributor_Name__c, Provide_Confirmation_to__c,Confirmation__c,SB_Registration_Number_Search__c ,Serial_Number_Search__c,Requesting_Override_Enhanced_Exception__c,Registered_On_Time__c,Enhanced__c FROM Registration_Correction__c  WHERE ' + whereClause;
                  system.debug('query...'+Database.query(query));
       try{
        return Database.query(query);
       }
     Catch(exception e){
            system.debug('There are no records in RC Object');
        }
        return null;
    }    
    
    public PageReference save(){        
        
       
        regCorrection.Case_Number__c= objCase.id;
        Boolean isAnyRemoveChecked = false;
        Boolean isAnyOverriedChecked = false;
        if(RegcorrecList!=null && RegcorrecList.size()>0){
            for(cRegCorrection eachEquip : RegcorrecList){
                if(eachEquip.con.Duplicate_Serial__c==true){
                    isAnyRemoveChecked = true;
                    break;
                }
            }
            for(cRegCorrection eachEquip : RegcorrecList){
                if(eachEquip.con.Override_Request__c==true){
                    isAnyOverriedChecked = true;
                    break;
                }
            }
        }
        System.debug('#isAnyRemoveChecked:'+isAnyRemoveChecked);
        System.debug('#isAnyOverriedChecked:'+isAnyOverriedChecked);
        System.debug('#isAnyRemoveChecked:'+regCorrection.Reason_for_Removing_Cancelling__c);
        System.debug('#isAnyRemoveChecked:'+regCorrection.Reasoning_for_Exception_Override__c);
        System.debug('#isAnyRemoveChecked IF:'+regCorrection.Reason_for_Removing_Cancelling__c=='');
        System.debug('#isAnyRemoveChecked IF:'+regCorrection.Reasoning_for_Exception_Override__c=='');
        if(isAnyRemoveChecked && (regCorrection.Reason_for_Removing_Cancelling__c==null || regCorrection.Reason_for_Removing_Cancelling__c=='')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide the Reason for Removing/Cancellation'));
            return null;
        }
        if(isAnyOverriedChecked && (regCorrection.Reasoning_for_Exception_Override__c==null || regCorrection.Reasoning_for_Exception_Override__c=='')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide the Reason to support Override Request'));
            return null;
        }
        if(regCorrection.Requesting_Override_Enhanced_Exception__c==true && (regCorrection.Reasoning_for_Exception_Override__c==null || regCorrection.Reasoning_for_Exception_Override__c==''))
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide the Reason for Exception Override'));
     
        return null;
        }
        
        if(regCorrection.Confirmation__c==true && (regCorrection.Provide_Confirmation_to__c==null || regCorrection.Provide_Confirmation_to__c==''))
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please confirm to whom confirmation needs to be send. Provide a value for "Provide Confirmation to"'));
      
        return null;
        } 
        
        if((regCorrection.Confirmation__c==true) 
            && (regCorrection.Provide_Confirmation_to__c=='Both')
            && ((regCorrection.Homeowner_Emai1__c==null || regCorrection.Homeowner_Emai1__c=='') && (regCorrection.Homeowner_Emai__c==null || regCorrection.Homeowner_Emai__c=='')) 
            && ((regCorrection.Dealer_Email_Address__c==null || regCorrection.Dealer_Email_Address__c=='') && (regCorrection.Dealer_Email_Address1__c==null || regCorrection.Dealer_Email_Address1__c=='')))
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide either "Dealer Email Address" and "Homeowner Email" for confirmation email to be sent '));
      
        return null;
        } 
        
        if(regCorrection.Confirmation__c==true && regCorrection.Provide_Confirmation_to__c=='Dealer' && ((regCorrection.Dealer_Email_Address__c==null || regCorrection.Dealer_Email_Address__c=='') && (regCorrection.Dealer_Email_Address1__c==null || regCorrection.Dealer_Email_Address1__c=='') ))
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide "Dealer Email Address" for confirmation email to be sent '));
      
        return null;
        } 
        
        if(regCorrection.Confirmation__c==true && regCorrection.Provide_Confirmation_to__c=='HomeOwner' && ((regCorrection.Homeowner_Emai1__c==null || regCorrection.Homeowner_Emai1__c=='') && (regCorrection.Homeowner_Emai__c==null || regCorrection.Homeowner_Emai__c=='')))
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide "Homeowner Email" for confirmation email to be sent'));
      
        return null;
        } 
        
        system.debug('!!!!!!!!!!!!!!!!!lstEquipRecords' + lstEquipRecords);
        
             if(regCorrection!=null && correct.Id == null){
            insert regCorrection;
        }
        else{
            upsert regCorrection;
        
        }
        
        if(lstEquipRecords.size()>0){
            
            for (Equipment__c equipment : lstEquipRecords) {
                if (correct.Id != null){
                    equipment.Registration_Correction__c=regCorrection.id;
               }
               else {
                   equipment.Registration_Correction__c=regCorrection.id;            
               }    
            }
            System.debug('#Inserting Equipments');
            upsert lstEquipRecords;
            System.debug('#After Insert Equipments');
        }
         
        if(!isNewProdReg){
            QueueSObject q= [Select Queue.Id from QueueSObject where Queue.Name = 'Warranty 1'];
        	objCase.Ownerid=q.Queue.Id ;
        }
        
        if(regCorrection!=null){
           objCase.RegCorrectionOncase__c=True; 
            
        }
        else{
            objCase.RegCorrectionOncase__c=False; 
        }
        
          
         if(currentUserProfile.Name == 'Tier 1 Agent Profile'){
         objCase.CCC_Purpose_Tier1_CR__c=objCase.CCC_Purpose__c;
         objCase.CCC_Sub_Purpose_Tier1_CR__c=objCase.CCC_Sub_Purpose__c;
         }
        String confirmationNumber = '';
        String contractNumber = '';
        if(RegcorrecList!=null && RegcorrecList.size()>0){
        for(cRegCorrection eachEquip : RegcorrecList){
                confirmationNumber = eachEquip.con.Confirmation_Number__c;
            	contractNumber = eachEquip.con.Contract_Number__c;
            }
         }
        objCase.Customer_Confirmation__c = confirmationNumber!=null?confirmationNumber:'';
        objCase.Service_Bench_Contract_Number__c = contractNumber!=null?contractNumber:'';
        System.debug('#isInternal User:'+isInternalUser);
        if(isInternalUser){
            System.debug('#Inside Origin Update');
            objCase.Origin = 'Community';
        }
        update objCase;
        
        for(cRegCorrection a : RegcorrecList){
        
               
            if(a.con.Registration_Correction__c == null)
            {
            a.con.Registration_Correction__c=regCorrection.id;
            }
            
            lstAllSelectedRecords.add(a.con);
            }
            
           
            
            if(lstAllSelectedRecords.size()>0){
         upsert lstAllSelectedRecords;
         }
        PageReference pf = new PageReference('/'+objCase.Id );
        pf.setRedirect(true);
        return pf;  
        
        //return null;     
    }
    
    /**
    * This method is used for community and will cancel the page, will redirect to case standard detail page.
    * @Developer : Sudheer Reddy
    **/
    public PageReference doCancelCommunity(){
        PageReference pf = new PageReference('/'+objCase.Id );
        pf.setRedirect(true);
        return pf;
    }
    
    
    public class cRegCorrection { 
        public Equipment__c con {get; set;} 
        public Boolean Selected {get; set;}
        public String serialNo {get;set;}

       //This is the constructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false

        public cRegCorrection(Equipment__c c) { 
            con = c;
            selected = false; 
        
        
        }
        
        public cRegCorrection(Equipment__c c,Boolean Sel) { 
            con = c;
            selected = Sel; 
        }
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
    
    
    public void populateDetails(){
        //contact = new Contact();
        if(uniqueEquipmentId !=null){
            reggCorrection = [select Id,Duplicate_Serial__c,Serial__c,Serial_Correction__c,Registration_Correction__c,Model__c,SB_Reg__c,Mark_As__c,Source__c,Reasoning_for_Removing_Equipment__c,Model_Correction__c ,Confirmation_Number__c,Override_Request__c,Brand__c,UTC_Property_Id__c,Enhanced_Warranty__c,Contract_Number__c,Registered_On_Time__c,Transfer_Date__c,Placeholder_for_Business_Unit__c,Registration_Id__c,Picture_of_Nameplate_needed__c 
            from Equipment__c where id =: uniqueEquipmentId ];
        }
    }
    
    public class SerialNumberResult{
        public boolean selected {get;set;}
        public Registration_Correction__c regRec {get;set;}
        public SerialNumberResult(Registration_Correction__c reg,boolean selected){
            this.selected  = selected ;
            this.regRec = reg;            
        }
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
        public String propertyId{get; set;}
        public String brand{get; set;}
        public String contractNumber{get; set;}
        public String equip_FirstName{get; set;}
        public String equip_LastName{get; set;}
        public String equip_BusinessName{get; set;}
        public String equip_Email{get; set;}
        public String registeredBy{get; set;}
        public String application{get; set;}
        public String installationType{get; set;}
        
    }   
    public class wrapperResponse{
        
        public List<serviceEntitlement> EntitleInfo {get;set;}
        public wrapperResponse(List<serviceEntitlement> EntitleInfo){
            this.EntitleInfo= EntitleInfo;
           
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
}