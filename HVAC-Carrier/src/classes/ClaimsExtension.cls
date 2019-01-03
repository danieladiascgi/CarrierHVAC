public class ClaimsExtension {
    public Case currentCase{get; set;}
    public ClaimsExtension(ApexPages.StandardController controller){
        currentCase = (Case)controller.getRecord();
        currentCase = [Select Id, Claims_Order_Type__c , Claims_Purpose__c, Claims_Sub_Purpose__c from Case where Id=:currentCase.Id];
        System.debug('#currentCase:'+currentCase);
    }
    
    public void saveCase(){
        update currentCase;
    }
}