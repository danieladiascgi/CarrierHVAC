public class CCC_ProdRegistrationSubmitExt {
    public Case updateCase{get; set;}
    public boolean isInternalUser{get;set;}
    
    public CCC_ProdRegistrationSubmitExt(ApexPages.StandardController sc){
        updateCase = (Case)sc.getRecord();
        isInternalUser = false;
        User user1 = [select Id,Profile.UserLicense.Name from User where Id = :userinfo.getUserId() limit 1];
        if(user1.Profile.UserLicense.Name =='Partner Community'){
            isInternalUser = true;
        } 
        
    }
    public PageReference submitAndRedirect(){
        CCC_Case_Ownership_Matrix__c ownershipMatrix = new CCC_Case_Ownership_Matrix__c();
        updateCase = [Select Id, CCC_Purpose__c,CCC_WarrantyCommunity_Purpose__c,OwnerId,CCC_Customer_Type__c,Service_Bench_Contract_Number__c,Origin from Case where id=:updateCase.Id];
     
        if(isInternalUser){
            if(updateCase.CCC_WarrantyCommunity_Purpose__c==null || updateCase.CCC_WarrantyCommunity_Purpose__c.length()==0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Purpose before Submit'));
                return null;
            }    
        }	
        else{	
            if(updateCase.CCC_Purpose__c==null || updateCase.CCC_Purpose__c.length()==0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Purpose before Submit'));
                return null;
            }    
        }		
        
        
        boolean hasContract = false;
        if(updateCase.Service_Bench_Contract_Number__c!=null && updateCase.Service_Bench_Contract_Number__c.length()>0){
            hasContract = true;
        }else{
            hasContract = false;
        }
        
        if(hasContract)
		{
		if(isInternalUser){
		 ownershipMatrix = [SELECT Id, Name, WarrantyCommunity_Purpose__c, Customer_Type__c, Queue_Owner_Name__c, Record_Type_Name__c, Has_Contract__c FROM CCC_Case_Ownership_Matrix__c where WarrantyCommunity_Purpose__c=:updateCase.CCC_WarrantyCommunity_Purpose__c and Has_Contract__c=:hasContract limit 1];
        }else{
			 ownershipMatrix = [SELECT Id, Name, Purpose__c, Customer_Type__c, Queue_Owner_Name__c, Record_Type_Name__c, Has_Contract__c FROM CCC_Case_Ownership_Matrix__c where Purpose__c=:updateCase.CCC_Purpose__c and Has_Contract__c=:hasContract limit 1];
		}
		}
        else{
		if(isInternalUser){
		 ownershipMatrix = [SELECT Id, Name, WarrantyCommunity_Purpose__c, Customer_Type__c, Queue_Owner_Name__c, Record_Type_Name__c, Has_Contract__c FROM CCC_Case_Ownership_Matrix__c where WarrantyCommunity_Purpose__c=:updateCase.CCC_WarrantyCommunity_Purpose__c and Has_Contract__c=:hasContract and Customer_Type__c=:updateCase.CCC_Customer_Type__c limit 1];
		 }else{
	  ownershipMatrix = [SELECT Id, Name, Purpose__c, Customer_Type__c, Queue_Owner_Name__c, Record_Type_Name__c, Has_Contract__c FROM CCC_Case_Ownership_Matrix__c where Purpose__c=:updateCase.CCC_Purpose__c and Has_Contract__c=:hasContract and Customer_Type__c=:updateCase.CCC_Customer_Type__c limit 1];
		}
      }
      
    //    CCC_Case_Ownership_Matrix__c ownershipMatrix = [SELECT Id, Name, Purpose__c, Sub_Purpose__c, Customer_Type__c, Queue_Owner_Name__c, Record_Type_Name__c, Has_Contract__c FROM CCC_Case_Ownership_Matrix__c where Purpose__c=:updateCase.CCC_Purpose__c and Has_Contract__c=:hasContract and Customer_Type__c=:updateCase.CCC_Customer_Type__c limit 1];
        if(ownershipMatrix!=null && ownershipMatrix.Queue_Owner_Name__c!=null && ownershipMatrix.Queue_Owner_Name__c.length()>0){
            String queueName = ownershipMatrix.Queue_Owner_Name__c;
            updateCase.OwnerId = [select Id from Group where Name=:queueName and Type ='Queue'].Id;
           
            if(isInternalUser){
            	System.debug('#Inside Origin Update');
            	updateCase.Origin = 'Community';
        	}
            update updateCase;
        }
        PageReference pr = new PageReference('/'+updateCase.Id);
        pr.setRedirect(true);
        return pr;
    }
}