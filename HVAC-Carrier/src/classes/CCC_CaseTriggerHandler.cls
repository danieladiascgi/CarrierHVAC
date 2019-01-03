/**
* @ Developer    :  Ishita Sharma & Sudheer Reddy Vangala
* @date_created  :  1/14/2016
* Description    :  Description: This Class is Handler for the Trigger : 
1."Assign To DSM" that Assign the Case To Contact [Owner : Ishita]
Owner who falls under Distributor Account and Contact With Title= DSM
o  If Account is associated, then look for the contacts associated to the Account/Distributor based on title-â€œDSMâ€
o  If system finds unique contact with title â€œDSMâ€, then change the case owner to Contact Owner(DSM)
2.Update Product Details ON Case  Functionality [Owner : Ishita]
3."CaptureBusinessHours" - Captures the business hours on case fields for time as 8 hours and 16 hours-  and trigger an email based on business hours time.

* @Date Modified :  26 january :[Ishita] : Changed Account On Case from Account to Distributor Account
26 january :[Ishita] 1. Changed class name to CCC_CaseTriggerHandler
2. Bulkified Code for Copying Product details to Case : Method: updateProductDetails
3. Moved Unused and commented Code to Commented Block : Will Remove the code later
5 feb     :[Ishita] 1. Added Logic in Assign To DSM Button for :More than one DSM Contacts are associated with the distributor
9 Feb     :[Ishita] 1. Added Logic For capturing Business Hours
10/20 Release [Sudheer Reddy]: Code optimization is done as part of Performance fix.
***/


public class CCC_CaseTriggerHandler{
    
    public Account accountrecord;
    public Contact con;
    public Case cse;
    User caseuser;
    public static boolean run = true;
    List<CaseShare> getShareRecordsforUpdate=new List<CaseShare>();
    List<Case> getCaseShareRecords=new List<Case>();
    list<Case_Share__c> CaseShareRecords=new List<Case_Share__c>();
    
    public Void updateToAddress(List<Case> objCaseList) {
        //Queries the current Logged in User Profile Name and ID
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        //Fetches Current Logged in User's profile name
        String MyProflieName = PROFILE.size()>0 && PROFILE[0].Name!=null && PROFILE[0].Name.length()>0?PROFILE[0].Name:'';
        for (Case cse : objCaseList) {
            //Checks if Case's Origin source is not equal to null
            if (cse.Origin !=''){
                //Below code checks weather the case created by Community user or internal user, If the owner is community user then it assigns Community, else assigns the Origin field value to To address field.
                //DEF0000889
                if((MyProflieName=='Partner Community DSM')||(MyProflieName=='Partner Community Warranty Admin')||(MyProflieName=='Partner Community-Warranty/DSM')||(MyProflieName=='NAFO WA Profile'))
                {
                    cse.To_Address__c='Community';
                }
                else
                {
                    //Copies Origin field value to Case's To_Address__c field
                    cse.To_Address__c=cse.Origin;
                }
            } //if statement ends.
            
        } //for loop ends.
        
    } // method ends.
    
    /**
* This method will Update Purpose Subpurpose ON Case
* Parameters : Case trigger List
* @Developer : Diksha Batra
**/
    
