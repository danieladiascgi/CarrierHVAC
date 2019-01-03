public class UpdateAccNameOnAddressChange {
    
    
    //public String uniqueContactId {get;set;}
    
    
    @InvocableMethod
    public static void  getAccountName(list<id> uniqueContactId){
        Contact cont=null;
        Account account=null;
        //Id AccountId;
        
        system.debug('idhugukhj');
        if(uniqueContactId != null){
            system.debug('id @@@@'+uniqueContactId[0]);
            // account =[SELECT Id, Name FROM Account where id =: uniqueContactId[0] Limit 1 ];
            //   system.debug('account @@@@'+account);
            cont = [select Id,AccountId,account.Name, FirstName,Lastname,Recordtype.name,HomePhone,Otherphone,phone,Email,Mobilephone,mailingStreet,MailingCity,MailingState,
                    MailingCountry,MailingPostalcode from Contact where id =: uniqueContactId[0] Limit 1 ];
            system.debug('contact @@@@'+cont);
            Id AcctId = cont.AccountId; 
            system.debug('AccountId @@@@'+AcctId); 
            account = [select id,Name from account where id =:AcctId];
            system.debug('account @@@@'+account); 
        }
        String nameToReturn = 'Residential - ';
        String differentiator = ',';
        
        if((cont.MailingStreet!=null && cont.MailingStreet.length()>0) || (cont.MailingCity!=null && cont.MailingCity.length()>0) || (cont.MailingState!=null && cont.MailingState.length()>0) /*|| (cont.MailingPostalCode!=null && cont.MailingPostalCode.length()>0) || (cont.MailingCountry!=null && cont.MailingCountry.length()>0)*/){
            
            if(cont.MailingStreet!=null && cont.MailingStreet.length()>0){
                nameToReturn = nameToReturn + cont.MailingStreet;
                nameToReturn = nameToReturn + differentiator;
            }
            if(cont.MailingCity!=null && cont.MailingCity.length()>0){
                nameToReturn = nameToReturn + cont.MailingCity;
                nameToReturn = nameToReturn + differentiator;
            }
            if(cont.MailingState!=null && cont.MailingState.length()>0){
                nameToReturn = nameToReturn + cont.MailingState;
                nameToReturn = nameToReturn + differentiator;
            }
            if(cont.MailingPostalCode!=null && cont.MailingPostalCode.length()>0){
                nameToReturn = nameToReturn + cont.MailingPostalCode;
                nameToReturn = nameToReturn + differentiator;
            }
            if(cont.MailingCountry!=null && cont.MailingCountry.length()>0){
                nameToReturn = nameToReturn + cont.MailingCountry;
                nameToReturn = nameToReturn + differentiator;
            }
            if(nameToReturn!=null && nameToReturn.length()>0 && nameToReturn.endsWith(differentiator)){
                nameToReturn = nameToReturn.substring(0, nameToReturn.lastIndexOf(differentiator));
            }
            
        }else if(cont.LastName!=null && cont.LastName.length()>0){
            nameToReturn = nameToReturn + cont.LastName;
            nameToReturn = nameToReturn + differentiator;
            if(cont.MailingPostalCode!=null && cont.MailingPostalCode.length()>0){
                nameToReturn = nameToReturn + cont.MailingPostalCode;
                nameToReturn = nameToReturn + differentiator;
            }
            if(cont.MailingCountry!=null && cont.MailingCountry.length()>0){
                nameToReturn = nameToReturn + cont.MailingCountry;
            }
            if(nameToReturn!=null && nameToReturn.length()>0 && nameToReturn.endsWith(differentiator)){
                nameToReturn = nameToReturn.substring(0, nameToReturn.lastIndexOf(differentiator));
            }
        }
        system.debug('Name'+nameToReturn);
        account.Name = nameToReturn;
        system.debug('Name @@@'+account.Name); 
        
        update account;
        system.debug('UpdatedName'+account); 
        
        
    }
    
    
}