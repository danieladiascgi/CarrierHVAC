public class ExpediteSendEmailController {
    @AuraEnabled
    public static EmailMessage emailMsg {get; private set;}
    @AuraEnabled
    public static String SUPPORT_EMAIL_ADDRESS{get;set;}
    @AuraEnabled
    Public static List<EmailTemplate> tempList{get;set;}
    @AuraEnabled 
    public static List<attachWrapper> listAttachments{get;set;}
    @AuraEnabled 
    public static List<Id> lstIds{get;set;}
    @AuraEnabled
    public static boolean flag{get;set;}
    @AuraEnabled
    public static String selectedfrom{get;set;}
    
    @AuraEnabled
    public static List<EmailTemplate> selectTemplatePopup(){
        tempList=new List<EmailTemplate>();
        tempList=[ SELECT Id,Name,Subject,TemplateType,Description,Folder.Name FROM EmailTemplate where Folder.Name='Expedite'];
        /*listTemplates=new List<templateWrapper>();
if(tempList != null && tempList.size()>0){
for(EmailTemplate eachtemp : tempList){
templateWrapper tt = new templateWrapper(false, eachtemp);
listTemplates.add(tt);
}
}*/
        return tempList;
    }
     @AuraEnabled 
    public static user fetchUser(){
        User u = [select id,Name,alias,Email from User where id =: userInfo.getUserId()];
        System.debug('#userNew:'+u);
        
        return u;
    }
    
   /* @AuraEnabled
    public static Expedite__c DisplayContactEmail(Id ExpId)
    {
     Expedite__c exp = [Select Sender_s_Email__c from Expedite__c where Id=:ExpId]; 
        system.debug('exp'+exp);
     return exp;
    }*/
    
    @AuraEnabled    
    public static EmailMessage populateBodyWithTemplate(Id expId,Id paramRec,EmailMessage emailMsg) {
        System.debug('paramRec'+paramRec);
        Expedite__c exp = [Select Id,Name,Contact_Name__c, Case_Number__r.Reference_No__c,Sender_s_Email__c from Expedite__c where Id=:expId];
        System.debug('exp.Contact_Name__c'+exp.Contact_Name__c);
        System.debug('exp.Id'+exp.Id);
        Messaging.SingleEmailMessage email =
            Messaging.renderStoredEmailTemplate(paramRec , exp.Contact_Name__c , exp.Id);
        system.debug(email.getHTMLBody());                
        if(email.getHTMLBody()!=null){
            emailMsg.HtmlBody = '' + email.getHTMLBody();
        }else if(email.getPlainTextBody()!=null){
            String plainTextBody = email.getPlainTextBody();
            plainTextBody = plainTextBody.replace('\r\n', '<br/>');
            plainTextBody = plainTextBody.replace('\n', '<br/>');
            plainTextBody = plainTextBody.replace('\r', '<br/>');
            emailMsg.HtmlBody =''+plainTextBody;
        }
        if(email.getSubject()!=null){
            emailMsg.Subject = email.getSubject()+ ' ['+exp.Case_Number__r.Reference_No__c+']';
        }
        return emailMsg;
        
        //displayPopup = false;
        
    }
    
    @AuraEnabled
    public static EmailMessage populateTemplate(Id expId) {
        System.debug('inside method');
        //SUPPORT_EMAIL_ADDRESS = 'contact.carrier@carrier.utc.com';
        Expedite__c exp = [Select Id,Name,Case_Number__r.Reference_No__c,Sender_s_Email__c from Expedite__c where Id=:expId];   
        emailMsg = new EmailMessage();
        // now populate our fields with values from SingleEmailMessage.
        emailMsg.BccAddress  = UserInfo.getUserEmail();
        emailMsg.Subject     = exp.Name;
        emailMsg.HtmlBody    = '';
        String emailAddress = '';
        Id ContactId = [SELECT Id,Case_Number__r.ContactId FROM Expedite__c where id=:expId].Case_Number__r.ContactId;
        if(ContactId!=null){
            emailAddress = [Select Email from Contact where Id = :ContactId].Email;
        }
        
        //EmailMessage tempMsg = null;
        // System.debug('#emailMessageRecordId:'+emailMessageRecordId);
        // if(emailMessageRecordId!=null){
        //tempMsg = [Select Id, Subject, TextBody,HtmlBody, BccAddress, CcAddress, ParentId, ToAddress, FromAddress from EmailMessage where Id=:emailMessageRecordId];
        //emailMsg.Subject = tempMsg.Subject;
        
        //System.debug('#tempMsg.HtmlBody:'+tempMsg.HtmlBody);
        //emailMsg.HtmlBody = tempMsg.HtmlBody;
        
        // }
        if(emailMsg.Subject!=null && !emailMsg.Subject.contains('ref:')){
            if(exp.Case_Number__r.Reference_No__c != null){
                emailMsg.Subject = emailMsg.Subject + ' ['+exp.Case_Number__r.Reference_No__c+']';
                emailMsg.HtmlBody = emailMsg.HtmlBody + ' <br/><br/>['+exp.Case_Number__r.Reference_No__c+']';
            }
        }
        
        
        //emailMsg.ToAddress   = dummyEmailMsg.getToAddresses();
        //  emailMsg.FromAddress = SUPPORT_EMAIL_ADDRESS; 
        //emailMsg.FromAddress = selectedfrom; 
        emailMsg.CcAddress   = '';
        emailMsg.ParentId    = exp.Case_Number__c;
        emailMsg.ToAddress =  emailAddress;
        
        return emailMsg;
        
    }
    @AuraEnabled
    public static boolean sendMailMethod(String mMail ,String mFrom,String mCc, String mSubject ,String mbody,String selectedAttachsStr,Id recId){
        system.debug('mFrom:'+mFrom);
        if(mCc==null || mCc.length()==0){
            mCc = '';
        }
        //  mFrom = 'contact.carrier@carrier.utc.com';
        System.debug('#selectedAttachsStr:'+selectedAttachsStr);
        List<SelectedAttachs> selectedRecords = (List<SelectedAttachs>) System.JSON.deserialize(selectedAttachsStr, List<SelectedAttachs>.class);
        System.debug('#selectedRecords:'+selectedRecords);
        if(selectedRecords!=null && selectedRecords.size()>0){
            System.debug('#Selected Record 0:'+selectedRecords.get(0).value);
        }
        List<String> attachmentIdsToQuery = new List<String>();
        List<String> attachmentsToQuery = new List<String>();
        List<String> filesToQuery = new List<String>();
        if(selectedRecords!=null && selectedRecords.size()>0){
            System.debug('#Inside if Step 1');
            for(SelectedAttachs eachWrap : selectedRecords){
                System.debug('#Inside for Step 2');
                attachmentIdsToQuery.add(eachWrap.value);
                System.debug('#Inside for Step 2 - Added:'+attachmentIdsToQuery);
                
            }
        }
        System.debug('#attachmentIdsToQuery:'+attachmentIdsToQuery);
        if(attachmentIdsToQuery != null){
            for(String s : attachmentIdsToQuery){
                if (s.startsWith('00P')){
                    attachmentsToQuery.add(s);  
                }
                
                if (s.startsWith('069')){
                    filesToQuery.add(s); 
                }
            }
        }
        Attachment[] values = null;
        if(attachmentsToQuery!=null && attachmentsToQuery.size()>0){
            values = [Select Id, Name, Body from Attachment where id in :attachmentsToQuery];
            //values = [SELECT ContentDocument.Title,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId in :attachmentIdsToQuery];
        }
        System.debug('#Values:'+values);
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        //JSON.deserialize(mfile)
        /*Attachment[] values = (Attachment[])System.JSON.deserializeUntyped(mfile);*/ 
        List<ContentVersion> ver = [SELECT Id, ContentDocumentId, Title, ContentBodyId, ContentSize,VersionData FROM ContentVersion where ContentDocumentId in:filesToQuery];
        if(ver != null){
            for(ContentVersion a : ver){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                //   efa.id(a.id);
                efa.setFileName(a.Title);
                efa.setBody(a.VersionData);
                fileAttachments.add(efa);
            }
        }
        if(values != null){
            for(Attachment a : values){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                //   efa.id(a.id);
                efa.setFileName(a.Name);
                efa.setBody(a.Body);
                fileAttachments.add(efa);
            }
        }
        system.debug('fileAttachments'+fileAttachments);
        system.debug('fileAttachments'+fileAttachments.size());
        //  List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //List<List<Contact>> findContact=new List<List<Contact>>();
        List<List<Contact>> findContact= [FIND :mMail IN Email Fields RETURNING Contact(Id)];
        system.debug('---------------> SOQL Value'+findContact);
        
        //List<Payment__c> caseId = new List<Payment__c>();
        //recId='a1W63000000QVDc';
        
        Contact [] contactList = ((List<Contact>)findContact[0]);
        contactList=[Select Id, Email from Contact where Id in:contactList];
        system.debug('-------------->querying and assigning the contacts to list'+contactList);
        
        Id ContactId = [SELECT Id,Case_Number__r.ContactId FROM Expedite__c where id=:recId].Case_Number__r.ContactId;
        //List<Case> ContactId = new List<Case>();
        //ContactId = [SELECT Id, ContactId FROM Case where id=:caseId];
        Id ContactIdFinal;
        
        if(contactList != null){
            for(Contact c : contactList){
                if(c.Id == ContactId){
                    ContactIdFinal = c.id; 
                    break;
                }
            }
        }
        else{
            /* Contact c = new Contact();
c.Email = mMail;
insert c;
ContactIdFinal = c.id;*/
        }
        system.debug('---------------> SOQL Value3'+ContactIdFinal);
        // Step 2: Set list of people who should get the email
        List<String> sendTo = new List<String>();
        List<String> sendCc = new List<String>();
        
        if(mMail.contains(';')){
            List<String> emails = mMail.split(';');
            if(emails!=null && emails.size()>0){
                for(String eachEmail : emails){
                    if(eachEmail!=null && eachEmail.length()>0 && validateEmail(eachEmail)){
                        sendTo.add(eachEmail);
                    }else{
                        System.debug('#Email address['+eachEmail+'] is not valid and hence not sending email to this address.');
                    }
                }
            }
        }else{
            if(validateEmail(mMail)){
                sendTo.add(mMail);
            }
            
        }
        
         if(mCc!=null && mCc.length()>0 && mCc.contains(';')){
            List<String> emails = mCc.split(';');
            if(emails!=null && emails.size()>0){
                for(String eachEmail : emails){
                    if(eachEmail!=null && eachEmail.length()>0 && validateEmail(eachEmail)){
                        sendCc.add(eachEmail);
                    }else{
                        System.debug('#Email address['+eachEmail+'] is not valid and hence not sending email to this address.');
                    }
                }
            }
        }else{
            if(validateEmail(mCc)){
                sendCc.add(mCc);
            }
            
        }
        
        Id orgWideId;
        system.debug('User'+UserInfo.getUserEmail());
       // String UserEmail = UserInfo.getUserEmail();
        if(mFrom != UserInfo.getUserEmail())
        {
         orgWideId = [select id, Address from OrgWideEmailAddress where Address = :mFrom].id;
         mail.setOrgWideEmailAddressId(orgWideId);
         System.debug('orgWideId..'+orgWideId);
        }
        Id csId = [Select Id,Name,Case_Number__c from Expedite__c where Id=:recId].Case_Number__c; 
        mail.setToAddresses(sendTo);
        mail.setCcAddresses(sendCc);
        // mail.setWhatId('500630000047FHe');
        mail.setTargetObjectId(ContactIdFinal);
        mail.setWhatId(recId);
        mail.setSaveAsActivity(true);
        
        // Step 3: Set who the email is sent from
        //   mail.setReplyTo('noreply@gmail.com'); // change it with your mail address.
        //mail.setSenderDisplayName('salesforce User'); 
        
        // Step 4. Set email contents - you can use variables!
        mail.setSubject(mSubject);
        mail.setHtmlBody(mbody);
        mail.setFileAttachments(fileAttachments);
        // mail.setAttachment(file);
        //   mail.setTargetObjectId(UserInfo.getUserId());
        //   mail.setWhatId('500630000047FHe');
        //  mail.setSaveAsActivity(true);
        // Step 5. Add your email to the master list
        //     mail.add(mail);
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            flag = true;
            if(mCc==null){
                mCc = '';
            }
            
            String contactEmail = getExpediteContactEmail(recId);
            EmailMessage EmailMesssageRec = new EmailMessage (
                ParentId = csId,
                RelatedToId = recId,
                //FromName = 'FromName',
                FromAddress = mFrom,
                CcAddress = mCc,
                ToAddress = mMail,
                Subject = mSubject,
                HtmlBody = mbody
                
                //MessageDate = 'DateTimeFormat',
                //Status = 'New',
                //Incoming = true,
                //Headers = 'Internet message headers of the incoming email',
                //ActivityId = Activity.id        
            );
            insert EmailMesssageRec;
            if(fileAttachments!=null && fileAttachments.size()>0){
                List<Attachment> attachs = new List<Attachment>();
                for(Messaging.EmailFileAttachment eachAttach : fileAttachments){
                    Attachment newAttach = new ATtachment();
                    newAttach.Name = eachAttach.FileName;
                    newAttach.Body = eachAttach.Body;
                    newAttach.ParentId = EmailMesssageRec.Id;
                    attachs.add(newAttach);
                }
                if(attachs!=null && attachs.size()>0){
                    insert attachs;
                }
            }
            //    apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Email Sent!!'));
        }catch(exception e){
            flag = false;
            
            //    apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        } 
        system.debug('flag'+flag);
        return flag;
        
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
        expdteId = [SELECT Id,Case_Number__c FROM Expedite__c where id=:recId];
        system.debug('expdteId'+expdteId);
        system.debug('expdteId'+expdteId.size());
        if(expdteId!=null && expdteId.size()>0){
            
            for (Expedite__c objPay:expdteId)
            {
                csidslst.Add(objpay.Case_Number__c);
            }
            List<Case> childCases = [Select Id from Case where ParentId=:expdteId.get(0).Case_Number__c];
           if(childCases!=null && childCases.size()>0){
               for(Case eachChildCaseId : childCases){
                   csidslst.add(eachChildCaseId.Id);
               }
           }
        }
        
        finalIds.addAll(csidslst);
        
        system.debug('csids'+csidslst);
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
    
    
    public class SelectedAttachs {
        public String value;
    }
    
    public static Boolean validateEmail(String email) {
        Boolean res = true;
        if(email!=null && email.length()>0){
          email = email.trim();
      }
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        
        if (!MyMatcher.matches()) 
            res = false;
        return res;  
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

}