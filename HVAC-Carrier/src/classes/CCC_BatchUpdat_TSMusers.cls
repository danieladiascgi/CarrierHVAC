global class CCC_BatchUpdat_TSMusers implements Database.Batchable<sObject>
{   
        
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        //query to return all records with TSM users
        //String query='Select UserId,TeamMemberRole, Id, AccountId From AccountTeamMember where TeamMemberRole =\'TSM\'';
        String query='SELECT Id, Name, (Select UserId,TeamMemberRole, Id, AccountId From AccountTeamMembers where TeamMemberRole =\'TSM\') FROM Account';
        return Database.getQueryLocator(query);
    } 

    global void execute(Database.BatchableContext BC, list<Account> scope)
    {     
        List<Account> updateList = new List<Account>();
        for(Account acc: scope)
        { 
                //Account acc = (Account )so;
                
                for(AccountTeamMember at: acc.AccountTeamMembers)
                {
                    acc.CCC_TSM_User__c = at.UserId;
                }
                updateList.add(acc);
             
        }
        update updateList;
    }
    
    
    global void finish(Database.BatchableContext BC) 
    {                 
        //no post processing
      
       
    }
}





/*
Select a.UserId,a.User.Name,a.TeamMemberRole, a.Id, a.AccountId 
                                From AccountTeamMember a 
                                where a.TeamMemberRole =:'TSM' AND a.AccountId in :AccountIDs]
*/