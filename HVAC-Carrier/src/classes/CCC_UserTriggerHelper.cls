/**
* @Developer : Amitkumar Joshi,Ishita Sharma
* @dateCreated : 22/01/2016
* Methods      :1. createAccountCaseSharing - This method will give access to all parent child accounts of current user
*               2. CreateHierarchy          - This method will give list all accounts in heirarchy along with heirarchy of Sibling Accounts
*               3. AddToGroups              - This method will add Community Users of certain profiles to the Public Groups - To be used in Dashboard  
* Modified By - Ishita - Added Public Group Logic , Heirarachy Access Logic and made generic Method to fetch Account Heirarachy
**/
public class CCC_UserTriggerHelper{
    
     /**
     * This method will give access to all Parent Child Accounts,Contacts and Cases of current user
     * Parameters : List<User> users, Set<String> accList,List<String> CaselistfromAccount,List<String> contactlistAcc,List<String> accountlistAcc
     * @Developer : Ishita Sharma
     **/ 
     public void createAccountCaseSharing(List<User> users, Set<String> accList,List<String> CaselistfromAccount,List<String> contactlistAcc,List<String> accountlistAcc){      
        
       //List and variable declarations and initializations
      
        Set<String> finalSetAccounts = new Set<String>();           // Set Storing All Accounts in Hierarchy
        List<String> relatedCaseIdlist = new List<String>();        // List Storing all Related Cases Id
        List<String> Caselist = new List<String>();                 //List Storing all cases based on different condition     
        List<String> contactlist = new List<String>();              // List Storing all Related Contacts
        List<String> RelatedCaseAccountlist = new List<String>();   //List storing all accounts related to case based on conditions
        List<AccountShare> shares = new List<AccountShare>();       // List Storing Accountshare
        List<CaseShare> CAseshares = new List<CaseShare>();         // List Storing CaseShare
        List<ContactShare> contshares = new List<ContactShare>();   // List Storing Contactshare
        List<AccountShare> accshares = new List<AccountShare>();    // List Storing Accountshare 
        
        // Find out the user records who need the access to parent and child account.
        List<User> currentUserList = [select contact.AccountId from User where Id IN:users and IsActive=True];
        
        /* If Acclist from Account trigger is null then find all accounts in heirarchy from method : CreateHierarchy(accountList)
           else Use Account list passed from Account Trigger in parameters */
        if(accList==null){
            List<String> accountList = new List<String>();
            for(User u: currentUserList ) {
                if(u!=null && U.contact!=null && u.contact.accountId!=null){
                    accountList.add(u.contact.AccountId);
                }
            }
            finalSetAccounts = CreateHierarchy(accountList);
        }else{
            finalSetAccounts = accList;
        }
        
        /*  Give access to case from External hierarchy
        1. Query All related Contacts of Heirachical Accounts 
        2. Query all related Users for those Contacts
        3. If Caselist from account is null query all related cases  */
        List<Contact> contactlistHierarchy = new List<Contact>([Select id,name,AccountId from Contact where AccountId IN :finalSetAccounts]);
        List<User> userListHierarchy = new List<User>([Select id,name,ContactId from User where ContactId IN : contactlistHierarchy ]) ;
        If(CaselistfromAccount==null || CaselistfromAccount.size()==0){
            List<Case> CaseObjlist=[Select id,Ownerid,Contactid,Accountid from Case where ownerid IN :userListHierarchy];
            for(Case caseobj:CaseObjlist){
                relatedCaseIdlist.add(caseobj.id); 
                contactlist.add(caseobj.Contactid);
                RelatedCaseAccountlist.add(caseobj.Accountid);
            }
            Caselist=relatedCaseIdlist;
            
        }
        else{
            Caselist=CaselistfromAccount;
            contactlist=contactlistAcc;
            RelatedCaseAccountlist=accountlistAcc;
        }
        List<case> cases = [select Id,ownerId from case where id IN:Caselist];
        
        // Give access to all parent accounts to the users.
        for(User u :users ){
            
            for(String acc : finalSetAccounts ){
                if(acc !=null){
                    AccountShare AccShare = new AccountShare(AccountId = acc ,AccountAccessLevel = 'Edit'
                                                             , OpportunityAccessLevel = 'Edit',CaseAccessLevel = 'Edit', ContactAccessLevel= 'Edit', UserOrGroupId = u.Id);
                    shares.add(AccShare );
                }
            }
        }   
        
        // Give access to all cases to the users.
        if(cases!=null && cases.size()>0){
            
            for(User u :users ){
                
                for(Case Caseobj: cases){
                    if(Caseobj !=null && u.Id!=null && Caseobj.ownerId != u.Id){
                        CaseShare casShare = new CaseShare(Caseid=Caseobj.Id,CaseAccessLevel = 'Edit',UserOrGroupId = u.Id,RowCause='Manual');
                        CAseshares.add(casShare );
                    }
                }
            } 
        }
        
        // Give access to all contacts associated to case.
        if(contactlist!=null && contactlist.size()>0){
            
            for(User u :users ){
                
                for(String Contobj: contactlist ){
                    if(Contobj !=null && u.Id!=null){
                        ContactShare conShare = new ContactShare(Contactid=Contobj,ContactAccessLevel = 'Edit',UserOrGroupId = u.Id);
                        contshares.add(conShare);
                    }
                }
            } 
        }
        
        // Give access to all Accounts associated to case.
        if(RelatedCaseAccountlist!=null && RelatedCaseAccountlist.size()>0){
            for(User u :users ){
                for(String accobj: RelatedCaseAccountlist ){
                    if(accobj !=null && u.Id!=null){
                        AccountShare accShare = new AccountShare(Accountid=accobj,AccountAccessLevel = 'Edit',OpportunityAccessLevel = 'Edit',UserOrGroupId = u.Id);
                        accshares.add(accShare );
                    }
                }
                
            } 
            
        }
        
        // insert records in account share.
        if(shares.size()>0 || accshares.size()>0){
            
            string gCalJSON = JSON.serialize(shares);
            string gCalJSON1 = JSON.serialize(accshares);
            
            CCC_UserTriggerHelper.sharewithCase(gCalJSON,'accountshare');
            CCC_UserTriggerHelper.sharewithCase(gCalJSON1,'accountshare');
         }
        
        // insert records in account share.
        if(CAseshares.size()>0){
            
            string gCalJSONCase = JSON.serialize(CAseshares);
            CCC_UserTriggerHelper.sharewithCase(gCalJSONCase,'Caseshare');
            
        }
        
        // insert records in account share.
        if(contshares.size()>0){
            
            string gCalJSONcon = JSON.serialize(contshares);
            CCC_UserTriggerHelper.sharewithCase(gCalJSONCon,'Contactshare');
        }
    }
    
     
   /**
     * This method will create sharing object of Account, Contact and Case
     * Parameters : String strJson,String ShareObj
     * @Developer : Ishita Sharma
     **/
    @future
    public static void sharewithCase(String strJson,String ShareObj) {
        
        if(ShareObj.contains('account')){
            List<AccountShare> accountshares = (List<AccountShare>)Json.deserialize(strJson, List<AccountShare>.class);
            insert accountshares;
        }
        else if(ShareObj.contains('Case')){
            List<CaseShare> caseshares = (List<CaseShare>)Json.deserialize(strJson, List<CaseShare>.class);
            insert caseshares;
        }
        else if(ShareObj.contains('Contact')){
            List<ContactShare> Contactshares = (List<ContactShare>)Json.deserialize(strJson, List<ContactShare>.class);
            insert Contactshares;
        }
    }
    
    
    
