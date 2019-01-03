public class EmailMessageTriggerMethods {
    
    //1. Parses inbound NxTrend Quote TextEmailBody & copies related info into corresponding Case fields: Customer PO # & Reference
    public static void parseCRNAInboundEmail(List<EmailMessage> emails) {
        
        set<Id> caseIds = new set<Id>();
        Map<Id, EmailMessage> case2EmailMap = new Map<Id, EmailMessage>();
        for(EmailMessage e : emails) {
            if(e.parentId != null && e.Incoming) {
                if(String.valueOf(e.parentId).left(3) == '500') {
                    caseIds.add(e.parentId);
                    case2EmailMap.put(e.parentId, e);
                }
            }
            
        }
        System.debug('caseIds: '+caseIds);
        System.debug('case2EmailMap: '+case2EmailMap);
        
        set<String> customerPOs = new set<String>();
        Map<String, Id> POtoNxTrendCaseMap = new Map<String, Id>();
        
        if(case2EmailMap.size() > 0 && caseIds.size() > 0) {
            List<Case> cases = [Select Id, Reference__c, CCC_Customer_PO__c from Case where Id in :caseIds and recordtype.name='National Accounts'];
            for(case c : cases) {
                if(case2EmailMap.containsKey(c.Id)) {
                    EmailMessage e = case2EmailMap.get(c.Id);
                    //NxTrend Quote Emails
                    if (e.Incoming && e.TextBody != null) {
                        if(e.TextBody.contains('Reference')) {
                            c.Reference__c = e.TextBody.right(e.TextBody.length() - e.TextBody.indexOf('Reference') - 10);    
                        }
                        if(e.TextBody.contains('Customer PO #')) {
                            String splitString = e.TextBody.split('Reference',2)[0].trim();
                            System.debug('splitString: '+splitString);
                            c.CCC_Customer_PO__c = splitString.right(splitString.length() - splitString.indexOf('Customer PO #') - 14);
                            customerPOs.add(c.CCC_Customer_PO__c);
                        }
                    }
                }
            }
            update cases;
        }
    }
}