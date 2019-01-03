public class CaseSharePartnerUsersCaseCreated {
	@InvocableMethod
    public static void provideAccessToPartnerUsersWhoCreatedCase(List<String> caseIDS){
        System.debug('#caseIDS:'+caseIDS);
        String caseId = caseIDS.get(0);
		if(caseId!=null && caseId.length()>0){
             System.debug('#Querying Cases');
			List<Case> casesLst = [Select Id, CreatedBy.Contact.Public_group__c from Case where Id=:caseId and Case.createdby.isPortalEnabled=true];
            System.debug('#Queried Cases:'+casesLst);
			if(casesLst!=null && casesLst.size()>0){
				Case cse = casesLst.get(0);
                System.debug('#cse.CreatedBy:'+cse.CreatedBy);
                System.debug('#cse.CreatedBy.Contact:'+cse.CreatedBy.Contact);
                System.debug('#cse.CreatedBy.Contact.Public_group__c:'+cse.CreatedBy.Contact.Public_group__c);
				if(cse.CreatedBy!=null && cse.CreatedBy.Contact!=null && cse.CreatedBy.Contact.Public_group__c!=null){
                    System.debug('#Inside Public Group Association:'+cse);
					CaseShare share = new CaseShare();
					share.UserOrGroupId = cse.CreatedBy.Contact.Public_group__c;
					share.RowCause = 'Manual';
					share.CaseAccessLevel = 'Edit';
                    share.CaseId = cse.Id;
                    System.debug('#Creating Share:'+share);
					insert share;
				}
			}
		}
        
    }
}