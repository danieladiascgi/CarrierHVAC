public class CaseRemovePartnerUsers {

    @InvocableMethod
    public static void removeAccessToPartnerUsersProcessBuilder(List<String> caseIDS){
        String caseId = caseIDS.get(0);
        String groupId = Label.FRS_Case_Share_Group_Id;
        
        List<CaseShare> caseShareToDelete = new List<CaseShare>();
        List<CaseShare> csShareLst = [Select Id, UserOrGroupId, RowCause from CaseShare where CaseId=:caseId];
        if(csShareLst!=null && csShareLst.size()>0){
            for(CaseShare eachShare : csShareLst){
                if(eachShare.RowCause=='Manual' && eachShare.UserOrGroupId==groupId){
                    System.debug('#Yes its manual:'+eachShare);
                    caseShareToDelete.add(eachShare);
                }
            }
        }
        if(caseShareToDelete!=null && caseShareToDelete.size()>0){
            delete caseShareToDelete;
        }
    }
}