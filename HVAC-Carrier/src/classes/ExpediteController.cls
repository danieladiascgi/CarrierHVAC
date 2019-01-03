public class ExpediteController {
    public Id caseId{get; set;}
    public Expedite__c ex {get; set;}
    public Boolean verified { get; private set;}
    public Expedite__c caseRec{get; set;}
    public Map<String, String> mapTbkIdKeyTbkTitleValue{get; set;}
    public Map<String, Turnback__c> mapTbIdKeyTbkValue{get; set;}
    public String selectedId{get; set;}
    public Turnback__c tbk{get; set;}
    public Boolean renderSave{get; set;}
    public ExpediteController(ApexPages.StandardController controller)
    {
        CaseId =apexpages.currentPage().getparameters().get('caseid');
        ex =new Expedite__c();
        System.debug('#Case Id in Const:'+caseid);
        Case c= [ SELECT Id,CaseNumber,New_Comment__c,AccountId,ContactId,New_Msg__c,Description,
                 CCC_Date_Time_Assigned__c,Flag_Comments__c,LastModifiedDate,LastModifiedBy.Name,
                 isClosed,CreatedDate, Subject, CCC_SAP_Order__c, Priority, 
                 Status,OwnerId,Owner.Name,RecordTypeId,recordtype.name,Origin,To_Address__c,
                 SuppliedEmail,CCC_Brand__c,CCC_Customer_Type__c,Parent.CaseNumber,CreatedBy.Name,ZSM__c,
                 Phone_Number__c,CCC_Part__c,CCC_Part_Number__c,CCC_Part_Quantity__c,CCC_Part_Description__c,
                 CCC_Planner__c,CCC_Product_Buyer__c,CCC_Vendor_Name__c,CCC_Stocking_Type__c,Material__c,
                 CCC_C10Order__c,CCC_Customer_PO__c,CCC_RCD_PO__c,CCC_Quote__c,CCC_RMA__c,CCC_RMA_Sent__c,CCC_Invoice__c,
                 CCC_Model_Number__c,CCC_Serial_Number__c,CCC_Expedite_Status__c,CCC_Commit_Time__c,CCC_Vendor_Ship_Date__c,
                 CCC_Vendor_Tracking__c,CCC_Days_Open__c,CCC_Solution__c,CCC_Time_to_Closure__c,CCC_Turn_Back_Code__c,Order__c,
                 Claims_Purpose__c,Claims_Sub_Purpose__c,Claims_Order_Type__c,CCC_Vendor_Code__c,Reason__c,Expedite_Record_Is_present__c
                 from case where Id=:CaseId];
        System.debug('#Case Queried:'+c);
        ex.Subject__c = c.Subject;
        ex.Description__c=c.Description;
        ex.Priority__c= c.Priority;
        ex.Account_Name__c= c.AccountId;
        ex.Commit_Time__c=c.CCC_Commit_Time__c;
        ex.Contact_Name__c=c.ContactId;
        ex.Customer_PO__c=c.CCC_Customer_PO__c;
        ex.Customer_Type__c=c.CCC_Customer_Type__c;
        ex.Expedite_Status__c='Expedite';
        ex.Invoice__c=c.CCC_Invoice__c;
        ex.Material__c=c.Material__c;
        ex.Model__c=c.CCC_Model_Number__c;
        ex.New_Msg__c=c.New_Msg__c;
        ex.Part_Description__c=c.CCC_Part_Description__c;
        ex.Phone_Number__c=c.Phone_Number__c;
        ex.Priority__c=c.Priority;
        ex.Serial__c=c.CCC_Serial_Number__c;
        ex.Vendor_Ship_Date__c=c.CCC_Vendor_Ship_Date__c;
        ex.Vendor_Tracking__c=c.CCC_Vendor_Tracking__c;
        ex.Vendor_Code__c=c.CCC_Vendor_Code__c;
        ex.Vendor_Name__c=c.CCC_Vendor_Name__c;
        ex.Commit_Time__c=c.CCC_Commit_Time__c;
        ex.Quote__c=c.CCC_Quote__c;
        ex.Stocking_Type__c=c.CCC_Stocking_Type__c;
        ex.Case_Number__c=c.Id;
        ex.Source__c=c.Origin;
        selectedId = '';
        
        List<Expedite__c> expedite = [select Part_Number__c,Quantity__c,Part_Description__c from Expedite__c where Case_Number__c=:c.Id ];
        system.debug('*******expedite*******'+expedite);
        if(expedite!=null && expedite.size()>0)
        {
            system.debug('Inside if part number');
            ex.Part_Number__c=null;
            ex.Quantity__c=null;
            ex.Part_Description__c=null;
            ex.Part__c=null;
            ex.C10_Order__c =null;
            ex.RCD_PO__c=null;
            ex.Buyer__c=null;
            ex.Planner__c=null;
            ex.Vendor_Code__c=null;
            ex.Vendor_Name__c=null;
            
        }
        else
        {
            ex.Part_Number__c=c.CCC_Part_Number__c;
            ex.Quantity__c=c.CCC_Part_Quantity__c;
            ex.Part_Description__c=c.CCC_Part_Description__c;
            ex.Part__c=c.CCC_Part__c;
            ex.C10_Order__c =c.CCC_C10Order__c;
            ex.RCD_PO__c=c.CCC_RCD_PO__c;
            ex.Buyer__c=c.CCC_Product_Buyer__c;
            ex.Planner__c=c.CCC_Planner__c;
            ex.Vendor_Code__c=c.CCC_Vendor_Code__c;
            ex.Vendor_Name__c=c.CCC_Vendor_Name__c;
            
        }
        
        
        if(c.ContactId!=null)
        {
            system.debug('inside contact if');
            List<contact> contactemail= [select id,email from contact where id=:c.ContactId limit 1];
            for(contact cc:contactemail)
            {
                ex.Sender_s_Email__c=cc.email; 
            }
            system.debug('ex.Sender_s_Email__c'+ex.Sender_s_Email__c);  
         }
        
        List<Turnback__c> turnbacks = [Select Id, Title__c, Case_Count__c from Turnback__c where Title__c=:c.CCC_Turn_Back_Code__c and Status__c != 'Closed' limit 1];
        if(turnbacks!=null && turnbacks.size()>0){
            tbk = turnbacks.get(0);
            selectedId = tbk.Id;
        }
    }
    
    public List<SelectOption> getTurnbackOptions() {
        mapTbkIdKeyTbkTitleValue = new Map<String, String>();
        mapTbIdKeyTbkValue = new Map<String, Turnback__c>();
        List<Turnback__c> trnbcks = new List<Turnback__c>();
        trnbcks = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Expedite__c=true and Status__c != 'Closed' order by Title__c asc];
        System.debug('RC :' +trnbcks);
        List<SelectOption> channelOptions = new List<SelectOption>();
       
        if(trnbcks!=null && trnbcks.size()>0){
            for(Turnback__c tbk : trnbcks){
                System.debug('#TurnbackMap:'+mapTbkIdKeyTbkTitleValue);
                mapTbkIdKeyTbkTitleValue.put(tbk.Id, tbk.Title__c);
                mapTbIdKeyTbkValue.put(tbk.Id, tbk);
                channelOptions.add(new SelectOption(tbk.Id,tbk.Title__c));
            }
            
        }
        System.debug('#channelOptions Before:'+channelOptions);
        System.debug('#selectedId:'+selectedId);
        System.debug('#mapTbIdKeyTbkValue.containsKey(selectedId):'+mapTbIdKeyTbkValue.containsKey(selectedId));
        System.debug('#tbk:'+tbk);
        if(mapTbIdKeyTbkValue!=null && !mapTbIdKeyTbkValue.containsKey(selectedId)){
            if(selectedId!=null && selectedId.length()>0){
                channelOptions.add(new SelectOption(tbk.Id,tbk.Title__c));
            }
        }
        System.debug('#channelOptions:'+channelOptions);
        return channelOptions;  
    }
    public void save(){
        caseRec.Turnback__c = mapTbkIdKeyTbkTitleValue.get(selectedId);
        Turnback__c tbkToUpdate = mapTbIdKeyTbkValue.get(selectedId);
        System.debug('#tbkToUpdate:'+tbkToUpdate);
        if(tbkToUpdate!=null){
            if(tbkToUpdate.Case_Count__c!=null){
                tbkToUpdate.Case_Count__c = tbkToUpdate.Case_Count__c+1;
            }else{
                tbkToUpdate.Case_Count__c = 1;
            }
            
        }
        
        update caseRec;
        if(tbkToUpdate!=null){
            update tbkToUpdate;
        }    
        renderSave = false;
        
    }
    
    public PageReference showSave(){
        System.debug('#Coming here');
        renderSave = true;
        return null;
    }
    
   public void init(){
    }
   public PageReference customSave(){
     insert ex;
     System.debug('Expedite');
     PageReference pgRef = new PageReference('/' +ex.Id );
     pgRef.setRedirect(true);
     return pgRef;
        
   }
}