    public Void updatePurposeSubPurpose(List<Case> objCaseList) {
        //Queries the current Logged in User Profile Name and ID
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        //Fetches Current Logged in User's profile name
        String MyProflieName = PROFILE.size()>0 && PROFILE[0].Name!=null && PROFILE[0].Name.length()>0?PROFILE[0].Name:'';
        //System.debug('#CaseObject:'+caseObject.RecordType.Name);    
        RecordType rt= [select id,Name from RecordType where SobjectType='Case' and Name='Product Registration' Limit 1];
        for(Case CaseObject: objCaseList){
            if(CaseObject.RecordTypeId!=rt.Id){
                
                /*Checks the profile name to Update Pursose and sub-purpose.If Profile is 'Partner Community Warranty Admin' or 'Partner Community-Warranty/DSM' ie the useris community user(Warranty) , copies CCC_WarrantyCommunity_Purpose__c and CCC_WarrantyCommunity_Sub_Purpose__c to all other PSPs.*/
                
                //if loop starts.
                if((MyProflieName=='Partner Community Warranty Admin')||(MyProflieName=='Partner Community-Warranty/DSM')||(MyProflieName=='NAFO WA Profile')) {               
                    
                    if(CaseObject.CCC_WarrantyCommunity_Purpose__c != null)
                    {
                        //copies CCC_WarrantyCommunity_Purpose__c to all other Purposes to maintain symmetry.
                        CaseObject.CCC_Purpose__c= CaseObject.CCC_WarrantyCommunity_Purpose__c;
                        CaseObject.CCC_Purpose_Tier1_CR__c= CaseObject.CCC_WarrantyCommunity_Purpose__c;
                        CaseObject.CCC_Equipment_Category__c= CaseObject.CCC_WarrantyCommunity_Purpose__c;
                    }
                    
                    if(CaseObject.CCC_WarrantyCommunity_Sub_Purpose__c != null)
                    {
                        //copies CCC_WarrantyCommunity_Sub_Purpose__c to all other Sub Purposes to maintain symmetry.
                        CaseObject.CCC_Sub_Purpose__c=CaseObject.CCC_WarrantyCommunity_Sub_Purpose__c;
                        CaseObject.CCC_Sub_Purpose_Tier1_CR__c=CaseObject.CCC_WarrantyCommunity_Sub_Purpose__c;
                        CaseObject.CCC_Equipment_Purpose__c=CaseObject.CCC_WarrantyCommunity_Sub_Purpose__c;
                    }
                }
                // if loop ends.
                /*Checks the profile name to Update Pursose and sub-purpose.If Profile is'Tier 1 Agent Profile' ie the user
is Internal User , copies CCC_Purpose_Tier1_CR__c and CCC_Sub_Purpose_Tier1_CR__c to all other PSPs.*/
                
                // else if loop starts.
                
                else if(MyProflieName =='Tier 1 Agent Profile'){
                    if(CaseObject.CCC_Purpose_Tier1_CR__c != null)
                    {                           
                        //copies CCC_Purpose_Tier1_CR__c to all other Purposes to maintain symmetry.
                        CaseObject.CCC_Purpose__c= CaseObject.CCC_Purpose_Tier1_CR__c;
                        CaseObject.CCC_Equipment_Category__c= CaseObject.CCC_Purpose_Tier1_CR__c;
                        CaseObject.CCC_WarrantyCommunity_Purpose__c= CaseObject.CCC_Purpose_Tier1_CR__c;
                    }
                    if(CaseObject.CCC_Sub_Purpose_Tier1_CR__c != null)
                    {
                        //copies CCC_Sub_Purpose_Tier1_CR__c to all other sub-Purposes to maintain symmetry.
                        CaseObject.CCC_Sub_Purpose__c=CaseObject.CCC_Sub_Purpose_Tier1_CR__c;
                        CaseObject.CCC_Equipment_Purpose__c=CaseObject.CCC_Sub_Purpose_Tier1_CR__c;
                        CaseObject.CCC_WarrantyCommunity_Sub_Purpose__c=CaseObject.CCC_Sub_Purpose_Tier1_CR__c;
                    }
                }
                //else if loop ends.
                /*Checks the Record type name to Update Pursose and sub-purpose.If Record type is'Post Sale Support',
copies CCC_Equipment_Category__c and CCC_Equipment_Purpose__c to all other PSPs.*/
                // else if loop starts.
                
                else if(CaseObject.CCC_RecordTypeName__c=='Post Sale Support'){
                    if(CaseObject.CCC_Equipment_Category__c != null)
                    {
                        //copies CCC_Equipment_Category__c to all other Purposes to maintain symmetry.
                        CaseObject.CCC_Purpose__c=CaseObject.CCC_Equipment_Category__c;
                        CaseObject.CCC_Purpose_Tier1_CR__c=CaseObject.CCC_Equipment_Category__c;
                        CaseObject.CCC_WarrantyCommunity_Purpose__c=CaseObject.CCC_Equipment_Category__c;
                    }
                    if(CaseObject.CCC_Equipment_Purpose__c!=null)
                    {
                        //copies CCC_Equipment_Purpose__c to all other sub-Purposes to maintain symmetry.
                        CaseObject.CCC_Sub_Purpose__c=CaseObject.CCC_Equipment_Purpose__c;
                        CaseObject.CCC_Sub_Purpose_Tier1_CR__c=CaseObject.CCC_Equipment_Purpose__c;
                        CaseObject.CCC_WarrantyCommunity_Sub_Purpose__c=CaseObject.CCC_Equipment_Purpose__c;
                    }
                    
                }
                //else if loop ends.
                /*copies CCC_Purpose__c and CCC_Sub_Purpose__c to all other PSPs. for all other scenarios */
                // else  loop starts.
                else{
                    if(CaseObject.CCC_Purpose__c != null)
                    {
                        //copies CCC_Purpose__c to all other Purposes to maintain symmetry.
                        CaseObject.CCC_Purpose_Tier1_CR__c= CaseObject.CCC_Purpose__c;
                        CaseObject.CCC_WarrantyCommunity_Purpose__c=CaseObject.CCC_Purpose__c;
                        CaseObject.CCC_Equipment_Category__c=CaseObject.CCC_Purpose__c;
                    }
                    if(CaseObject.CCC_Sub_Purpose__c != null)
                    {
                        //copies CCC_Sub_Purpose__c to all other sub-Purposes to maintain symmetry.
                        CaseObject.CCC_Sub_Purpose_Tier1_CR__c= CaseObject.CCC_Sub_Purpose__c;
                        CaseObject.CCC_WarrantyCommunity_Sub_Purpose__c=CaseObject.CCC_Sub_Purpose__c;  
                        CaseObject.CCC_Equipment_Purpose__c=CaseObject.CCC_Sub_Purpose__c;              
                    }
                }
            }      
        }
    }
    
