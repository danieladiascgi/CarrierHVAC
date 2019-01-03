public class DuplicateContact {
    @InvocableMethod
    public static void DuplicateContact(list<Id>caseid){
        system.debug('caseid'+caseid);
        List<List<SObject>> findContact=new List<List<SObject>>();
        List<Contact> contactList1 = new List<Contact>();
        Case c = new case();
        //	Case c=null;
        c=[Select Id,SuppliedEmail,Duplicate_Contact_Exist__c from case where Id=:caseid[0] limit 1];
        if(c.SuppliedEmail != null && c.SuppliedEmail != '' && c.SuppliedEmail.length()>0){
            findContact= [FIND :c.SuppliedEmail IN Email Fields RETURNING Contact(Id)];
            system.debug('@findContact'+findContact);
        }
        if(findContact.size()>0 && findContact != null){
            Contact [] contactList = ((List<Contact>)findContact[0]);
            contactList1 = [Select Id, Email,Name from Contact where Id in:contactList];
            
            system.debug('@contactList1'+contactList1);
        }
        if(contactList1!=null && contactList1.size()>1)
        {
            c.Duplicate_Contact_Exist__c=true;  
            
            System.debug('#duplicate'+c.Duplicate_Contact_Exist__c);
            
        }
        update c;
    }
}