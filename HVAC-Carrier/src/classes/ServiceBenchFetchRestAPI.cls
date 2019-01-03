@RestResource(urlMapping='/ServiceBenchReviewQueue/*')
global with Sharing class ServiceBenchFetchRestAPI {
    
    
    // Create Warranty Claims
    
    /*  global static Warranty_Claim__c createWarrantyClaim(String claimStatus, String claimApptype, String claimComment, String claimNo)
{
System.debug('#claimStatus:'+claimStatus);
System.debug('#claimApptype:'+claimApptype);
System.debug('#claimComment:'+claimComment);
//check if the fields provided on not empty
if(isNotNullOrEmpty(claimStatus) && isNotNullOrEmpty(claimApptype) && isNotNullOrEmpty(claimComment))
{
Warranty_Claim__c newWC = new Warranty_Claim__c();
newWC.Claim_Status__c = claimStatus;
newWC.Application_Type__c = claimApptype;
newWC.Comment__c = claimComment;
newWC.Name = claimNo;

return newWC;         
}
else 
{
System.Debug('Required field values are not provided here');
return null;
}
}

global static boolean isNotNullOrEmpty(string str)
{
return str!=null || !String.isBlank(str); 
} */
    
    @HttpPost 
    global static ResponseHandler doPost(wrapObj warrantyClaimsData)
    {
        
        /*RestRequest request = RestContext.request;        
RestResponse response = RestContext.response;         
String jSONRequestBody=request.requestBody.toString().trim();        
Account accObj = (Account)JSON.deserializeStrict(jSONRequestBody,Account.class); */ 
        
        // Warranty_Claim__c  newWClm =  createWarrantyClaim(wrp.claimStatus, wrp.claimApptype, wrp.claimComment, wrp.claimNo); 
        //if(isNotNullOrEmpty(wrp.claimStatus) && isNotNullOrEmpty(wrp.claimApptype) && isNotNullOrEmpty(wrp.claimComment))
        // {
        Warranty_Claim__c newWC = new Warranty_Claim__c();
        List<Warranty_Claim__c> lstClm = [Select Id from Warranty_Claim__c where Name=:warrantyClaimsData.claimNo order by createddate desc];
        if(lstClm!=null && lstClm.size()>0){
            newWC.Id = lstClm.get(0).Id;
        }
        Parts__c pr;
        
        newWC.Claim_Status__c = warrantyClaimsData.claimStatus;
        newWC.Application_Type__c = warrantyClaimsData.claimApptype;
        newWC.Comment__c = warrantyClaimsData.claimComment;
        newWC.Name = warrantyClaimsData.claimNo;
        newWC.Action__c = warrantyClaimsData.Action;
        newWC.Amount_Approved__c = warrantyClaimsData.AmountApproved; 
        //newWC.Audit_Date__c = warrantyClaimsData.AuditDate; 
        newWC.Bulletin_Authorization_Number__c = warrantyClaimsData.BulletinAuthorizationNo; 
        //  newWC.Causal_Part__c = warrantyClaimsData.CausalPart; 
        newWC.Claim_Submitted_Date__c = warrantyClaimsData.ClaimSubmittedDate; 
        //newWC.Comment_Date__c = warrantyClaimsData.CommentDate; 
        //newWC.Comment_User__c = warrantyClaimsData.CommentUser;  
        newWC.Competitive_Equipment__c = warrantyClaimsData.CompetetiveEquipment; 
        // newWC.Competitor_Part_Y_N__c = warrantyClaimsData.CompetitorPart; 
        newWC.Component_Code__c = warrantyClaimsData.ComponentCode; 
        newWC.Credit_Memo__c = warrantyClaimsData.CreditMemoNo;
        newWC.Date_Paid__c = warrantyClaimsData.DatePaid;
        newWC.Dealer_City__c = warrantyClaimsData.DealerCity;
        newWC.Dealer_Name__c = warrantyClaimsData.DealerName;
        newWC.Dealer_State__c = warrantyClaimsData.DealerState;
        newWC.Dealer_Zip__c = warrantyClaimsData.DealerCode;
        newWC.Defect_Code__c = warrantyClaimsData.DefectCode;
        newWC.Diagnosis__c = warrantyClaimsData.Diagnosis;
        newWC.Distributor_Manufacturing_Account__c = warrantyClaimsData.DistributorMfgAcc;
        newWC.Fail_Date__c = warrantyClaimsData.FailDate;
        // newWC.Failed_Part_Install_Date__c = warrantyClaimsData.FailedPartInstallDate;
        // newWC.Failed_Part_Numbers__c = warrantyClaimsData.FailedPartNumbers;
        // newWC.Failed_Part_Quantity__c = warrantyClaimsData.FailedPartQuantity;
        // newWC.Failed_Part_Serial_Number__c = warrantyClaimsData.FailedPartSerialNo;
        newWC.Install_Startup_Date__c = warrantyClaimsData.InstallStartupDate;
        newWC.Labor_Repair_Type__c = warrantyClaimsData.LaborRepairType;
        newWC.Model__c = warrantyClaimsData.ModelNo;
        newWC.Optional_Contract_Number__c = warrantyClaimsData.OptionalContractNo;
        newWC.Original_Equipment_Owner_Yes_No__c = warrantyClaimsData.OriginalEquipmentOwner;
        // newWC.Part_Mark_Up__c = warrantyClaimsData.PartMarkUp;
        // newWC.Part_Price_Extended__c = warrantyClaimsData.PartPriceExtended;
        newWC.Repair_Date__c = warrantyClaimsData.RepairDate;
        // newWC.Replace_Part_Quantity__c = warrantyClaimsData.ReplacePartQuantity;
        // newWC.Replaced_Part_Number__c = warrantyClaimsData.ReplacedPartNo;
        // newWC.Replaced_Part_Serial_Number__c = warrantyClaimsData.ReplacedPartSerialNo;
        // newWC.Replacement_Approved_Amount__c = warrantyClaimsData.ReplacementApprovedAmount;
        newWC.Replacement_Mark_Up__c = warrantyClaimsData.ReplacementMarkUp;
        newWC.Replacement_Model__c = warrantyClaimsData.ReplacementModelNo;
        newWC.Replacement_Serial_Number__c = warrantyClaimsData.ReplacementSerialNo;
        newWC.Replacement_Unit_Price__c = warrantyClaimsData.ReplacementUnitPrice;
        newWC.Requested_Replacement_Amount__c = warrantyClaimsData.RequestedReplacementAmount;
        //newWC.Review_Reason_Description__c = warrantyClaimsData.ReviewReasonDescription;
        newWC.Review_Reason_s__c = warrantyClaimsData.ReviewReasonNo;  
        newWC.Serial__c = warrantyClaimsData.SerialNo; 
        newWC.Service_Provider_Manufacturing_Account_N__c = warrantyClaimsData.ServiceProviderMfgAcc; 
        newWC.Stock_Unit__c = warrantyClaimsData.StockUnit; 
        //newWC.Unit_Price__c = warrantyClaimsData.UnitPrice;
        newWC.Warranty_Type__c = warrantyClaimsData.WarrantyType;
        newWC.Audit_User__c = warrantyClaimsData.User; 
        newWC.Reason_Codes__c = warrantyClaimsData.reasonCodes;
        newWC.ReviewCompanyId__c = warrantyClaimsData.ReviewCompanyId;
        newWC.Claim_Id__c = warrantyClaimsData.ClaimId;
        
        List<Warranty_Claim__c> listToUpsert = new List<Warranty_Claim__c>(); 
        listToUpsert.add(newWC);
        List<Parts__c> lstpr;
        Set<Parts__c> setpr;
        
        
        ResponseHandler response = new ResponseHandler();
        try
        { 
            if(listToUpsert!=null && listToUpsert.size()>0){
                Schema.SObjectField SerialNo = Warranty_Claim__c.Fields.Serial__c;
                System.debug('#Before Upsert');
                //Database.UpsertResult[] results = Database.upsert(listToUpsert,SerialNo,false);
                Database.UpsertResult[] results = Database.upsert(listToUpsert);
                System.debug('#After Upsert:'+results);           
                //insert newWC;
                lstpr = new List<Parts__c>();
                setpr = new Set<Parts__c>();
                
                if (results[0].isCreated()) {               
                    if(warrantyClaimsData.partDetails!=null){
                        for(partDetails pd : warrantyClaimsData.partDetails){
                            //lstpr = new List<Parts__c>();
                            pr = new Parts__c();
                            pr.Failed_Part_Serial_Number__c = pd.FailedPartSerialNo;
                            pr.Approved_Amount__c = pd.ApprovedAmount;
                            pr.Casual_Part__c = pd.CasualPart;
                            pr.Competitor_Part__c = pd.CompetitorPart;
                            pr.Failed_Part_Install_Date__c = pd.FailedPartInstallDate;
                            pr.Failed_Part_Quantity__c = pd.FailedPartQuantity;
                            //pr.Failed_Part_Serial_Number__c = pd.FailedPartSerialNo;
                            pr.Part_Mark_Up__c = pd.PartMarkUp;
                            pr.Part_Disposition__c = pd.PartDisposition;
                            pr.Part_Price_Extended__c = pd.PartPriceExtended;
                            pr.Replaced_Part_Description__c = pd.ReplacePartDescription;
                            pr.Replaced_Part_Invoice_Number__c = pd.ReplacePartInvoiceNumber;
                            pr.Replaced_Part_Number__c = pd.ReplacedPartNo;
                            pr.Replaced_Part_Serial_Number__c = pd.ReplacedPartSerialNo;
                            pr.Replaced_Part_Quantity__c = pd.ReplacePartQuantity;
                            pr.Unit_Price__c= pd.UnitPrice;
                            pr.Name = pd.FailedPartNo;
                            pr.Warranty_Claim__c = newWC.Id;
                            
                            setpr.add(pr);
                        }
                        
                        lstpr.addAll(setpr);
                        insert lstpr;
                        response.Status = 'Success-Inserted';
                    }else{
                        response.Status = 'Success-Inserted';
                    }    
                }
                else{
                    if(warrantyClaimsData.partDetails!=null){
                        for(partDetails pd : warrantyClaimsData.partDetails){  
                            //lstpr = new List<Parts__c>();
                            pr = new Parts__c();
                            pr.Failed_Part_Serial_Number__c= pd.FailedPartSerialNo;
                            pr.Warranty_Claim__c = newWC.Id;
                            pr.Approved_Amount__c = pd.ApprovedAmount;
                            pr.Casual_Part__c = pd.CasualPart;
                            pr.Competitor_Part__c = pd.CompetitorPart;
                            pr.Failed_Part_Install_Date__c = pd.FailedPartInstallDate;
                            pr.Failed_Part_Quantity__c = pd.FailedPartQuantity;
                            //pr.Failed_Part_Serial_Number__c = pd.FailedPartSerialNo;
                            pr.Part_Mark_Up__c = pd.PartMarkUp;
                            pr.Part_Disposition__c = pd.PartDisposition;
                            pr.Part_Price_Extended__c = pd.PartPriceExtended;
                            pr.Replaced_Part_Description__c = pd.ReplacePartDescription;
                            pr.Replaced_Part_Invoice_Number__c = pd.ReplacePartInvoiceNumber;
                            pr.Replaced_Part_Number__c = pd.ReplacedPartNo;
                            pr.Replaced_Part_Serial_Number__c = pd.ReplacedPartSerialNo;
                            pr.Replaced_Part_Quantity__c = pd.ReplacePartQuantity;
                            pr.Unit_Price__c= pd.UnitPrice;
                            pr.Name = pd.FailedPartNo;
                            setpr.add(pr);
                        }
                        lstpr.addAll(setpr);
                        Schema.SObjectField FailedPartSerialNo = Parts__c.Fields.Failed_Part_Serial_Number__c;             
                        Database.UpsertResult[] resultsPart = Database.upsert(lstpr,FailedPartSerialNo,false);
                        System.debug('resultsPart..'+resultsPart);
                        response.Status = 'Success-Updated';
                    }else{
                        response.Status = 'Success-Updated';
                    }
                }
            }
            
            response.ErrorCode = '';
            response.Message = '';
            response.WarrantyClaimsId = newWC.Id;
            /*if(pr!=null && pr.Id!=null){
response.PartId = pr.Id;
}else{
response.PartId = '';
}*/
            System.debug('#lstpr:'+lstpr);
            if(lstpr!=null && lstpr.size()>0){
                String partIdResp = '';
                for(Parts__c eachSuccessPart : lstpr){
                    if(eachSuccessPart!=null && eachSuccessPart.Id!=null){
                        partIdResp = partIdResp + eachSuccessPart.Id;
                        partIdResp = partIdResp + ';';
                        System.debug('#PartIdResp inside Loop:'+partIdResp);
                    }
                    
                }
                System.debug('#partIdResp outside loop:'+partIdResp);
                if(partIdResp!=null && partIdResp.length()>0){
                    if(partIdResp.endsWith(';')){
                        partIdResp = partIdResp.substring(0, (partIdResp.length()-1));
                    }
                    //response.PartId = partIdResp;
                }
                
                response.PartId = partIdResp;
            }else{
                response.PartId = '';
            }
            
            //response.AuditDate = newWC.Audit_Date__c;
        } 
        catch(DmlException e) 
        {
            //Add custom error code when you could not insert a record
            response.ErrorCode = 'errorCode - 0001';
            response.Status = 'error';
            response.Message = e.getMessage();
            response.WarrantyClaimsId = '';
            response.PartId = '';
        }
        System.debug('response..'+response);
        return response;   
    }
    
    global class ResponseHandler {
        
        //List of custom attributes that we want to check the status of the org
        public String Status {get; set;}
        public String Message {get;set;}
        public String ErrorCode {get; set;}
        public String WarrantyClaimsId {get; set;}
        public String PartId {get; set;}
        //public Date AuditDate {get; set;} 
        
    }
    
    global class wrapObj {
        
        public String Action {get; set;}  
        public Double AmountApproved {get; set;}      
        public String claimApptype {get; set;}      
        public Date AuditDate {get; set;}      
        public String BulletinAuthorizationNo {get; set;}
        // public String CausalPart {get; set;}
        public String ClaimStatus {get; set;}
        public Date ClaimSubmittedDate {get; set;}
        public DateTime CommentDate {get; set;}
        public String CommentUser {get; set;}
        public String claimComment {get; set;}
        public String CompetetiveEquipment {get; set;}
        public Boolean CompetitorPart {get; set;}
        public String ComponentCode {get; set;}
        public String CreditMemoNo {get; set;}
        public Date DatePaid {get; set;}
        public String DealerCity {get; set;}
        public String DealerName {get; set;}
        public String DealerState {get; set;}
        public String DealerCode {get; set;}
        public String DefectCode {get; set;}
        public String Diagnosis {get; set;}
        public String DistributorMfgAcc {get; set;}
        public Date FailDate {get; set;}  
        public Date FailedPartInstallDate {get; set;}  
        //  public String FailedPartNumbers {get; set;}
        //  public Double FailedPartQuantity {get; set;}
        //  public String FailedPartSerialNo {get; set;}
        public Date InstallStartupDate {get; set;}
        public String LaborRepairType {get; set;}
        public String ModelNo {get; set;}
        public String claimNo {get; set;}
        public String OptionalContractNo {get; set;}
        public String OriginalEquipmentOwner {get; set;}
        //   public Double PartMarkUp {get; set;}
        //   public Double PartPriceExtended {get; set;}
        public Date RepairDate {get; set;}
        //   public Double ReplacePartQuantity {get; set;}
        //   public String ReplacedPartNo {get; set;}
        //   public String ReplacedPartSerialNo {get; set;}
        //   public Double ReplacementApprovedAmount {get; set;}
        public Double ReplacementMarkUp {get; set;}
        public String ReplacementModelNo {get; set;}
        public String ReplacementSerialNo {get; set;}
        public Double ReplacementUnitPrice {get; set;}
        public Double RequestedReplacementAmount {get; set;}
        public String ReviewReasonDescription {get; set;}
        public Double ReviewReasonNo {get; set;}
        public String SerialNo {get; set;}
        public String ServiceProviderMfgAcc {get; set;}
        public String StockUnit {get; set;}
        //   public Double UnitPrice {get; set;}
        public String WarrantyType {get; set;}
        public String User {get; set;}
        
        public List<partDetails> partDetails{get; set;}
        public String reasonCodes{get; set;}
		public String ReviewCompanyId {get; set;}
        public String ClaimId{get; set;}        
    }  
    
    global class partDetails{
        public String FailedPartSerialNo{get; set;}
        public Double ApprovedAmount{get; set;}
        public Boolean CasualPart {get; set;}
        public Boolean CompetitorPart {get; set;}
        public Date FailedPartInstallDate {get; set;}
        public String FailedPartQuantity {get; set;}
        public Double PartMarkUp {get; set;}
        public String PartDisposition {get; set;}
        public Double PartPriceExtended {get; set;}
        public String ReplacePartDescription {get; set;}
        public Double ReplacePartInvoiceNumber {get; set;}
        public String ReplacedPartNo {get; set;}
        public String ReplacedPartSerialNo {get; set;}
        public Double ReplacePartQuantity {get; set;}
        public Double UnitPrice {get; set;}
        public String FailedPartNo {get; set;}
        
        
    }
}