    /**
* This method will Update Product(Part) Details ON Case
* Parameters : Case trigger List
* @Developer : Ishita Sharma
**/
    
    public Void updateProductDetails(List<Case> objCaseList) {
        //Creating a list of products/parts
        List<Product2> objProd= new List<Product2>();
        //creating a set of IDs to map Part records with case Records.
        Set<Id> CaseId= new Set<id>();
        for(Case ObjCase:objCaseList){
            //Add Product IDs to the case ID Set.
            CaseId.add(ObjCase.CCC_Part__c);
        }  //for loop ends.
        
        /*Fetch all Product records where Id matches the Updated/Inserted Part field on Cases Updated/Inserted  */
        //If statement starts.
        if(CaseId.Size()>0||CaseId!= null){
            MAP<ID ,Product2> mapCon = new MAP<ID ,Product2>([Select Id,CCC_Parts_Quantity__c,
                                                              CCC_Buyer__c,CCC_ItemType__c,CCC_Planner__c,
                                                              Description,CCC_CasePack__c,Name,
                                                              CCC_Vendor_Code__c,ProductCode,
                                                              CCC_Vendor_Name__c from Product2 where id IN:CaseId]);
            
            
            /*Iterate On all Case List and populate Product/Part data on Case Record  */  
            //for loop starts.
            for(Case ObjCase:objCaseList){
                // if statement starts
                if(ObjCase.CCC_Part__c != null)
                {
                    //Maps Product Id to case's CCC_Part__c field.
                    Product2 prod= mapCon.get(ObjCase.CCC_Part__c);
                    //objCase.CCC_Part_Quantity__c = prod.CCC_CasePack__c;
                    objCase.CCC_Part_Number__c = prod.Name;
                    objCase.CCC_Product_Buyer__c =  prod.CCC_Buyer__c;
                    objCase.CCC_Part_Description__c = prod.Description;
                    objCase.CCC_Vendor_Code__c = prod.CCC_Vendor_Code__c;
                    objCase.CCC_Vendor_Name__c = prod.CCC_Vendor_Name__c;
                    objCase.CCC_Stocking_Type__c = prod.CCC_ItemType__c;
                    objCase.CCC_Planner__c = prod.CCC_Planner__c;
                }  //if statement ends.
                
                //if user does not select any part or deletes part on case update . it deletes case's records data that was fetched from product/Part.
                // else loop starts
                else{
                    //objCase.CCC_Part_Quantity__c = NULL ;
                    objCase.CCC_Part_Number__c = '';
                    objCase.CCC_Product_Buyer__c =  '';
                    objCase.CCC_Part_Description__c = '';
                    objCase.CCC_Vendor_Code__c = '';
                    objCase.CCC_Vendor_Name__c = '';
                    objCase.CCC_Stocking_Type__c = '';
                    objCase.CCC_Planner__c = '';
                }  //else statement ends.
            }  //for loop ends.
        }  //if statement ends.
    }
    
    
    /**
* This method will Update Distrubutor/Dealer Account Details on Case
* Parameters : Case trigger List
* @Developer : Sudheer Reddy
**/
    
