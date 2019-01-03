public with sharing class CaseFetch {
    
    public static Boolean flag{get; set;}
   // public static Boolean selected{get; set;}
    @AuraEnabled
    public static Map<String, Picklists_Control__c> purposePicklistForEquipment{get; set;}
    @AuraEnabled
    public static Map<String, Picklists_Control__c> subPurposePicklistForEquipment{get; set;}
    @AuraEnabled
    public static Map<String, String> customerType{get; set;}
    
    
    public CaseFetch()
    {}  
    
    
    @AuraEnabled
    public Static Case ChangeOwner(Id id)
   {
       System.debug('Enter apex');
       Case c =[select Id,OwnerId from Case  where id =: id];
       c.OwnerId = [select Id from Group where Name='Junk Email' and Type = 'Queue'].Id;
       System.debug('Queue'+ c.OwnerId);
       Update c;
       return c;
     //  refreshPage=true;
      /* PageReference nextPage = new PageReference('/' + c.Id);
       nextPage.setRedirect(true);
       return nextPage;*/
      
    }
    
    @AuraEnabled
    public Static Case ChangeOwner2(Id id)
   {
       System.debug('Enter apex2');
       Case c =[select Id,OwnerId,CCC_Expedite_Status__c,CCC_Purpose__c,CCC_Sub_Purpose__c from Case  where id =: id];
       c.OwnerId = [select Id from Group where Name='Expedite' and Type = 'Queue'].Id;
       System.debug('Queue'+ c.OwnerId);
       c.CCC_Expedite_Status__c='Expedite';
       c.CCC_Purpose__c ='Expedite';
       c.CCC_Sub_Purpose__c ='Expedite';
       System.debug('Queue'+ c.OwnerId);
       Update c;
       return c;
     //  refreshPage=true;
      /* PageReference nextPage = new PageReference('/' + c.Id);
       nextPage.setRedirect(true);
       return nextPage;*/
      
    }
    @AuraEnabled
    public static void updateNewMsgFieldOnRead(Id csId) {
        flag=false;
        Case currentcase=[select Id, New_Msg__c from Case where Id = :csId ];
        List<EmailMessage> allEmails= new List<EmailMessage>();
        allEmails=[Select Id, Status from EmailMessage where ParentId=:currentcase.Id];
        if(allEmails != null){
            for(Emailmessage mail:allEmails){                
                if(mail.status == '0'){                
                    flag=true;                   
                }
            }            
         if(flag == false){              
            if(currentcase.New_Msg__c==true){
                currentcase.New_Msg__c=false;
               // Database.update(currentcase);                
            }                                  
         }
         else{
            System.debug('Unread msg is there....');
         }
           System.debug('yes....'+currentcase.New_Msg__c);
       }
       else{
         System.debug('Nothing....');   
       }
    }

    @AuraEnabled
    public static Case getCase(Id id) {
       
        Case C = [
             SELECT Id,CaseNumber,New_Comment__c,AccountId,ContactId,New_Msg__c,Description,
            CCC_Date_Time_Assigned__c,Flag_Comments__c,LastModifiedDate,LastModifiedBy.Name,
            isClosed,CreatedDate, Subject, CCC_Purpose__c,CCC_Sub_Purpose__c,CCC_SAP_Order__c, Priority, 
            Status,OwnerId,Owner.Name,RecordTypeId,recordtype.name,Origin,To_Address__c,
            SuppliedEmail,CCC_Brand__c,CCC_Customer_Type__c,Parent.CaseNumber,CreatedBy.Name,ZSM__c,
            Phone_Number__c,CCC_Part__c,CCC_Part_Number__c,CCC_Part_Quantity__c,CCC_Part_Description__c,
            CCC_Planner__c,CCC_Product_Buyer__c,CCC_Vendor_Name__c,CCC_Vendor_Code__c,CCC_Stocking_Type__c,Material__c,
            CCC_C10Order__c,CCC_Customer_PO__c,CCC_RCD_PO__c,CCC_Quote__c,CCC_RMA__c,CCC_RMA_Sent__c,CCC_Invoice__c,
            CCC_Model_Number__c,CCC_Serial_Number__c,CCC_Expedite_Status__c,CCC_Commit_Time__c,CCC_Vendor_Ship_Date__c,
            CCC_Vendor_Tracking__c,CCC_Days_Open__c,CCC_Solution__c,CCC_Time_to_Closure__c,CCC_Turn_Back_Code__c,
            Claims_Purpose__c,Claims_Sub_Purpose__c,Claims_Order_Type__c,Expedite_Record_Is_present__c

                 FROM Case
                 WHERE Id = :id 
         ];
        List<Expedite__c> expedite = [select Part_Number__c,Quantity__c,Part_Description__c from Expedite__c where Case_Number__c=:c.Id ];
        if(expedite.size()>0){ 
         c.Expedite_Record_Is_present__c= true;   
        }
        else
        {
          c.Expedite_Record_Is_present__c= false;   
        }
        if(c.ContactId!=null)
        {
            system.debug('inside contact if');
            List<contact> contactemail= [select id,email from contact where id=:c.ContactId limit 1];
            for(contact cc:contactemail)
            {
                c.SuppliedEmail=cc.email; 
            }
            system.debug('c.SuppliedEmail'+c.SuppliedEmail);  
         }
       
        
        System.debug('#Case Queried:'+c);
        return C;
    }
    
     @AuraEnabled
    public static Case getRT(Id id) {
        Case c = [
                SELECT Id,recordtype.name FROM Case
            WHERE Id = :id
         ];
        string rt = c.recordtype.name;
        System.debug('#RT:'+rt);
        return c;
    }
        @AuraEnabled
    public static case saveCase(Case caseObject) {
        system.debug('Case '+caseObject);
            upsert caseObject;
            System.debug('#Case Queried After:'+caseObject);
            return caseObject;
    }
     @AuraEnabled
    public static case saveCase5(Case caseObject) {
        system.debug('Case '+caseObject);
            upsert caseObject;
            System.debug('#Case Queried After:'+caseObject);
            return caseObject;
    }
     @AuraEnabled  
    public static Map<String,List<String>> getDependentOptionsImpl(string objApiName , string contrfieldApiName , string depfieldApiName){
        system.debug(objApiName + '##' + contrfieldApiName + '###' + depfieldApiName);
        purposePicklistForEquipment = new Map<String, Picklists_Control__c>();
        subPurposePicklistForEquipment = new Map<String, Picklists_Control__c>();
        customerType = new Map<String, String>();
        if(contrfieldApiName!=null && contrfieldApiName.length()>0){
        List<Picklists_Control__c> purposeValuesToFilter = [SELECT Id, Record_Type__c, Picklist_Field_Name__c, Picklist_Field_Value__c,Controlling_Field_Value__c,Is_Dependent__c,Is_Controlling__c FROM Picklists_Control__c where Picklist_Field_Name__c=:contrfieldApiName];
        if(purposeValuesToFilter!=null && purposeValuesToFilter.size()>0){
            for(Picklists_Control__c eachValue : purposeValuesToFilter){
                purposePicklistForEquipment.put(eachValue.Picklist_Field_Value__c, eachValue);
            }
        }
        }    
        if(depfieldApiName!=null && depfieldApiName.length()>0){
        List<Picklists_Control__c> subpurposeValuesToFilter = [SELECT Id, Record_Type__c, Picklist_Field_Name__c, Picklist_Field_Value__c,Controlling_Field_Value__c,Is_Dependent__c,Is_Controlling__c FROM Picklists_Control__c where Picklist_Field_Name__c=:depfieldApiName];
        if(subpurposeValuesToFilter!=null && subpurposeValuesToFilter.size()>0){
            for(Picklists_Control__c eachValue : subpurposeValuesToFilter){
                subpurposePicklistForEquipment.put(eachValue.Picklist_Field_Value__c, eachValue);
            }
        }
        }    
      /*  List<Picklists_Control__c> purposeValuesToFilter2 = [SELECT Id, Record_Type__c, Picklist_Field_Name__c, Picklist_Field_Value__c FROM Picklists_Control__c where Picklist_Field_Name__c='Brand'];
        if(purposeValuesToFilter2!=null && purposeValuesToFilter2.size()>0){
            for(Picklists_Control__c eachValue : purposeValuesToFilter2){
                purposePicklistForEquipment.put(eachValue.Picklist_Field_Value__c, eachValue.Picklist_Field_Value__c);
            }
        }*/
        System.debug('#purposePicklistForEquipment:'+purposePicklistForEquipment);
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        String objectName = objApiName.toLowerCase();
        // Added new Code start
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
         Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null){
            return objResults;
        }
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            System.debug('FIELD NOT FOUND --.> ' + controllingField + ' OR ' + dependentField);
            return objResults;     
        }
        List<Schema.PicklistEntry> contrEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> depEntries = objFieldMap.get(dependentField).getDescribe().getPicklistValues();
        for(Integer contrIndex=0; contrIndex<contrEntries.size(); contrIndex++){            
            Schema.PicklistEntry ctrlentry = contrEntries[contrIndex];
            String label = ctrlentry.getLabel();
            if(purposePicklistForEquipment.containsKey(label)){
                objResults.put(label,new List<String>());
            }
        }    
        for(Integer dependentIndex=0; dependentIndex<depEntries.size(); dependentIndex++){            
               Schema.PicklistEntry depentry = depEntries[dependentIndex];
            String label = depentry.getLabel();
            System.debug('#Dependent Field Label:'+label);
            if(subPurposePicklistForEquipment.containsKey(label)){
                Picklists_Control__c eachPickVal = subPurposePicklistForEquipment.get(label);
                if(eachPickVal.Controlling_Field_Value__c!=null && eachPickVal.Controlling_Field_Value__c.length()>0 && objResults.containsKey(eachPickVal.Controlling_Field_Value__c)){
                    List<String> lst = objResults.get(eachPickVal.Controlling_Field_Value__c);
                    lst.add(label);
                }
            }
        }   
        // Added new Code end
        /*String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        
            //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
         
        if (!Schema.getGlobalDescribe().containsKey(objectName)){
            System.debug('OBJNAME NOT FOUND --.> ' + objectName);
            return null;
         }
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null){
            return objResults;
        }
        Bitset bitSetObj = new Bitset();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        //Check if picklist values exist
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            System.debug('FIELD NOT FOUND --.> ' + controllingField + ' OR ' + dependentField);
            return objResults;     
        }
        
        List<Schema.PicklistEntry> contrEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> depEntries = objFieldMap.get(dependentField).getDescribe().getPicklistValues();
        System.debug('#depEntries:'+depEntries);
         objFieldMap = null;
        List<Integer> controllingIndexes = new List<Integer>();
        for(Integer contrIndex=0; contrIndex<contrEntries.size(); contrIndex++){            
            Schema.PicklistEntry ctrlentry = contrEntries[contrIndex];
            String label = ctrlentry.getLabel();
            //System.debug('#label:'+label);
            //System.debug('#contains:'+purposePicklistForEquipment.containsKey(label));
            if(purposePicklistForEquipment.containsKey(label)){
                objResults.put(label,new List<String>());
                controllingIndexes.add(contrIndex);
            }
            
        }
        List<Schema.PicklistEntry> objEntries = new List<Schema.PicklistEntry>();
        List<PicklistEntryWrapper> objJsonEntries = new List<PicklistEntryWrapper>();
        for(Integer dependentIndex=0; dependentIndex<depEntries.size(); dependentIndex++){            
               Schema.PicklistEntry depentry = depEntries[dependentIndex];
            //System.debug('#depentry:'+depentry);
               objEntries.add(depentry);
        } 
        System.debug('#objEntries:'+objEntries);
        System.debug('#objEntries Serialized:'+JSON.serialize(objEntries));
        objJsonEntries = (List<PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objEntries), List<PicklistEntryWrapper>.class);
        System.debug('#objJsonEntries:'+objJsonEntries);
        List<Integer> indexes;
        for (PicklistEntryWrapper objJson : objJsonEntries){
            //system.debug('#objJson.label:'+objJson.label);
            //system.debug('#objJson.validFor:'+objJson.validFor);
            if (objJson.validFor==null || objJson.validFor==''){
                continue;
            }
            indexes = bitSetObj.testBits(objJson.validFor,controllingIndexes);
           //System.debug('#indexes:'+indexes);
            for (Integer idx : indexes){                
                String contrLabel = contrEntries[idx].getLabel();
                //system.debug('#objJson.label:'+objJson.label);
                //if(subpurposePicklistForEquipment.containsKey(objJson.label)){
                    objResults.get(contrLabel).add(objJson.label);
                //}
                    
                
            }
        }
        objEntries = null;
        objJsonEntries = null;*/
        system.debug('objResults--->' + objResults);
        return objResults;
    }
    @AuraEnabled  
    public static Map<String,List<String>> getPicklistOptionsImpl(string objApiName , string contrfieldApiName , string depfieldApiName){
        system.debug(objApiName + '##' + contrfieldApiName + '###' + depfieldApiName);
        purposePicklistForEquipment = new Map<String, Picklists_Control__c>();
        
        customerType = new Map<String, String>();
        if(contrfieldApiName!=null && contrfieldApiName.length()>0){
        List<Picklists_Control__c> purposeValuesToFilter = [SELECT Id, Record_Type__c, Picklist_Field_Name__c, Picklist_Field_Value__c,Controlling_Field_Value__c,Is_Dependent__c,Is_Controlling__c FROM Picklists_Control__c where Picklist_Field_Name__c=:contrfieldApiName];
        if(purposeValuesToFilter!=null && purposeValuesToFilter.size()>0){
            for(Picklists_Control__c eachValue : purposeValuesToFilter){
                purposePicklistForEquipment.put(eachValue.Picklist_Field_Value__c, eachValue);
            }
        }
        }    
            
      /*  List<Picklists_Control__c> purposeValuesToFilter2 = [SELECT Id, Record_Type__c, Picklist_Field_Name__c, Picklist_Field_Value__c FROM Picklists_Control__c where Picklist_Field_Name__c='Brand'];
        if(purposeValuesToFilter2!=null && purposeValuesToFilter2.size()>0){
            for(Picklists_Control__c eachValue : purposeValuesToFilter2){
                purposePicklistForEquipment.put(eachValue.Picklist_Field_Value__c, eachValue.Picklist_Field_Value__c);
            }
        }*/
        System.debug('#purposePicklistForEquipment:'+purposePicklistForEquipment);
        String controllingField = contrfieldApiName.toLowerCase();
        //String dependentField = depfieldApiName.toLowerCase();
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        String objectName = objApiName.toLowerCase();
        // Added new Code start
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
         Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null){
            return objResults;
        }
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        if (!objFieldMap.containsKey(controllingField)){
            System.debug('FIELD NOT FOUND --.> ' + controllingField);
            return objResults;     
        }
        List<Schema.PicklistEntry> contrEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        //List<Schema.PicklistEntry> depEntries = objFieldMap.get(dependentField).getDescribe().getPicklistValues();
        for(Integer contrIndex=0; contrIndex<contrEntries.size(); contrIndex++){            
            Schema.PicklistEntry ctrlentry = contrEntries[contrIndex];
            String label = ctrlentry.getLabel();
            if(purposePicklistForEquipment.containsKey(label)){
                objResults.put(label,new List<String>());
            }
        }    
        
        // Added new Code end
        system.debug('objResults--->' + objResults);
        return objResults;
    }
    
}