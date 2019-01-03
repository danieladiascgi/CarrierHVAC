public class PurposesRelatedListExt {
    public Case caseRec {get; set;}
    public List<Purpose__c> listOfPurposes{get; set;}
    public PurposesRelatedListExt(Apexpages.StandardController cont){
        caseRec = (Case)cont.getRecord();
        listOfPurposes = new List<Purpose__c>();
    }
    public void init(){
        listOfPurposes = [Select Id, Name, Count__c from Purpose__c where Case__c = :caseRec.Id and Count__c!=0 order by Count__c desc];
    }
}