    public Void updateDistributorDetails(List<Case> objCaseList) {
        //Creating a list of Account
        List<Account> objAcc= new List<Account>();
        //creating a set of IDs to map Account Records with case Records.
        Set<Id> CaseId= new Set<id>();
        //for loop starts.
        for(Case ObjCase:objCaseList){
            //Adding Account IDs (Distributor Type) to the case ID Set.
            if(ObjCase.CCC_Dealer_Name__c!= null)
            {
                CaseId.add(ObjCase.CCC_Dealer_Name__c);
            }
            if(ObjCase.CCC_Installer_Name__c != null)
            {
                CaseId.add(ObjCase.CCC_Installer_Name__c);
            }
            
        } //for loop ends.
        
        /*Fetch all Account records where Id matches the Updated/Inserted Distributor Details field on Cases Updated/Inserted  */
        //If statement starts.
        if(CaseId.Size()>0||CaseId!= null) {
            MAP<ID ,Account> mapCon = new MAP<ID ,Account>([Select Id,Name,Phone,CCC_Email_Address__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where id IN:CaseId]);
            /*Iterate On all Case List and populate Account Phone and Email data on Case Record  */ 
            //for loop starts.
            for(Case ObjCase:objCaseList){
                
                if(ObjCase.CCC_Installer_Name__c != null)
                {
                    Account acc1= mapCon.get(ObjCase.CCC_Installer_Name__c);
                    
                    ObjCase.Current_Installer_Name__c=acc1.Name;
                    ObjCase.Community_Installer_Name__c=acc1.Name;
                    ObjCase.CCC_Installer_Phone__c=acc1.Phone;
                    ObjCase.CCC_Installer_City__c=acc1.BillingCity;
                    ObjCase.CCC_Installer_Country__c=acc1.BillingCountry;
                    ObjCase.CCC_Installer_Postal_Code__c=acc1.BillingPostalCode;
                    ObjCase.CCC_Installer_State__c=acc1.BillingState;
                    ObjCase.CCC_Installer_Street__c=acc1.BillingStreet;
                    
                }
                if(ObjCase.CCC_Installer_Name__c == null)
                {
                    ObjCase.Current_Installer_Name__c='';
                    ObjCase.CCC_Installer_Phone__c='';
                    ObjCase.Community_Installer_Name__c='';
                    ObjCase.CCC_Installer_City__c='';
                    ObjCase.CCC_Installer_Country__c='';
                    ObjCase.CCC_Installer_Postal_Code__c='';
                    ObjCase.CCC_Installer_State__c='';
                    ObjCase.CCC_Installer_Street__c='';
                }
                
                if(ObjCase.CCC_Dealer_Name__c != null)
                {
                    //Maps Account Id to case's CCC_Dealer_Name__c field.
                    Account acc2= mapCon.get(ObjCase.CCC_Dealer_Name__c);
                    objCase.CCC_Dealer_s_Phone_No__c = acc2.Phone;
                    objCase.CCC_Dealer_s_Email__c = acc2.CCC_Email_Address__c;
                    objCase.Current_Servicing_Dealer__c=acc2.Name;
                    objCase.Community_Dealer_Name__c=acc2.Name;
                    objCase.CCC_Dealer_City__c=acc2.BillingCity;
                    objCase.CCC_Dealer_Country__c=acc2.BillingCountry;
                    objCase.CCC_Dealer_Postal_Code__c=acc2.BillingPostalCode;
                    objCase.CCC_Dealer_State__c=acc2.BillingState;
                    objCase.CCC_Dealer_Street__c=acc2.BillingStreet;
                    
                }
                
                //if user does not select any Account or deletes Account on case update . it deletes case's records data that was fetched from Account.
                if(ObjCase.CCC_Dealer_Name__c== null){
                    objCase.CCC_Dealer_s_Phone_No__c ='';
                    objCase.CCC_Dealer_s_Email__c = '';
                    objCase.Current_Servicing_Dealer__c='';
                    objCase.Community_Dealer_Name__c='';
                    objCase.CCC_Dealer_City__c='';
                    objCase.CCC_Dealer_Country__c='';
                    objCase.CCC_Dealer_Postal_Code__c='';
                    objCase.CCC_Dealer_State__c='';
                    objCase.CCC_Dealer_Street__c='';                    
                }
            }
        }
    }
    
    /**
* This method is used to set the time based on Organizations Local Time.
* Parameters :List<Case> datetime z
* @Developer : Sudheer Reddy
**/
    
    public static Datetime getLocalDateTime(Datetime z)
    {    
        //Returns Local Timezone date and adds hour mitute and seconds to it to return Current Local date Time 
        Datetime l = z.Date();
        l = l.addHours(z.hour());
        l = l.addMinutes(z.minute());
        l = l.addSeconds(z.second());
        return l;
    }
    
    /**
* This method is used to fetch the date and time when the case is Assigned to DSM .
* The fuction fetches the current date in CCC_Date_Time_Assigned__c case field.
* CCC_Date_Time_Assigned__c field is used in email temptate (DSM Template) which informs when the case is Assigned to DSM
* Below method uses getLocalDateTime (Datetime) to get the local date time based on Timezone
* Parameters :List<Case> objCaseList
* @Developer : Sudheer Reddy
**/
    
    public void CaptureAssignToDSMDate(List<Case> objCaseList){
        //for loop starts.
        for(Case Caseobj :objCaseList){
            //It copies Current(Local) Date Time (When the case is assigned to DSM) to Case's CCC_Date_Time_Assigned__c custom field.
            Caseobj.CCC_Date_Time_Assigned__c = Datetime.Now();
            Caseobj.Date_Time_Assigned_Template__c= getLocalDateTime(Datetime.Now());          
        }// for loop Ends
        
    }
    
    
    /**
* This method is used to fetch the DSM Name , Distributor's Account and its related TSM Name from Account Team when the case is Assigned to DSM .
* Parameters :List<Case> objCaseList
* @Developer : Sudheer Reddy
**/
    