     /**
     *  This method will give list all accounts in heirarchy along with heirarchy of Sibling Accounts
     * Parameters : List<String> AccountList
     * @Developer : Ishita Sharma
     **/
    public Set<String> CreateHierarchy(List<String> AccountList){
        
        if(AccountList==null || AccountList.size()==0){
            return new Set<String>();
            
        }    
        List<String> finalAccountList=new List<String>();
        List<String> parentAccIdList = new List<String>();
        Set<String> finalIdSet= new Set<String>();
        
        //Create a Set of ids for all Parentids of Account to find sibling records
        List<Account> currentAccounts = [select Id,ParentId, Parent.ParentId ,Parent.Parent.ParentId,Parent.Parent.Parent.ParentId from Account where Id IN :AccountList];
        
        // Map of Accountid and it's parent account's list
        Map<String,List<String>> accIdParentAccIdMap = new Map<String,List<String>>();
        
        for(Account acc : currentAccounts ){
            if(acc.ParentId!=null){
                parentAccIdList.add(acc.ParentId);
            }
            if(acc.Parent.ParentId!=null){
                parentAccIdList.add(acc.Parent.ParentId);
            }
            if(acc.Parent.Parent.ParentId!=null){
                parentAccIdList.add(acc.Parent.Parent.ParentId);
            }
            if(acc.Parent.Parent.Parent.ParentId!=null){
                parentAccIdList.add(acc.Parent.Parent.Parent.ParentId);
            }
            
            if(acc.id!=null){
                parentAccIdList.add(acc.Id);
            }
            accIdParentAccIdMap.put(acc.Id, parentAccIdList);
        }
        
        finalIdSet.addAll(parentAccIdList);
        
        // find all child accounts of this users's account
        List<Account> childAccounts = [select Id,name,ParentId from Account where ParentId IN :AccountList];
        
        if(childAccounts.size()>0 && childAccounts!=null){
            for(Account acc:childAccounts){
                finalIdSet.add(acc.id);
                
            }
            
        //find all second level children accounts of this users's account
        List<Account> childChildAccounts = [select Id,name,Parent.ParentId from Account where ParentId IN: childAccounts];
        
        for(Account acc:childChildAccounts){
            finalIdSet.add(acc.id);
            //finalIdSet.add(acc.Parent.ParentId);
        }
        if(childChildAccounts.size()>0 && childChildAccounts!=null){
            // find all third level children accounts of this users's account
            List<Account> childChildChildAccounts = [select Id,Parent.Parent.ParentId  from Account where ParentId IN:childChildAccounts ];
            
            for(Account acc : childChildChildAccounts){
                finalIdSet.add(acc.id);
                
            }
            }
        }
        // Query all Sibling Accounts with same Parent ID
        if(finalIdSet!=null){
           List<Account> SiblingAccountsHeir1= [Select id,name,ParentId from Account where ParentId IN :finalIdSet];
            for(Account acc: SiblingAccountsHeir1){
                finalIdSet.add(acc.id);
            }
            // Query second level of  Sibling Accounts with same Parent ID
            List<Account> SiblingAccountsHeir2= [Select id,name,ParentId from Account where ParentId IN :SiblingAccountsHeir1];
            for(Account acc: SiblingAccountsHeir2){
                finalIdSet.add(acc.id);
                
            }
            // Query third level of  Sibling Accounts with same Parent ID
            List<Account> SiblingAccountsHeir3= [Select id,name,ParentId from Account where ParentId IN :SiblingAccountsHeir2];
            for(Account acc: SiblingAccountsHeir3){
                finalIdSet.add(acc.id);
            }
            
            // Query fourth level of  Sibling Accounts with same Parent ID
            List<Account> SiblingAccountsHeir4= [Select id,name,ParentId from Account where ParentId IN :SiblingAccountsHeir3];
            for(Account acc: SiblingAccountsHeir4){
                finalIdSet.add(acc.id);
            }
            
        }
        return  finalIdSet;
    }
    
    
    /**
     *   This method will add Community Users of certain profiles to the Public Groups - To be used in Dashboard  
     * Parameters : String strJson
     * @Developer : Ishita Sharma
     **/
   
