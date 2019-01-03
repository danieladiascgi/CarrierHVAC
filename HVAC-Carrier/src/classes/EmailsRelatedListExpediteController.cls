public class EmailsRelatedListExpediteController {
    
    public Expedite__c expd{get; set;}
    public Case cse {get;set;} 
    public List<EmailMessage> emails{get;set;}
    public List<EmailMessage> mails{get;set;}
    public List<EmailMessage> msgs{get;set;}
    public Boolean isInternalUser{get; set;}
    public String urlToPass{get; set;}

    public Case cases {get;set;} 

    public EmailsRelatedListExpediteController(ApexPages.StandardController controller){
      Expedite__c expd = (Expedite__c)controller.getRecord(); 
      Id expid=expd.Id;
   
      
       /* String caseId = [Select Id, Case_Number__c from Expedite__c where Id=:expd.Id].Case_Number__c;
        if(caseId!=null){
          cases = [Select Id from Case where id=:caseId];
          emails = [Select Id, Subject, Status, ToAddress, MessageDate from EmailMessage where ParentId=:cases.Id order by createddate desc];
        }*/
         Expedite__c exp = [Select Id,Name,Case_Number__c from Expedite__c where Id=:expid];
        Id caseId = exp.Case_Number__c;
        system.debug(caseId);
        String contactEmail = getExpediteContactEmail(expid);
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
        emails = [Select Id, Subject, Status, FromAddress, ToAddress,CcAddress, MessageDate,IsExternallyVisible,HasAttachment,Incoming,TextBody,RelatedToId,RelatedTo.Name from EmailMessage where ParentId IN :caseIds  order by createddate desc];
        system.debug('emails'+emails.size());
       
        
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
                msgs.add(eachMsg);
                /*if(eachMsg.Incoming==true && contactEmail != null){
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
                }*/
            }
        }
        system.debug('msgs'+msgs.size());
       mails = new List<EmailMessage>();
       mails =msgs; 
        
        isInternalUser = true;
        urlToPass = '';
        // return msgs;
    }
    
    //This method is to edit the existing Emails record while clicking the Reply link 

    public void replyEmail(){  

        String emailRecordId = Apexpages.currentpage().getParameters().get('emailRecordId');  
		System.debug('#emailRecordId:'+emailRecordId);
        System.debug('#expd:'+expd);
        System.debug('#expd.Id:'+expd.Id);
        //pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + '_ui/core/email/author/EmailAuthor?email_id='+emailRecordId+'&replyToAll=0&retURL/'+pymnt.Id);  
		urlToPass = (URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'apex/SendEmailExpeditePage?id='+expd.Id+'&emailRecordId='+emailRecordId);
      
        // pageReference pageRef = new pageReference('SendEmailPaymentPage');
        // return pageRef;
        //urlToPass = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'SendEmailPaymentPage';   
       
    }   
    
    public void NewEmail(){  

      //  String emailRecordId = Apexpages.currentpage().getParameters().get('emailRecordId');  
	//	System.debug('#emailRecordId:'+emailRecordId);
        System.debug('#expd.Id:'+expd.Id);
        //pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + '_ui/core/email/author/EmailAuthor?email_id='+emailRecordId+'&replyToAll=0&retURL/'+expd.Id);  
		urlToPass = (URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'apex/SendEmailExpeditePage?id='+expd.Id);
      
          
       
    } 
    
    public void toAll(){  

        String emailRecordId = Apexpages.currentpage().getParameters().get('emailRecordId');  
		System.debug('#emailRecordId:'+emailRecordId);
        System.debug('#expd.Id:'+expd.Id);
        //pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + '_ui/core/email/author/EmailAuthor?email_id='+emailRecordId+'&replyToAll=1&retURL/'+expd.Id);  
		urlToPass = URL.getSalesforceBaseUrl().toExternalForm() + '/' + '_ui/core/email/author/EmailAuthor?email_id='+emailRecordId+'&replyToAll=1&retURL/'+expd.Id;
        //return pageRef;  

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
            System.debug('#Subject['+emsg.Subject+'] #ENumberFromSubject['+ENumberFromSubject+'] - ENumber['+eNumber+']');
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
        System.debug('#Subject['+emsg.Subject+'] and ENumber['+eNumber+']');
        return contains;
    }

}