    public void AssignTSMUser(List<Case> objCaseList){
        
        //Creating a list of Users for fetching DSM Users and TSM Users
        List<User> Userobj= new List<User>();
        //creating a set of IDs to capture case Owner .
        Set<Id> CaseId= new Set<id>();
        //creating a map of IDs to map Case ID to Distributors Account ID .
        Map< Id , Id > caseIdToAccountId = new Map< Id , Id >();
        
        //Iterates on Case List and adds Case Owner IDs to the set. 
        //For loop starts
        for(Case ObjCase:objCaseList){
            CaseId.add(ObjCase.OwnerID);
        }
        //Checks weather case has owner.
        //If loop starts.
        if(CaseId.Size()>0||CaseId!= null){
            //Creating map of IDs and Users that fetches user information of those users who are case's owner.
            //It fetches users Name and AccountID and Role, as Account is needed to be populated on Distributor's Account
            MAP<ID ,User> mapCon = new MAP<ID ,User>([Select Id,Name,AccountID,ContactID,UserRoleId from User where id IN:CaseId]);
            
            /*Iterate On all Case List and populate DSM Name,TSM Name and Distributor Name on Case Record  */  
            //for loop starts.
            for(Case ObjCase:objCaseList){
                /* If Statement starts.
Checks whether case owner profile is 'Partner Community DSM' or 'Partner Community-Warranty/DSM' 
means weather the case has been assigned to DSM.  */
                if(ObjCase.Owner_profile__c == 'Partner Community DSM' || ObjCase.Owner_profile__c == 'Partner Community-Warranty/DSM')
                {
                    //Maps User Id to case's OwnerID field.
                    User user1= mapCon.get(ObjCase.OwnerID);
                    //Assigns DSM User name to CCC_DSM__c case field.
                    objCase.CCC_DSM__c = user1.Name;
                    //Assigns DSM user Account Name  to CCC_Distributor_s_Name__c case field.
                    objCase.CCC_Distributor_s_Name__c= user1.AccountID;
                    //Maps Case ID to Account Distributor ID as we need distributor Account's Account team Member's details who has TSM Role. 
                    caseIdToAccountId.put(ObjCase.Id,  ObjCase.CCC_Distributor_s_Name__c );
                }
            } //for Loop ends.
            
        }
        
        // Creating map of Account IDs and Account team members.
        Map<id, List<AccountTeamMember > > accountIdToAccountTeamMembers = new    Map<id,  List<AccountTeamMember > > ();
        //for loop starts.
        //Query to fetch userID , Name , Team Member Role and AccountId from AccountTeamMember object.
        // It fetches those records whose  Team Member Role is 'TSM' and Account ID is in caseIdToAccountId list. ie Account is DSM's Account.
        //Concluding it , it fetches DSM users Account's TSM user.
        
        for(AccountTeamMember accountTeamMember : [Select a.UserId,a.User.Name,a.TeamMemberRole, a.Id, a.AccountId 
                                                   From AccountTeamMember a 
                                                   where a.TeamMemberRole =:'TSM' AND
                                                   a.AccountId in :caseIdToAccountId.values() ])   {
                                                       //Fetches the list of account Team Members who has Account ID .
                                                       List<AccountTeamMember > accountTeamMembers = ( accountIdToAccountTeamMembers.get(accountTeamMember.Accountid) == null) ?
                                                           new  List<AccountTeamMember >() :
                                                       accountIdToAccountTeamMembers.get(accountTeamMember.Accountid);
                                                       
                                                       //Adds the list of TSM users to the list.
                                                       accountTeamMembers.add(accountTeamMember);
                                                       //maps Team members with Account ID and adds the value in map with Account being key and Account team members being TSM users
                                                       accountIdToAccountTeamMembers.put(accountTeamMember.Accountid, accountTeamMembers);
                                                       
                                                   }
        //for loop starts.
        for(Case ObjCase : objCaseList) {
            /* If Statement starts.
Checks whether case owner profile is 'Partner Community DSM' or 'Partner Community-Warranty/DSM' 
means weather the case has been assigned to DSM.  */
            
            if(ObjCase.Owner_profile__c == 'Partner Community DSM' || ObjCase.Owner_profile__c == 'Partner Community-Warranty/DSM'){
                //fetches the list of Cases Who has Distributor Account.
                Id accountId  = caseIdToAccountId.get(ObjCase.Id);
                //If loop starts.
                //If DSM Account has TSM user in Account Team Member , Copy the user ID to CCC_TSM_User__c field
                if(accountIdToAccountTeamMembers.size()>0){
                    //for loop starts.
                    for ( AccountTeamMember accteam : accountIdToAccountTeamMembers.get(accountId) )  {
                        ObjCase.CCC_TSM_User__c = accteam.UserId;
                    }
                }
            } 
        }
    }
    /**
* This method is used to give Access To All Account Hierarchy Users
* Parameter - List<case> cases
* @Developer : Ishita Sharma
* Code Optimization done by Sudheer Reddy as part of 10/20 Release

Scenario1:

On Owner Change 
If Owner is not a portal user
Do Nothing
If Owner is a portal User
Fetch the contact associated with the User
Find the account which is associated to the contact
Find all the contacts under the above account which are enable as portal contacts
Get the list of all users (portal users) (active==true)
Give access to case, case.contact and accounts( case.account, dealer and installer) for above users 

Scenario 2:

On Account Change
If Account is Residential
Do nothing
If Account is Portal Enabled
Give the case access to entire account hierarchy users



**/
    
