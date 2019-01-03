global class CRNA_Notification {
    
    global static Map<NotificationRequest, Set<Id>> nr2ContactsMap;
    global static Map<Id, Map<String, Integer>> case2SentEmailsMap;
    
    @InvocableMethod(label='Send CRNA Order Email')
    global static void sendOrderEmail(List<NotificationRequest> requests) {
        
        Set<Id> caseIds = new Set<Id>();
        Set<Id> caseAccountIds = new Set<Id>();
        Set<Id> caseContactIds = new Set<Id>();
        for(NotificationRequest nr : requests) {
            caseIds.add(nr.caseRecord.Id);
            caseAccountIds.add(nr.caseRecord.AccountId);
            caseContactIds.add(nr.caseRecord.ContactId);
        }
        System.debug('caseIds: '+caseIds);
        System.debug('caseAccountIds: '+caseAccountIds);
        System.debug('caseContactIds: '+caseContactIds);
        
        case2SentEmailsMap = new Map<Id, Map<String, Integer>>();
        if(caseIds.size() > 0) {
            for(EmailMessage em : [select Id, ParentId, Subject from EmailMessage where ParentId in :caseIds and Incoming=false]) {
                if(case2SentEmailsMap.containsKey(em.ParentId)) {
                    if(case2SentEmailsMap.get(em.ParentId).containsKey(em.Subject)) {
                        integer i = case2SentEmailsMap.get(em.ParentId).get(em.Subject);
                        i++;
                        case2SentEmailsMap.get(em.ParentId).put(em.Subject, i);
                    } else {
                        case2SentEmailsMap.get(em.ParentId).put(em.Subject, 1);
                    }
                } else {
                    Map<String, Integer> newMap = new Map<String, Integer>();
                    newMap.put(em.Subject, 1);
                    case2SentEmailsMap.put(em.ParentId, newMap);
                }
            }
        }
        System.debug('case2SentEmailsMap: '+case2SentEmailsMap);
        System.debug('caseAccountIds: '+caseAccountIds);
        System.debug('caseAccountIds size: '+caseAccountIds.size());
        
        Map<Id, Set<Id>> acc2ParentMap = new Map<Id, Set<Id>>();
        Set<Id> allAccountIds = new Set<Id>();
        System.debug('allAccountIds before: '+allAccountIds);
        System.debug('allAccountIds size before: '+allAccountIds.size());
        
        if(caseAccountIds.size() > 0) {
            for(Id ca : caseAccountIds) {
                Set<Id> cIds = new Set<Id>();
                Set<Id> parentIds = new Set<Id>();
                
                if(ca != null) {
                    cIds.add(ca);
                    allAccountIds.add(ca);
                    parentIds = getAllParentIds(cIds);
                }
                
                if(parentIds.size() > 0) {
                    acc2ParentMap.put(ca, parentIds);
                    allAccountIds.addAll(parentIds);
                }
            }    
        }
        System.debug('acc2ParentMap: '+acc2ParentMap);
        System.debug('allAccountIds after: '+allAccountIds);
        System.debug('allAccountIds size after: '+allAccountIds.size());
        
        
        Map<Id, List<Contact>> acc2ContactsMap = new Map<Id, List<Contact>>();
        Map<Id, List<Notification_Subscription__c>> accSubsMap = new Map<Id, List<Notification_Subscription__c>>();
        Map<Id, List<Notification_Subscription__c>> conSubsMap = new Map<Id, List<Notification_Subscription__c>>();
        
        if(allAccountIds.size() > 0) {
            for(Contact c : [Select Id, AccountId, (Select Notification_Type__c, IsNotify__c from Notification_Subscriptions__r) from Contact where AccountId in :allAccountIds]) {
                if(acc2ContactsMap.containsKey(c.AccountId)) {
                    acc2ContactsMap.get(c.AccountId).add(c);
                } else {
                    List<Contact> contacts = new List<Contact>();
                    contacts.add(c);
                    acc2ContactsMap.put(c.AccountId, contacts);
                }
            }
            
            for(Notification_Subscription__c ns : [Select Account__c, Include_Child_Accounts__c, Notification_Type__c, IsNotify__c 
                                                   from Notification_Subscription__c 
                                                   where Account__c in :allAccountIds]){
                                                       if(accSubsMap.containsKey(ns.Account__c)) {
                                                           accSubsMap.get(ns.Account__c).add(ns);
                                                       } else {
                                                           List<Notification_Subscription__c> subs = new List<Notification_Subscription__c>();
                                                           subs.add(ns);
                                                           accSubsMap.put(ns.Account__c, subs);
                                                       }
                                                   }
        }
        
        if(caseContactIds.size() > 0) {
            for(Notification_Subscription__c ns : [Select Contact__c, Notification_Type__c, IsNotify__c 
                                                   from Notification_Subscription__c 
                                                   where Account__c=null and Contact__c in :caseContactIds]){
                                                       if(conSubsMap.containsKey(ns.Contact__c)) {
                                                           conSubsMap.get(ns.Contact__c).add(ns);
                                                       } else {
                                                           List<Notification_Subscription__c> subs = new List<Notification_Subscription__c>();
                                                           subs.add(ns);
                                                           conSubsMap.put(ns.Contact__c, subs);
                                                       }
                                                   }
        }
        
        System.debug('acc2ContactsMap: '+acc2ContactsMap);
        System.debug('accSubsMap: '+accSubsMap);
        System.debug('conSubsMap: '+conSubsMap);
        
        nr2ContactsMap = new Map<NotificationRequest, Set<Id>>();
        //Parent Accounts
        if(acc2ParentMap.size() > 0) {
            for(NotificationRequest nr : requests) {
                for(Id parentAccId : acc2ParentMap.get(nr.caseRecord.AccountId)) {
                    if(accSubsMap.containsKey(parentAccId)){
                        for(Notification_Subscription__c nsa : accSubsMap.get(parentAccId)) {
                            if(nsa.IsNotify__c && nsa.Notification_Type__c == nr.notificationType && nsa.Include_Child_Accounts__c) {
                                if(acc2ContactsMap.containsKey(parentAccId)) {
                                    for(Contact c : acc2ContactsMap.get(parentAccId)) {
                                        for(Notification_Subscription__c nsc : c.Notification_Subscriptions__r) {
                                            if(nsc.Notification_Type__c == nr.notificationType && nsc.IsNotify__c) {
                                                if(nr2ContactsMap.containsKey(nr)) {
                                                    nr2ContactsMap.get(nr).add(c.Id);
                                                } else {
                                                    Set<Id> contactIds = new Set<Id>();
                                                    contactIds.add(c.Id);
                                                    nr2ContactsMap.put(nr, contactIds);
                                                }
                                            }
                                        }
                                    }    
                                }
                            }
                        }
                    }
                }
            }
        }
                
        if(accSubsMap.size() > 0) { //Subscribed Accounts
            for(NotificationRequest nr : requests) {
                for(Id saId : caseAccountIds) {
                    if(accSubsMap.containsKey(saId)) {
                        for(Notification_Subscription__c nsa1 : accSubsMap.get(saId)) {
                            if(nsa1.IsNotify__c && nsa1.Notification_Type__c == nr.notificationType) {
                                if(acc2ContactsMap.containsKey(saId)) {
                                    for(Contact c1 : acc2ContactsMap.get(saId)) {
                                        for(Notification_Subscription__c nsc1 : c1.Notification_Subscriptions__r) {
                                            if(nsc1.Notification_Type__c == nr.notificationType && nsc1.IsNotify__c) {
                                                if(nr2ContactsMap.containsKey(nr)) {
                                                    nr2ContactsMap.get(nr).add(c1.Id);
                                                } else {
                                                    Set<Id> contactIds1 = new Set<Id>();
                                                    contactIds1.add(c1.Id);
                                                    nr2ContactsMap.put(nr, contactIds1);
                                                }
                                            }
                                        }
                                    }    
                                }
                            }
                        }    
                    }
                }
            }
        } 
        
        //Subscribed Contacts
        if(conSubsMap.size() > 0) {
            for(NotificationRequest nr : requests) {
                for(Id scId : caseContactIds) {
                    if(conSubsMap.containsKey(scId)) {
                        for(Notification_Subscription__c nsa2 : conSubsMap.get(scId)) {
                            if(nsa2.IsNotify__c && nsa2.Notification_Type__c == nr.notificationType) {
                                if(nr2ContactsMap.containsKey(nr)) {
                                    nr2ContactsMap.get(nr).add(scId);
                                } else {
                                    Set<Id> contactIds2 = new Set<Id>();
                                    contactIds2.add(scId);
                                    nr2ContactsMap.put(nr, contactIds2);
                                }
                            }
                        }    
                    }
                }
            }
        }

        System.debug('nr2ContactsMap: '+nr2ContactsMap);
        
        //Send Email to subscribed Contacts
        if(nr2ContactsMap.size() > 0) {
            sendEmail(requests);
        }
    }
    
    //Get Parent Account Ids
    public static Set<ID> getAllParentIds(Set<ID> childIds) {
        Set<ID> parentIds = new Set<ID>();
        for(Account a : [SELECT ParentId FROM Account WHERE Id IN :childIds AND ParentId != null]) {
            parentIds.add(a.ParentId);
        }
        if(parentIds.size() > 0) {
            parentIds.addAll(getAllParentIds(parentIds));
        }
        return parentIds;
    }
    
    
    public static void sendEmail(List<NotificationRequest> requests) {
        System.debug('requests: '+requests);
        Set<String> templateNames = new Set<String>();
        Set<String> senderNames = new Set<String>();
        
        Map<String, String> nType2SubjectMap = new Map<String, String>();
        for(Notification2EmailSubjectMap__mdt nes : [select MasterLabel, EmailSubject__c from Notification2EmailSubjectMap__mdt where EmailSubject__c!= null]) {
            nType2SubjectMap.put(nes.MasterLabel, nes.EmailSubject__c);
        }
        System.debug('nType2SubjectMap: '+nType2SubjectMap);
        
        for(NotificationRequest nr : requests) {
            templateNames.add(nr.emailTemplateName);
            senderNames.add(nr.SenderDisplayName);
        }
        
        Map<String, Id> templateMap = new Map<String, Id>();
        for(EmailTemplate et : [Select Id, Name from EmailTemplate where Name in :templateNames])
            templateMap.put(et.Name, et.Id);
        
        Map<String, Id> senderNameMap = new Map<String, Id>();
        for(OrgWideEmailAddress owa : [Select Id, DisplayName from OrgWideEmailAddress where DisplayName in :senderNames])
            senderNameMap.put(owa.DisplayName, owa.Id);
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(NotificationRequest nr : requests) {
            System.debug('nr.notificationType: '+nr.notificationType);
            System.debug('nType2SubjectMap has Key? '+nType2SubjectMap.containsKey(nr.notificationType));
            if(nType2SubjectMap.containsKey(nr.notificationType)) {
                System.debug('nr.caseRecord.Id: '+nr.caseRecord.Id);
                System.debug('case2SentEmailsMap has Key? '+case2SentEmailsMap.containsKey(nr.caseRecord.Id));
                
                if(case2SentEmailsMap.size() == 0 ||
                   (case2SentEmailsMap.containsKey(nr.caseRecord.Id) && !case2SentEmailsMap.get(nr.caseRecord.Id).containsKey(nType2SubjectMap.get(nr.notificationType)))) {
                       Set<Id> contactIds = new Set<Id>();
                       contactIds = nr2ContactsMap.get(nr);
                       for(Id contactId: contactIds) {
                           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                           mail.setTemplateId(templateMap.get(nr.emailTemplateName));
                           mail.setTargetObjectId(contactId);
                           mail.setWhatId(nr.caseRecord.Id);
                           mail.setOrgWideEmailAddressId(senderNameMap.get(nr.SenderDisplayName));
                           mails.add(mail);
                       }
                   }
            }
        }
        System.debug('mails: '+mails);

        if(mails.size() > 0) {
            Messaging.sendEmail(mails);
        }
    }
    
    global class NotificationRequest {
        @InvocableVariable(required=true)
        global String notificationType;
        
        @InvocableVariable(required=true)
        global String emailTemplateName;
        
        @InvocableVariable(required=true)
        global Case caseRecord;
        
        @InvocableVariable
        global String SenderDisplayName;
        
        public NotificationRequest() {}
    }
}