/**
* @ Developer     : Ishita Sharma
* @date_created   : 1/14/2016
* @functions      : 1. AssignTSMUser   - Looks for TSM User in the Account Team and makes the same user owner of Account.
*                   2. AccountHierarchy- Fetches all the accounts in heirarchy five level up and 3 level down along with the Siblings Account heirarchy.
* @Date Modified  : <3/15/2016> Reason: Added comments
*
*
***/

public class CCC_AccountTriggerHandler {
    
 public set<ID> AccountIDs = new set<ID>();   
 //Map storing Account id and its respective Account team member
 public map<ID,AccountTeamMember> AcctTeamMap = new Map<ID,AccountTeamMember>();
 //Instantiating User Trigger Helper
 CCC_UserTriggerHelper userhelper = new CCC_UserTriggerHelper();
 

 /*************************************************************************************************************************************************************************/
 /**
* This method will Fetch all the accounts in heirarchy five level up and 3 level down along with the Siblings Account heirarchy and 
* give shared access to Accounts,contacts and cases
* @Developer : Ishita Sharma
**/
  Public void AccountHierarchy(List<Account> AccountList){
      
      //List of Case,Account and Contact
      List<String> idlist=new List<String>();
      List<String> Case2list=new List<String>();        //stores all cases where user is the owner 
      List<String> contact1list=new List<String>();     //Stores all contacts related to case
      List<String> account1list=new List<String>();     // Stores Account related to the case
      
      For(Account acc:AccountList){
          if(acc!=null && acc.id!=null){
            idlist.add(acc.id);
          }
          
      }
     //Set fetching complete list of Accounts in heirarchy from UserTrigger method named :CreateHierarchy
      Set <String> finalIdSet= userhelper.CreateHierarchy(idlist);
     
      //Fetch all contacts from the Accounts in heirarchy 
      List<Contact> contactlist = new List<Contact>([Select id,name,AccountId from Contact where AccountId IN :finalIdSet]);
      
      //Fetch all users from the associated contacts
      List<User> userList = new List<User>([Select id,name,ContactId from User where ContactId IN : contactlist and IsActive=True]) ;
      
      //Fetch all Cases belonging to the User
      List<Case> caselist=[Select id,Ownerid,Contactid,Accountid from Case where ownerid IN :Userlist];
      for(Case caseobj:caselist){
           Case2list.add(caseobj.id); 
           if(caseobj.Contactid!=null){
            contact1list.add(caseobj.Contactid);
           }
           if(caseobj.Accountid!=null){
            account1list.add(caseobj.Accountid);
           }
      }
      // Pass all the list to User helper trigger to provide shared access to Case,Account and Contact
      userhelper.createAccountCaseSharing(userList,finalIdSet,Case2list,contact1list,account1list);
       
    }

}