    public pagereference giveAccessToAllAccountHierarchyUsers(List<case> cases)
    {
        try
        {
            
            system.debug('Entered in to giveAccessToAllAccountHierarchyUsers');
            //Creating a setof Owner IDs and Created by IDs
            //Scenario 1 & 2
            Set<Id> ownerIdSet = new Set<ID>();
            
            List<String> caseAccountIdList = new List<String>();
            List<String> caseContactIdList = new List<String>();
            
            //Final set of user id list
            Set<Id> finalSetOfUserId= new Set<Id>();
            
            //Final set of User record list
            List<User> userList=new List<User>();                                
            
            List<String> caseIdList = new List<String>();
            
            //creating a map to map case ID to Owner ID 
            Map<String,String> caseIdOwnerMap = new Map<String,String> ();
            
            //creating a map to map case's contact and contact's account ID
            Map<String,String> caseContactAccountMap = new Map<String,String> ();
            
            //creating a map to map case and Contact
            Map<String,Case> contactCaseMap = new Map<String,Case> ();                            
            
            //Creating a set of Account Ids that fetches list of Accounts of newly created cases.
            Set<id>accontIds=new Set<Id>();
            
            //Creating a set of Contact Ids that fetches list of Contact of the account that is fetched in accontIds Set.
            Set<id>contactIds=new Set<Id>();
            
            //Creating a set of Users who has same contact ids as in contactIds set.
            //Scenario 2
            Set<id>userId=new Set<id>();
            
            //Below query is used to restrict DSM or DSM/Warranty users not to close cases which are not owned by them/thier hierarchy. 
            List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            //Fetches Current Logged in User's profile name
            String MyProflieName = PROFILE[0].Name;
            
            system.debug('cases'+cases);            
            //for loop starts.
            for(case c:cases)
            {
                
                //Null point check for accountId on case  
                if(c.accountId!=null)
                {
                    //Scenario 1
                    caseAccountIdList.add(c.accountId);
                    
                    //Adding Case's Account in  accontIds set if the account is portal enabled (filter added to the query).
                        //Scenario 2
                        accontIds.add(c.accountid);
                }
                system.debug('caseAccountIdList'+caseAccountIdList);    
                
                //Adding case owners to ownerIdSet string.
                //Scenario 1
                ownerIdSet.add(c.ownerId);
                system.debug('ownerIdSet'+ownerIdSet);    
                
                //createdById is required to share the cases created by portal user with thier hierarchy users
                //Scenario 1
                ownerIdSet.add(c.createdById);
                system.debug('ownerIdSet'+ownerIdSet);                
                
                
                /*checks if case has Contact associated with it then ,
* it Adds contactId to caseContactIdList list ,
* maps case's contact and case contact's Accounts and adds in caseContactAccountMap map,
* maps case's contact to the case record and adds in contactCaseMap map */
                //Scenario 1
                if(c.contactId!=null)
                {
                    caseContactIdList.add(c.contactId);
                    caseContactAccountMap.put(c.contactId, c.contact.AccountId);
                        contactCaseMap.put(c.contactId,c);
                    
                }
                system.debug('caseContactIdList'+caseContactIdList);    
                
                // Adds the cases IDs to caseIdList 
                caseIdList.add(c.Id);
                system.debug('caseIdList'+caseIdList);     
                
                // maps caseID to case's Owner ie CaseID as key , which fetches the case ownerId in caseIdOwnerMap
                caseIdOwnerMap.put(c.Id,c.ownerId);
            }
            system.debug('caseIdOwnerMap'+caseIdOwnerMap); 
            //Fetching all contacts under the associated account (if the account is portal enabled) on the case
                //Scenario 2
                // Can't we put a filter to query only contacts which are portal enabled?
                Map<id,contact> cMap = new Map<id,contact>([select id from contact where accountid in:accontIds AND account.IsPartner=:true]);
                system.debug('*********Any Results?'+cMap);
                if(!cMap.isEmpty())
                {
                    system.debug ('Map has values in it');
                    //Creating set of ids which are part of associated account on the case.
                    contactIds= cMap.keySet() ;                          
 
                    // It Fetches map of Users who has same contact ids as in contactIds set.             
                    Map<id,User> cMapUser = new Map<id,User>([select id from user where contactid in:contactIds]);
               
                    //Creating set of user ids to query the users to provide the case access
                    //below list of users has to be inserted in the case share object so that all the users(hierarchy) gets the case access
                    userId= cMapUser.keySet() ;
                }
                    
                // Adding Scenario 2 userlist(userId) to ownerIdSet set.
                if(userId != null)
                {
                    ownerIdSet.addAll(userId);
                }
            
            
            // Get the list of Account from the User Quering user id, and  User's Contact's Account of users who are either case owners or those who have created the cases
            //Scenario 1 & 2
            List<User> uList = [select Id, contact.AccountId ,ContactId,contact.Public_group__c from User where Id IN :ownerIdSet and IsActive=True and IsPortalEnabled =true];                
            system.debug('uList'+uList);
            //creating a list of accounts which are users contact associated accounts
                //Scenario 1 & 2
                List<String> accLst = new List <String>();
                
                //for loop starts.
                //Scenario 1 & 2
                for(User u : uList)
                {
                    //Checks if user has Account , i.e user is a community user that had contact and Account Associated with it.If yes , it Adds corresponding Accounts to accLst*/
                    if(u.contact.AccountId!=null)
                        {
                            accLst.add(u.contact.AccountId);
                        }
                }
                                            
                /* Fetch all accounts in heirarchy from the Accounts of user list passed */
                //Scenario 1 & 2
                if(accLst.size()>0)
                {
                    //Below accountIdList contains the all acclst hierarchy users
                    Set<String> accountIdList = new CCC_UserTriggerHelper().CreateHierarchy(accLst );
                
                    /* Fetch all contacts from the heiarchy Accounts */
                    List<Contact> contactList = [select Id from Contact where accountId IN :accountIdList ];
                
                    /* Fetch all users from the heiarchy Contacts */
                    //Map of Final userList
                    Map<Id,User> finalUserList =new Map<Id,User>([select Id,name from User where contactId IN :contactList and IsActive=True]); 
                    userList= finalUserList.values();
                    finalSetOfUserId=finalUserList.keyset();
                    system.debug('Final User List Size'+userList.size());
            
            /*
DEF0000637: Community User - Warranty Admins need to be able to close cases. DSMs should have the ability to close a PSS case type. 
The only Community User that should not have the ability to close a case when the case is assigned to another user, is a DSM and it should be specific to the Consumer Relations case type.
DEF0000915

*/
            for(case cseobj:cases)
            {
                if(cseobj.Status=='Closed' && cseobj.CCC_RecordTypeName__c =='Consumer Relations'  && (!finalSetOfUserId.contains(cseobj.ownerID))&& ((MyProflieName=='Partner Community DSM') ||(MyProflieName=='Partner Community-Warranty/DSM')))
                {
                    cseobj.adderror('You are not authorized to close this case');
                }
                
            }
            
            // Lists of AccountShare for different Accounts each , ie dealer, distributor , current dealer , dsm Account , Previous dealer etc
            List<AccountShare> acctShareList = new List<AccountShare>();
            
            // creating ContactShare list to share the contacts with related users.
            List<ContactShare> contactShareList = new List<ContactShare>();
            
            // creating CaseShare list to share the cases with related users.
            List<CaseShare> caseShareList = new List<CaseShare>();
            
            /*Creating a list of Custom Case Share object to give case access to users even when case's is in Companies Account.
It copies the same data from standard case share object to custom case share, as using custom case share it revokes the access back if case is assigned to some other owner except comunity user.*/
            List<Case_Share__c> caseShareRecords=new List<Case_Share__c>(); 
            
            //Create Account Share list */
            //for loop starts.
            //   system.debug('userList'+userList);                
            
            for(User u : uList )
            {
                
                /* nested for loop starts.
Give Access to user on Account record by adding to Account Share Object for acctShareList
*/
                
                for(String accId : caseAccountIdList)
                {
                    AccountShare acctShare = new AccountShare();
                    system.debug('accId'+accId);
                    system.debug('u.Id'+u.Id);
                    if(accId!=null && u.Id!=null)
                    {                                
                        acctShare.AccountId = accId;
                        acctShare.UserOrGroupId = u.contact.Public_group__c;
                        acctShare.RowCause='Manual';
                        acctShare.OpportunityAccessLevel='Read';
                        acctShare.AccountAccessLevel = 'Read';
                        acctShareList.add(acctShare);
                    }
                }
                
                
                /* nested for loop starts.
Give Access to user on Contact record by adding to Contact Share Object
Create Contact Share list
*/
                
                for(String ccId : caseContactIdList)
                {
                    if(ccId!=null && u.id!=null)
                    { 
                        ContactShare contactShare = new ContactShare();   
                        contactShare.ContactId = ccId;
                        System.debug('#u.id:'+u.id);
                        contactShare.UserOrGroupId = u.contact.Public_group__c;
                        contactShare.ContactAccessLevel = 'Read';
                        contactShare.RowCause='Manual';
                        contactShareList.add(contactShare);                                                        
                    }
                }
                
                /* nested for loop starts.
Create Case Share list (Standard)
Creating Custom Case share for cases where user is not the case owner or creator
So creating same share record for both standard and custom case share.
*/
                System.debug('#caseIdList:'+caseIdList);
                System.debug('#caseIdOwnerMap:'+caseIdOwnerMap);
                
                for(String caseId : caseIdList)
                {
                    system.debug(u.Id);
                    system.debug(caseIdOwnerMap.get(caseId));
                    if(u.Id == caseIdOwnerMap.get(caseId))
                    {                            
                        CaseShare caseShare = new CaseShare();
                        caseShare.CaseId = caseId;
                        System.debug('#u.id:'+u.id);
                        caseShare.UserOrGroupId = u.contact.Public_group__c;
                        caseShare.CaseAccessLevel = 'Edit';
                        caseShare.RowCause='Manual';
                        caseShareList.add(caseShare);
                        
                    }
                    
                }
                
            }
            system.debug('acctShareList'+acctShareList);
            system.debug('contactShareList'+contactShareList);
            system.debug('caseShareList'+caseShareList);
            /*Insert all Shared Access Records 
Insert Account Share List fro All Accounts
Insert Contact Share List
Insert Standard Case Share List
*/
            
            if(acctShareList.size()>0)
            {
                system.debug('Account Share Records size'+ acctShareList.size());
                upsert acctShareList;
                
            }                
            
            if(contactShareList.size()>0)
            {
                system.debug('Contact Share Records size'+ contactShareList.size());
                upsert contactShareList;
                
            }
            
            if(caseShareList.size()>0)
            {             
                system.debug('Case Share Records size'+ caseShareList.size());
                upsert caseShareList;                    
            }
            
        }
        }
        catch(Exception e)
        {
            system.debug('-------->'+e);
            system.debug('1-------->'+e.getStackTraceString());
        }
        return null;
    }
    
