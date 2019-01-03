/**
* @ Developer     : Ishita Sharma
* @date_created   : 4/2/2016
* @functions      : 
*
***/

public class NewOrEditProductRegistrationController {


    /*Variable Declarations*/ 
    public Registration_Correction__c regCorrection { get; set; }
    public List<cRegCorrection> RegcorrecList {get; set;}
    Public boolean EquipFlag{get;set;}
    public case objCase{get;set;}
    public List<Equipment__c> lstAllSelectedRecords = new List<Equipment__c>();
    public List<Equipment__c> reggCorrection = new List<Equipment__c>();
    public Id uniqueEquipmentId {get;set;}
    public list<RegistrationDataObj> registrationDataReslts;
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
    public String redirectURL{get; set;}
    public String confNo{get; set;}
    public String sbRegnNo{get; set;}
    public String serialNo{get; set;}
    
    public Case setregoncasevalue(Case caseobject) {
        objCase=[Select id,RegCorrectionOncase__c,CCC_Purpose__c,CCC_Sub_Purpose__c,CCC_Purpose_Tier1_CR__c,CCC_Sub_Purpose_Tier1_CR__c,Description from Case where id=:caseobject.id];
        return objCase;
    }

    
    public NewOrEditProductRegistrationController(ApexPages.StandardController controller) {  
        objCase =   (Case)controller.getRecord();    
        

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
            reggCorrection = [select Id,Duplicate_Serial__c,Serial__c,Serial_Correction__c,Registration_Correction__c,Model__c,SB_Reg__c,Mark_As__c,Source__c,Reasoning_for_Removing_Equipment__c,Model_Correction__c 
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
    }   
}