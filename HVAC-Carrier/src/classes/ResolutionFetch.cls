public with sharing class ResolutionFetch {
    @AuraEnabled
    public static Map<String, Picklists_Control__c> purposePicklistForEquipment{get; set;}
    @AuraEnabled
    public static Map<String, Picklists_Control__c> subPurposePicklistForEquipment{get; set;}
    @AuraEnabled
    public static Map<String, List<String>> contrlKeyLstOfDepend{get; set;}
    @AuraEnabled
    public static List<Case> lstCase {get;set;}
    @AuraEnabled
    public static List<Purpose__c> lstResCount {get;set;}
    @AuraEnabled
    public static String s {get;set;} 
    @AuraEnabled
    public static String caseowner {get;set;} 
    
    @AuraEnabled
    public static Boolean getPurposeCount(Id id){
        Boolean flag;
        flag = false;
        
        Integer i = 0;
        system.debug('id'+id);
        lstResCount = new list<Purpose__c>();
        Case cse = [Select Id,Claims_Purpose__c, Claims_Sub_Purpose__c,Is_Claim__c from Case where Id=:id];
        if(!cse.Is_Claim__c){
            lstResCount = [SELECT Id, Count__c FROM Purpose__c where  Case__c =:id]; 
            system.debug('lstResCount'+lstResCount);
            system.debug('lstResCount'+lstResCount.size());
            if(lstResCount != null && lstResCount.size()>0)
            { 
                for(i = 0 ;i<lstResCount.size();i++)
                {
                    if(lstResCount[i].Count__c !=0){
                        flag = true;
                        break;
                    }
                   
                }
                system.debug('flag1'+flag);
                //return flag;
               
            }
            else{
                
                system.debug('flag2'+flag);
                //return flag;
            } 
        }else{
            if(cse.Claims_Purpose__c!=null && cse.Claims_Purpose__c!='' && cse.Claims_Sub_Purpose__c!=null && cse.Claims_Sub_Purpose__c!=''){
                flag=true;
            }else{
                flag=false;
            }
        }  
        return flag;
    }
    
    @AuraEnabled
    public static Boolean getClaimCases(Id id){
        Boolean claimFlag;
        Integer i = 0;
        system.debug('id'+id);
        lstResCount = new list<Purpose__c>();
        Case cse = [Select Id,Claims_Purpose__c, Claims_Sub_Purpose__c,Is_Claim__c from Case where Id=:id];
      
            if(!cse.Is_Claim__c){
                claimFlag=false;
            }else{
                claimFlag=true;
            }
          
        return claimFlag;
    }
    
    @AuraEnabled
     public static Boolean getContactVal(Id id){
        
        Id cntId = [SELECT Id, ContactId FROM Case where  Id =:id].ContactId; 
       System.debug('cntId..'+cntId);
        if(cntId != null)
        {             
            return true;           
        }
        else{            
            return false;
        } 
    }
    
    @AuraEnabled
    public static String getRecordType(String id){
        lstCase = new List<Case>();
        lstCase = [SELECT RecordType.Name FROM Case where id = :id];
        s = lstCase[0].RecordType.Name;
        System.debug('s..'+s);
        return s;       
    }
    
    @AuraEnabled
    public static String getCaseOwner(String id){
        lstCase = new List<Case>();
        lstCase = [SELECT Id,OwnerId,Owner.Name FROM Case where id = :id];
        caseowner = lstCase[0].OwnerId;
        System.debug('caseowner'+caseowner);
        return caseowner;       
    }
    
    @AuraEnabled
    public static Case getCase(Id id) {
        System.debug('#id:'+id);
        Case C = [
            SELECT Id,Origin,Reason, CCC_Solution__c,CCC_Turn_Back_Code__c,Status,Internal_Comments__c,CCC_Purpose__c, CCC_Sub_Purpose__c,CCC_Defect_Code__c,CCC_Defect_Sub_Code__c
            FROM Case
            WHERE Id = :id
        ];
        
        System.debug('#Case Queried:'+c);
        return C;
    }
    
    @AuraEnabled
    public static list<String> getResolutionCode(Id id) {
        System.debug('#id11:'+id);
        List<Picklists_Control__c> reasonList = new List<Picklists_Control__c>();
        List<String>lstReasons = new List<String>();
        String recordTypeName = [Select Id, RecordType.Name from Case where id=:id].RecordType.Name; 
        IF(recordTypeName =='Replacement Component (RC)')
        {
            reasonList = [SELECT Id,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= 'CCC_Replacement_Component' and Picklist_Field_Name__c='Reason'order by Order__c asc];
        }
        IF(recordTypeName =='Equipment'){
            reasonList = [SELECT Id,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= 'Equipment' and Picklist_Field_Name__c='Reason'order by Order__c asc]; 
        }
        IF(recordTypeName =='Channel'){
            reasonList = [SELECT Id,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= 'CCC_Channel' and Picklist_Field_Name__c='Reason'order by Order__c asc]; 
        }
        for(Picklists_Control__c pc : reasonList){
            lstReasons.add(pc.Picklist_Field_Value__c);
        }
        Picklists_Control__c pc = new Picklists_Control__c();
       // pc.Picklist_Field_Value__c='---None---';
      //  reasonList.add(0,pc);
        //  System.debug('#lstOfReasons:'+id);
        return lstReasons;
    }
    @AuraEnabled
    public static list<String> getStatus(Id id) {
        List<Picklists_Control__c> statusList = new List<Picklists_Control__c>();
        List<String>lstStatus = new List<String>();
        
        statusList = [SELECT Id,Picklist_Field_Value__c FROM Picklists_Control__c where  Picklist_Field_Name__c='Status' order by Picklist_Field_Value__c asc ];
        for(Picklists_Control__c pc1 : statusList){
            lstStatus.add(pc1.Picklist_Field_Value__c);
        }
        System.debug('#lstOfStatus:'+id);
        return lstStatus;
    }
    
    
    @AuraEnabled
    public static list<Turnback__c> getTurnback(Id id) {
        System.debug('#Inside Turnback');
        System.debug('#id:'+id);
        List<Turnback__c> lstOfTurnBack = new List<Turnback__c>();
        
        String recordTypeName = [Select Id, RecordType.Name from Case where id=:id].RecordType.Name; 
        IF(recordTypeName =='Replacement Component (RC)')
        {
            lstOfTurnBack = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Replacement_Component_RC__c=true and Is_ICP__c=true and Status__c != 'Closed' order by Title__c asc];
        } else if(recordTypeName =='Equipment'){
            lstOfTurnBack = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Equipment__c=true and Status__c != 'Closed' order by Title__c asc];  
        }else if(recordTypeName =='Channel'){
            lstOfTurnBack = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Channel__c=true and Status__c != 'Closed' order by Title__c asc];  
        }else if(recordTypeName =='Post Sale Support'){
            lstOfTurnBack = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Post_Sale_Support__c=true and Status__c != 'Closed' order by Title__c asc]; 
        }
        // lstOfTurnBack = [Select Id,Title__c from Turnback__c where RecordType.Name = :recordTypeName and Status__c != 'Closed'];
        
        //System.debug('#Case Queried:'+T);
        Turnback__c tb = new Turnback__c();
        tb.Title__c='---None---';
        lstOfTurnBack.add(0,tb);
        return lstOfTurnBack;
    }
    
    @AuraEnabled
    public static Case saveCase(Case caseObject,String selValue,String selValTB,String selValStatus,String selValDefectCode, String selValDefectSubCode)
    {
        System.debug('#caseObject:'+caseObject);
        caseObject.Reason = selValue;
        caseObject.CCC_Turn_Back_Code__c = selValTB;
        caseObject.Status = selValStatus;
        caseObject.CCC_Defect_Code__c = selValDefectCode;
        caseObject.CCC_Defect_Sub_Code__c = selValDefectSubCode;
        
        System.debug('#caseObject Before:'+caseObject);
        update caseObject;
        List<Turnback__c> T = new List<Turnback__c>();
        T = [Select Id,Title__c,Case_Count__c from Turnback__c where Equipment__c=true and Title__c = :selValTB]; 
        System.debug('kkkk'+T);
        for(Turnback__c tr : T){
            tr.Case_Count__c++;
            update tr;
        }
        System.debug('#Case Queried After:'+caseObject);
        return caseObject;
        
    }
    
    @AuraEnabled
    public static Case saveCaseClose(Case caseObject,String selValue,String selValTB,string selValDefectCode,string selValDefectSubCode)
    {
        System.debug('#caseObject:'+caseObject);
       // caseObject.OwnerId=caseowner;
        caseObject.Status='Closed';
        caseObject.Reason = selValue;
        caseObject.CCC_Turn_Back_Code__c = selValTB;
        caseObject.CCC_Defect_Code__c = selValDefectCode;
        caseObject.CCC_Defect_Sub_Code__c = selValDefectSubCode;
        update caseObject;
        List<Turnback__c> T = new List<Turnback__c>();
        T = [Select Id,Title__c,Case_Count__c from Turnback__c where Equipment__c=true and Title__c = :selValTB]; 
        System.debug('kkkk'+T);
        for(Turnback__c tr : T){
            tr.Case_Count__c++;
            update tr;
        }
        System.debug('#Case Queried After:'+caseObject);
        return caseObject;
        
    }
    @AuraEnabled  
    public static Map<String,List<String>> getDependentOptionsImpl(string objApiName , string contrfieldApiName , string depfieldApiName){
        system.debug(objApiName + '##' + contrfieldApiName + '###' + depfieldApiName);
        purposePicklistForEquipment = new Map<String, Picklists_Control__c>();
        subPurposePicklistForEquipment = new Map<String, Picklists_Control__c>();
        contrlKeyLstOfDepend = new Map<String, List<String>>();
        //  customerType = new Map<String, String>();
        if(contrfieldApiName!=null && contrfieldApiName.length()>0){
            List<Picklists_Control__c> purposeValuesToFilter = [SELECT Id, Record_Type__c, Picklist_Field_Name__c, Picklist_Field_Value__c,Controlling_Field_Value__c,Is_Dependent__c,Is_Controlling__c FROM Picklists_Control__c where Record_Type__c = 'CCC_Post_Sale_Support' and Picklist_Field_Name__c=:contrfieldApiName  order by Picklist_Field_Value__c asc];
            if(purposeValuesToFilter!=null && purposeValuesToFilter.size()>0){
                for(Picklists_Control__c eachValue : purposeValuesToFilter){
                    purposePicklistForEquipment.put(eachValue.Picklist_Field_Value__c, eachValue);
                    contrlKeyLstOfDepend.put(eachValue.Picklist_Field_Value__c, new List<String>());
                }
            }
        }    
        if(depfieldApiName!=null && depfieldApiName.length()>0){
            List<Picklists_Control__c> subpurposeValuesToFilter = [SELECT Id, Record_Type__c, Picklist_Field_Name__c, Picklist_Field_Value__c,Controlling_Field_Value__c,Is_Dependent__c,Is_Controlling__c FROM Picklists_Control__c where Record_Type__c = 'CCC_Post_Sale_Support' and Picklist_Field_Name__c=:depfieldApiName];
            if(subpurposeValuesToFilter!=null && subpurposeValuesToFilter.size()>0){
                for(Picklists_Control__c eachValue : subpurposeValuesToFilter){
                    subpurposePicklistForEquipment.put(eachValue.Picklist_Field_Value__c, eachValue);
                    if(contrlKeyLstOfDepend.containsKey(eachValue.Controlling_Field_Value__c)){
                        List<String> depdLst = contrlKeyLstOfDepend.get(eachValue.Controlling_Field_Value__c);
                        depdLst.add(eachValue.Picklist_Field_Value__c);
                    }
                }
            }
        }    
        System.debug('#contrlKeyLstOfDepend:'+contrlKeyLstOfDepend);
        return contrlKeyLstOfDepend;
    }
}