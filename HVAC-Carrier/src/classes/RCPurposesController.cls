public class RCPurposesController {
@AuraEnabled
    public static Case getCase(Id id) {
        System.debug('#id:'+id);
        Case C = [
            SELECT Id,RecordTypeId,Origin,Reason, CCC_Solution__c,CCC_Turn_Back_Code__c,Status,Internal_Comments__c,CCC_Purpose__c, CCC_Sub_Purpose__c,CCC_Defect_Code__c,CCC_Defect_Sub_Code__c
            FROM Case
            WHERE Id = :id
        ];
        
        System.debug('#Case Queried:'+c);
        return C;
    }
}