public  class CCC_DSMTemplateController{
    public Id CaseID {get;set;}
    public List<CCC_junctionCaseAsset__c> getjunRecords()
    {
        List<CCC_junctionCaseAsset__c> junRecords;
        junRecords = [SELECT Asset__r.Name, Asset__r.CCC_Model_Number__c,Asset__r.Brand__c from CCC_junctionCaseAsset__c where Case__c=:CaseID];
        return junRecords;
    }
}