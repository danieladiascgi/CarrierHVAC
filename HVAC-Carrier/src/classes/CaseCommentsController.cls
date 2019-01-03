global without sharing class CaseCommentsController {
    
    
    
     @AuraEnabled
    global static List<CaseComment> DisplayComments(string ExpId)
    { 
        List<Expedite__c> CaseId=[SELECT  Case_Number__c FROM Expedite__c where Id=:ExpId];
        set<id> caseIds= new set<id>();
        for(Expedite__c exp:CaseId){
           caseIds.add(exp.Case_Number__c);
        }
        List<CaseComment> CmdList;
      
        CmdList =[select Id,CommentBody,IsPublished, CreatedDate, CreatedBy.Name from CaseComment where parentId in:caseIds order by createddate desc];
       /* string str = CmdList.CommentBody;
        string subStr = str.subString(0,50);*/
        system.debug('******CmdList******'+CmdList);
        return CmdList;
    }

    @AuraEnabled
    public static Boolean checkIfPlannerIsEmpty(Id ExpediteId) {
        Boolean isPopupRequired = false;
        if(ExpediteId!=null){
            Expedite__c exp = [Select id, Planner__c from Expedite__c where Id=:ExpediteId];
            if(exp!=null && (exp.Planner__c==null || exp.Planner__c=='')){
                isPopupRequired = true;
            }else{
                isPopupRequired = false;
            }
        }
        return isPopupRequired;
    }
}