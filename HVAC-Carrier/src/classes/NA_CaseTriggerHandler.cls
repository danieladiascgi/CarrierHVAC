/**
* @ Developer    :  Nilesh
* @date_created  :  11/20/2017
* Description    :  Description: This Class is Handler for the Trigger : 
                    populate Distributor based on Distributor Number and vice-versa.
                    Populate Account based on NxtrndNumber and vice-versa.

* @Date Modified :  
***/



public class NA_CaseTriggerHandler {

    
    //Added on 10/16 s-02209 - to populate Distributor based on Distributor Number.
    public void NApopulateDstrNameOrNumber(List<Case> NAcaseToProcess,Set<String> NADstrNmbr,List<Case> NAcaseToProcess_DstrName,Set<Id> NADstrName, Boolean IsDstrUpate ){
        List<Account> NAdstrToProcess = [Select Id,NxTrend_Customer_Distributor__c from Account where NxTrend_Customer_Distributor__c!=null AND NxTrend_Customer_Distributor__c =: NADstrNmbr ];
        List<Account> NAdstrToProcess_DstrName = [Select Id,NxTrend_Customer_Distributor__c from Account where Id =: NADstrName];
        List<Case> NAupdateCase = new List<Case>();
        Map<String,Account> NADstrNumToAcc = new Map<String,Account>();
        Map<Id,Account> NADstrIdToAcc = new Map<Id,Account>();
       // System.debug('NAdstrToProcess ' + NAdstrToProcess);
       // System.debug('NAcaseToProcess_DstrName ' + NAcaseToProcess_DstrName);
        for(Account Acc: NAdstrToProcess)
        {
            if(!NADstrNumToAcc.containsKey(Acc.NxTrend_Customer_Distributor__c))
                NADstrNumToAcc.put(Acc.NxTrend_Customer_Distributor__c, Acc);
            
        }
        for(Account Acc: NAdstrToProcess_DstrName)
        {
            if(!NADstrIdToAcc.containsKey(Acc.Id))
                NADstrIdToAcc.put(Acc.Id, Acc);
            
        }
        if(IsDstrUpate)
        {
        for(Case ca: NAcaseToProcess)
        {
            if(ca.Distributor_Number__c=='' || ca.Distributor_Number__c==null)
            {
                ca.CCC_Distributor_s_Name__c = null;
                NAupdateCase.add(ca);               
            }
            else if(NADstrNumToAcc.containsKey(ca.Distributor_Number__c ))
            {
                ca.CCC_Distributor_s_Name__c = NADstrNumToAcc.get(ca.Distributor_Number__c).Id;
                NAupdateCase.add(ca);
            }
            else
            {
                   ca.addError('Distributor Number is not found.'); 
            }
            
        }
        for(Case ca: NAcaseToProcess_DstrName)
        {
            if(NADstrIdToAcc.containsKey(ca.CCC_Distributor_s_Name__c))
                ca.Distributor_Number__c = NADstrIdToAcc.get(ca.CCC_Distributor_s_Name__c).NxTrend_Customer_Distributor__c;
        }
        }
        else
        {
             for(Case ca: NAcaseToProcess)
        {
            if(ca.NxtTrend__c=='' || ca.NxtTrend__c==null)
            {
                ca.NxtTrend__c = null;
                NAupdateCase.add(ca);               
            }
            else if(NADstrNumToAcc.containsKey(ca.NxtTrend__c ))
            {
                ca.AccountId = NADstrNumToAcc.get(ca.NxtTrend__c).Id;
                NAupdateCase.add(ca);
            }
            else
            {
                   ca.addError('Nxtrend Number is not found.'); 
            }
            
        }
        for(Case ca: NAcaseToProcess_DstrName)
        {
            if(NADstrIdToAcc.containsKey(ca.AccountId))
                ca.NxtTrend__c = NADstrIdToAcc.get(ca.AccountId).NxTrend_Customer_Distributor__c;
        }
        }
       
    } 
    // s-02209 end here
    
    
    //Pushes the entitlement id into case
    public void NAAssociateEntitlementToCase(List<Case> caseToProcess_Entlmnt)
    {
        Entitlement entl = [SELECT Id,Name FROM Entitlement where Name = 'National Accounts' LIMIT 1];
        for(Case cs : caseToProcess_Entlmnt)
        {
            if(entl!=null)
            cs.EntitlementId = entl.id;
        }
            
    }
    
}