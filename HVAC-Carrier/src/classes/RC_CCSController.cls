global without sharing class RC_CCSController {
    
    @AuraEnabled
    public static Map<String, Picklists_Control__c> purposePicklistForEquipment{get; set;}
    @AuraEnabled
    public static Map<String, Picklists_Control__c> subPurposePicklistForEquipment{get; set;}
    @AuraEnabled
    public static List<Product2> parts{get;set;}
    @AuraEnabled
    public static Attachment oAttachment{get;set;}
    @AuraEnabled
    public String hvacId{get; set;}
    @AuraEnabled 
    public static user fetchUser(){
        User u = [select id,Name,alias from User where id =: userInfo.getUserId()];
        System.debug('#user:'+u);
        return u;
    }
    @AuraEnabled
    public static Case getCase(Id id) {
        Case C = [
            SELECT Id,Description, Subject, CCC_Purpose__c,CCC_Part_Quantity__c,CCC_Sub_Purpose__c, CCC_Part_Number__c,CCC_Part_Description__c,CCC_Customer_PO__c,CCC_Model_Number__c,CCC_Serial_Number__c,ODS__c,CCC_SAP_Invoice__c
            FROM Case
            WHERE Id = :id
        ];
        System.debug('#Case Queried:'+c);
        return C;
    }
    /*  @AuraEnabled
public static Case getCaseNumber(id recId) {
Case casenum = [
select casenumber from case where id =:recId

];
System.debug('#Case Queried:'+casenum);
return casenum;
}*/
    
    
    @AuraEnabled
    global static list<string> getparsePayloadAndGetValues(String payloadStr){
        string value=null;
        string contactFirstName=null;
        string contactLastName=null;
        string hvacid='';
        list<string> contlst = new  list<string>();
        if(payloadStr!=null){
            System.debug('#payload:'+payloadStr);
            //payload = 'SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=';
            if(payloadStr.contains(' ')){
                payloadStr = payloadStr.replaceAll(' ', '+');
            }
            System.debug('#payload after:'+payloadStr);
            JWTDecryptFinal decrypt = new JWTDecryptFinal();
            contactFirstName = decrypt.getFirstNameDecrypt(payloadStr);
            contactLastName = decrypt.getLastNameDecrypt(payloadStr);
            value = decrypt.getEmailDecrypt(payloadStr);
            hvacId = decrypt.getHVACIDDecrypt(payloadStr);
            system.debug('FirstName'+contactFirstName);
            system.debug('LastName'+contactLastName);
            system.debug('email'+value);
            
            contlst.add(contactFirstName);
            contlst.add(contactLastName);
            contlst.add(value);
            contlst.add(hvacId);
        }
        /* else{
value='communityuser';
}*/    system.debug('contlst'+contlst);
        return contlst;
    }
    
    
    
    @AuraEnabled
    public static Case saveCase(String description,String distributor_customer, String subject, String conPurpose, String conSubPurpose, String serial, String model, List<WrapperCls__c> ListPart, String CustomerPO , List<string> contlst,String sap,String ods,String jobName,String buildDate) {
        //   system.debug('description...'+description+'subject'+subject +'conPurpose'+conPurpose+'ods'+ods+'sap'+sap+'buildDate'+buildDate);
        Case cs = new Case();
        cs.CCC_Purpose__c = conPurpose;
        cs.CCC_Sub_Purpose__c = conSubPurpose;
        cs.Distributor_Customer__c=distributor_customer;
        
        cs.recordTypeId = '01215000001JLpG';
        if(conPurpose=='Technical/Part Info - 42 Series Fan Coil')
        {
            cs.Subject = '42 Series Fan Coil Request - Model: '+model+' - '+'Serial: '+serial;
            cs.OwnerId = [select Id from Group where Name='RC Tech Support - Residential' and Type = 'Queue'].Id;
        }
        else{
            cs.Subject = subject;
            cs.OwnerId = [select Id from Group where Name='CBP' and Type = 'Queue'].Id;
        }
        if(description!=null){
            cs.Description = description;   
        }
        
        cs.Origin='RC Community';
        cs.Priority = 'Medium';
        cs.CCC_Customer_PO__c = CustomerPO ;
        if(sap!=null){
            cs.CCC_SAP_Invoice__c = sap;
        }
        if(jobName!=null){
            cs.CCC_Job_Name__c = jobName;    
        }
        if(buildDate!=null)
        {
            cs.Build_Date__c = buildDate;
        }
        System.debug('#ODS:'+ods);
        System.debug('#Job Name:'+jobName);
        System.debug('#sap:'+sap);
        if(ods!=null){
            cs.ODS__c = ods;
        }
        
        User u = [select id,Name,alias,email from User where id =: userInfo.getUserId()];
        string LoggedInEmail=contlst[2];
        system.debug('*********Loggedinemail*************'+LoggedInEmail);
        List<Contact> contactsWithMatchingHvacIds = [Select Id, Name, Email from Contact where HVAC_Contact_Id__c =:contlst[3] order by createddate desc];
        System.debug('#contactsWithMatchingHvacIds:'+contactsWithMatchingHvacIds);
        if(contactsWithMatchingHvacIds!=null && contactsWithMatchingHvacIds.size()>0){
            Contact cont = contactsWithMatchingHvacIds.get(0);
            cs.ContactId = cont.Id;
        }else{
            List<List<Contact>> findContact= [FIND :LoggedInEmail IN Email Fields RETURNING Contact(Id)];
            system.debug('LoggedinuseremailID*************'+findContact);
            Contact [] contactList = ((List<Contact>)findContact[0]);
            contactList=[Select Id, Email, HVAC_Contact_Id__c, AccountId, RecordType.Name from Contact where Id in:contactList order by createddate desc];
            system.debug('-------------->querying and assigning the contacts to list'+contactList);
            system.debug('-------------->querying and assigning the contacts to list'+contactList.size());
            system.debug('*********Contact********'+cs.ContactId); 
            if(contactList.size() == 1 && cs.ContactId == null )
            {
                system.debug('*********');
                system.debug('------>size of contacts '+contactList);
                cs.ContactId=contactList[0].Id;
                if(cs.Description == null)
                {
                    cs.Description= cs.Description;
                }
                
            }
            
            else if(contactList.size() > 1  )
            {
                system.debug('&&&&&&&&&');
                String hvacIdFromRequest = contlst[3];
                for(Contact eachCont : contactList){
                    if(eachCont!=null && eachCont.HVAC_Contact_Id__c!=null && eachCont.HVAC_Contact_Id__c.length()>0 && eachCont.HVAC_Contact_Id__c.equalsIgnoreCase(hvacIdFromRequest)){
                        cs.ContactId= eachCont.Id;
                        break;
                    }else{
                        cs.ContactId=contactList[0].Id;
                    }
                }
                
                system.debug('contactid when size is 2'+cs.ContactId);
                cs.Description= cs.Description +'\r\n'+'Multiple Contacts were found with the provided Email Address:'+LoggedInEmail;
            }
            else if(contactList.size()==0)
            {
                system.debug('%%%%%%%%%%%%%%%');
                Contact con = new Contact();
                Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Non-Residential Contact').getRecordTypeId();
                con.RecordTypeId = contactRecordTypeId;
                con.LastName = contlst[1];
                con.FirstName = contlst[0];
                con.email =contlst[2];
                con.HVAC_Contact_Id__c= contlst[3];
                insert con;
                system.debug('New Contact'+con);
                cs.ContactId=con.Id;  
            }
        }
        if(ListPart!=null){
            integer count = 0;
            integer count2 = 0;
            for(WrapperCls__c wc : ListPart )
            {
                if(wc.failedPrt__c == true)
                {
                    count =count + 1;
                }
                else
                {
                    count2= count2+1;
                }
            }
            if(count>0){
                for(WrapperCls__c wc : ListPart){
                    
                    if (wc.failedPrt__c == true){
                        if(wc.prtNo__c != null && wc.prtNo__c != ''){
                            List<Product2> parts = [Select Id, Name from Product2 where Name=:wc.prtNo__c];
                            if(parts!=null && parts.size()>0){
                                if(parts.size()==1){
                                    cs.CCC_Part__c = parts.get(0).Id;
                                } 
                            }
                        }  
                        //  flag=true;
                        cs.CCC_Part_Number__c = wc.prtNo__c;
                        cs.CCC_Part_Quantity__c = wc.Quantity__c;
                        cs.CCC_Part_Description__c = wc.Description__c;  
                    }
                    else
                    {
                        
                        if(cs.Description!=null){  
                            integer i =  Integer.ValueOf(wc.Quantity__c);
                            system.debug('Quantity'+i);
                            cs.Description = cs.Description+'\r\n'+ 'Part Numbers:' + wc.prtNo__c+' '+ 'Quantity:' + wc.Quantity__c+ + 'Description:' +wc.Description__c;
                        }
                        else{
                            if(wc.Description__c == null)
                                cs.Description ='Part Numbers:'+ wc.prtNo__c+' '+ 'Quantity:' + wc.Quantity__c +' '+ 'Description:' +wc.Description__c;
                        }
                    }
                    
                }
            }
            else
            {
                if(listPart[0].prtNo__c != null && listPart[0].prtNo__c != ''){
                    
                    List<Product2> parts = [Select Id, Name from Product2 where Name=:listPart[0].prtNo__c];
                    system.debug('parts'+parts);
                    system.debug('parts size'+parts.size());
                    if(parts!=null && parts.size()>0){
                        if(parts.size()==1){
                            cs.CCC_Part__c = parts.get(0).Id;
                        }   
                    }
                }
                
                cs.CCC_Part_Number__c = listPart[0].prtNo__c;
                cs.CCC_Part_Quantity__c = listPart[0].Quantity__c;
                cs.CCC_Part_Description__c = listPart[0].Description__c;
                
                for( integer i=1;i<ListPart.size();i++){
                    system.debug('size'+ListPart.size());
                    if(cs.Description!=null){  
                        
                        cs.Description = cs.Description+' '+ 'Part Numbers:' + ListPart[i].prtNo__c+' '+ 'Quantity:' + ListPart[i].Quantity__c+ ''+'Description:' +ListPart[i].Description__c;
                    }
                    else{
                        cs.Description ='Part Numbers:'+ ListPart[i].prtNo__c+' '+ 'Quantity:' + ListPart[i].Quantity__c +' '+ 'Description:' +ListPart[i].Description__c;
                    }
                    
                }
            }
        }
        
        cs.CCC_Model_Number__c = model;
        cs.CCC_Serial_Number__c = serial;
        cs.CCC_Customer_Type__c = 'CBP';
        insert cs;
        system.debug('cs************'+cs);
        // return cs.Id;
        Case caseNum=[select CaseNumber,Id from Case where Id=:cs.Id] ;
        return caseNum; 
    }
    
    @AuraEnabled  
    public static Map<String,List<String>> getDependentOptionsImpl(string objApiName , string contrfieldApiName , string depfieldApiName){
        //system.debug('getDependentOptionsImpl'+objApiName + '##' + contrfieldApiName + '###' + depfieldApiName);
        purposePicklistForEquipment = new Map<String, Picklists_Control__c>();
        subPurposePicklistForEquipment = new Map<String, Picklists_Control__c>();
        //  customerType = new Map<String, String>();
        if(contrfieldApiName!=null && contrfieldApiName.length()>0){
            List<Picklists_Control__c> purposeValuesToFilter = [SELECT Id, Record_Type__c, Picklist_Field_Name__c, Picklist_Field_Value__c,Controlling_Field_Value__c,Is_Dependent__c,Is_Controlling__c FROM Picklists_Control__c where Record_Type__c = 'CCC_Replacement_Component' and Picklist_Field_Name__c=:contrfieldApiName and Is_Community__c = true ];
            if(purposeValuesToFilter!=null && purposeValuesToFilter.size()>0){
                for(Picklists_Control__c eachValue : purposeValuesToFilter){
                    purposePicklistForEquipment.put(eachValue.Picklist_Field_Value__c, eachValue);
                }
            }
        }    
        if(depfieldApiName!=null && depfieldApiName.length()>0){
            List<Picklists_Control__c> subpurposeValuesToFilter = [SELECT Id, Record_Type__c, Picklist_Field_Name__c, Picklist_Field_Value__c,Controlling_Field_Value__c,Is_Dependent__c,Is_Controlling__c FROM Picklists_Control__c where Picklist_Field_Name__c=:depfieldApiName and Is_Community__c = true];
            if(subpurposeValuesToFilter!=null && subpurposeValuesToFilter.size()>0){
                for(Picklists_Control__c eachValue : subpurposeValuesToFilter){
                    subpurposePicklistForEquipment.put(eachValue.Picklist_Field_Value__c, eachValue);
                }
            }
        }    
        //System.debug('#purposePicklistForEquipment:'+purposePicklistForEquipment);
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
            //System.debug('#Dependent Field Label:'+label);
            if(subPurposePicklistForEquipment.containsKey(label)){
                Picklists_Control__c eachPickVal = subPurposePicklistForEquipment.get(label);
                if(eachPickVal.Controlling_Field_Value__c!=null && eachPickVal.Controlling_Field_Value__c.length()>0 && objResults.containsKey(eachPickVal.Controlling_Field_Value__c)){
                    List<String> lst = objResults.get(eachPickVal.Controlling_Field_Value__c);
                    lst.add(label);
                }
            }
        }   
        
        //system.debug('objResults--->' + objResults);
        return objResults;
    }
    @AuraEnabled  
    public static Map<String,List<String>> getPicklistOptionsImpl(string objApiName , string contrfieldApiName , string depfieldApiName){
        //system.debug(objApiName + '##' + contrfieldApiName + '###' + depfieldApiName);
        purposePicklistForEquipment = new Map<String, Picklists_Control__c>();
        
        // customerType = new Map<String, String>();
        if(contrfieldApiName!=null && contrfieldApiName.length()>0){
            List<Picklists_Control__c> purposeValuesToFilter = [SELECT Id, Record_Type__c, Picklist_Field_Name__c, Picklist_Field_Value__c,Controlling_Field_Value__c,Is_Dependent__c,Is_Controlling__c FROM Picklists_Control__c where Picklist_Field_Name__c=:contrfieldApiName and Is_Community__c = true];
            if(purposeValuesToFilter!=null && purposeValuesToFilter.size()>0){
                for(Picklists_Control__c eachValue : purposeValuesToFilter){
                    purposePicklistForEquipment.put(eachValue.Picklist_Field_Value__c, eachValue);
                }
            }
        }    
        
        
        //System.debug('#purposePicklistForEquipment:'+purposePicklistForEquipment);
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
    
    @AuraEnabled
    public static Id saveChunk( Id recordId,String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        System.debug('#FileId:'+fileId);
        System.debug('#recordId:'+recordId);
        System.debug('#fileName:'+fileName);
        System.debug('#contentType:'+contentType);
        if (fileId==null || fileId == '') {
            fileId = saveTheFile( recordId,fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id recordId, String fileName, String base64Data, String contentType) {
        system.debug('1234567890');
        System.debug('#Save recordId:'+recordId);
        System.debug('#Save fileName:'+fileName);
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        oAttachment = new Attachment();
        oAttachment.parentId = recordId;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        insert oAttachment;
        system.debug('******AttachmentId*******'+oAttachment.Id);
        return oAttachment.Id;
    }
    @TestVisible
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        system.debug('******body*******'+ a.Body);
        update a;
    }
    
    
}