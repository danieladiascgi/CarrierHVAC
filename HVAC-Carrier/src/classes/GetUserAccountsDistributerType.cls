public class GetUserAccountsDistributerType {

    @AuraEnabled
    public static List<AccountContactRelation> GetUserAccounts(){
        String userId = userInfo.getUserId() ;
        //String UserType = userInfo.getUserType();
        //00515000007G7pvAAC
        //:userId
        List<AccountContactRelation> AccountList = [select Account.name ,Accountid  from AccountContactRelation 
                                                    where ContactId in(select Contactid from user where id='0050m000001E8QrAAK')];
        return AccountList;
    }
    
    
    @AuraEnabled
    public static List<CCC_Partner__c> GetDealerName(String account_id){

        List<CCC_Partner__c> PartnerList = [select name, CCC_Dealer__r.name , id,CIN__c  from CCC_Partner__c 
                                                    where CCC_Distributor__r.id =:account_id and CCC_Relationship__c = 'Pricing'];
        return PartnerList;
    }
    
    
}