    //create a temp records in case share custom object
    
    public void createCustomShareRecords(list<Case> caseList)
    {
        getShareRecordsforUpdate=[Select Id,CaseId,UserOrGroupId,CaseAccessLevel,RowCause from CaseShare where CaseId in :caseList];
        system.debug('@@@@@@@@@@@@@@beforeupdate query loop'+getShareRecordsforUpdate);
        
        if(getShareRecordsforUpdate.size()>0)
        {
            for(CaseShare iterCaseShareRecords:getShareRecordsforUpdate)
            {
                if(string.valueOf(iterCaseShareRecords.UserOrGroupId).startsWith('00G'))
                {
                    Case_Share__c caseShareRecord=new Case_Share__c(); 
                    
                    caseShareRecord.Case_ID__c=iterCaseShareRecords.caseId;
                    
                    caseShareRecord.Name__c=iterCaseShareRecords.UserOrGroupId;
                    
                    caseShareRecord.Case_Access__c= 'Edit';
                    
                    caseShareRecord.Reason__c='Manual';
                    
                    caseShareRecords.add(caseShareRecord);
                }
            }
            system.debug('caseShareRecords'+caseShareRecords);
            if(caseShareRecords.size()>0)
            {
                insert caseShareRecords;
            }
        }
        
    }
    
    
    //This method to keep the caseshare object records after owner change
    
