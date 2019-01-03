global without sharing class MyOpenCasesController {
    @AuraEnabled
    public static list <Case> fetchCases(String EmailAddress) {
        System.debug('#Supplied Email Address:'+EmailAddress);
        List<List<Contact>> findContact= [FIND :EmailAddress IN Email Fields RETURNING Contact(Id)];
        Contact [] contactList = ((List<Contact>)findContact[0]);
        List<Case> casesLst = [Select Id, CaseNumber, Account.Name, RecordType.Name, Priority,CCC_Purpose__c, CCC_Sub_Purpose__c, Owner.Name,CreatedDate,ClosedDate, Subject, Status from Case where Status!='Closed' and RecordType.Name='Replacement Component (RC)' and ContactId IN:contactList order by lastmodifieddate desc];
        System.debug('#Cases Queried Size:'+casesLst.size());
        System.debug('#Cases Queried:'+casesLst);
        return casesLst;          
    }
    
    @AuraEnabled
    public static list <Case> fetchClosedCases(String EmailAddress) {
        System.debug('#Supplied Email Address Closed Cases:'+EmailAddress);
        List<List<Contact>> findContact= [FIND :EmailAddress IN Email Fields RETURNING Contact(Id)];
        Contact [] contactList = ((List<Contact>)findContact[0]);
        List<Case> casesLst = [Select Id, CaseNumber, Account.Name, RecordType.Name, Priority,CCC_Purpose__c, CCC_Sub_Purpose__c, Owner.Name,CreatedDate,ClosedDate, Subject, Status from Case where Status='Closed' and RecordType.Name='Replacement Component (RC)' and ContactId IN:contactList order by lastmodifieddate desc];
        System.debug('#Closed Cases Queried:'+casesLst);
        return casesLst;          
    }
    
    /*@AuraEnabled
public static list <Case> fetchOpenSortedCases(String EmailAddress, String sortField, boolean isAsc) {
List<List<Contact>> findContact= [FIND :EmailAddress IN Email Fields RETURNING Contact(Id)];
Contact [] contactList = ((List<Contact>)findContact[0]);
String s1 = 'Closed';
String s2 = 'Replacement Component (RC)';
String sSoql = 'Select Id, CaseNumber, Account.Name, RecordType.Name, Priority,CCC_Purpose__c, CCC_Sub_Purpose__c, Owner.Name,CreatedDate,ClosedDate, Subject, Status from Case where Status!=\'Closed\' and RecordType.Name=\'Replacement Component (RC)\'';

sSoql += 'and ContactId IN :contactList';

system.debug('sortField-->' + sortField);

if (sortField != '') {
sSoql += ' order by ' + sortField;

// if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
if (isAsc == True) {
sSoql += ' asc';
} else {
sSoql += ' desc';
}
}
// set record limit to query 
sSoql += ' LIMIT 20';

System.debug('@Developer -->sSoql:' + sSoql);
list <Case> lstResult;
try {
system.debug('The query is' + sSoql);
lstResult = Database.query(sSoql);
system.debug('The result of query is' + lstResult);
List < Case > returnConList = new List < Case > ();

for (Case c: lstResult) {
returnConList.add(c);
}
return returnConList;
} 
catch (Exception ex) {
// for handle Exception
return null;
}
}*/
    @AuraEnabled
    public static List<caseWrapper> getOpenCases(String EmailAddress) {
        System.debug('#Supplied Email Address:'+EmailAddress);
        List<List<Contact>> findContact= [FIND :EmailAddress IN Email Fields RETURNING Contact(Id)];
        Contact [] contactList = ((List<Contact>)findContact[0]);
        List<Case> casesLst = [Select Id, CaseNumber, Account.Name, RecordType.Name, Priority,CCC_Purpose__c, CCC_Sub_Purpose__c, Owner.Name,CreatedDate,ClosedDate, Subject, Status from Case where Status!='Closed' and RecordType.Name='Replacement Component (RC)' and ContactId IN:contactList order by lastmodifieddate desc];
        System.debug('#Cases Queried Size:'+casesLst.size());
        System.debug('#Cases Queried:'+casesLst);
        List<caseWrapper> wrprLst = new List<caseWrapper>();
        if(casesLst!=null && casesLst.size()>0){
            for(Case eachCase : casesLst){
                caseWrapper wrp = new caseWrapper();
                wrp.caseId = eachCase.Id;
                wrp.caseNumber= eachCase.CaseNumber;
                wrp.accountName = eachCase.Account.Name;
                wrp.subject= eachCase.Subject;
                wrp.status= eachCase.Status;
                wrp.priority= eachCase.Priority;
                wrp.purpose= eachCase.CCC_Purpose__c;
                wrp.subPurpose= eachCase.CCC_Sub_Purpose__c;
                wrp.owner= eachCase.Owner.Name;
                wrp.dateTimeOpened= getDateFormatted(eachCase.CreatedDate);
                wrp.dateTimeClosed= getDateFormatted(eachCase.ClosedDate);
                wrprLst.add(wrp);
            }
        }
        System.debug('#wrprLst to Return:'+wrprLst);
        return wrprLst;          
    }
    @AuraEnabled
    public static List<caseWrapper> getClosedCases(String EmailAddress) {
        System.debug('#Supplied Email Address Closed Cases:'+EmailAddress);
        List<List<Contact>> findContact= [FIND :EmailAddress IN Email Fields RETURNING Contact(Id)];
        System.debug('#findContact'+findContact);
        Contact [] contactList = ((List<Contact>)findContact[0]);
        System.debug('#contactList'+contactList);
        List<Case> casesLst = [Select Id, CaseNumber, Account.Name, RecordType.Name, Priority,CCC_Purpose__c, CCC_Sub_Purpose__c, Owner.Name,CreatedDate,ClosedDate, Subject, Status from Case where Status='Closed' and RecordType.Name='Replacement Component (RC)' and ContactId IN:contactList order by lastmodifieddate desc];
        System.debug('#Closed Cases Queried:'+casesLst);
        List<caseWrapper> wrprLst = new List<caseWrapper>();
        if(casesLst!=null && casesLst.size()>0){
            for(Case eachCase : casesLst){
                caseWrapper wrp = new caseWrapper();
                wrp.caseId = eachCase.Id;
                wrp.caseNumber= eachCase.CaseNumber;
                wrp.accountName = eachCase.Account.Name;
                wrp.subject= eachCase.Subject;
                wrp.status= eachCase.Status;
                wrp.priority= eachCase.Priority;
                wrp.purpose= eachCase.CCC_Purpose__c;
                wrp.subPurpose= eachCase.CCC_Sub_Purpose__c;
                wrp.owner= eachCase.Owner.Name;
                wrp.dateTimeOpened= getDateFormatted(eachCase.CreatedDate);
                wrp.dateTimeClosed= getDateFormatted(eachCase.ClosedDate);
                wrprLst.add(wrp);
            }
        }
        System.debug('#wrprLst Closed cases to Return:'+wrprLst);
        return wrprLst;                  
    }
    public class caseWrapper{
        @AuraEnabled public String caseId{get;set;}
        @AuraEnabled public String caseNumber{get;set;}
        @AuraEnabled public String accountName{get;set;}
        @AuraEnabled public String subject{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String priority{get;set;}
        @AuraEnabled public String purpose{get;set;}
        @AuraEnabled public String subPurpose{get;set;}
        @AuraEnabled public String owner{get;set;}
        @AuraEnabled public String dateTimeOpened{get;set;}
        @AuraEnabled public String dateTimeClosed{get;set;}
        
    }
    public class expediteWrapper{
        @AuraEnabled public String expediteId{get;set;}
        @AuraEnabled public String expediteName{get;set;}
        @AuraEnabled public String expediteStatus{get;set;}
        @AuraEnabled public String customerPO{get;set;}
        @AuraEnabled public String c10Order{get;set;}
        @AuraEnabled public String partNumber{get;set;}
        @AuraEnabled public String caseNumber{get;set;}
        @AuraEnabled public String caseId{get;set;}
        @AuraEnabled public String createdDate{get;set;}
        /*@AuraEnabled public String priority{get;set;}
        @AuraEnabled public String purpose{get;set;}
        @AuraEnabled public String subPurpose{get;set;}
        @AuraEnabled public String owner{get;set;}
        @AuraEnabled public String dateTimeOpened{get;set;}
        @AuraEnabled public String dateTimeClosed{get;set;}*/
        
    }
    public static String getDateFormatted(Datetime dtTimeVal){
        String returnVal = '';
        if(dtTimeVal!=null){
         returnVal = dtTimeVal.format('YYYY-MM-dd HH:MM:SS');   
        }        
        return returnVal;
    }
    @AuraEnabled
    public static List<expediteWrapper> getOpenExpedites(String EmailAddress) {
        System.debug('#Supplied Email Address:'+EmailAddress);
        List<List<Contact>> findContact= [FIND :EmailAddress IN Email Fields RETURNING Contact(Id)];
        Contact [] contactList = ((List<Contact>)findContact[0]);
        List<Expedite__c> expediteLst = [SELECT Id, Name, Subject__c,Expedite_Status__c,Customer_PO__c,C10_Order__c,Part_Number__c, CreatedDate,Case_Number__c, Case_Number__r.CaseNumber  FROM Expedite__c where Contact_Name__c IN:contactList order by createddate desc];
        System.debug('#Expedites Queried Size:'+expediteLst.size());
        System.debug('#Expedites Queried:'+expediteLst);
        List<expediteWrapper> wrprLst = new List<expediteWrapper>();
        if(expediteLst!=null && expediteLst.size()>0){
            for(Expedite__c eachExpedite : expediteLst){
                expediteWrapper wrp = new expediteWrapper();
                wrp.expediteId = eachExpedite.Id;
                wrp.expediteName= eachExpedite.Name;
                //wrp.expediteStatus = eachExpedite.Expedite_Status__c;
                if(eachExpedite.Expedite_Status__c!=null && eachExpedite.Expedite_Status__c.length()>0 && eachExpedite.Expedite_Status__c=='Expedite'){
                	wrp.expediteStatus = 'New';
                }else if(eachExpedite.Expedite_Status__c!=null && eachExpedite.Expedite_Status__c.length()>0 && (eachExpedite.Expedite_Status__c=='Supplier #1' || eachExpedite.Expedite_Status__c=='Supplier #2' ||eachExpedite.Expedite_Status__c=='Supplier #3' || eachExpedite.Expedite_Status__c=='Escape' ||eachExpedite.Expedite_Status__c=='Hold' || eachExpedite.Expedite_Status__c=='Internal Wait' ||eachExpedite.Expedite_Status__c=='Supplier Promise' || eachExpedite.Expedite_Status__c=='Track No.Required' || eachExpedite.Expedite_Status__c=='Track No. to Customer' )){
                    wrp.expediteStatus = 'In Progress';
                }else{
                    wrp.expediteStatus = 'Closed';
                }
                wrp.customerPO= eachExpedite.Customer_PO__c;
                wrp.c10Order= eachExpedite.C10_Order__c;
                wrp.partNumber = eachExpedite.Part_Number__c;
                wrp.createdDate = getDateFormatted(eachExpedite.CreatedDate);
                wrp.caseNumber = eachExpedite.Case_Number__r.CaseNumber;
                wrp.caseId = eachExpedite.Case_Number__c;
                wrprLst.add(wrp);
            }
        }
        System.debug('#Expedite wrprLst to Return:'+wrprLst);
        return wrprLst;          
    }
}