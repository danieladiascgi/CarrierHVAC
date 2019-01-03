public class CaseSharePartnerUsers {
    
    /*public static void giveAccessToPartnerUsers(String caseId, String accessLevel, String groupId){
        System.debug('#Started');
        CaseShare cs = new CaseShare();
        cs.CaseId=caseId;
        cs.UserOrGroupId = groupId;
        cs.CaseAccessLevel = accessLevel;
        cs.RowCause = Schema.CaseShare.RowCause.Manual;
        Database.SaveResult sr = Database.insert(cs,false);
        System.debug('#inserted Successfully:'+sr);

    }*/
    @InvocableMethod
    public static void giveAccessToPartnerUsersProcessBuilder(List<String> caseIDS){
        System.debug('#Started');
        String caseId = caseIDS.get(0);
        String groupId = Label.FRS_Case_Share_Group_Id;
        String accessLevel = 'Read';
        CaseShare cs = new CaseShare();
        cs.CaseId=caseId;
        cs.UserOrGroupId = groupId;
        cs.CaseAccessLevel = accessLevel;
        cs.RowCause = Schema.CaseShare.RowCause.Manual;
        Database.SaveResult sr = Database.insert(cs,false);
        System.debug('#inserted Successfully:'+sr);

    }
    /*public static void removeAccessToPartnerUsers(String caseId, String groupId){
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
    }*/
   /* @InvocableMethod
    public static void removeAccessToPartnerUsersProcessBuilder(List<String> caseIDS){
        String caseId = caseIDS.get(0);
        String groupId = '00G1500000424rhEAA';
        
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
    }*/

}