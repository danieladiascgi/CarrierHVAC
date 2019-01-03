public class CloseCaseTurnbackController {
    public Case caseRec{get; set;}
    public Map<String, String> mapTbkIdKeyTbkTitleValue{get; set;}
    public Map<String, Turnback__c> mapTbIdKeyTbkValue{get; set;}
    public String selectedId{get; set;}
    public Turnback__c tbk{get; set;}
    public boolean isCommunityUser{get;set;}
    
    public CloseCaseTurnbackController(ApexPages.StandardController cont){
        caseRec = (Case)cont.getRecord();
        
        selectedId = '';
        caseRec = [SELECT AccountId,RecordType.Name,Action_Plan__c,AssetId,AssignToDSM__c,BusinessHoursId,Call_back__c,CaseNumber,Cases__c,CCC_Additional_Comments_on_this_Claim__c,CCC_Additional_Comments__c,CCC_Add_to_Confirmation__c,CCC_Amount__c,CCC_Application_Type__c,CCC_Area__c,CCC_At_Job_Site__c,CCC_Billing_Flag__c,CCC_Brand__c,CCC_Bulletin__c,CCC_Business_Unit__c,CCC_C10Order__c,CCC_Cancel_Contract__c,CCC_Cancleation_Reason__c,CCC_case_tenure__c,CCC_Claim_dispositioned__c,CCC_Claim_processed__c,CCC_Claim_Type__c,CCC_Claim__c,CCC_Commit_Time__c,CCC_Contract_End_Date__c,CCC_Contract_Number__c,CCC_Contract_Start_Date__c,CCC_Contract__c,CCC_Customer_PO__c,CCC_Customer_Sub_Type__c,CCC_Customer_Type__c,CCC_DataLoad_Execution_Date__c,CCC_Date_Code__c,CCC_Date_Time_Assigned__c,CCC_Days_Open__c,CCC_Dealer_Change__c,CCC_Dealer_Name__c,CCC_Dealer_s_Email__c,CCC_Dealer_s_Phone_No__c,CCC_Defect_Code__c,CCC_Defect_Sub_Code__c,CCC_Distributor_Name__c,CCC_Distributor_s_Email__c,CCC_Distributor_s_Name__c,CCC_Distributor_s_Phone_No__c,CCC_DSM_Contact__c,CCC_DSM__c,CCC_Equipment_Add_Correction__c,CCC_Equipment_Category__c,CCC_Equipment_Purpose__c,CCC_Expedite_Status__c,CCC_Fetch_Queue_Time_16_Hrs__c,CCC_Fetch_Queue_Time__c,CCC_File_Name__c,CCC_First_Contact_Date__c,CCC_High_Profile_Job__c,CCC_Home_Owner_Transfer__c,CCC_Incoming_Email__c,CCC_Installation_date__c,CCC_Installer_Name__c,CCC_Installer_Phone__c,CCC_International__c,CCC_Invoice__c,CCC_IsCreatedByDSM_Warranty__c,CCC_IsHistory__c,CCC_Job_Name__c,CCC_Job_Site_Address__c,CCC_Manufacturer_Warranty_Flag__c,CCC_Minimum_Efficiency_Standards__c,CCC_Missing_Commercial_Contract__c,CCC_Model_Number__c,CCC_Model__c,CCC_New_Model_Number__c,CCC_New_Serial_Number__c,CCC_Optional_Contract__c,CCC_Part_Description__c,CCC_Part_Number__c,CCC_Part_Quantity__c,CCC_Part__c,CCC_Planner__c,CCC_Preauthorization_Amount__c,CCC_Product_Buyer__c,CCC_Product_Group_Code__c,CCC_Progressive_Claiming__c,CCC_Purpose_Tier1_CR__c,CCC_Purpose__c,CCC_Quote__c,CCC_RCD_PO__c,CCC_Reason_Description__c,CCC_Rebate_Amounts__c,CCC_RecordTypeName__c,CCC_Report_denied_and_Requestor_informed__c,CCC_Report_generated_requestor__c,CCC_RMA_Sent__c,CCC_RMA__c,CCC_Safety_Issue__c,CCC_SAP_Invoice__c,CCC_SAP_Order__c,CCC_Serial_Number__c,CCC_Service_Date__c,CCC_Service_Provider__c,CCC_Siebel_Row_Id__c,CCC_Solution__c,CCC_Status_Color__c,CCC_Stocking_Type__c,CCC_Sub_Purpose_Tier1_CR__c,CCC_Sub_Purpose__c,CCC_Supporting_Comments__c,CCC_Time_to_Closure__c,CCC_Time_to_First_Contact__c,CCC_TSM_User__c,CCC_Turn_Back_Code__c,CCC_UTC_No_Schedule_date__c,CCC_Vendor_Code__c,CCC_Vendor_Name__c,CCC_Vendor_Ship_Date__c,CCC_Vendor_Tracking__c,CCC_WAF_Preauthorization__c,CCC_WarrantyCommunity_Purpose__c,CCC_WarrantyCommunity_Sub_Purpose__c,CCC_Warranty_Certificate__c,CCC_Warranty_End_Date__c,CCC_Warranty_Start_Date__c,CCC_Warranty_Type__c,Claims_Adjuster_Email__c,Claims_Adjuster_Name__c,ClosedDate,CommunityId,Component__c,Concession_Type__c,Concession__c,ContactEmail,ContactFax,ContactId,ContactMobile,ContactPhone,Coupoun__c,CreatedById,CreatedDate,CreatorFullPhotoUrl,CreatorName,CreatorSmallPhotoUrl,Current_State__c,Customer_Confirmation__c,Date_and_Time_1st_Contact_Attempt__c,Date_and_Time_1st_Contact_Made__c,Date_Received__c,Date_Time_Assigned_Template__c,Days_Since_Assigned__c,Description,EntitlementId,Executive_Contact__c,Executive__c,Flags__c,Frequency__c,HasCommentsUnreadByOwner,HasSelfServiceComments,Reason,Internal_Comments__c FROM Case where Id=:caseRec.id];
        System.debug('#caseRec.CCC_Turn_Back_Code__c:'+caseRec.CCC_Turn_Back_Code__c);
        List<Turnback__c> turnbacks = [Select Id, Title__c, Case_Count__c from Turnback__c where Title__c=:caseRec.CCC_Turn_Back_Code__c and Status__c != 'Closed' limit 1];
        if(turnbacks!=null && turnbacks.size()>0){
            tbk = turnbacks.get(0);
            selectedId = tbk.Id;
        }
        System.debug('#tbk:'+tbk);
        
        System.debug('#selectedId:'+selectedId);
        
        caseRec.status='Closed';
        isCommunityUser = false;
        User user1 = [select Id,Profile.UserLicense.Name from User where Id = :userinfo.getUserId() limit 1];
        Set<String> allPartnerProfiles = GeneralUtility.getAllCommunityProfilesList();
        System.debug('#Liscence:'+allPartnerProfiles.contains(user1.Profile.UserLicense.Name));
        if(allPartnerProfiles!=null && !allPartnerProfiles.contains(user1.Profile.UserLicense.Name)){
            isCommunityUser = true;
        }
    }

public List<SelectOption> getStatusOptions() {

       System.debug('#caseRec.RecordType.Name:'+caseRec.RecordType.Name);
    
        List<SelectOption> statusOptions = new List<SelectOption>();
            
        statusOptions.add(new SelectOption('Closed','Closed'));
        statusOptions.add(new SelectOption('Re-open','Re-open'));
    
        return statusOptions;
    }
    
    public List<SelectOption> getResolutionCodeOptions(){
        
        List<SelectOption> resolutionCodeOptions = new List<SelectOption>();
        
        resolutionCodeOptions.add(new SelectOption('','-None-'));
        resolutionCodeOptions.add(new SelectOption('Changes/Corrections Made as Requested','Changes/Corrections Made as Requested'));
        resolutionCodeOptions.add(new SelectOption('Customer canceled request','Customer canceled request'));
        resolutionCodeOptions.add(new SelectOption('Dealer Referral','Dealer Referral'));
        resolutionCodeOptions.add(new SelectOption('Distributor Referral','Distributor Referral'));
        resolutionCodeOptions.add(new SelectOption('DSM Referral','DSM Referral'));
        resolutionCodeOptions.add(new SelectOption('In as help/information/training provided','In as help/information/training provided'));
        resolutionCodeOptions.add(new SelectOption('Item added to PHDB/ServiceBench','Item added to PHDB/ServiceBench'));
        resolutionCodeOptions.add(new SelectOption('Not enough information provided, closing','Not enough information provided, closing'));
        resolutionCodeOptions.add(new SelectOption('Other External Referral/Escalation','Other External Referral/Escalation'));
        resolutionCodeOptions.add(new SelectOption('RSM Referral','RSM Referral'));
        resolutionCodeOptions.add(new SelectOption('TSM Referral','TSM Referral'));
        
        return resolutionCodeOptions;
    }

    public void saveAndRedirect(){
        System.debug('#saveAndRedirect');
        /*TB Changes Start*/
        System.debug('#NA TB:'+mapTbkIdKeyTbkTitleValue.get(selectedId));
        System.debug('#NA TB Cond:'+mapTbkIdKeyTbkTitleValue.get(selectedId).equalsIgnoreCase('Not Applicable'));
        if(caseRec.RecordType.Name=='Warranty' && mapTbkIdKeyTbkTitleValue.get(selectedId).equalsIgnoreCase('Not Applicable')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Warranty Case cannot have "Not Applicable" turnback value.'));
            //return null;
        }
        caseRec.CCC_Turn_Back_Code__c = mapTbkIdKeyTbkTitleValue.get(selectedId);
        Turnback__c tbkToUpdate = mapTbIdKeyTbkValue.get(selectedId);
        System.debug('#tbkToUpdate:'+tbkToUpdate);
        if(tbkToUpdate!=null){
            if(tbkToUpdate.Case_Count__c!=null){
                tbkToUpdate.Case_Count__c = tbkToUpdate.Case_Count__c+1;
            }else{
                tbkToUpdate.Case_Count__c = 1;
            }
            
        }
        
        //update caseRec;
        if(tbkToUpdate!=null){
        	update tbkToUpdate;
        }    
        /*TB Changes End*/
        System.debug('#CaseRec To Update:'+caseRec);
        upsert caseRec;
        /*TB Changes Start*/
        update tbkToUpdate;
        /*TB Changes End*/
         //PageReference redirectPage = new PageReference('/apex/Turnback_search?caseid='+caseRec.Id);
        //PageReference redirectPage = new PageReference('/apex/Search_Turnback_Latest?caseid='+caseRec.Id);
        PageReference redirectPage = new PageReference('/apex/SearchTB?caseid='+caseRec.Id);
        redirectPage.setRedirect(true);
    //redirectPage.getParameters().put('id',caseRec.Id);
    //return redirectPage;
    }
    public void saveAndClose(){
        /*TB Changes Start*/
        System.debug('#Case Type Name:'+caseRec.RecordType.Name);
        //System.debug('#NA TB:'+mapTbkIdKeyTbkTitleValue.get(selectedId));
        //System.debug('#NA TB Cond:'+mapTbkIdKeyTbkTitleValue.get(selectedId).equalsIgnoreCase('Not Applicable'));
        //System.debug('#NA TB Cond Final:'+(caseRec.RecordType.Name=='Warranty' && mapTbkIdKeyTbkTitleValue.get(selectedId).equalsIgnoreCase('Not Applicable')));
        if(caseRec.RecordType.Name=='Warranty' && (mapTbkIdKeyTbkTitleValue.get(selectedId)==null || mapTbkIdKeyTbkTitleValue.get(selectedId).equalsIgnoreCase('Not Applicable'))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Warranty Case cannot have "Not Applicable" turnback value.'));
            //return null;
        }
        caseRec.CCC_Turn_Back_Code__c = mapTbkIdKeyTbkTitleValue.get(selectedId)!=null?mapTbkIdKeyTbkTitleValue.get(selectedId):'';
        Turnback__c tbkToUpdate = mapTbIdKeyTbkValue.get(selectedId);
        System.debug('#tbkToUpdate:'+tbkToUpdate);
        if(tbkToUpdate!=null){
            if(tbkToUpdate.Case_Count__c!=null){
                tbkToUpdate.Case_Count__c = tbkToUpdate.Case_Count__c+1;
            }else{
                tbkToUpdate.Case_Count__c = 1;
            }
            
        }
        
        //update caseRec;
        if(tbkToUpdate!=null){
        	update tbkToUpdate;
        }    
        /*TB Changes End*/
        /*TB Changes Start*/
        //update tbkToUpdate;
        /*TB Changes End*/
        System.debug('#CaseRec To Update:'+caseRec);
        upsert caseRec;
        PageReference redirectPage = new PageReference('/'+caseRec.Id);
        redirectPage.setRedirect(true);
        //return redirectPage;
    }
    public PageReference cancel(){
        PageReference pr = new PageReference('/'+caseRec.Id);
        pr.setRedirect(true);
        return pr;
    }
    public List<SelectOption> getTurnbackOptions() {
        mapTbkIdKeyTbkTitleValue = new Map<String, String>();
        mapTbIdKeyTbkValue = new Map<String, Turnback__c>();
        //selectedId = '';
      /*  List<case> c = new List<case>();
        c = [Select RecordType.Name from case];
        System.debug('RecordType.Name:'+c);*/
        
        List<Turnback__c> trnbcks = new List<Turnback__c>();
       
        IF(caseRec.RecordType.Name =='Replacement Component (RC)')
        {
         
          trnbcks = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Replacement_Component_RC__c=true and Status__c != 'Closed'];
             System.debug('RC :' +trnbcks);
           /* trnbcks = [Select Id,Name,Type__c,Sub_Type__c, Title__c,Case_Count__c from Turnback__c where Consumer_Relations__c=true and Status__c != 'Closed'];
            System.debug('Consumer_Relations :' +trnbcks);*/
        }else if(caseRec.RecordType.Name == 'Consumer Relations'){
            trnbcks = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Consumer_Relations__c=true and Status__c != 'Closed'];
        }else if(caseRec.RecordType.Name == 'Channel'){
            trnbcks = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Channel__c=true and Status__c != 'Closed'];
        }else if(caseRec.RecordType.Name == 'Replacement Component(RC)'){
            trnbcks = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Replacement_Component_RC__c=true and Status__c != 'Closed'];
             System.debug('RC :' +trnbcks);
        } else if(caseRec.RecordType.Name == 'Post Sale Support'){
            trnbcks = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Post_Sale_Support__c=true and Status__c != 'Closed' order by Title__c asc];
            System.debug('Post Sale Support :' +trnbcks);
        } else if(caseRec.RecordType.Name == 'Product Registration'){
            trnbcks = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Product_Registration__c=true and Status__c != 'Closed' order by Title__c asc];
        } else if(caseRec.RecordType.Name == 'Warranty'){
           trnbcks = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Warranty__c=true and Status__c != 'Closed'];
        }        
        //List<Turnback__c> trnbcks = [Select Id, Name,Type__c,Sub_Type__c  from Turnback__c where Channel__c=true];
        
        List<SelectOption> channelOptions = new List<SelectOption>();
        
        if(trnbcks!=null && trnbcks.size()>0){
            for(Turnback__c tbk : trnbcks){
                mapTbkIdKeyTbkTitleValue.put(tbk.Id, tbk.Title__c);
                mapTbIdKeyTbkValue.put(tbk.Id, tbk);
                channelOptions.add(new SelectOption(tbk.Id,tbk.Title__c));
            }
            
        }
        System.debug('#tbk before options:'+tbk);
        if(mapTbIdKeyTbkValue!=null && !mapTbIdKeyTbkValue.containsKey(selectedId)){
            if(selectedId!=null && selectedId.length()>0){
                channelOptions.add(new SelectOption(tbk.Id,tbk.Title__c));
            }
        }
        System.debug('#channelOptions:'+channelOptions);
        
        
        
      return channelOptions;  
    }
}