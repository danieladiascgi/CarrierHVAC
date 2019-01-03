public with sharing class ResolutionFetchExpedite {
    
   /* @AuraEnabled
    public static List<Case> lstCase {get;set;}
    @AuraEnabled
    public static String s {get;set;} */  
    
    @AuraEnabled
    public static Boolean getContactVal(Id id){
        Id cntId = [SELECT Id, Contact_Name__c FROM Expedite__c where  Id =:id].Contact_Name__c; 
        System.debug('cntId..'+cntId);
        if(cntId != null)
        {             
            return true;           
        }
        else{            
            return false;
        } 
    }
    
  /*  @AuraEnabled
    public static String getRecordType(String id){
        lstCase = new List<Case>();
        lstCase = [SELECT RecordType.Name FROM Case where id = :id];
        s = lstCase[0].RecordType.Name;
        System.debug('s..'+s);
        return s;       
    }*/
    
    
    @AuraEnabled
    public static Expedite__c getExpedite(Id id) {
        Expedite__c ex= new Expedite__c();
        ex= [SELECT Id, Resolution_Code__c,Turnback__c,Expedite_Status__c,Commit_Time__c,Vendor_Tracking__c,Vendor_Ship_Date__c FROM Expedite__c where Id=: id];
        System.debug('#getExpedite:'+ex);
        return ex;
        
    }
    
    @AuraEnabled
    public static list<String> getResolutionCode(Id id) {
        System.debug('#id11:'+id);
        List<Picklists_Control__c> reasonList = new List<Picklists_Control__c>();
        List<String>lstReasons = new List<String>();
        reasonList = [SELECT Id,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= 'CCC_Replacement_Component' and Picklist_Field_Name__c='ExpediteReason'order by Order__c asc];
        for(Picklists_Control__c pc : reasonList)
        {
            lstReasons.add(pc.Picklist_Field_Value__c);
        }
        Picklists_Control__c pc = new Picklists_Control__c();
        System.debug('#lstOfReasons:'+lstReasons);
        return lstReasons;
    }
    
    @AuraEnabled
    public static list<Turnback__c> getTurnback(Id id) {
        System.debug('#Inside Turnback');
        System.debug('#id:'+id);
        List<Turnback__c> lstOfTurnBack = new List<Turnback__c>();
        lstOfTurnBack = [Select Id, Name,Type__c,Sub_Type__c,Title__c,Case_Count__c  from Turnback__c where Expedite__c=true and Is_ICP__c=true and Status__c != 'Closed' order by Title__c asc];
        Turnback__c tb = new Turnback__c();
        tb.Title__c='---None---';
        lstOfTurnBack.add(0,tb);
        System.debug('Turnback:'+lstOfTurnBack);
        return lstOfTurnBack;
    }
    
    @AuraEnabled
    public static Expedite__c saveCase(Expedite__c caseObject,String selValue,String selValTB,String selValStatus,Datetime committime,String vendortracking, String shipdate)
    {
        
        System.debug('#committime:'+committime);
        System.debug('#shipdate:'+shipdate);
        caseObject.Resolution_Code__c = selValue;
        caseObject.Turnback__c = selValTB;
        System.debug('#selValStatus:'+selValStatus);
        if(selValStatus!=null && selValStatus.length()>0){
            caseObject.Expedite_Status__c = selValStatus;
        }
        if(committime!=null){
            caseObject.Commit_Time__c= committime;
        }
        caseObject.Vendor_Tracking__c=vendortracking;
        if(shipdate!=null){
            caseObject.Vendor_Ship_Date__c=Date.valueOf(shipdate);
        }
        
        System.debug('#caseObject Before:'+caseObject);
        update caseObject;
        List<Turnback__c> T = new List<Turnback__c>();
        T = [Select Id,Title__c,Case_Count__c from Turnback__c where Expedite__c=true and Title__c = :selValTB]; 
        System.debug('kkkk'+T);
        for(Turnback__c tr : T){
            tr.Case_Count__c++;
            update tr;
        }
        System.debug('#Case Queried After:'+caseObject);
        return caseObject;
    }
    
    @AuraEnabled
    public static Expedite__c saveCaseClose(Expedite__c caseObject,String selValue,String selValTB,Datetime committime,String vendortracking, String shipdate)
    {
        System.debug('#committime:'+committime);
        System.debug('#shipdate:'+shipdate);
        caseObject.Expedite_Status__c='Closed';
        caseObject.Resolution_Code__c = selValue;
        caseObject.Turnback__c = selValTB;
        if(committime!=null){
        	caseObject.Commit_Time__c= committime;
        }  
        if(vendortracking!=null){
            caseObject.Vendor_Tracking__c=vendortracking;
        }        
        if(shipdate!=null){
            caseObject.Vendor_Ship_Date__c=Date.valueOf(shipdate);
        }
        
        
        update caseObject;
        List<Turnback__c> T = new List<Turnback__c>();
        T = [Select Id,Title__c,Case_Count__c from Turnback__c where Expedite__c=true and Title__c = :selValTB]; 
        System.debug('kkkk'+T);
        for(Turnback__c tr : T){
            tr.Case_Count__c++;
            update tr;
        }
        System.debug('#Case Queried After:'+caseObject);
        return caseObject;
        
    }
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List <String> allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list <Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        return allOpts;
    }
     @AuraEnabled
    public static Boolean checkIfPlannerIsEmpty(Id ExpediteId) {
        Boolean isPopupRequired = false;
        if(ExpediteId!=null){
            Expedite__c exp = [Select id, Planner__c from Expedite__c where Id=:ExpediteId];
            if(exp!=null && (exp.Planner__c==null || exp.Planner__c=='')){
                isPopupRequired = true;
            }else{
                isPopupRequired = false;
            }
        }
        return isPopupRequired;
    }
    
}