    public static void AddToGroups(String strJson)
    {
        List<User> Users =  (List<User>)Json.deserialize(strJson, List<User>.class);
        List<String> dsmUserList = new List<String>();
        List<String> deletedsmUserList = new List<String>();
        List<String> warrantyUserList = new List<String>();
        List<String> WarrAdminUserList = new List<String>();
        List<String> OtherUserList = new List<String>();
        List<String> Ecobeelist = new List<String>();
        List<String> Wiprolist = new List<String>();
        
        
        Map<String,String> userProfileMap = new Map<String,String>();
        for(User userobj:Users){
            userProfileMap.put(userobj.Id,Userobj.profileid); 
            
        }
        
        List<Profile> ProfileNamelist = [select id,Name from profile where id IN: userProfileMap.values()];
        Map<String,String> ProfileidName= nEw Map<String,String>();
        
        for(Profile Profileobj:ProfileNamelist){
            ProfileidName.put(Profileobj.Id,Profileobj.Name);
            
        }
        
        for(User userobj:Users){
            String Profilename= ProfileidName.get(userProfileMap.get(userobj.id));
            if(Profilename=='Partner Community DSM' ){//&& Profilename!='Partner Community-Warranty/DSM' && Profilename!='Partner Community Warranty Admin'){
                dsmUserList.add(userobj.id);
            }
            
            if(Profilename=='Partner Community-Warranty/DSM' ){//&& Profilename!='Partner Community DSM' && Profilename!='Partner Community Warranty Admin'){
                warrantyUserList.add(userobj.id);
            }
            
            
            if(Profilename=='Partner Community Warranty Admin' ){
                WarrAdminUserList.add(userobj.id);
            }
            
            if(Profilename=='Wipro Community' ){
                Wiprolist.add(userobj.id);
            }
            if(Profilename=='Ecobee Community' ){
                Ecobeelist.add(userobj.id);
            }
            
        }
        
        //Get the groups that the user should be added to and assign to String 
        List<Group> grouplist=[select Id,DeveloperName from Group ];//Where DeveloperName IN: GroupMap.keySet()];
        String DSM,WarrantyDSM,AdminWarranty,Wipro,Ecobee;
        for(Group g:grouplist){
            if(g.DeveloperName=='CCC_DSM'){
                DSM=g.id;
            }
            else if(g.DeveloperName=='CCC_DSM_Warranty'){
                WarrantyDSM=g.id;
            }
            else if(g.DeveloperName=='CCC_Warranty_Admin'){
                AdminWarranty=g.id;
            }
            else if(g.DeveloperName=='CCC_Ecobee'){
                Ecobee=g.id;
            }
            else if(g.DeveloperName=='CCC_Wipro'){
                Wipro=g.id;
            }
            
        }
        List<GroupMember>listGroupMember =new List<GroupMember>();  
        if(dsmUserList.size()>0){
            for(String Userobj:dsmUserList){
                GroupMember gm= new GroupMember(); 
                gm.GroupId=DSM;
                gm.UserOrGroupId = Userobj;
                listGroupMember.add(gm);
                
            }
        }
        
        if(warrantyUserList.size()>0){
            for(String Userobj:warrantyUserList){
                GroupMember gm1= new GroupMember(); 
                gm1.GroupId=WarrantyDSM;
                gm1.UserOrGroupId = Userobj;
                listGroupMember.add(gm1);
                
            }
        }
        
        
        if(WarrAdminUserList.size()>0){
            for(String Userobj:WarrAdminUserList){
                GroupMember gm2= new GroupMember(); 
                gm2.GroupId=AdminWarranty;
                gm2.UserOrGroupId = Userobj;
                listGroupMember.add(gm2);
                
            }
        }
        
        if(Ecobeelist.size()>0){
            for(String Userobj:Ecobeelist){
                GroupMember gm3= new GroupMember(); 
                gm3.GroupId=Ecobee;
                gm3.UserOrGroupId = Userobj;
                listGroupMember.add(gm3);
                
            }
        }
        
        if(Wiprolist.size()>0){
            for(String Userobj:Wiprolist){
                GroupMember gm4= new GroupMember(); 
                gm4.GroupId=Wipro;
                gm4.UserOrGroupId = Userobj;
                listGroupMember.add(gm4);
                
            }
        }
        string gCalJSONCase = JSON.serialize(listGroupMember);
        CCC_UserTriggerHelper.insertGroupMember(gCalJSONCase);
     }
    
    @future
    public static void insertGroupMember(string groupMemStr){
        List<GroupMember>listGroupMember = (List<GroupMember>)Json.deserialize(groupMemStr, List<GroupMember>.class);
         if (Test.isRunningTest()) {
     // start new context via system.runAs() for the same user for test code only
      System.runAs(new User(Id = Userinfo.getUserId())) {
       insert listGroupMember;
      }
    } else {
      // in non-test code insert normally
      insert listGroupMember;
    }
        
    }
    
}