    public void keepAccessToPortalUsers(List<Case> caseList)
    {
        system.debug('----------------->Entered into the keepAccessToPortalUsers'+caseList);
        List<Case_Share__c> getShareRecords= new List<Case_Share__c>(); 
        List<CaseShare> putShareRecords= new List<CaseShare>();          
        try
        {
            //gets the shared records from case share custom Object and updated/replicates the same sharing Access in Standard Case Share Object.
            getShareRecords=[Select Id,Case_ID__c,Name__c from Case_Share__c where Case_ID__c in :caseList];
            
            if(getShareRecords.size()>0)
            {
                for(case_Share__c upsertCSRecords:getShareRecords)
                {
                    CaseShare caseShare1 = new CaseShare();
                    caseShare1.CaseId = upsertCSRecords.Case_ID__c;
                    caseShare1.UserOrGroupId = upsertCSRecords.Name__c;
                    caseShare1.CaseAccessLevel = 'Edit';
                    caseShare1.RowCause='Manual';
                    putShareRecords.add(caseShare1); 
                }
                
                if(putShareRecords.size()>0)
                {
                    system.debug('----------------------->Before the updating the case standard share object'+putShareRecords);
                    upsert putShareRecords;
                }
                
            }
            
            
        }
        catch(exception e)
        {
            system.debug('Exception in case share object'+e);
        }
    }
    
    public void calculateSolutionLength(List<case> solutionList)
    {
        
        for(Case updateSolutionLength:solutionList)
        {
            Integer lengthValue=updateSolutionLength.CCC_Solution__c.length();
            updateSolutionLength.Solution_Length__c=lengthValue;
            
        }
    }
    
    
}