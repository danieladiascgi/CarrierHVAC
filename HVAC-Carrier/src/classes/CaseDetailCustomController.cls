global without sharing class CaseDetailCustomController {
    @AuraEnabled
    public static List<EmailMessage> emails{get;set;}
    @AuraEnabled
    public static EmailMessage emsg{get;set;}
    @AuraEnabled
    public static List<Expedite__c> expedites{get;set;}
    @AuraEnabled
    public static CaseWrapper fetchCase(String caseRecordId){
        CaseWrapper wrp = new CaseWrapper();
        Case cseRec = [Select Id, CaseNumber, Type, Priority, Contact.Name, Account.Name, Subject, Description, Status,
                       CCC_Purpose__c,CCC_Sub_Purpose__c,CCC_SAP_Order__c, 
                       OwnerId,Owner.Name,RecordTypeId,recordtype.name,Origin,To_Address__c,
                       SuppliedEmail,CCC_Brand__c,CCC_Customer_Type__c,Parent.CaseNumber,CreatedBy.Name,ZSM__c,
                       Phone_Number__c,CCC_Part__c,CCC_Part_Number__c,CCC_Part_Quantity__c,CCC_Part_Description__c,
                       CCC_Planner__c,CCC_Product_Buyer__c,CCC_Vendor_Name__c,CCC_Vendor_Code__c,CCC_Stocking_Type__c,Material__c,
                       CCC_C10Order__c,CCC_Customer_PO__c,CCC_RCD_PO__c,CCC_Quote__c,CCC_RMA__c,CCC_RMA_Sent__c,CCC_Invoice__c,
                       CCC_Model_Number__c,CCC_Serial_Number__c,CCC_Expedite_Status__c,CCC_Commit_Time__c,CCC_Vendor_Ship_Date__c,
                       CCC_Vendor_Tracking__c,CCC_Days_Open__c,CCC_Solution__c,CCC_Time_to_Closure__c,CCC_Turn_Back_Code__c,
                       Claims_Purpose__c,Claims_Sub_Purpose__c,Claims_Order_Type__c,CCC_Model__c,Qty__c,CCC_TSM_User__c,CreatedDate,Distributor_Customer__c from Case where Id=:caseRecordId];
        system.debug('caseRecords'+cseRec);
        wrp.caseId = cseRec.Id;
        wrp.caseNumber = cseRec.CaseNumber;
        wrp.Subject =cseRec.Subject;
        wrp.description = cseRec.Description;
        wrp.status = cseRec.Status;
        //  wrp.type = cseRec.Type;
        wrp.priority =cseRec.Priority;
        wrp.contName = cseRec.Contact.Name;
        wrp.accName = cseRec.Account.Name;
        wrp.brand = cseRec.CCC_Brand__c;
        //  wrp.buyer = cseRec.
        wrp.C10Order = cseRec.CCC_C10Order__c;
        wrp.commitTime = cseRec.CCC_Commit_Time__c;
        wrp.customerPO = cseRec.CCC_Customer_PO__c;
        wrp.customerType = cseRec.CCC_Customer_Type__c;
        wrp.daysOpen = cseRec.CCC_Days_Open__c;
        wrp.expediteStatus = cseRec.CCC_Expedite_Status__c;
        wrp.invoice = cseRec.CCC_Invoice__c;
        wrp.model=cseRec.CCC_Model_Number__c;
        wrp.part = cseRec.CCC_Part__c;
        wrp.partDescription= cseRec.CCC_Part_Description__c;
        wrp.partNumber = cseRec.CCC_Part_Number__c;
        wrp.phoneNumber = cseRec.Phone_Number__c;
        wrp.planner = cseRec.CCC_Planner__c;
        wrp.purpose = cseRec.CCC_Purpose__c;
        wrp.priority = cseRec.Priority;
        wrp.quantity = cseRec.CCC_Part_Quantity__c;
        wrp.quote = cseRec.CCC_Quote__c;
        wrp.RCD_PO = cseRec.CCC_RCD_PO__c;
        wrp.RMA = cseRec.CCC_RMA__c;
        wrp.RMASent = cseRec.CCC_RMA_Sent__c;
        wrp.serial = cseRec.CCC_Serial_Number__c;
        wrp.solution = cseRec.CCC_Solution__c;
        wrp.source =cseRec.Origin ;
        //  wrp.source = 'RC Community';
        wrp.status = cseRec.Status;
        wrp.stockingType = cseRec.CCC_Stocking_Type__c;
        wrp.subPurpose = cseRec.CCC_Sub_Purpose__c;
        wrp.timeToClosure = cseRec.CCC_Time_to_Closure__c;
        wrp.zsm = cseRec.ZSM__c;
        wrp.vendorCode = cseRec.CCC_Vendor_Code__c;
        wrp.vendorName = cseRec.CCC_Vendor_Name__c;
        wrp.vendorShipDate = cseRec.CCC_Vendor_Ship_Date__c;
        wrp.vendorTracking = cseRec.CCC_Vendor_Tracking__c;
        wrp.createdDate= cseRec.CreatedDate;
        wrp.distributor_customer=cseRec.Distributor_Customer__c;
        system.debug('wrp'+wrp);
        return wrp;
    }
    @AuraEnabled
    public static  List<CaseComment> SaveComments(String commentbody,boolean ispublished,String CaseId)
    {
        
        List<CaseComment> LstComments = new List<CaseComment>(); 
        CaseComment comment = new CaseComment();
        comment.CommentBody=commentbody;
        //comment.IsPublished=ispublished;
        comment.IsPublished=true;
        comment.ParentId=CaseId;
        LstComments.add(comment);
        database.insert(LstComments);
        return LstComments;
        
    }
    @AuraEnabled
    public static string  checkStatus(String CaseId)
    {
        string caseStatus;
        Case cc = [select Id, Status from Case where id=:CaseId];
        caseStatus =cc.Status;
        return caseStatus;
        
    }
    @AuraEnabled
    global static List<CaseComment> DisplayComments(string CaseId)
    { 
        List<CaseComment> CmdList;
        CmdList =[select Id,CommentBody,IsPublished, CreatedDate, CreatedBy.Name from CaseComment where parentId=:CaseId and IsPublished= true order by createddate desc];
        return CmdList;
    }
    
    @AuraEnabled
    global static List<Attachment> DisplayAttachments(string CaseId)
    { 
        List<Attachment> AttachList;
        AttachList =[SELECT Id, Name, CreatedDate,BodyLength,CreatedBy.Name, LastModifiedDate FROM Attachment where parentId=:CaseId ];
        system.debug('AttachList'+AttachList);
        return AttachList;
    }
    

    @AuraEnabled
    public static EmailMessage getEmailMessageRecToBePassed(Id clickedEmailRecId){
        emsg = [Select Id, Subject, Status, HtmlBody, FromAddress,TextBody, FromName ,CcAddress, BccAddress,  ToAddress, MessageDate from EmailMessage where Id=:clickedEmailRecId];
        return emsg;
    }  
    
    @AuraEnabled
    public static List<EmailMessage> getEmailMessageRec(Id CaseId){
        // Id caseId = [Select Id,Name,Case_Number__c from Expedite__c where Id=:expId].Case_Number__c; 
        //cases = [Select Id from Case where id=:caseId];
        String contactEmail = '';
        List<Case> cases = [Select Id, ContactEmail from Case where Id=:CaseId];
        if(cases!=null && cases.size()>0){
            Case eachCase = cases.get(0);
            contactEmail = eachCase.ContactEmail;
        }
        emails = [Select Id, Subject, Status, FromAddress, ToAddress,CcAddress,Incoming, MessageDate from EmailMessage where ParentId=:caseId order by createddate desc];
        
        system.debug(emails);
        List<EmailMessage> msgs = new List<EmailMessage>();
        for(EmailMessage eachMsg : emails){
            String toAddr = eachMsg.ToAddress;
            String ccAddr = eachMsg.CcAddress;
            String fromAddr = eachMsg.FromAddress;
            if(eachMsg.Incoming==true && contactEmail != null && contactEmail != ''){
                //Check if contactemail contains in from email addr
                if(fromAddr.contains(contactEmail) || ( toAddr!=null && toAddr.contains(contactEmail) )||(ccAddr!=null && ccAddr.contains(contactEmail)))
                    msgs.add(eachMsg);
                system.debug('emailmsgs_true'+msgs);
            }else if (contactEmail != null && contactEmail != '') //check if contactemail contains in either toAddr or ccAddr
            {
                if(( toAddr!=null && toAddr.contains(contactEmail) )||(ccAddr!=null && ccAddr.contains(contactEmail)))
                {
                    msgs.add(eachMsg);
                    system.debug('emailmsgs_false'+msgs);
                }
            }
            else
            {
                
                //msgs.add(null);
                system.debug('emailmsgs_else'+msgs);
            }
        }
        return msgs;
    }
    
    @AuraEnabled
    public static List<Expedite__c> getExpediteRec(Id CaseId){
        List<Expedite__c> lstToReturn = new List<Expedite__c>();
       expedites=[SELECT Id, Name, Subject__c,Expedite_Status__c,Customer_PO__c,C10_Order__c,Part_Number__c  FROM Expedite__c where Case_Number__c=:caseId order by createddate desc];
        for(Expedite__c eachExpedite: expedites){
            if(eachExpedite.Expedite_Status__c!=null && eachExpedite.Expedite_Status__c.length()>0 && eachExpedite.Expedite_Status__c=='Expedite'){
                eachExpedite.Expedite_Status__c = 'New';
            }else if(eachExpedite.Expedite_Status__c!=null && eachExpedite.Expedite_Status__c.length()>0 && (eachExpedite.Expedite_Status__c=='Supplier #1' || eachExpedite.Expedite_Status__c=='Supplier #2' ||eachExpedite.Expedite_Status__c=='Supplier #3' || eachExpedite.Expedite_Status__c=='Escape' ||eachExpedite.Expedite_Status__c=='Hold' || eachExpedite.Expedite_Status__c=='Internal Wait' ||eachExpedite.Expedite_Status__c=='Supplier Promise' || eachExpedite.Expedite_Status__c=='Track No.Required' || eachExpedite.Expedite_Status__c=='Track No. to Customer' )){
                eachExpedite.Expedite_Status__c = 'In Progress';
            }
            lstToReturn.add(eachExpedite);
        }
       return lstToReturn;
    
}
}