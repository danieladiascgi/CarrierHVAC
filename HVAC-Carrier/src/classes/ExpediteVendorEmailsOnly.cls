public class ExpediteVendorEmailsOnly {
    @InvocableMethod
    public static void getExpediteRecords(List<String> EmsgIDS){
        System.debug('#Inside getExpediteRecords');
        List<EmailMessage> EmsgLst =  [SELECT Id, Subject, TextBody, HTMLBody,FromAddress, ToAddress, CcAddress, ParentId,IsExternallyVisible FROM EmailMessage where id=:EmsgIDS order by CreatedDate Desc];
        if(EmsgLst!=null && EmsgLst.size()>0 )
        {
            EmailMessage emsg = EmsgLst.get(0);
            System.debug('#emsg:'+emsg);
            String csId = emsg.ParentId;
            System.debug('#csId:'+csId);
            if(csId!=null && csId.length()>0){
                List<Case> caseRecs = [Select Id, ContactId, Contact.Email from Case where Id=:csId];
                System.debug('#caseRecs:'+caseRecs);
                if(caseRecs!=null && caseRecs.size()>0){
                    Case cseRec = caseRecs.get(0);
                    if(cseRec!=null && cseRec.Contact!=null && cseRec.Contact.Email!=null && cseRec.Contact.Email.length()>0){
                        Boolean isVendorEmailOnly = false;
                        String contactEmail = cseRec.Contact.Email;
                        System.debug('#contactEmail:'+contactEmail);
                        Set<String> EmailAddresses = new Set<String>();
                    	//EmailAddresses.add(emsg.ToAddress);
                    	EmailAddresses.addAll(getEmailArray(emsg.ToAddress));
                        if(emsg.CcAddress!=null && emsg.CcAddress.length()>0){
                            EmailAddresses.addAll(getEmailArray(emsg.CcAddress));
                        }
                        System.debug('#EmailAddresses:'+EmailAddresses);
                        if(EmailAddresses!=null && EmailAddresses.size()>0){
                            /*for(String eachEmail : EmailAddresses){
                                if(!contactEmail.equalsIgnoreCase(eachEmail)){
                                    isVendorEmailOnly = true;
                                    System.debug('Email['+contactEmail+'] is either presetn in to or cc in Email Message, So Making IsExternallyVisisble False');
                                    //break;
                                }else{
                                    isVendorEmailOnly = false;
                                }
                            }*/
                            if(!EmailAddresses.contains(contactEmail.toLowerCase())){
                                isVendorEmailOnly = true;
                                System.debug('Email['+contactEmail+'] is not present in to or cc in Email Message{'+EmailAddresses+'}, So Making IsExternallyVisisble False');
                            }
                        }
                        if(isVendorEmailOnly!=null && isVendorEmailOnly==true){
                            emsg.IsExternallyVisible = false;
                            update emsg;
                            System.debug('#Update Successful:'+emsg);
                            List<Id> emailMessgeId = new List<Id>();
                            emailMessgeId.add(emsg.Id);
                            HideEmailsFromExternalVisiblity.hideVednorEmailsFromExternalVisiblity(emailMessgeId);
                        }
                    }
                }
            }
        }   
    }
    
    public static Set<String> getEmailArray(String emailAddress){
        Set<String> emailArr = new Set<String>();
        
        if(emailAddress!=null && emailAddress.length()>0){
            if(emailAddress.contains(';')){
                List<String> splitAddresses = emailAddress.split(';');
                if(splitAddresses!=null && splitAddresses.size()>0){
                    for(String eachEmail : splitAddresses){
                        emailArr.add(eachEmail.toLowerCase());
                    }
                }
            }else{
                emailArr.add(emailAddress.toLowerCase());
            }
        }
        return emailArr;
    }
}