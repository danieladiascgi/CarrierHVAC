@isTest (SeeAllData=True)
public class TestCaseSharePartnerUsersCaseCreated {

    public static testMethod void testCaseSharePartnerCreated(){
        User partnerUser = [Select Id, ContactId from User where isActive=true and isPortalEnabled=true and Profile.Name like '%Partner%' order by Createddate desc limit 1];
        //System.runAs(partnerUser){
        if(partnerUser.ContactId!=null){
            Case cse = new Case();
            cse.Subject = 'Testing Case';
            cse.Description = 'Testing Description';
            cse.CCC_WarrantyCommunity_Purpose__c = 'Claim Appeal';
            cse.CCC_WarrantyCommunity_Sub_Purpose__c = 'Claim was Rejected';
            cse.CCC_Claim__c = '12345';
            cse.CCC_Contract__c = '12345';
            cse.CCC_Additional_Comments_on_this_Claim__c = 'Test Comments';
            cse.CCC_Customer_Type__c = 'Residential';
            cse.ContactId = partnerUser.ContactId;
            cse.CreatedById = partnerUser.Id;
            insert cse;
            List<String> caseIdLst = new List<String>();
            caseIdLst.add(cse.Id);
            CaseSharePartnerUsersCaseCreated.provideAccessToPartnerUsersWhoCreatedCase(caseIdLst);
        }
           // }
    }
}