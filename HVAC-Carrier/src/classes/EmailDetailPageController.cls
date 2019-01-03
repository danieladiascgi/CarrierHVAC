public without sharing class EmailDetailPageController {
   /* @AuraEnabled
    public static List<EmailMessage> emails{get;set;}*/
    @AuraEnabled
    public static EmailMessage emsg{get;set;}
    @AuraEnabled 
    public static List<attachWrapper> listAttachments{get;set;}
    @AuraEnabled
    public static Case cc{get;set;} 
    @AuraEnabled
    public static EmailMessage getEmailMessageRecToBePassed(String clickedEmailRecId){
        
        emsg = [Select Id, Subject,Status, HtmlBody, FromAddress,TextBody, FromName ,CcAddress, BccAddress,  ToAddress, MessageDate from EmailMessage where Id=:clickedEmailRecId];
        
        
        if(emsg.Status == '0'){
            emsg.Status = 'New';
        }
        if(emsg.Status == '1'){
            emsg.Status = 'Read';
        }
        if(emsg.Status == '2'){
            emsg.Status = 'Replied';
        }
        if(emsg.Status == '3'){
            emsg.Status = 'Sent';
        }
        if(emsg.Status == '4'){
            emsg.Status = 'Forwarded';
        }
        if(emsg.Status == '5'){
            emsg.Status = 'Outbound Draft';
        }
        
        system.debug('emsg*************'+emsg.Status);
        return emsg;
    }  
    @AuraEnabled
    public static List<attachWrapper> getAttachments(Id recId){
        system.debug('#recId:'+recId);
        listAttachments = new List<attachWrapper>();
        
        List<Attachment> lst = new List<Attachment>();
        
        List<Expedite__c> expdteId = new List<Expedite__c>();
        List<Id> csidslst = new List<Id>();
        set<Id> finalIds = new set<Id>();
        finalIds.add(recId);
        system.debug('finalIds'+finalIds);
        lst = [SELECT Id, Name FROM Attachment WHERE Parentid IN :finalIds];  
        system.debug('lst'+lst);
        List<ContentDocumentLink> contentDocs = [SELECT ContentDocument.Title,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :finalIds];
        System.debug('#contentDocs:'+contentDocs);
        if(lst != null && lst.size()>0){
            for(Attachment eachAttach : lst){
                attachWrapper att = new attachWrapper(false, eachAttach.Id, eachAttach.Name);
                listAttachments.add(att);
            }
        }
        if(contentDocs != null && contentDocs.size()>0){
            for(ContentDocumentLink eachAttach : contentDocs){
                attachWrapper att = new attachWrapper(false, eachAttach.ContentDocumentId, eachAttach.ContentDocument.Title);
                listAttachments.add(att);
            }
        }
        return listAttachments;  
    }
    public class attachWrapper{
        @AuraEnabled
        public Boolean selected{get; set;}
        @AuraEnabled
        public String attachmentId{get; set;}
        @AuraEnabled
        public String attachmentName{get; set;}
        public attachWrapper(Boolean selected, String attachmentId, String attachmentName){
            this.selected = selected;
            this.attachmentId = attachmentId;
            this.attachmentName = attachmentName;
        }
    }
    
     @AuraEnabled
    public static EmailMessage getEmailMessageRecToBePassedNew(Id clickedEmailRecId, String type){
        system.debug('clickedEmailRecId'+clickedEmailRecId);
         system.debug('type'+type);
        emsg = [Select Id, Subject, Status, HtmlBody,TextBody,FromAddress, ToAddress,CcAddress,HasAttachment, MessageDate,ParentId,Incoming from EmailMessage where Id=:clickedEmailRecId];
        
        
        if(type!=null && type.length()>0 && type.equalsIgnoreCase('reply')){
            emsg = getReplyEmailMsg(emsg, type);
        }else if(type!=null && type.length()>0 && type.equalsIgnoreCase('replyall')){
            emsg = getReplyEmailMsg(emsg, type);
        }
        else{}
        //else if(type!=null && type.length()>0 && type.equalsIgnoreCase('forward')){
        //    emsg = getForwardEmailMsg(emsg);
       // }
        /* else if(type!=null && type.length()>0 && type.equalsIgnoreCase('replyall')){
emsg = getReplyAllEmailMsg(emsg);
}*/     system.debug('emsg'+emsg);
        return emsg;
    }
    
    public static EmailMessage getReplyEmailMsg(EmailMessage emsg, String type){
        cc= [SELECT Id, Reference_No__c FROM Case where Id=:emsg.ParentId];
        String subject = emsg.Subject;
        String htmlBody = emsg.HtmlBody;
        String textBody = emsg.TextBody;
        String fromAddr = emsg.FromAddress; 
        DateTime sentDtTime = emsg.MessageDate;
        String reference = cc.Reference_No__c;
        String sentDateTime = sentDtTime.format(); 
        String toAddress = emsg.ToAddress; 
        String ccAddress = emsg.CcAddress;
        String preTextSecondPart = getPreTextHTMLString(fromAddr, sentDateTime, toAddress, subject, reference);
        String preText = '--------------- Original Message ---------------<br/>';
        preText = preText + preTextSecondPart;
        if((htmlBody==null || htmlBody.length()==0) && textBody!=null && textBody.length()>0){
            htmlBody = textBody;
        }
        htmlBody = '<br/><br/>'+preText + htmlBody;
        emsg.HtmlBody = htmlBody;
        emsg.Subject = 'RE: '+Subject;
        // emsg.FromAddress = fromAddr.remove('rcdexpediting@carrier.utc.com') +toAddress.remove('rcdexpediting@carrier.utc.com');
        if(type!=null && type.length()>0 && type.equalsIgnoreCase('ReplyAll')){
            System.debug('#ReplyAll:'+toAddress);
            emsg.FromAddress = toAddress+';'+fromAddr; 
        }else if(type!=null && type.length()>0 && type.equalsIgnoreCase('Reply')){
            emsg.FromAddress = fromAddr; 
        }
        
        if(emsg.FromAddress!=null && (emsg.FromAddress.contains('rcdexpediting@carrier.utc.com') || emsg.FromAddress.contains('rcdexpediting@carrier.utc.com;'))){
            if(emsg.FromAddress.contains('rcdexpediting@carrier.utc.com')){
                emsg.FromAddress = emsg.FromAddress.remove('rcdexpediting@carrier.utc.com');
            }else{
                emsg.FromAddress = emsg.FromAddress.remove('rcdexpediting@carrier.utc.com;');
            }
            if(emsg.FromAddress.contains('; ;')){
                emsg.FromAddress = emsg.FromAddress.replaceAll('; ;', ';');
            }else if(emsg.FromAddress.contains(';;')){
                emsg.FromAddress = emsg.FromAddress.replaceAll(';;', ';');
            }
            if(emsg.FromAddress.startsWith(';')){
                emsg.FromAddress = emsg.FromAddress.substring(1,emsg.FromAddress.length());
            }
            if(emsg.FromAddress.endsWith(';')){
                emsg.FromAddress = emsg.FromAddress.substring(0,emsg.FromAddress.length()-1);
            }
            
            
        }
        emsg.CcAddress = ccAddress;
        return emsg;
    }
    
     public static String getPreTextHTMLString(String fromAddr, String sentDateTime, String toAddress, String subject, String reference){
        String htmlToReturn = '';
        htmlToReturn = htmlToReturn + '<b>From: </b>';
        htmlToReturn = htmlToReturn + '['+fromAddr+']';
        htmlToReturn = htmlToReturn + '<br/>';
        htmlToReturn = htmlToReturn + '<b>Sent: </b>';
        htmlToReturn = htmlToReturn + '['+sentDateTime+']';
        htmlToReturn = htmlToReturn + '<br/>';
        htmlToReturn = htmlToReturn + '<b>To: </b>';
        htmlToReturn = htmlToReturn + '['+toAddress+']';
        htmlToReturn = htmlToReturn + '<br/>';
        htmlToReturn = htmlToReturn + '<b>Subject: </b>';
        htmlToReturn = htmlToReturn + ''+subject+'';
        htmlToReturn = htmlToReturn + '<br/>';
        // htmlToReturn = htmlToReturn + '<b>ref: </b>';
        htmlToReturn = htmlToReturn + '['+reference+']';
        htmlToReturn = htmlToReturn + '<br/>';
        
        return htmlToReturn;
    }
    @AuraEnabled
    public static void updateEmailMsgCustomStatus(String emailMsgId){
        if(emailMsgId!=null && emailMsgId.length()>0){
            EmailMessage msgToUpdate = [Select Id, Status_Custom__c from EmailMessage where Id=:emailMsgId];
            msgToUpdate.Status_Custom__c = 'Read';
            update msgToUpdate;
        }
    }
    @AuraEnabled
    public static Boolean checkIfCurrentLoggedInUserIsExpedite()
    {
        Boolean toReturn = false;
        return ExpediteUtility.checkIfCurrentLoggedInUserIsExpedite();
    }
    
    
    
}