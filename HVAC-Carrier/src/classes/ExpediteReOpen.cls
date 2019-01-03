public class ExpediteReOpen {
    @InvocableMethod
    public static void getExpediteRecords(List<String> EmsgIDS){
        
        List<EmailMessage> EmsgLst =  [SELECT Id, Subject, TextBody, HTMLBody,FromAddress, ToAddress, CcAddress, ParentId, IsExternallyVisible FROM EmailMessage where id=:EmsgIDS order by CreatedDate Desc];
        if(EmsgLst!=null && EmsgLst.size()>0 )
        {
            EmailMessage emsg = EmsgLst.get(0);
            String expediteNumber = '';
            //Id ExpId = emsg.Id;
            String textBody = emsg.TextBody;
            String htmlBody = emsg.HtmlBody;
            String caseId = emsg.ParentId;
            String caseContactEmail = getCaseContactEmail(caseId);
            System.debug('#caseContactEmail:'+caseContactEmail);
            if(checkIfMessageContactContactEmail(caseContactEmail, emsg)){
                System.debug('#Reopening Case');
                reopenCase(caseId);
            }else if(emsg!=null && emsg.Subject!=null && emsg.Subject.contains('E-') /*&& (emsg.TextBody.contains('RCD Expediting') || emsg.HtmlBody.contains('RCD Expediting'))*/){
                expediteNumber = getExpediteNumberFromSubject(emsg.Subject);
                System.debug('#Expedite Number:'+expediteNumber);
                if(expediteNumber!=null && expediteNumber.length()>0){
                    List<Expedite__c> expLst = [select Id,Expedite_Status__c from Expedite__c where Name=:expediteNumber];
                    if(expLst!=null && expLst.size()>0){
                        Expedite__c Exp=expLst.get(0);
                        if(Exp.Expedite_Status__c!=null && Exp.Expedite_Status__c=='Closed'){
                            system.debug('Before Update'+Exp);
                            Exp.Expedite_Status__c='Re-Open';
                            Update Exp;
                            system.debug('After Update'+Exp);
                        }
                        emsg.IsExternallyVisible = false;
                        //System.debug('#Emsg:'+emsg);
                        update emsg;
                        List<Id> emailMsgId = new List<Id>();
                        emailMsgId.add(emsg.Id);
                        System.debug('#Calling Future Method:'+emailMsgId);
                        HideEmailsFromExternalVisiblity.hideVednorEmailsFromExternalVisiblity(emailMsgId);
                        List<Id> expediteIdLst = new List<Id>();
                        expediteIdLst.add(Exp.Id);
                        HideEmailsFromExternalVisiblity.postToExpediteGroup(expediteIdLst, emailMsgId);
                    }
                }
            }
            
            
        }
        
    }
    public static String getExpediteNumberFromSubject(String subject){
        String expediteNumberToRet = '';
        if(subject!=null && subject.contains('E-')){
            String expediteNumberProcess = subject.Substring(subject.indexOf('E-'), subject.length());
            if(expediteNumberProcess!=null && expediteNumberProcess.length()>0){
                if(expediteNumberProcess.contains(' ')){
                    expediteNumberToRet = expediteNumberProcess.substring(0, expediteNumberProcess.indexOf(' '));
                    if(expediteNumberToRet!=null && expediteNumberToRet.length()>0){
                        expediteNumberToRet = expediteNumberToRet.trim();
                    }
                }
            }
        }    
        return expediteNumberToRet;
    }
    public static String getCaseContactEmail(String caseId){
        String contactEmailToReturn = '';
        if(caseId!=null && caseId.length()>0){
            Case cse = [SElect Id, ContactEmail from Case where Id=:caseId];
            if(cse!=null && cse.ContactEmail!=null && cse.ContactEmail.length()>0){
                contactEmailToReturn = cse.ContactEmail;
            }
        }
        return contactEmailToReturn;
    }
    
    public static Boolean checkIfMessageContactContactEmail(String caseContactEmail, EmailMessage emsg){
        Boolean toReturn = false;
        if(caseContactEmail!=null && caseContactEmail.length()>0){
            System.debug('#FromAddr:'+emsg.FromAddress);
            System.debug('#ToAddress:'+emsg.ToAddress);
            System.debug('#CcAddress:'+emsg.CcAddress);
            if(emsg.FromAddress!=null && emsg.FromAddress.length()>0 && emsg.FromAddress.containsIgnoreCase(caseContactEmail)){
                System.debug('#Inside From Addr');
                toReturn = true;
            }else if(emsg.ToAddress!=null && emsg.ToAddress.length()>0 && emsg.ToAddress.containsIgnoreCase(caseContactEmail)){
                System.debug('#Inside To Addr');
                toReturn  = true;
            }else if(emsg.CcAddress!=null && emsg.CcAddress.length()>0 && emsg.CcAddress.containsIgnoreCase(caseContactEmail)){
                System.debug('#Inside CC Addr');
                toReturn  = true;
            }else{
                toReturn = false;
            }
        }
        System.debug('#toReturn:'+toReturn);
        return toReturn;
    }
    
    public static void reopenCase(String caseId){
        if(caseId!=null && caseId.length()>0 ){
            Case cseToReOpen = [Select Id, Status from Case where Id=:caseId];
            cseToReOpen.Status = 'Re-Open';
            update cseToReOpen;
        }
    }
}