public class EmailsRelatedListInCaseController {
    
    public Case cse {get;set;} 
    public List<EmailMessage> emails{get;set;}
    public List<EmailMessage> custmails{get;set;} 
    public Boolean isInternalUser{get; set;}
    public String urlToPass{get; set;}

    public Case cases {get;set;} 

    public EmailsRelatedListInCaseController(ApexPages.StandardController controller){
        cse = (Case)controller.getRecord();
        Id caseId =cse.Id;
        String contactEmail = getCaseContactEmail(caseId);
        //String caseId = [Select Id, C from Case where Id=:pymnt.Id].Case_Number__c;
        //cases = [Select Id from Case where id=:caseId];
        emails = [Select Id, Subject, Incoming, Status, FromAddress,FromName,HasAttachment, ToAddress,CcAddress, MessageDate,IsExternallyVisible,HtmlBody,Status_Custom__c,TextBody from EmailMessage where RelatedToId=:cse.Id order by createddate desc];
            
        
        //emails = [Select Id, Subject, Status, FromAddress, ToAddress, MessageDate from EmailMessage where ParentId=:caseId order by createddate desc];
      //  emails = [Select Id, Subject, Incoming, Status, FromAddress,FromName,HasAttachment, ToAddress,CcAddress, MessageDate,IsExternallyVisible,HtmlBody,Status_Custom__c from EmailMessage where ParentId IN :caseIds order by createddate desc];
        system.debug('emails'+emails);
        for(EmailMessage em : emails){
           
            
            
        }
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
       custmails = new List<EmailMessage>();
        custmails = msgs;
        
        isInternalUser = true;
        urlToPass = '';
    }
    
    //This method is to edit the existing Emails record while clicking the Reply link 

    public void replyEmail(){  

        String emailRecordId = Apexpages.currentpage().getParameters().get('emailRecordId');  
		System.debug('#emailRecordId:'+emailRecordId);
        
        //pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + '_ui/core/email/author/EmailAuthor?email_id='+emailRecordId+'&replyToAll=0&retURL/'+cse.Id);  
		//urlToPass = (URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'apex/SendEmailExpeditePage?id='+cse.Id+'&emailRecordId='+emailRecordId);
      	urlToPass = URL.getSalesforceBaseUrl().toExternalForm() + '/' + '_ui/core/email/author/EmailAuthor?email_id='+emailRecordId+'&replyToAll=0&retURL/'+cse.Id;
        // pageReference pageRef = new pageReference('SendEmailExpeditePage');
         //return pageRef;
        //urlToPass = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'SendEmailExpeditePage';   
       
    }   
    
    public void NewEmail(){  

      //  String emailRecordId = Apexpages.currentpage().getParameters().get('emailRecordId');  
	//	System.debug('#emailRecordId:'+emailRecordId);
        //System.debug('#pymnt.Id:'+pymnt.Id);
        //pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + '_ui/core/email/author/EmailAuthor?email_id='+emailRecordId+'&replyToAll=0&retURL/'+pymnt.Id);  
		//urlToPass = (URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'apex/SendEmailExpeditePage?id='+pymnt.Id);
      
          
       
    } 
    
    public void toAll(){  

        String emailRecordId = Apexpages.currentpage().getParameters().get('emailRecordId');  
		System.debug('#emailRecordId:'+emailRecordId);
        //System.debug('#pymnt.Id:'+pymnt.Id);
        //pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + '_ui/core/email/author/EmailAuthor?email_id='+emailRecordId+'&replyToAll=1&retURL/'+pymnt.Id);  
		urlToPass = URL.getSalesforceBaseUrl().toExternalForm() + '/' + '_ui/core/email/author/EmailAuthor?email_id='+emailRecordId+'&replyToAll=1&retURL/'+cse.Id;
        //return pageRef;  

    }  
    
    public static String getCaseContactEmail(Id caseId){
        String emailToReturn = '';
        if(caseId!=null){
            Case c =  [Select Id, ContactEmail from Case where Id=:caseId];
           // if(c!=null && c.ContactEmail!=null){
              //  Contact cont = [Select Id, Email from Contact where Id=:c.ContactEmail];
              //  if(cont.Email!=null && cont.Email.length()>0){
                    emailToReturn = c.ContactEmail;
                }
            
        
        system.debug('emailToReturn'+emailToReturn);
        return emailToReturn;
    }

}