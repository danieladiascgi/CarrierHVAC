public class GetBrandValue {
    
    
    @AuraEnabled
    public static List<String> getBrand(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Dealer_Profile__c.Brand__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    
    
    
    
    
}