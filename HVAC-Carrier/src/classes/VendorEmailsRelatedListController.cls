public class VendorEmailsRelatedListController  {
    @AuraEnabled
    public static List<EmailMessage> emails{get;set;}
    @AuraEnabled
    public static EmailMessage emsg{get;set;}
    @AuraEnabled
    public static Case cc{get;set;} 
    
    @AuraEnabled
    public static EmailMessage getEmailMessageRecToBePassed(Id clickedEmailRecId, String type, String expediteId){
        system.debug('clickedEmailRecId'+clickedEmailRecId);
        emsg = [Select Id, Subject, Status, HtmlBody,TextBody,FromAddress, ToAddress,CcAddress, MessageDate,ParentId from EmailMessage where Id=:clickedEmailRecId];
        String eNumber = '';
        if(expediteId!=null && expediteId.length()>0){
            eNumber = [Select Id, Name from Expedite__c where Id=:expediteId].Name;
        }
        if(type!=null && type.length()>0 && type.equalsIgnoreCase('reply')){
            emsg = getReplyEmailMsg(emsg, type, eNumber);
        }else if(type!=null && type.length()>0 && type.equalsIgnoreCase('replyall')){
            emsg = getReplyEmailMsg(emsg, type, eNumber);
        }else if(type!=null && type.length()>0 && type.equalsIgnoreCase('forward')){
            emsg = getForwardEmailMsg(emsg, eNumber);
        }
        
        return emsg;
    } 
    
    @AuraEnabled
    public static List<EmailMessage> getEmailMessageRec(Id expId){
        //Id caseId = [Select Id,Name,Case_Number__c from Expedite__c where Id=:expId].Case_Number__c;
        Expedite__c exp = [Select Id,Name,Case_Number__c from Expedite__c where Id=:expId];
        Id caseId = exp.Case_Number__c;
        system.debug(caseId);
        String contactEmail = getExpediteContactEmail(expId);
        system.debug('ContactEmail'+contactEmail);
        List<String> caseIds = new List<String>();
        caseIds.add(caseId);
        List<Case> childCases = [Select Id from Case where ParentId=:caseId];
        if(childCases!=null && childCases.size()>0){
            for(Case eachChildCaseId : childCases){
                caseIds.add(eachChildCaseId.Id);
            }
        }
        
        //emails = [Select Id, Subject, Status, FromAddress, ToAddress, MessageDate from EmailMessage where ParentId=:caseId order by createddate desc];
        emails = [Select Id, Subject, Status, FromAddress, ToAddress,CcAddress, MessageDate,IsExternallyVisible,HasAttachment,Incoming,HtmlBody,Status_Custom__c ,TextBody,RelatedToId,RelatedTo.Name from EmailMessage where ParentId IN :caseIds  order by createddate desc];
        system.debug('emails'+emails);
        for(EmailMessage em : emails){
            String customStatus = em.Status_Custom__c!=null && em.Status_Custom__c.length()>0?em.Status_Custom__c:'';
            if(em.Status == '0' && em.Status_Custom__c=='New'){
                em.Status = 'New';
            }else if(em.Status == '0' &&  em.Status_Custom__c!='New'){
                em.Status = 'Read';
            }
            if(em.Status == '1' && em.Status_Custom__c!='New'){
                em.Status = 'Read';
            }else if(em.Status == '1' && em.Status_Custom__c=='New'){
              	em.Status = 'New';  
            }
            if(em.Status == '2'){
                em.Status = 'Replied';
            }
            if(em.Status == '3'){
                em.Status = 'Sent';
            }
            if(em.Status == '4'){
                em.Status = 'Forwarded';
            }
            if(em.Status == '5'){
                em.Status = 'Outbound Draft';
            }
        }
        List<EmailMessage> msgs = new List<EmailMessage>();
        for(EmailMessage eachMsg : emails){
            if(checkIfSubjectContainsENumber(exp.Name, eachMsg)){
                String toAddr = eachMsg.ToAddress;
                String ccAddr = eachMsg.CcAddress;
                String fromAddr = eachMsg.FromAddress;
                System.debug('###Processing Email message:['+eachMsg.Id+'] Incoming:['+eachMsg.Incoming+'] and FromAddress:['+eachMsg.FromAddress+'] To Address:['+eachMsg.ToAddress+'] and CC Address:['+eachMsg.CcAddress+'].');
                if(ccAddr==null){
                    ccAddr = '';
                }
                if(eachMsg.Incoming==true && contactEmail != null){
                    //Check if contactemail contains in from email addr
                    if(!fromAddr.contains(contactEmail))
                        msgs.add(eachMsg);
                    system.debug('vendormsgs_true'+msgs);
                }else if((!toAddr.contains(contactEmail))&&((ccAddr==null) || (!ccAddr.contains(contactEmail))) && (contactEmail != null || contactEmail != '')){
                    //check if contactemail contains in either toAddr or ccAddr
                    if((!toAddr.contains(contactEmail))&&((ccAddr==null) || (!ccAddr.contains(contactEmail))))
                        msgs.add(eachMsg);
                    system.debug('vendormsgs_false'+msgs);
                }
                else
                {
                    if(contactEmail == null || contactEmail == ''){
                        
                        // if((!toAddr.contains(contactEmail))&&((ccAddr==null) || (!ccAddr.contains(contactEmail))))  
                        msgs.add(eachMsg);
                        system.debug('vendormsgs_false2'+msgs);
                    }
                }
            }
        }
        system.debug('msgs'+msgs);
        return msgs;
        
        
    }
    public static EmailMessage getReplyEmailMsg(EmailMessage emsg, String type, String eNumber){
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
        if(emsg.Subject!=null && emsg.Subject.length()>0 && !emsg.Subject.containsIgnoreCase('re:')){
            emsg.Subject = 'RE: '+Subject;
        }
        if(emsg.Subject!=null && !emsg.Subject.contains('E-')){
            emsg.Subject = emsg.Subject + '['+eNumber+']';
        }
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
    
    public static EmailMessage getForwardEmailMsg(EmailMessage emsg, String eNumber){
        cc= [SELECT Id, Reference_No__c FROM Case where Id=:emsg.ParentId];
        String subject = emsg.Subject;
        String htmlBody = emsg.HtmlBody;
        String textBody = emsg.TextBody;
        String fromAddr = emsg.FromAddress; 
        DateTime sentDtTime = emsg.MessageDate; 
        String reference = cc.Reference_No__c;
        String sentDateTime = sentDtTime.format(); 
        String toAddress = emsg.ToAddress; 
        String preTextSecondPart = getPreTextHTMLString(fromAddr, sentDateTime, toAddress, subject, reference);
        String preText = '--------------- Forwarded Message ---------------<br/>';
        preText = preText + preTextSecondPart;
        if((htmlBody==null || htmlBody.length()==0) && textBody!=null && textBody.length()>0){
            htmlBody = textBody;
        }
        htmlBody = '<br/><br/>'+preText + htmlBody;
        emsg.HtmlBody = htmlBody;
        if(emsg.Subject!=null && emsg.Subject.length()>0 && !emsg.Subject.containsIgnoreCase('fw:')){
            emsg.Subject = 'FW: '+Subject;
        } 
        if(emsg.Subject!=null && !emsg.Subject.contains('E-')){
            emsg.Subject = emsg.Subject + '['+eNumber+']';
        }
        emsg.FromAddress='';
        emsg.CcAddress='';
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
    public static case getNewmsg(Id expId)
    {
        system.debug('getNewmsg'+expId);
        Id caseId2 = [Select Id,Name,Case_Number__c from Expedite__c where Id=:expId].Case_Number__c; 
        Case c = [select Id, New_Msg__c from case where Id=:caseId2];
        system.debug('before c update'+c);
        c.New_Msg__c=false;
        system.debug('after c update'+c);
        update c;
        return c;
    }
    public static String getExpediteContactEmail(Id expediteId){
        String emailToReturn = '';
        if(expediteId!=null){
            Expedite__c exp =  [Select Id, Contact_Name__c from Expedite__c where Id=:expediteId];
            if(exp!=null && exp.Contact_Name__c!=null){
                Contact cont = [Select Id, Email from Contact where Id=:exp.Contact_Name__c];
                if(cont.Email!=null && cont.Email.length()>0){
                    emailToReturn = cont.Email;
                }
            }
        }
        return emailToReturn;
    }
    public static Boolean checkIfSubjectContainsENumber(String eNumber, EmailMessage emsg){
        Boolean contains = false;
        if(eNumber!=null && eNumber.length()>0 && emsg!=null && emsg.Subject!=null){
            String ENumberFromSubject = ExpediteReOpen.getExpediteNumberFromSubject(emsg.Subject);
            if(ENumberFromSubject!=null && ENumberFromSubject.length()>0 && ENumberFromSubject.equalsIgnoreCase(eNumber)){
                contains = true;
            }/*else if(ENumberFromSubject!=null && ENumberFromSubject.length()>0){
                contains = true;
            }*/else if(emsg!=null && emsg.FromAddress!=null && emsg.FromAddress.length()>0 && emsg.RelatedToId!=null && emsg.RelatedTo.Name!=null && emsg.RelatedTo.Name.equalsIgnoreCase(eNumber)){
                contains = true;
            }else if(emsg!=null && emsg.TextBody!=null && emsg.TextBody.length()>0){
                String ENumberFromBody = ExpediteReOpen.getExpediteNumberFromSubject(emsg.TextBody);
                if(ENumberFromBody!=null && ENumberFromBody.length()>0 && ENumberFromBody.equalsIgnoreCase(eNumber)){
                	contains = true;
            	}
            }
        }
        return contains;
    }
    @AuraEnabled
    public static List<EmailMessage> getAllEmails(Id expId)
    {
          //Id caseId = [Select Id,Name,Case_Number__c from Expedite__c where Id=:expId].Case_Number__c;
        Expedite__c exp = [Select Id,Name,Case_Number__c from Expedite__c where Id=:expId];
        Id caseId = exp.Case_Number__c;
        system.debug(caseId);
        String contactEmail = getExpediteContactEmail(expId);
        system.debug('ContactEmail'+contactEmail);
        List<String> caseIds = new List<String>();
        caseIds.add(caseId);
        List<Case> childCases = [Select Id from Case where ParentId=:caseId];
        if(childCases!=null && childCases.size()>0){
            for(Case eachChildCaseId : childCases){
                caseIds.add(eachChildCaseId.Id);
            }
        }
        
        //emails = [Select Id, Subject, Status, FromAddress, ToAddress, MessageDate from EmailMessage where ParentId=:caseId order by createddate desc];
        emails = [Select Id, Subject, Status, FromAddress, ToAddress,CcAddress, MessageDate,IsExternallyVisible,HasAttachment,Incoming,HtmlBody,Status_Custom__c ,TextBody,RelatedToId,RelatedTo.Name from EmailMessage where ParentId IN :caseIds  order by createddate desc];
        system.debug('emails'+emails);
        for(EmailMessage em : emails){
            if(em.Status == '0'){
                em.Status = 'New';
            }
            if(em.Status == '1'){
                em.Status = 'Read';
            }
            if(em.Status == '2'){
                em.Status = 'Replied';
            }
            if(em.Status == '3'){
                em.Status = 'Sent';
            }
            if(em.Status == '4'){
                em.Status = 'Forwarded';
            }
            if(em.Status == '5'){
                em.Status = 'Outbound Draft';
            }
        }
        List<EmailMessage> msgs = new List<EmailMessage>();
        for(EmailMessage eachMsg : emails){
            //if(checkIfSubjectContainsENumber(exp.Name, eachMsg)){
            if(true){    
                String toAddr = eachMsg.ToAddress;
                String ccAddr = eachMsg.CcAddress;
                String fromAddr = eachMsg.FromAddress;
                System.debug('###Processing Email message:['+eachMsg.Id+'] Incoming:['+eachMsg.Incoming+'] and FromAddress:['+eachMsg.FromAddress+'] To Address:['+eachMsg.ToAddress+'] and CC Address:['+eachMsg.CcAddress+'].');
                if(ccAddr==null){
                    ccAddr = '';
                }
                if(eachMsg.Incoming==true && contactEmail != null){
                    //Check if contactemail contains in from email addr
                    if(!fromAddr.contains(contactEmail))
                        msgs.add(eachMsg);
                    system.debug('vendormsgs_true'+msgs);
                }else if((!toAddr.contains(contactEmail))&&((ccAddr==null) || (!ccAddr.contains(contactEmail))) && (contactEmail != null || contactEmail != '')){
                    //check if contactemail contains in either toAddr or ccAddr
                    if((!toAddr.contains(contactEmail))&&((ccAddr==null) || (!ccAddr.contains(contactEmail))))
                        msgs.add(eachMsg);
                    system.debug('vendormsgs_false'+msgs);
                }
                else
                {
                    if(contactEmail == null || contactEmail == ''){
                        
                        // if((!toAddr.contains(contactEmail))&&((ccAddr==null) || (!ccAddr.contains(contactEmail))))  
                        msgs.add(eachMsg);
                        system.debug('vendormsgs_false2'+msgs);
                    }
                }
            }
        }
        system.debug('msgs'+msgs);
        return msgs;
    }
}